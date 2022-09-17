//
//  Keyboards.swift
//  automata
//
//  Created by Manwoo Yi on 9/10/22.
//

import Foundation

enum Chosung:unichar {
    // 현대 한글 초성
    case Giyuk       = 0x1100 //ᄀ
    case SsGiyuk     = 0x1101 //ᄁ
    case Nien        = 0x1102 //ᄂ
    case Digek       = 0x1103 //ᄃ
    case SsDigek     = 0x1104 //ᄄ
    case Riel        = 0x1105 //ᄅ
    case Miem        = 0x1106 //ᄆ
    case Biep        = 0x1107 //ᄇ
    case SsBiep      = 0x1108 //ᄈ
    case Siot        = 0x1109 //ᄉ
    case SsSiot      = 0x110a //ᄊ
    case Yieng       = 0x110b //ᄋ
    case Jiek        = 0x110c //ᄌ
    case SsJiek      = 0x110d //ᄍ
    case Chiek       = 0x110e //ᄎ
    case Kiyuk       = 0x110f //ᄏ
    case Tigek       = 0x1110 //ᄐ
    case Piep        = 0x1111 //ᄑ
    case Hiek        = 0x1112 //ᄒ
    // 여기부터 옛 한글 초성
    case YetNG       = 0x1113 //ᄓ
    case YetNN       = 0x1114 //ᄔ
    case YetND       = 0x1115 //ᄕ
    case YetNB       = 0x1116 //ᄖ
    case YetDG       = 0x1117 //ᄗ
    case YetRN       = 0x1118 //ᄘ
    case YetRR       = 0x1119 //ᄙ
    case YetRH       = 0x111a //ᄚ
    case YetRO       = 0x111b //ᄛ
    case YetMB       = 0x111c //ᄜ
    case YetMO       = 0x111d //ᄝ
    case YetBG       = 0x111e //ᄞ
    case YetBN       = 0x111f //ᄟ
    case YetBD       = 0x1120 //ᄠ
    case YetBS       = 0x1121 //ᄡ
    case YetBSG      = 0x1122 //ᄢ
    case YetBSD      = 0x1123 //ᄣ
    case YetBSB      = 0x1124 //ᄤ
    case YetBSS      = 0x1125 //ᄥ
    case YetBSJ      = 0x1126 //ᄦ
    case YetBJ       = 0x1127 //ᄧ
    case YetBC       = 0x1128 //ᄨ
    case YetBT       = 0x1129 //ᄩ
    case YetBP       = 0x112a //ᄪ
    case YetBO       = 0x112b //ᄫ
    case YetSBO      = 0x112c //ᄬ
    case YetSG       = 0x112d //ᄭ
    case YetSN       = 0x112e //ᄮ
    case YetSD       = 0x112f //ᄯ
    case YetSR       = 0x1130 //ᄰ
    case YetSM       = 0x1131 //ᄱ
    case YetSB       = 0x1132 //ᄲ
    case YetSBG      = 0x1133 //ᄳ
    case YetSSS      = 0x1134 //ᄴ
    case YetSY       = 0x1135 //ᄵ
    case YetSJ       = 0x1136 //ᄶ
    case YetSC       = 0x1137 //ᄷ
    case YetSK       = 0x1138 //ᄸ
    case YetST       = 0x1139 //ᄹ
    case YetSP       = 0x113a //ᄺ
    case YetSH       = 0x113b //ᄻ
    case YetSl       = 0x113c //ᄼ
    case YetSlSl     = 0x113d //ᄽ
    case YetSr       = 0x113e //ᄾ
    case YetSrSr     = 0x113f //ᄿ
    case YetPaS      = 0x1140 //ᅀ
    case YetYG       = 0x1141 //ᅁ
    case YetYD       = 0x1142 //ᅂ
    case YetYM       = 0x1143 //ᅃ
    case YetYB       = 0x1144 //ᅄ
    case YetYS       = 0x1145 //ᅅ
    case YetYPaS     = 0x1146 //ᅆ
    case YetYY       = 0x1147 //ᅇ
    case YetYJ       = 0x1148 //ᅈ
    case YetYC       = 0x1149 //ᅉ
    case YetYT       = 0x114a //ᅊ
    case YetYP       = 0x114b //ᅋ
    case YetY        = 0x114c //ᅌ
    case YetJY       = 0x114d //ᅍ
    case YetJl       = 0x114e //ᅎ
    case YetJlJl     = 0x114f //ᅏ
    case YetJr       = 0x1150 //ᅐ
    case YetJrJr     = 0x1151 //ᅑ
    case YetCK       = 0x1152 //ᅒ
    case YetCH       = 0x1153 //ᅓ
    case YetCl       = 0x1154 //ᅔ
    case YetCr       = 0x1155 //ᅕ
    case YetPB       = 0x1156 //ᅖ
    case YetPO       = 0x1157 //ᅗ
    case YetHH       = 0x1158 //ᅘ
    case YetYH       = 0x1159 //ᅙ
    case YetGD       = 0x115a //ᅚ
    case YetNS       = 0x115b //ᅛ
    case YetNJ       = 0x115c //ᅜ
    case YetNH       = 0x115d //ᅝ
    case YetDR       = 0x115e //ᅞ
    case Filler      = 0x115f //ᅟ
}

enum Jungsung:unichar {
    case Filler     = 0x1160 //
    // 현대 한글 중성ᅠ
    case A          = 0x1161 // ᅡ
    case Ae         = 0x1162 // ᅢ
    case Ya         = 0x1163 // ᅣ
    case Yae        = 0x1164 // ᅤ
    case Eo         = 0x1165 // ᅥ
    case E          = 0x1166 // ᅦ
    case Yeo        = 0x1167 // ᅧ
    case Ye         = 0x1168 // ᅨ
    case O          = 0x1169 // ᅩ
    case Wa         = 0x116a // ᅪ
    case Wae        = 0x116b // ᅫ
    case Oe         = 0x116c // ᅬ
    case Yo         = 0x116d // ᅭ
    case U          = 0x116e // ᅮ
    case Weo        = 0x116f // ᅯ
    case We         = 0x1170 // ᅰ
    case Wi         = 0x1171 // ᅱ
    case Yu         = 0x1172 // ᅲ
    case Eu         = 0x1173 // ᅳ
    case Yi         = 0x1174 // ᅴ
    case I          = 0x1175 // ᅵ
    // 옛 한글 중성
    case YetAo      = 0x1176 // ᅶ
    case YetAu      = 0x1177 // ᅷ
    case YetYao     = 0x1178 // ᅸ
    case YetYayo    = 0x1179 // ᅹ
    case YetEoo     = 0x117a // ᅺ
    case YetEou     = 0x117b // ᅻ
    case YetEoeu    = 0x117c // ᅼ
    case YetYeoo    = 0x117d // ᅽ
    case YetYeou    = 0x117e // ᅾ
    case YetOeo     = 0x117f // ᅿ
    case YetOe      = 0x1180 // ᆀ
    case YetOye     = 0x1181 // ᆁ
    case YetOo      = 0x1182 // ᆂ
    case YetOu      = 0x1183 // ᆃ
    case YetYoya    = 0x1184 // ᆄ
    case YetYoyae   = 0x1185 // ᆅ
    case YetYoyeo   = 0x1186 // ᆆ
    case YetYoo     = 0x1187 // ᆇ
    case YetYoi     = 0x1188 // ᆈ
    case YetUa      = 0x1189 // ᆉ
    case YetUae     = 0x118a // ᆊ
    case YetUeoeu   = 0x118b // ᆋ
    case YetUye     = 0x118c // ᆌ
    case YetUu      = 0x118d // ᆍ
    case YetYua     = 0x118e // ᆎ
    case YetYueo    = 0x118f // ᆏ
    case YetYue     = 0x1190 // ᆐ
    case YetYuyeo   = 0x1191 // ᆑ
    case YetYuye    = 0x1192 // ᆒ
    case YetYuu     = 0x1193 // ᆓ
    case YetYui     = 0x1194 // ᆔ
    case YetEuu     = 0x1195 // ᆕ
    case YetEueu    = 0x1196 // ᆖ
    case YetYiu     = 0x1197 // ᆗ
    case YetIa      = 0x1198 // ᆘ
    case YetIya     = 0x1199 // ᆙ
    case YetIo      = 0x119a // ᆚ
    case YetIu      = 0x119b // ᆛ
    case YetIeu     = 0x119c // ᆜ
    case YetIaraea  = 0x119d // ᆝ
    case YetAraea   = 0x119e // ᆞ
    case YetAraeaeo = 0x119f // ᆟ
    case YetAraeau  = 0x11a0 // ᆠ
    case YetAraeai  = 0x11a1 // ᆡ
    case YetSsaraea = 0x11a2 // ᆢ
    case YetAeu     = 0x11a3 // ᆣ
    case YetYau     = 0x11a4 // ᆤ
    case YetYeoya   = 0x11a5 // ᆥ
    case YetOya     = 0x11a6 // ᆦ
    case YetOyae    = 0x11a7 // ᆧ
}

enum Jongsung:unichar {
    // 현대 한글 종성
    case Kiyeok               = 0x11a8 // ᆨ
    case Ssangkiyeok          = 0x11a9 // ᆩ
    case Kiyeoksios           = 0x11aa // ᆪ
    case Nieun                = 0x11ab // ᆫ
    case Nieuncieuc           = 0x11ac // ᆬ
    case Nieunhieuh           = 0x11ad // ᆭ
    case Tikeut               = 0x11ae // ᆮ
    case Rieul                = 0x11af // ᆯ
    case Rieulkiyeok          = 0x11b0 // ᆰ
    case Rieulmieum           = 0x11b1 // ᆱ
    case Rieulpieup           = 0x11b2 // ᆲ
    case Rieulsios            = 0x11b3 // ᆳ
    case Rieulthieuth         = 0x11b4 // ᆴ
    case Rieulphieuph         = 0x11b5 // ᆵ
    case Rieulhieuh           = 0x11b6 // ᆶ
    case Mieum                = 0x11b7 // ᆷ
    case Pieup                = 0x11b8 // ᆸ
    case Pieupsios            = 0x11b9 // ᆹ
    case Sios                 = 0x11ba // ᆺ
    case Ssangsios            = 0x11bb // ᆻ
    case Ieung                = 0x11bc // ᆼ
    case Cieuc                = 0x11bd // ᆽ
    case Chieuch              = 0x11be // ᆾ
    case Khieukh              = 0x11bf // ᆿ
    case Thieuth              = 0x11c0 // ᇀ
    case Phieuph              = 0x11c1 // ᇁ
    case Hieuh                = 0x11c2 // ᇂ
    // 옛 한글 종성
    case YetKiyeokrieul       = 0x11c3 // ᇃ
    case YetKiyeoksioskiyeok  = 0x11c4 // ᇄ
    case YetNieunkiyeok       = 0x11c5 // ᇅ
    case YetNieuntikeut       = 0x11c6 // ᇆ
    case YetNieunsios         = 0x11c7 // ᇇ
    case YetNieunpansios      = 0x11c8 // ᇈ
    case YetNieunthieuth      = 0x11c9 // ᇉ
    case YetTikeutkiyeok      = 0x11ca // ᇊ
    case YetTikeutrieul       = 0x11cb // ᇋ
    case YetRieulkiyeoksios   = 0x11cc // ᇌ
    case YetRieulnieun        = 0x11cd // ᇍ
    case YetRieultikeut       = 0x11ce // ᇎ
    case YetRieultikeuthieuh  = 0x11cf // ᇏ
    case YetSsangrieul        = 0x11d0 // ᇐ
    case YetRieulmieumkiyeok  = 0x11d1 // ᇑ
    case YetRieulmieumsios    = 0x11d2 // ᇒ
    case YetRieulpieupsios    = 0x11d3 // ᇓ
    case YetRieulpieuphieuh   = 0x11d4 // ᇔ
    case YetRieulpyeunpieup   = 0x11d5 // ᇕ
    case YetRieulssangsios    = 0x11d6 // ᇖ
    case YetRieulpansios      = 0x11d7 // ᇗ
    case YetRieulkhieukh      = 0x11d8 // ᇘ
    case YetRieulyeorinhieuh  = 0x11d9 // ᇙ
    case YetMieumkiyeok       = 0x11da // ᇚ
    case YetMieumrieul        = 0x11db // ᇛ
    case YetMieumpieup        = 0x11dc // ᇜ
    case YetMieumsios         = 0x11dd // ᇝ
    case YetMieumssangsios    = 0x11de // ᇞ
    case YetMieumpansios      = 0x11df // ᇟ
    case YetMieumchieuch      = 0x11e0 // ᇠ
    case YetMieumhieuh        = 0x11e1 // ᇡ
    case YetKapyeounmieum     = 0x11e2 // ᇢ
    case YetPieuprieul        = 0x11e3 // ᇣ
    case YetPieupphieuph      = 0x11e4 // ᇤ
    case YetPieuphieuh        = 0x11e5 // ᇥ
    case YetKapyeounpieup     = 0x11e6 // ᇦ
    case YetSioskiyeok        = 0x11e7 // ᇧ
    case YetSiostikeut        = 0x11e8 // ᇨ
    case YetSiosrieul         = 0x11e9 // ᇩ
    case YetSiospieup         = 0x11ea // ᇪ
    case YetPansios           = 0x11eb // ᇫ
    case YetIeungkiyeok       = 0x11ec // ᇬ
    case YetIeungssangkiyeok  = 0x11ed // ᇭ
    case YetSsangieung        = 0x11ee // ᇮ
    case YetIeungkhieukh      = 0x11ef // ᇯ
    case YetYesieung          = 0x11f0 // ᇰ
    case YetYesieungsios      = 0x11f1 // ᇱ
    case YetYesieungpansios   = 0x11f2 // ᇲ
    case YetPhieuphpieup      = 0x11f3 // ᇳ
    case YetKapyeounphieuph   = 0x11f4 // ᇴ
    case YetHieuhnieun        = 0x11f5 // ᇵ
    case YetHieuhrieul        = 0x11f6 // ᇶ
    case YetHieuhmieum        = 0x11f7 // ᇷ
    case YetHieuhpieup        = 0x11f8 // ᇸ
    case YetYeorinhieuh       = 0x11f9 // ᇹ
    case YetKiyeoknieun       = 0x11fa // ᇺ
    case YetKiyeokpieup       = 0x11fb // ᇻ
    case YetKiyeokchieuch     = 0x11fc // ᇼ
    case YetKiyeokkhieukh     = 0x11fd // ᇽ
    case YetKiyeokhieuh       = 0x11fe // ᇾ
    case YetSsangnieun        = 0x11ff // ᇿ
}

enum NormType {
    case NFC
    case NFD
}

class Keyboard {
    var chosung_layout:[String:Chosung]
    var jungsung_layout:[String:Jungsung]
    var jongsung_layout:[String:Jongsung]
    
    init() {
        self.chosung_layout = [:]
        self.jungsung_layout = [:]
        self.jongsung_layout = [:]
    }
    
    func chosung_proc(comp:Composition, ch:String) -> Bool {
        self.chosung_layout[ch] != nil ? true : false
    }
    
    func jungsung_proc(comp:Composition, ch:String) -> Bool {
        self.jungsung_layout[ch] != nil ? true : false
    }
    
    func jongsung_proc(comp:Composition, ch:String) -> Bool {
        self.jongsung_layout[ch] != nil ? true : false
    }
    
    func is_hangul(ch:String) -> Bool {
        // chosung_proc(),jungsung_proc(), jongsung_proc()은 override 가능하기 때문에
        // 초중종성 키매핑 레이아웃에서 직접 검색한다.
        let is_cho = self.chosung_layout[ch] != nil ? true : false
        let is_jung = self.jungsung_layout[ch] != nil ? true : false
        let is_jong = self.jongsung_layout[ch] != nil ? true : false
        return (is_cho || is_jung || is_jong)
    }
    
    func debugout(comp:Composition) -> String {
        if comp.Size != 0 {
            let ch:String = comp.chosung != "" ? comp.chosung : "X"
            let ju:String = comp.jungsung != "" ? comp.jungsung : "X"
            let jo:String = comp.jongsung != "" ? comp.jongsung : "X"
            
            return ch + ju + jo
        }
        return ""
    }
    
    func norm_nfd(comp:Composition) -> [unichar] {
        var mac_nfd:[unichar] = []
        
        if comp.Size == 0 {
            return mac_nfd
        }
        
        // 맥 기본앱인 메모(Memo) 앱은 중성이 혼자 있고 조합 중인 상황에서 무조건 앞에 한글자를 잡아서 초성으로 간주한다.
        // 그래서 초성만 filler를 넣어준다. 다른 앱에서도 적당히 괜찮게 동작한다.
        
        // 초성
        if let chosung_unicode = self.chosung_layout[comp.chosung] {
            mac_nfd.append(chosung_unicode.rawValue)
        } else {
            mac_nfd.append(Chosung.Filler.rawValue)
        }
        
        // 중성
        if let jungsung_unicode = self.jungsung_layout[comp.jungsung]{
            mac_nfd.append(jungsung_unicode.rawValue)
        }
        
        // 종성
        if let jongsung_unicode = self.jongsung_layout[comp.jongsung] {
            mac_nfd.append(jongsung_unicode.rawValue)
        }
        
        return mac_nfd
    }
    
    func norm_nfc(comp:Composition) -> [unichar] {
        var nfc:[unichar] = []
        
        let cho_base = Chosung.Giyuk.rawValue
        let jung_base = Jungsung.A.rawValue
        let jong_base = Jongsung.Kiyeok.rawValue - 1
        
        // ((초성인덱스 * 588) + (중성인덱스 * 28) + 종성인덱스) + 0xAC00
        var cho_idx:Int = -1
        var jung_idx:Int = -1
        var jong_idx:Int = 0
        
        if let chosung_unicode = self.chosung_layout[comp.chosung] {
            cho_idx = Int(chosung_unicode.rawValue - cho_base)
        }
        if let jungsung_unicode = self.jungsung_layout[comp.jungsung]{
            jung_idx = Int(jungsung_unicode.rawValue - jung_base)
        }
        if let jongsung_unicode = self.jongsung_layout[comp.jongsung] {
            jong_idx = Int(jongsung_unicode.rawValue - jong_base)
        }
        
        if (cho_idx != -1) && (jung_idx != -1) {
            let uni_han = (cho_idx * 588) + (jung_idx * 28) + jong_idx + 0xac00
            let uch:unichar = unichar(uni_han)
            nfc = [uch]
        } else {
            // 초성과 중성이 없으면 완성된 글자가 아니므로 NFD로 정규화
            nfc = self.norm_nfd(comp: comp)
        }
        
        return nfc
    }
    
    func normalization(comp:Composition, norm_type:NormType) -> [unichar] {
        var norm:[unichar] = []
        
        if norm_type == NormType.NFC {
            norm = self.norm_nfc(comp: comp)
        } else if norm_type == NormType.NFD {
            norm = self.norm_nfd(comp: comp)
        }
        
        return norm
    }
}

