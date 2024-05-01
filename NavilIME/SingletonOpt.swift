//
//  SingletonOpt.swift
//  NavilIME
//
//  Created by Manwoo Yi on 3/31/23.
//
//  UI와 연결된 객체는 AppDelegate.swift 에 있다.
//

import Foundation
import Cocoa

class OptHandler {
    static let shared = OptHandler()

    let opt_menu_tag = 0xffff
    
    // 두벌식 옵션
    var dubul_no_shift_checkbox: NSButton?
    
    // 한영전환 옵션
    var hotkeys: [NSButton] = []
    let hotkeys_db_key = "han_eng_hotkey_opt"
    var hotkey_radio_tag = 0
    
    private init() { 
        hotkey_radio_tag = UserDefaults.standard.integer(forKey: hotkeys_db_key)
    }
    
    func Open_opt_window(_ sender:Any?) {
        if dubul_no_shift_checkbox != nil {
            if let dubul = Hangul.Get_keyboard002() {
                if dubul.sel_cho_layout == 0 {
                    dubul_no_shift_checkbox?.state = NSControl.StateValue.off
                } else {
                    dubul_no_shift_checkbox?.state = NSControl.StateValue.on
                }
            }
        }
        
        PrintLog.shared.Log(log: "Selected hotkey \(hotkey_radio_tag) - \(String(describing: self.hotkeys.count))")
        if hotkeys.count != 0 {
            for hk in hotkeys {
                PrintLog.shared.Log(log: "hotkey tag \(hk.tag) - \(hk.title)")
                if hk.tag == hotkey_radio_tag {
                    hk.state = NSControl.StateValue.on
                }
            }
        }
        
        if let w = NSApplication.shared.windows.first {
            w.makeKeyAndOrderFront(sender)
        }
    }
    
    func Dubul_no_shift(sel:Int) {
        // sel 이 0 이면 no shift: ㄸㄸㄸ 로 입력됨
        // sel 이 1 이면 shift: ㄷㄷㄷ 로 입력됨
        if let dubul = Hangul.Get_keyboard002() {
                dubul.sel_no_shift(sel: sel)
        }
    }
    
    func HanEng_hotkey(sel:Int) {
        hotkey_radio_tag = sel
        UserDefaults.standard.set(hotkey_radio_tag, forKey: hotkeys_db_key)
        UserDefaults.standard.synchronize()
    }
    
    func Is_han_eng_changed(keycode:uint16, modi:NSEvent.ModifierFlags) -> Bool {
        /*
         오른쪽 cmd = 54 — keycode=54 modi=1048576
         오른쪽 옵션 = 61 — keycode=61 modi=524288
         스페이스 시프트 — keycode=56 modi=131072
         keycode = 49 cmd = false opt = false shift = true
         */
        PrintLog.shared.Log(log: "keycode = \(keycode) cmd = \(modi.contains(.command)) opt = \(modi.contains(.option)) shift = \(modi.contains(.shift))")
       
        // nothing
        if hotkey_radio_tag == 0 {
            return false
        }
        // shift + space
        if hotkey_radio_tag == 1 {
            /* keycode = 49 cmd = false opt = false shift = true */
            if keycode == 49 && modi.contains(.shift) {
                return true
            }
        }
        // right cmd
        if hotkey_radio_tag == 2 {
            /* keycode = 54 cmd = true opt = false shift = false */
            if keycode == 54 && modi.contains(.command) {
                return true
            }
        }
        // right opt
        if hotkey_radio_tag == 3 {
            /* keycode = 61 cmd = false opt = true shift = false */
            if keycode == 61 && modi.contains(.option) {
                return true
            }
        }
        return false
    }
}

