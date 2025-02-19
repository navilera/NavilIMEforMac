//
//  Keyboard318.swift
//  automata
//
//  Created by Manwoo Yi on 9/10/22.
//

import Foundation

class Keyboard318 : Keyboard {
    
    
    override init() {
        super.init()
        
        self.name = "세벌318"
        self.id = 318
        
        // 초성 레이아웃
        self.chosung_layout = [
            "Q":Chosung.SsBiep,
            "W":Chosung.SsJiek,
            "E":Chosung.SsDigek,
            "R":Chosung.SsGiyuk,
            "T":Chosung.SsSiot,
            
            "qq":Chosung.SsBiep,
            "ww":Chosung.SsJiek,
            "ee":Chosung.SsDigek,
            "rr":Chosung.SsGiyuk,
            "tt":Chosung.SsSiot,
            
            "q":Chosung.Biep,
            "w":Chosung.Jiek,
            "e":Chosung.Digek,
            "r":Chosung.Giyuk,
            "t":Chosung.Siot,
            
            "a":Chosung.Miem,
            "s":Chosung.Nien,
            "d":Chosung.Yieng,
            "f":Chosung.Riel,
            "g":Chosung.Hiek,
            
            "z":Chosung.Kiyuk,
            "x":Chosung.Tigek,
            "c":Chosung.Chiek,
            "v":Chosung.Piep
        ]
        
        // 중성 레이아웃
        self.jungsung_layout = [
            "O":Jungsung.Yae,
            "P":Jungsung.Ye,
            
            "oo":Jungsung.Yae,
            "pp":Jungsung.Ye,
            
            "y":Jungsung.Yo,
            "u":Jungsung.Yeo,
            "i":Jungsung.Ya,
            "o":Jungsung.Ae,
            "p":Jungsung.E,
            
            "h":Jungsung.O,
            "j":Jungsung.Eo,
            "k":Jungsung.A,
            "l":Jungsung.I,
            
            "b":Jungsung.Yu,
            "n":Jungsung.U,
            "m":Jungsung.Eu,
            
            // 이중 모음 (ㅘ,ㅙ,ㅝ,ㅞ,ㅚ,ㅟ,ㅢ)
            "hk":Jungsung.Wa,
            "ho":Jungsung.Wae,
            "nj":Jungsung.Weo,
            "np":Jungsung.We,
            "hl":Jungsung.Oe,
            "nl":Jungsung.Wi,
            "ml":Jungsung.Yi
        ]
        
        // 종성 레이아웃
        self.jongsung_layout = [
            "y":Jongsung.Kiyeok,    "yy":Jongsung.Ssangkiyeok,
            "u":Jongsung.Sios,      "uu":Jongsung.Ssangsios,
            "i":Jongsung.Ieung,     "ii":Jongsung.Hieuh,        "I":Jongsung.Rieulhieuh,
            
            "h":Jongsung.Nieun,     "hh":Jongsung.Thieuth,      "H":Jongsung.Nieunhieuh,
            
            "J":Jongsung.Pieupsios,
            "K":Jongsung.Rieulkiyeok,
            "L":Jongsung.Nieuncieuc,

            ";":Jongsung.Cieuc,     ";;":Jongsung.Chieuch,

            "b":Jongsung.Pieup,     "bb":Jongsung.Phieuph,      "B":Jongsung.Rieulpieup,
            "n":Jongsung.Rieul,     "nn":Jongsung.Khieukh,
            "m":Jongsung.Mieum,     "mm":Jongsung.Tikeut,       "M":Jongsung.Rieulmieum,
            
            // 겹받침 (ㄳ, ㄵ, ㄶ, ㄺ, ㄻ, ㄼ, ㄾ, ㄿ, ㅀ, ㅄ, ㄽ)
            "yu":Jongsung.Kiyeoksios,
            "h;":Jongsung.Nieuncieuc,
            "hi":Jongsung.Nieunhieuh,
            "ny":Jongsung.Rieulkiyeok,
            "nm":Jongsung.Rieulmieum,
            "nb":Jongsung.Rieulpieup,
            "nh":Jongsung.Rieulthieuth,
            "nbb":Jongsung.Rieulphieuph,
            "ni":Jongsung.Rieulhieuh,
            "bu":Jongsung.Pieupsios,
            "nu":Jongsung.Rieulsios
        ]
    }
    
    override func chosung_proc(comp: inout Composition, ch: String) -> Bool {
        // 직전 입력과 간격이 50ms 이내라면 동시 입력으로 간주한다.
        if self.input_delta < 50 {
            // 종성이 있고
            if comp.jongsung != "" {
                // 종성의 마지막 글자 (종성은 겹받침이 가능하므로 최대 두 글자)
                var jong_arr = Array(comp.jongsung)
                let jong_last = jong_arr.removeLast()
                // 종성으로 입력된 마지막 글자가 중성 테이블에 있으면 다음 글자의 중성으로 인식함
                if self.jungsung_layout[String(jong_last)] != nil {
                    // 종성 마지막 글자를 없애고 조합 완료를 표시하고 더이상 검색하지 않음
                    comp.jongsung = String(jong_arr)
                    comp.done = true
                    return false
                }
            }
        }
        
        let chokey:String = comp.chosung + ch
        return self.chosung_layout[chokey] != nil ? true : false
    }
    
    override func jungsung_proc(comp: inout Composition, ch: String) -> Bool {
        // 기존 입력에 중성 있고 종성도 있음
        if comp.jungsung != "" && comp.jongsung != "" {
            // 중성 테이블에서 더이상 검색하지 않음
            return false
        }
        let jungkey:String = comp.jungsung + ch
        return self.jungsung_layout[jungkey] != nil ? true : false
    }
    
    override func jongsung_proc(comp: inout Composition, ch: String) -> Bool {
        let jongkey:String = comp.jongsung + ch
        return self.jongsung_layout[jongkey] != nil ? true : false
    }
}
