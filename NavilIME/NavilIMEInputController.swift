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

    /*
     텔레그램처럼 keyDown 오버라이드에서 `엔터 && !hasMarkedText()` 로 전송을 판정하는 앱은
     그 판정이 입력기가 이벤트를 받기 전에 끝난다. 그래서 marked text 방식으로 조합하는 한
     조합 중 엔터는 절대 첫 타에 전송되지 않는다 (엔터 두 번 문제).
     이 앱들에서는 시스템 한글 입력기처럼 marked text 없이 조합한다:
     조합 중 글자를 실제 텍스트로 즉시 넣고, 조합이 진행되면 insertText(replacementRange:)로
     직전 글자를 교체한다. (Apple 한글 IME, SokIM DirectStrategy, hangeul_ime와 같은 방식)
     주의: 이 목록에 앱을 추가하려면 그 앱이 selectedRange()와 attributedSubstring(from:)을
     제대로 지원해야 한다. (커서 위치를 못 읽으면 교체 범위를 계산할 수 없다)
     */
    static let direct_insert_clients:Set<String> = ["ru.keepcoder.Telegram"]

    func is_direct(_ client:Any!) -> Bool {
        guard let disp = client as? IMKTextInput else { return false }
        return NavilIMEInputController.direct_insert_clients.contains(disp.bundleIdentifier() ?? "")
    }

    // 직접 삽입 모드 상태: 화면에 넣어둔 조합 중 글자와, 삽입 직후의 기대 커서 위치
    var direct_pending:String = ""
    var direct_expected_loc:Int = -1

    override open func activateServer(_ sender: Any!) {
        super.activateServer(sender)

        PrintLog.shared.Log(log: "Server Activated")
        self.hangul = Hangul()
        self.hangul.Start(type: HangulMenu.shared.selected_keyboard)
        self.direct_pending = ""
        self.direct_expected_loc = -1
    }
    
    override open func deactivateServer(_ sender: Any!) {
        super.deactivateServer(sender)
        
        PrintLog.shared.Log(log: "Server deactivating")

        guard self.hangul != nil else { return }
        self.hangul.Flush()
        self.update_display(client: sender)

        self.hangul.Stop()
        // Stop()은 automata만 nil로 만들고 hangul 객체는 남아서, 이 뒤에 또
        // commitComposition이 오면 Flush()의 강제 언래핑에서 크래시난다.
        // hangul 자체를 nil로 만들어 위의 가드들이 실제로 막게 한다.
        self.hangul = nil
        self.direct_pending = ""
        self.direct_expected_loc = -1
    }
    
    override open func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
        guard self.hangul != nil else { return false }
        if OptHandler.shared.Is_han_eng_changed(keycode: event.keyCode, modi: event.modifierFlags) {
            self.hangul.ToggleSuspend()
            self.commitComposition(sender)
            return true
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

        // 직접 삽입 모드: 우리가 모르는 사이 필드가 바뀌었으면(엔터 전송으로 비워짐, 클릭 등)
        // 들고 있던 조합 상태를 조용히 버리고 이번 키부터 새로 시작한다.
        self.direct_sync_check(client: client)

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

            // 직접 삽입 모드에서 마지막 낱자를 지우는 백스페이스는 앱에 그대로 넘긴다.
            // 화면의 조합 글자는 실제 텍스트라서 앱 네이티브 백스페이스로 지우는 게 확실하다.
            // (커스텀 텍스트뷰에서 insertText("")의 '빈 문자열 = 삭제' 동작은 보장되지 않음)
            if self.is_direct(client) && self.hangul.InputCount() == 1 {
                self.hangul.Discard()
                self.direct_pending = ""
                self.direct_expected_loc = -1
                return false
            }

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
            // 클라이언트 없이 호출되면 화면의 조합 글자는 그대로 확정된 것으로 본다
            self.direct_pending = ""
            self.direct_expected_loc = -1
            return
        }

        commited += additional

        // marked text를 쓰면 안 되는 앱은 직접 삽입 방식으로 처리
        if self.is_direct(disp) {
            self.direct_update(disp: disp, commited: commited, preediting: preediting)
            return
        }

        let build_count = 302
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
     직접 삽입 모드의 화면 갱신.
     조합 중 글자(preedit)를 marked text 대신 실제 텍스트로 넣는다.
     직전 키에서 넣어둔 글자(direct_pending)가 있으면 그 범위를 새 내용으로 교체한다.
     */
    func direct_update(disp:IMKTextInput, commited:String, preediting:String) {
        let new_text = commited + preediting
        let old_pending = self.direct_pending

        if new_text.isEmpty && old_pending.isEmpty {
            return
        }
        // flush로 조합만 확정되고 화면 내용이 그대로면 클라이언트 호출 생략
        // (이미 실제 텍스트로 들어가 있으므로 상태만 정리하면 된다)
        // 주의: 이 비교는 commit 정규화 == preedit 정규화(normalization의 is_commit이
        // 현재 무시됨)에 의존한다. 둘을 다르게 만들면 이 조건이 깨진다.
        if preediting.isEmpty && new_text == old_pending {
            self.direct_pending = ""
            self.direct_expected_loc = -1
            return
        }

        let sel = disp.selectedRange()
        let old_len = old_pending.utf16.count
        var rr = NSRange(location: NSNotFound, length: 0)
        var base = sel.location

        if old_pending.isEmpty == false && sel.location != NSNotFound && sel.location >= old_len {
            // 직전에 넣어둔 조합 글자가 커서 앞에 그대로 있는지 확인하고 교체
            let check_range = NSRange(location: sel.location - old_len, length: old_len)
            let actual = disp.attributedSubstring(from: check_range)?.string
            if actual == nil || actual == old_pending {
                rr = check_range
                base = sel.location - old_len
            }
        }

        disp.insertText(new_text, replacementRange: rr)

        self.direct_pending = preediting
        if preediting.isEmpty || base == NSNotFound {
            self.direct_expected_loc = -1
        } else {
            self.direct_expected_loc = base + new_text.utf16.count
        }
        PrintLog.shared.Log(log: "direct: '\(new_text)' rr=\(rr) pending='\(self.direct_pending)' exp=\(self.direct_expected_loc)")
    }

    /*
     직접 삽입 모드의 일관성 검사. 키 입력 처리 전에 호출한다.
     조합 글자가 실제 텍스트라서, 앱이 그걸 포함해 전송해 버리거나(텔레그램 엔터는
     입력기에 전달되지 않고 keyDown에서 소비됨) 사용자가 클릭으로 커서를 옮겨도
     입력기는 알 수 없다. 기대 커서 위치/내용과 다르면 조합 상태를 조용히 버린다.
     */
    func direct_sync_check(client:Any!) {
        guard self.direct_pending.isEmpty == false,
              let disp = client as? IMKTextInput,
              self.is_direct(disp) else {
            return
        }
        let pending_len = self.direct_pending.utf16.count
        let sel = disp.selectedRange()
        var stale = (sel.location == NSNotFound)
            || (sel.length != 0)    // 선택 영역이 있으면 조합을 버리고 네이티브처럼 선택을 대체
            || (sel.location != self.direct_expected_loc)
            || (sel.location < pending_len)
        if stale == false {
            let check_range = NSRange(location: sel.location - pending_len, length: pending_len)
            if let actual = disp.attributedSubstring(from: check_range)?.string {
                stale = (actual != self.direct_pending)
            }
        }
        if stale {
            PrintLog.shared.Log(log: "direct: field changed externally, discard composition")
            self.hangul?.Discard()
            self.direct_pending = ""
            self.direct_expected_loc = -1
        }
    }

    /*
     입력 메서드가 이 메서드를 구현하면, 클라이언트가 컴포지션 세션을 즉시 종료하고자 할 때 호출됩니다.
     일반적인 응답은 클라이언트의 insertText 메서드를 호출한 다음 세션별 버퍼와 변수를 정리하는 것입니다.
     이 메시지를 받은 후 입력 방법은 주어진 컴포지션 세션이 완료된 것을 고려해야 합니다.
     */
    override open func commitComposition(_ sender: Any!) {
        PrintLog.shared.Log(log: "Commit Composition")
        // IMK가 activateServer(=hangul 초기화) 전에 commitComposition을 호출할 때가 있어
        // self.hangul 이 nil이면 강제 언래핑으로 크래시난다 → 가드로 방지.
        guard self.hangul != nil else { return }
        // 직접 삽입 모드: 필드가 외부에서 바뀐 채 커밋이 오면 stale 조합부터 정리
        self.direct_sync_check(client: sender)
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
                self.hangul?.Flush()
                OptHandler.shared.Open_opt_window(sender)
                return
            }
            HangulMenu.shared.change_selected_keyboard(id: kbd.tag)
            for mi in HangulMenu.shared.menu.items {
                mi.state = NSControl.StateValue.off
            }
            kbd.state = NSControl.StateValue.on
            
            // 바꾼 한글 자판을 즉시 적용
            self.hangul?.Flush()
            self.hangul?.Stop()
            self.hangul?.Start(type: HangulMenu.shared.selected_keyboard)
        } else {
            PrintLog.shared.Log(log: "Not NSMenuItem????")
        }
    }
}
