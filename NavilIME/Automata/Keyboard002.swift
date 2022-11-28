//
//  Keyboard002.swift
//  automata
//
//  Created by Manwoo Yi on 9/30/22.
//

import Foundation

class Keyboard002 : Keyboard {
    override init() {
        super.init()
        
        self.name = "두벌식"
        self.id = 2
        
        // 초성 레이아웃
        self.chosung_layout = [
            "Q":Chosung.SsBiep, "qq":Chosung.SsBiep,
            "W":Chosung.SsJiek, "ww":Chosung.SsJiek,
            "E":Chosung.SsDigek, "ee":Chosung.SsDigek,
            "R":Chosung.SsGiyuk, "rr":Chosung.SsGiyuk,
            "T":Chosung.SsSiot, "tt":Chosung.SsSiot,
            
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
            "O":Jungsung.Yae, "oo":Jungsung.Yae,
            "P":Jungsung.Ye, "pp":Jungsung.Ye,
            
            // 타이핑 속도가 매우 빠르거나 (천타 이상)
            // 그냥 쌍자음 입력후 시프트를 오래 누르는 경우 (시프트를 늦게 떼는 경우) 두벌식 모음 입력이 안되는 현상이 생김
            // 그래서 대문자에도 모음을 맵핑함
            "y":Jungsung.Yo, "Y":Jungsung.Yo,
            "u":Jungsung.Yeo, "U":Jungsung.Yeo,
            "i":Jungsung.Ya, "I":Jungsung.Ya,
            "o":Jungsung.Ae, // 이중 모음이 있으므로 대문자 맵핑 안함
            "p":Jungsung.E,  // 이중 모음이 있으므로 대문자 맵핑 안함
            
            "h":Jungsung.O, "H":Jungsung.O,
            "j":Jungsung.Eo, "J":Jungsung.Eo,
            "k":Jungsung.A, "K":Jungsung.A,
            "l":Jungsung.I, "L":Jungsung.I,
            
            "b":Jungsung.Yu, "B":Jungsung.Yu,
            "n":Jungsung.U, "N":Jungsung.U,
            "m":Jungsung.Eu, "M":Jungsung.Eu,
            
            // 이중 모음 (ㅘ,ㅙ,ㅝ,ㅞ,ㅚ,ㅟ,ㅢ)
            "hk":Jungsung.Wa, "Hk":Jungsung.Wa, "HK":Jungsung.Wa,
            "ho":Jungsung.Wae, "Ho":Jungsung.Wae, "HO":Jungsung.Wae,
            "nj":Jungsung.Weo, "Nj":Jungsung.Weo, "NJ":Jungsung.Weo,
            "np":Jungsung.We, "Np":Jungsung.We, "NP":Jungsung.We,
            "hl":Jungsung.Oe, "Hl":Jungsung.Oe, "HL":Jungsung.Oe,
            "nl":Jungsung.Wi, "Nl":Jungsung.Wi, "NL":Jungsung.Wi,
            "ml":Jungsung.Yi, "Ml":Jungsung.Yi, "ML":Jungsung.Yi
        ]
        
        // 종성 레이아웃
        self.jongsung_layout = [
            "r":Jongsung.Kiyeok,
            "R":Jongsung.Ssangkiyeok,
            "rt":Jongsung.Kiyeoksios,
            "s":Jongsung.Nieun,
            "sw":Jongsung.Nieuncieuc,
            "sg":Jongsung.Nieunhieuh,
            "e":Jongsung.Tikeut,
            "f":Jongsung.Rieul,
            "fr":Jongsung.Rieulkiyeok,
            "fa":Jongsung.Rieulmieum,
            "fq":Jongsung.Rieulpieup,
            "ft":Jongsung.Rieulsios,
            "fx":Jongsung.Rieulthieuth,
            "fv":Jongsung.Rieulphieuph,
            "fg":Jongsung.Rieulhieuh,
            "a":Jongsung.Mieum,
            "q":Jongsung.Pieup,
            "qt":Jongsung.Pieupsios,
            "t":Jongsung.Sios,
            "T":Jongsung.Ssangsios,
            "d":Jongsung.Ieung,
            "w":Jongsung.Cieuc,
            "c":Jongsung.Chieuch,
            "z":Jongsung.Khieukh,
            "x":Jongsung.Thieuth,
            "v":Jongsung.Phieuph,
            "g":Jongsung.Hieuh
        ]
    }
    
    override func chosung_proc(comp: inout Composition, ch: String) -> Bool {
        // 기존 입력에 초성이 있고 중성도 있음
        if comp.chosung != "" && comp.jungsung != "" {
            // 초성 테이블에서 더이상 검색하지 않음
            return false
        }
        let chokey:String = comp.chosung + ch
        return self.chosung_layout[chokey] != nil ? true : false
    }
    
    override func jungsung_proc(comp: inout Composition, ch: String) -> Bool {
        // 입력이 중성이 아니면 일단 넘어감
        if self.jungsung_layout[ch] == nil {
            return false
        }
        // 종성이 있고
        if comp.jongsung != "" {
            // 종성의 마지막 글자 (종성은 겹받침이 가능하므로 최대 두 글자)
            var jong_arr = Array(comp.jongsung)
            let jong_last = jong_arr.removeLast()
            // 종성이 초성 테이블에 있으면 (앞글자의 종성이 다음 글자의 초성으로 가는 상황.. 도깨비불 현상)
            if self.chosung_layout[String(jong_last)] != nil {
                // 종성 마지막 글자를 없애고 조합 완료를 표시하고 더이상 검색하지 않음
                comp.jongsung = String(jong_arr)
                comp.done = true
                return false
            }
        }
        // 다른 예외 없이 중성이 입력되었단 뜻
        // 그러므로 이중 모음을 찾아봄
        let jungkey:String = comp.jungsung + ch
        return self.jungsung_layout[jungkey] != nil ? true : false
    }
    
    override func jongsung_proc(comp: inout Composition, ch: String) -> Bool {
        // 중성이 없으면 검색하지 않음
        if comp.jungsung == "" {
            return false
        }
        let jongkey:String = comp.jongsung + ch
        return self.jongsung_layout[jongkey] != nil ? true : false
    }
}
