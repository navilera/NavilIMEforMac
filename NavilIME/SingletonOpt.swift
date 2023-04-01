//
//  SingletonOpt.swift
//  NavilIME
//
//  Created by Manwoo Yi on 3/31/23.
//

import Foundation
import Cocoa

class OptHandler {
    static let shared = OptHandler()

    let opt_menu_tag = 0xffff
    
    var dubul_no_shift_checkbox: NSButton?
    
    private init() { }
    
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
}

