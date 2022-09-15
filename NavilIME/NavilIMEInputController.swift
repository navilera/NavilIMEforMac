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
            PrintLog.shared.Log(log: "Commit: \(commited)")
            disp.insertText(commited, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
        }
        
        if preediting.count != 0 {
            PrintLog.shared.Log(log: "Predit: \(preediting)")
            let markedRange = disp.markedRange()
            disp.setMarkedText(preediting, selectionRange: NSRange(location: 0, length: preediting.count), replacementRange: markedRange)
        }
    }
    
    override open func commitComposition(_ sender: Any!) {
        PrintLog.shared.Log(log: "Commit Composition?")
        self.hangul.Flush()
        self.update_display(client: sender)
    }
}
