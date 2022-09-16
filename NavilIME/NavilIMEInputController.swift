//
//  NavilIMEInputController.swift
//  NavilIME
//
//  Created by Manwoo Yi on 9/4/22.
//

import InputMethodKit

@objc(NavilIMEInputController)
open class NavilIMEInputController: IMKInputController {
    let key_code:String =       "asdfhgzxcv\tbqweryt123465=97-80]ou[ip\tlj'k;\\,/nm"
    let shift_key_code:String = "ASDFHGZXCV\tBQWERYT!@#$^%+(&_*)}OU{IP\tLJ\"K:|<?NM"
    
    var hangul:Hangul!
    
    open override func inputText(_ string: String!, client sender: Any!) -> Bool {
        guard let client = sender as? IMKTextInput else {
            return false
        }
        client.insertText(string+"1", replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
        
        PrintLog.shared.Log(log: string)
        
        return true
    }
    
    override open func activateServer(_ sender: Any!) {
        super.activateServer(sender)
        
        PrintLog.shared.Log(log: "Server Activated")
        self.hangul = Hangul()
        self.hangul.Start(type: "318")
    }
    
    override open func deactivateServer(_ sender: Any!) {
        super.deactivateServer(sender)
        
        PrintLog.shared.Log(log: "Server deactivating")
        
        self.hangul.Flush()
        self.update_display(client: sender)
        
        self.hangul.Stop()
    }
    
    override open func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
        switch event.type {
        case .keyDown:
            return self.keydown_event_handler(event: event, client: sender)
        case .leftMouseDown, .leftMouseUp, .leftMouseDragged, .rightMouseDown, .rightMouseUp, .rightMouseDragged:
            self.commitComposition(sender)
        default:
            PrintLog.shared.Log(log: "unhandled event")
        }
        return false
    }
    
    func keydown_event_handler(event:NSEvent, client:Any!) -> Bool {
        let keycode = event.keyCode
        let flag = event.modifierFlags
        
        if flag.contains(.command)
            || flag.contains(.option)
            || flag.contains(.control) {
            PrintLog.shared.Log(log: "Modikey - \(keycode) with \(flag.rawValue)")
            return false
        }
        
        let backspace = 0x33    // MacOS defined
        if keycode == backspace {
            PrintLog.shared.Log(log: "Backspace")
            
            let remain = self.hangul.Backspace()
            if remain == true {
                self.update_display(client: client)
            } else {
                self.commitComposition(client)
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
        var ascii = self.key_code[ascii_idx]
        let shift:Bool = flag.contains(.shift)
        if shift == true {
            ascii = self.shift_key_code[ascii_idx]
        }
        
        let eaten:Bool = self.hangul.Process(ascii: String(ascii))
        if eaten == false {
            PrintLog.shared.Log(log: "Not Hangul: \(ascii)")
            
            self.hangul.Flush()
            self.update_display(client: client)
            
            return false
        }
        
        self.update_display(client: client)
        
        return true
    }
    
    func update_display(client:Any!) {
        let commit_unicode:[unichar] = self.hangul.GetCommit()
        let preedit_unicode:[unichar] = self.hangul.GetPreedit()
        let commited:String = String(utf16CodeUnits:commit_unicode , count: commit_unicode.count)
        let preediting:String = String(utf16CodeUnits: preedit_unicode, count: preedit_unicode.count)
        
        guard let disp = client as? IMKTextInput else {
            return
        }
        
        if commited.count != 0 {
            let markedRange_disp = disp.markedRange()
            let selectedRange_disp = disp.selectedRange()
            disp.insertText(commited, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
            
            PrintLog.shared.Log(log: "Commit: \(commited) mloc:\(markedRange_disp.location) sloc:\(selectedRange_disp.location)")
        }
        
        if preediting.count != 0 {
            let markedRange_disp = disp.markedRange()
            let selectedRange_disp = disp.selectedRange()
            let markedRange = NSRange(location: markedRange_disp.location, length: preediting.count)
            disp.setMarkedText(preediting, selectionRange: NSRange(location: 0, length: preediting.count), replacementRange: markedRange)
            
            PrintLog.shared.Log(log: "Predit: \(preediting) mloc:\(markedRange_disp.location) sloc:\(selectedRange_disp.location)")
        }
    }
    
    /*
     입력 메서드가 이 메서드를 구현하면, 클라이언트가 컴포지션 세션을 즉시 종료하고자 할 때 호출됩니다.
     일반적인 응답은 클라이언트의 insertText 메서드를 호출한 다음 세션별 버퍼와 변수를 정리하는 것입니다.
     이 메시지를 받은 후 입력 방법은 주어진 컴포지션 세션이 완료된 것을 고려해야 합니다.
     */
    override open func commitComposition(_ sender: Any!) {
        PrintLog.shared.Log(log: "Commit Composition?")
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
    
    override open func mouseDown(onCharacterIndex index: Int, coordinate point: NSPoint, withModifier flags: Int, continueTracking keepTracking: UnsafeMutablePointer<ObjCBool>!, client sender: Any!) -> Bool {
        PrintLog.shared.Log(log: "Mouse Down")
        
        self.commitComposition(sender)
        return false
    }
}
