//
//  KeyboardS3P2.swift
//  NavilIME
//
//  Created by BADA IM on 2023/04/04.
//

import Foundation

class KeyboardS3P2 : Keyboard {
    override init() {
        super.init()
        
        self.name = "신세벌P2"
        self.id = 32
        
        // 초성 레이아웃
        self.chosung_layout = [
            "/":Chosung.Kiyuk,
            
            "y":Chosung.Riel,
            "u":Chosung.Digek,  "uu":Chosung.SsDigek,
            "i":Chosung.Miem,
            "o":Chosung.Chiek,
            "p":Chosung.Piep,
            
            "h":Chosung.Nien,
            "j":Chosung.Yieng,
            "k":Chosung.Giyuk,  "kk":Chosung.SsGiyuk,
            "l":Chosung.Jiek,   "ll":Chosung.SsJiek,
            ";":Chosung.Biep,   ";;":Chosung.SsBiep,
            "'":Chosung.Tigek,
            
            "n":Chosung.Siot,   "nn":Chosung.SsSiot,
            "m":Chosung.Hiek
        ]
        
        // 중성 레이아웃
        self.jungsung_layout = [
            "q":Jungsung.Yae,   "Q":Jungsung.Yae,
            "w":Jungsung.Ya,    "W":Jungsung.Ya,
            "e":Jungsung.Ae,    "E":Jungsung.Ae,
            "r":Jungsung.Eo,    "R":Jungsung.Eo,
            "t":Jungsung.Yeo,   "T":Jungsung.Yeo,
            
            "a":Jungsung.Yu,    "A":Jungsung.Yu,
            "s":Jungsung.Ye,    "S":Jungsung.Ye,
            "d":Jungsung.I,     "D":Jungsung.I,
            "f":Jungsung.A,     "F":Jungsung.A,
            "g":Jungsung.Eu,    "G":Jungsung.Eu,
            
            "i":Jungsung.Eu,    "id":Jungsung.Yi,
            
            "z":Jungsung.YetAraea,
            
            "x":Jungsung.Yo,    "X":Jungsung.Yo,
            "c":Jungsung.E,     "C":Jungsung.E,
            "v":Jungsung.O,     "V":Jungsung.O,
            "b":Jungsung.U,     "B":Jungsung.U,
            
            "o":Jungsung.U,
            "/":Jungsung.O,
            
            // 이중모음
            "/f":Jungsung.Wa,
            "/e":Jungsung.Wae,
            "/d":Jungsung.Oe,
            "or":Jungsung.Weo,
            "oc":Jungsung.We,
            "od":Jungsung.Wi
        ]
        
        // 종성 레이아웃
        self.jongsung_layout = [
            "q":Jongsung.Sios,
            "w":Jongsung.Rieul,
            "e":Jongsung.Pieup,
            "r":Jongsung.Thieuth,
            "t":Jongsung.Khieukh,
            
            "a":Jongsung.Ieung,
            "s":Jongsung.Nieun,
            "d":Jongsung.Hieuh,
            "f":Jongsung.Phieuph,
            "g":Jongsung.Tikeut,
            
            "z":Jongsung.Mieum,
            "x":Jongsung.Ssangsios,
            "c":Jongsung.Kiyeok,
            "v":Jongsung.Cieuc,
            "b":Jongsung.Chieuch,
            
            // 겹받침
            "sd":Jongsung.Nieunhieuh,  // ᆭ
            "wc":Jongsung.Rieulkiyeok, // ᆰ
            "cc":Jongsung.Ssangkiyeok, // ᆩ
            "eq":Jongsung.Pieupsios,   // ᆹ
            "wz":Jongsung.Rieulmieum,  // ᆱ
            "wd":Jongsung.Rieulhieuh,  // ᆶ
            "cq":Jongsung.Kiyeoksios,  // ᆪ
            "sv":Jongsung.Nieuncieuc,  // ᆬ
            "we":Jongsung.Rieulpieup,  // ᆲ
            "wq":Jongsung.Rieulsios,   // ᆳ
            "wr":Jongsung.Rieulthieuth,// ᆴ
            "wf":Jongsung.Rieulphieuph,// ᆵ
        ]
        
        // 기타 기호, 숫자 레이아웃
        self.etc_layout = [
            "Y":"×", "U":"○", "I":"I", "O":"O", "P":";",
            "H":"□", "J":"'", "K":"\"", "L":"·", ":":":", "\"":"/",
            "N":"―", "M":"…", "<":"<", ">":">", "?":"?",
        ]
    }
    
    override func chosung_proc(comp: inout Composition, ch: String) -> Bool {
        if comp.jongsung != "" {
            return false
        }
        let chokey:String = comp.chosung + ch
        return self.chosung_layout[chokey] != nil ? true : false
    }

    override func jungsung_proc(comp: inout Composition, ch: String) -> Bool {
        if comp.chosung == ""  {
            if ch.range(of: "[QWERTASDFGXCVB]", options: .regularExpression, range: nil, locale: nil) != nil {
                if comp.jongsung != "" {
                    return false
                }
            }
            else {
                return false
            }
        }
        let jungkey:String = comp.jungsung + ch
        return self.jungsung_layout[jungkey] != nil ? true : false
    }
    
    override func jongsung_proc(comp: inout Composition, ch: String) -> Bool {
        let jongkey:String = comp.jongsung + ch
        return self.jongsung_layout[jongkey] != nil ? true : false
    }
}
