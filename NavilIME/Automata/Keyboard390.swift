//
//  Keyboard390.swift
//  automata
//
//  Created by Manwoo Yi on 9/21/22.
//

import Foundation

class Keyboard390 : Keyboard {
    override init() {
        super.init()
        
        self.name = "세벌390"
        self.id = 390
        
        // 초성 레이아웃
        self.chosung_layout = [
            "0":Chosung.Kiyuk,
            
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
            "4":Jungsung.Yo,
            "5":Jungsung.Yu,
            "6":Jungsung.Ya,
            "7":Jungsung.Ye,
            "8":Jungsung.Yi,
            "9":Jungsung.U,
            
            "e":Jungsung.Yeo,
            "r":Jungsung.Ae,    "R":Jungsung.Yae,
            "t":Jungsung.Eo,
                
            "d":Jungsung.I,
            "f":Jungsung.A,
            "g":Jungsung.Eu,
                
            "c":Jungsung.E,
            "v":Jungsung.O,
            "b":Jungsung.U,
                
            "/":Jungsung.O,
            
            // 이중모음
            "vf":Jungsung.Wa,
            "vr":Jungsung.Wae,
            "vd":Jungsung.Oe,
            "bt":Jungsung.Weo,      "9t":Jungsung.Weo,
            "bc":Jungsung.We,       "9c":Jungsung.We,
            "bd":Jungsung.Wi,       "9d":Jungsung.Wi
        ]
        
        // 종성 레이아웃
        self.jongsung_layout = [
            "1":Jongsung.Hieuh,     "!":Jongsung.Cieuc,
            "2":Jongsung.Ssangsios,
            "3":Jongsung.Pieup,
                
            "q":Jongsung.Sios,      "Q":Jongsung.Phieuph,
            "w":Jongsung.Rieul,     "W":Jongsung.Thieuth,
                                    "E":Jongsung.Khieukh,
                
            "a":Jongsung.Ieung,     "A":Jongsung.Tikeut,
            "s":Jongsung.Nieun,     "S":Jongsung.Nieunhieuh,
                                    "D":Jongsung.Rieulkiyeok,
                                    "F":Jongsung.Ssangkiyeok,
                
            "z":Jongsung.Mieum,     "Z":Jongsung.Chieuch,
            "x":Jongsung.Kiyeok,    "X":Jongsung.Pieupsios,
                                    "C":Jongsung.Rieulmieum,
                                    "V":Jongsung.Rieulhieuh,
                
            // 겹받침
            "xq":Jongsung.Kiyeoksios,  // ᆪ
            "s1":Jongsung.Nieuncieuc,  // ᆬ
            "w3":Jongsung.Rieulpieup,  // ᆲ
            "wq":Jongsung.Rieulsios,   // ᆳ
            "wW":Jongsung.Rieulthieuth,// ᆴ
            "wQ":Jongsung.Rieulphieuph,// ᆵ
        ]
        
        // 기타 기호, 숫자 레이아웃
        self.etc_layout = [
            "T":";",    "Y":"<",    "U":"7",    "I":"8",    "O":"9",    "P":">",
            "G":"/",    "H":"'",    "J":"4",    "K":"5",    "L":"6",
            "B":"!",    "N":"0",    "M":"1",    "<":"2",    ">":"3"
        ]
    }
}
