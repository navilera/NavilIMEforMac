//
//  SingletonOpt.swift
//  NavilIME
//
//  Created by Manwoo Yi on 3/31/23.
//

import Foundation

class OptHandler {
    static let shared = OptHandler()

    let opt_menu_tag = 0xffff
    
    private init() { }
    
    func Dubul_no_shift(sel:Int) {
        // sel 이 0 이면 no shift: ㄸㄸㄸ 로 입력됨
        // sel 이 1 이면 shift: ㄷㄷㄷ 로 입력됨
        
        for k in Hangul.hangul_keyboard {
            if k.id == 2 {
                if let dubul = k as? Keyboard002 {
                    dubul.sel_no_shift(sel: sel)
                }
            }
        }
    }
}

