//
//  NavilIMEInputController.swift
//  NavilIME
//
//  Created by Manwoo Yi on 9/4/22.
//

import InputMethodKit

@objc(NavilIMEInputController)
open class NavilIMEInputController: IMKInputController {
    let key_code:String =       "asdfhgzxcv\tbqweryt123465=97-80]ou[ip\tlj'k;\\,/nm.\t `"
    let shift_key_code:String = "ASDFHGZXCV\tBQWERYT!@#$^%+(&_*)}OU{IP\tLJ\"K:|<?NM>\t ~"
    
    var hangul:Hangul!
    
    override open func activateServer(_ sender: Any!) {
        super.activateServer(sender)
        
        PrintLog.shared.Log(log: "Server Activated")
        self.hangul = Hangul()
        self.hangul.Start(type: HangulMenu.shared.selected_keyboard)
    }
    
    override open func deactivateServer(_ sender: Any!) {
        super.deactivateServer(sender)
        
        PrintLog.shared.Log(log: "Server deactivating")
        
        self.hangul.Flush()
        self.update_display(client: sender)
        
        self.hangul.Stop()
    }
    
    override open func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
        if OptHandler.shared.Is_han_eng_changed(keycode: event.keyCode, modi: event.modifierFlags) {
            self.hangul.Flush()
            self.update_display(client: sender)
            self.hangul.ToggleSuspend()
            return false
        }
        
        switch event.type {
        case .keyDown:
            let eaten = self.keydown_event_handler(event: event, client: sender)
            if eaten == false {
                self.commitComposition(sender)
            }
            return eaten
        case .leftMouseDown, .leftMouseUp, .leftMouseDragged, .rightMouseDown, .rightMouseUp, .rightMouseDragged:
            self.commitComposition(sender)
        default:
            PrintLog.shared.Log(log: "unhandled event keycode=\(event.keyCode) modi=\(event.modifierFlags.rawValue)")
        }
        return false
    }
    
    func keydown_event_handler(event:NSEvent, client:Any!) -> Bool {
        let keycode = event.keyCode
        let flag = event.modifierFlags
        
        // 특정 패턴 입력은 한글로 변환하지 않는다.
        Hotfix.shared.add(keycode)
        let is_matched = Hotfix.shared.check()
        if is_matched == true {
            return false
        }
        
        if flag.contains(.command)
            || flag.contains(.option)
            || flag.contains(.control) {
            PrintLog.shared.Log(log: "Modikey - \(keycode) with \(flag.rawValue)")
            return false
        }
        
        let enter_return = 0x24 // MacOS defined
        let tab = 0x30          // MacOS defined
        if keycode == enter_return || keycode == tab {
            PrintLog.shared.Log(log: "Enter or Tab")
            
            self.hangul.Flush()
            self.update_display(client: client)
            
            return false
        }
        
        let backspace = 0x33    // MacOS defined
        if keycode == backspace {
            PrintLog.shared.Log(log: "Backspace")
            
            let remain = self.hangul.Backspace()
            if remain == true {
                self.update_display(client: client, backspace: true)
            }
            return remain
        }
        
        if keycode >= self.key_code.count {
            PrintLog.shared.Log(log: "Bypassd keycode: \(keycode) >= \(self.key_code.count)")
            
            self.hangul.Flush()
            self.update_display(client: client)
            
            return false
        }
        
        let ascii_idx = self.key_code.index(self.key_code.startIndex, offsetBy: Int(keycode))
        var ascii = self.key_code[ascii_idx] // String(describing: event.characters))
        let shift:Bool = flag.contains(.shift)
        if shift == true {
            ascii = self.shift_key_code[ascii_idx]
        }
        
        let is_hangul:Bool = self.hangul.Process(ascii: String(ascii))
        if is_hangul == false {
            PrintLog.shared.Log(log: "Not Hangul: \(ascii)")
            
            self.hangul.Flush()
            
            // 기호가 다른 키보드에서 나빌 입력기를 쓸 때, 기본 기호가 아닌 다른 기호가 나온다.
            // 나빌 입력기는 기본 키코드에 해당하는 기호를 그대로 출력한다.
            var extra:String = String(ascii)
            // 390 자판처럼 숫자나 기호를 한글 자판에 별도로 맵핑한 경우, 별도 API로 기호를 바꾼다.
            if let etc = hangul.Additional(ascii: String(ascii)) {
                extra = etc
            }
            self.update_display(client: client, backspace: false, additional: extra)
        } else {
            self.update_display(client: client)
        }
        return true
    }
    
    func update_display(client:Any!, backspace:Bool = false, additional:String = "") {
        let commit_unicode:[unichar] = self.hangul.GetCommit()
        let preedit_unicode:[unichar] = self.hangul.GetPreedit()
        var commited:String = String(utf16CodeUnits:commit_unicode , count: commit_unicode.count)
        let preediting:String = String(utf16CodeUnits: preedit_unicode, count: preedit_unicode.count)
        
        PrintLog.shared.Log(log: "C:'\(commited)' - \(commited.count) P:'\(preediting)' - \(preediting.count)")
        
        guard let disp = client as? IMKTextInput else {
            return
        }
        
        commited += additional
        
        let build_count = 283
        if commited.count != 0 {
            disp.insertText(commited, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
            
            PrintLog.shared.Log(log: "\(build_count) Commit: \(commited)")
        }
        
        // replacementRange 가 아래 코드와 같아야만 잘 동작한다.
        if (preediting.count != 0) || (backspace == true) {
            // 백스페이스로 글자를 지울 때, preddition.count == 0 인 상태가 되는데
            // 이 때 명시적으로 length = 0 인 NSRange를 setMarkedText()에 주어야만 자연스럽게 처리된다.
            let sr = NSRange(location: 0, length: preediting.count)
            let rr = NSRange(location: NSNotFound, length: NSNotFound)
            PrintLog.shared.Log(log: "RR: \(rr) SR: \(sr) on \(String(describing: disp.bundleIdentifier()))")
            disp.setMarkedText(preediting, selectionRange: sr, replacementRange: rr)
            
            PrintLog.shared.Log(log: "\(build_count) Predit: \(preediting)")
        }
    }
    
    /*
     입력 메서드가 이 메서드를 구현하면, 클라이언트가 컴포지션 세션을 즉시 종료하고자 할 때 호출됩니다.
     일반적인 응답은 클라이언트의 insertText 메서드를 호출한 다음 세션별 버퍼와 변수를 정리하는 것입니다.
     이 메시지를 받은 후 입력 방법은 주어진 컴포지션 세션이 완료된 것을 고려해야 합니다.
     */
    override open func commitComposition(_ sender: Any!) {
        PrintLog.shared.Log(log: "Commit Composition")
        self.hangul.Flush()
        self.update_display(client: sender)
    }
    
    /*
     클라이언트는 입력 메서드가 이벤트를 지원하는지 확인하기 위해 이 메서드를 호출합니다.
     기본 구현은 NSKeyDownMask를 반환합니다.
     입력 방법이 키 다운 이벤트만 처리하는 경우, 입력 방법 키트는 기본 마우스 처리를 제공합니다.
     기본 마우스다운 처리 동작은 다음과 같습니다:
       활성 컴포지션 영역이 있고 사용자가 텍스트를 클릭하지만 컴포지션 영역 외부에서 클릭하는 경우,
       입력 방법 키트는 입력 메서드에 commitComposition: 메시지를 보냅니다.
       이것은 기본값인 NSKeyDownMask만 반환하는 입력 메서드에서만 발생합니다.
     */
    override open func recognizedEvents(_ sender: Any!) -> Int {
        return Int(NSEvent.EventTypeMask(arrayLiteral: .keyDown, .flagsChanged,
            .leftMouseUp, .rightMouseUp, .leftMouseDown, .rightMouseDown,
            .leftMouseDragged, .rightMouseDragged,
            .appKitDefined, .applicationDefined, .systemDefined).rawValue)
    }
    
    /*
     마우스 버튼이 눌리면 현재 조합을 종료하고 커밋
     */
    override open func mouseDown(onCharacterIndex index: Int, coordinate point: NSPoint, withModifier flags: Int, continueTracking keepTracking: UnsafeMutablePointer<ObjCBool>!, client sender: Any!) -> Bool {
        PrintLog.shared.Log(log: "Mouse Down")
        
        self.commitComposition(sender)
        return false
    }
    
    
    /*
     이 메서드는 입력 메서드가 현재 상태를 반영하도록 메뉴를 업데이트할 수 있도록 메뉴를 그려야 할 때마다 호출됩니다.
     */
   override open func menu() -> NSMenu! {
        return HangulMenu.shared.menu
   }
    
    /*
     IMKit 프레임워크는 실제 NSMenu 객체가 어디에 있건간에 NSMenuItem.action은 무조건 InputController 내부에 있어야 한다.
     그리고 sender는 NSMenuItem이 아니다. <-- 졸라 중요.
     IMKit에서 생성한 Dictionary 타입 객체가 sender로 전달된다.
     거기서 NSMenuItem을 찾으려면 ["IMKCommandMenuItem"]으로 Dictionary에서 값을 가져와야 한다.
     인터넷 그 어디에도 공식적인 문서 자료가 없다. 내가 삽질해서 찾은 것임.
     */
    @objc func select_menu(_ sender:Any?) {
        guard let menuitem = sender as? Dictionary<String, Any> else {
            PrintLog.shared.Log(log: "WTF \(sender.debugDescription)")
            return
        }
        
        if let kbd:NSMenuItem = menuitem["IMKCommandMenuItem"] as? NSMenuItem {
            PrintLog.shared.Log(log: "Selected Keyboard: \(kbd.title)")
            if kbd.tag == OptHandler.shared.opt_menu_tag {
                PrintLog.shared.Log(log: "This is Option: \(kbd.title)")
                self.hangul.Flush()
                OptHandler.shared.Open_opt_window(sender)
                return
            }
            HangulMenu.shared.change_selected_keyboard(id: kbd.tag)
            for mi in HangulMenu.shared.menu.items {
                mi.state = NSControl.StateValue.off
            }
            kbd.state = NSControl.StateValue.on
            
            // 바꾼 한글 자판을 즉시 적용
            self.hangul.Flush()
            self.hangul.Stop()
            self.hangul.Start(type: HangulMenu.shared.selected_keyboard)
        } else {
            PrintLog.shared.Log(log: "Not NSMenuItem????")
        }
    }
}
