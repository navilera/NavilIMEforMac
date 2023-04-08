//
//  Testcases.swift
//  automata
//
//  Created by Manwoo Yi on 9/10/22.
//

import Foundation
import Cocoa

class TestCase {
    
    var stdout_gui:NSScrollView?
    
    func test_debug(hangul:Hangul, t:String, ch:String, expect_commit:[String], expect_preedit: [String]) {
        var eaten:Bool = true
        var extra:String?
        
        if t == "input" {
            // 백스페이스
            if ch == "//b" {
                let _ = hangul.Backspace()
            } else {
                eaten = hangul.Process(ascii: ch)
                if eaten == false {
                    hangul.Flush()
                    if let etc = hangul.Additional(ascii: ch) {
                        extra = etc
                        eaten = true
                    }
                }
            }
        } else if t == "flush" {
            hangul.Flush()
        } else {
            assert(false)
        }

        var actual_commit = hangul.GetDebug(t: "commit")
        let actual_preedit = hangul.GetDebug(t: "preedit")
        
        if eaten == false {
            actual_commit.append(ch)
        }
        if let etc = extra {
            actual_commit.append(etc)
        }
        
        let commit_unicode:[unichar] = hangul.GetCommit()
        let preedit_unicode:[unichar] = hangul.GetPreedit()
        var commited:String = String(utf16CodeUnits:commit_unicode , count: commit_unicode.count)
        let preediting:String = String(utf16CodeUnits: preedit_unicode, count: preedit_unicode.count)
        
        if eaten == false {
            commited += ch
        }
        if let etc = extra {
            commited += etc
        }
        
        let result_str = "\(t) \(ch) commited \(expect_commit) = \(actual_commit) (\(commited)) preedited \(expect_preedit) = \(actual_preedit) (\(preediting))"
        print(result_str)
        
        assert(expect_commit == actual_commit)
        assert(expect_preedit == actual_preedit)
        _ = hangul.GetDebug(t: "clean")
        
        if let out_gui = self.stdout_gui {
            out_gui.documentView?.insertText(result_str + "\n")
        }
    }
}

class Test318 : TestCase {
    func run() {
        let hangul = Hangul()
        hangul.Start(type: 318)
        
        print("========318===========")

        // 기본 테스트 , "동해물"
        self.test_debug(hangul: hangul, t: "input", ch: "e", expect_commit: [], expect_preedit: ["eXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["ehX"])
        self.test_debug(hangul: hangul, t: "input", ch: "i", expect_commit: [], expect_preedit: ["ehi"])
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: ["ehi"], expect_preedit: ["gXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "o", expect_commit: [], expect_preedit: ["goX"])
        self.test_debug(hangul: hangul, t: "input", ch: "a", expect_commit: ["goX"], expect_preedit: ["aXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["anX"])
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["ann"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["ann"], expect_preedit: [])

        // 모아치기 테스트 , "동해물"
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["XhX"])
        self.test_debug(hangul: hangul, t: "input", ch: "e", expect_commit: [], expect_preedit: ["ehX"])
        self.test_debug(hangul: hangul, t: "input", ch: "i", expect_commit: [], expect_preedit: ["ehi"])
        self.test_debug(hangul: hangul, t: "input", ch: "o", expect_commit: ["ehi"], expect_preedit: ["XoX"])
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["goX"])
        self.test_debug(hangul: hangul, t: "input", ch: "a", expect_commit: ["goX"], expect_preedit: ["aXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["anX"])
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["ann"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["ann"], expect_preedit: [])

        // 쌍자음 두번치기 , "씨발"
        self.test_debug(hangul: hangul, t: "input", ch: "t", expect_commit: [], expect_preedit: ["tXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "t", expect_commit: [], expect_preedit: ["ttXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["ttlX"])
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: ["ttlX"], expect_preedit: ["qXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["qkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["qkn"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["qkn"], expect_preedit: [])

        // 쌍자음 대문자 , "씨발"
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["XlX"])
        self.test_debug(hangul: hangul, t: "input", ch: "T", expect_commit: [], expect_preedit: ["TlX"])
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: ["TlX"], expect_preedit: ["qXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["qkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["qkn"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["qkn"], expect_preedit: [])

        // 이중모음 테스트 , "나의"
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["sXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["skX"])
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: ["skX"], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["dmX"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["dmlX"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["dmlX"], expect_preedit: [])

        // 이중모음 대문자, "예뻐"
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "P", expect_commit: [], expect_preedit: ["dPX"])
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: ["dPX"], expect_preedit: ["qXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: [], expect_preedit: ["qqXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: [], expect_preedit: ["qqjX"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["qqjX"], expect_preedit: [])

        // 이중모음 두번치기, "예뻐"
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "p", expect_commit: [], expect_preedit: ["dpX"])
        self.test_debug(hangul: hangul, t: "input", ch: "p", expect_commit: [], expect_preedit: ["dppX"])
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: ["dppX"], expect_preedit: ["qXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: [], expect_preedit: ["qqXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: [], expect_preedit: ["qqjX"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["qqjX"], expect_preedit: [])

        // 이중모음 모아치기 , "의"
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["XmX"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["XmlX"])
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["dmlX"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["dmlX"], expect_preedit: [])

        // 이중모음 비한글 , "나의 살"
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["sXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["skX"])
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: ["skX"], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["dmX"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["dmlX"])
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["dmlX", " "], expect_preedit: [])
        self.test_debug(hangul: hangul, t: "input", ch: "t", expect_commit: [], expect_preedit: ["tXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["tkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["tkn"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["tkn"], expect_preedit: [])

        // 쌍자음 모아치기, 두번째 초성을 중성 이후에, "시ㅅ발"
        self.test_debug(hangul: hangul, t: "input", ch: "t", expect_commit: [], expect_preedit: ["tXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["tlX"])
        self.test_debug(hangul: hangul, t: "input", ch: "t", expect_commit: ["tlX"], expect_preedit: ["tXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: ["tXX"], expect_preedit: ["qXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["qkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["qkn"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["qkn"], expect_preedit: [])

        // 겹받침 대문자 , "이값은"
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["dlX"])
        self.test_debug(hangul: hangul, t: "input", ch: "r", expect_commit: ["dlX"], expect_preedit: ["rXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["rkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "H", expect_commit: [], expect_preedit: ["rkH"])
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: ["rkH"], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["dmX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["dmh"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["dmh"], expect_preedit: [])

        // 겹받침 두번치기 , "이값은"
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["dlX"])
        self.test_debug(hangul: hangul, t: "input", ch: "r", expect_commit: ["dlX"], expect_preedit: ["rXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["rkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "b", expect_commit: [], expect_preedit: ["rkb"])
        self.test_debug(hangul: hangul, t: "input", ch: "u", expect_commit: [], expect_preedit: ["rkbu"])
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: ["rkbu"], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["dmX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["dmh"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["dmh"], expect_preedit: [])

        // not한글 여러개 연속 , "한글 .*0"
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["gXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["gkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["gkh"])
        self.test_debug(hangul: hangul, t: "input", ch: "r", expect_commit: ["gkh"], expect_preedit: ["rXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["rmX"])
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["rmn"])
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["rmn", " "], expect_preedit: [])
        self.test_debug(hangul: hangul, t: "input", ch: ".", expect_commit: ["."], expect_preedit: [])
        self.test_debug(hangul: hangul, t: "input", ch: "*", expect_commit: ["*"], expect_preedit: [])
        self.test_debug(hangul: hangul, t: "input", ch: "0", expect_commit: ["0"], expect_preedit: [])

        // not한글 여러개 연속 그리고 한글, "한글 &3_8(* 최고"
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["gXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["gkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["gkh"])
        self.test_debug(hangul: hangul, t: "input", ch: "r", expect_commit: ["gkh"], expect_preedit: ["rXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["rmX"])
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["rmn"])
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["rmn", " "], expect_preedit: [])
        self.test_debug(hangul: hangul, t: "input", ch: "&", expect_commit: ["&"], expect_preedit: [])
        self.test_debug(hangul: hangul, t: "input", ch: "3", expect_commit: ["3"], expect_preedit: [])
        self.test_debug(hangul: hangul, t: "input", ch: "_", expect_commit: ["_"], expect_preedit: [])
        self.test_debug(hangul: hangul, t: "input", ch: "8", expect_commit: ["8"], expect_preedit: [])
        self.test_debug(hangul: hangul, t: "input", ch: "(", expect_commit: ["("], expect_preedit: [])
        self.test_debug(hangul: hangul, t: "input", ch: "*", expect_commit: ["*"], expect_preedit: [])
        self.test_debug(hangul: hangul, t: "input", ch: "c", expect_commit: [], expect_preedit: ["cXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["chX"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["chlX"])
        self.test_debug(hangul: hangul, t: "input", ch: "r", expect_commit: ["chlX"], expect_preedit: ["rXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["rhX"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["rhX"], expect_preedit: [])
        
        // 백스페이스 "안녕 -> 안녀->안ㄴ->안냥"
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["dkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["dkh"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: ["dkh"], expect_preedit: ["sXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "u", expect_commit: [], expect_preedit: ["suX"])
        self.test_debug(hangul: hangul, t: "input", ch: "i", expect_commit: [], expect_preedit: ["sui"])
        // 스위프트는 문자열에서 백스페이스 이스케입이 없다? \b 가 안되네.. 그래서 //b로 대충 대체함
        self.test_debug(hangul: hangul, t: "input", ch: "//b", expect_commit: [], expect_preedit: ["suX"])
        self.test_debug(hangul: hangul, t: "input", ch: "//b", expect_commit: [], expect_preedit: ["sXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "i", expect_commit: [], expect_preedit: ["siX"])
        self.test_debug(hangul: hangul, t: "input", ch: "i", expect_commit: [], expect_preedit: ["sii"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["sii"], expect_preedit: [])
        // 두ᅡ
        self.test_debug(hangul: hangul, t: "input", ch: "e", expect_commit: [], expect_preedit: ["eXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["enX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: ["enX"], expect_preedit: ["XkX"])
    }
}

class Test390 : TestCase {
    func run() {
        let hangul = Hangul()
        hangul.Start(type: 390)
        
        print("========390===========")
        
         // 얇은 사 하이얀 고깔은
        // j 6 w3
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: [], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "6", expect_commit: [], expect_preedit: ["j6X"])
        self.test_debug(hangul: hangul, t: "input", ch: "w", expect_commit: [], expect_preedit: ["j6w"])
        self.test_debug(hangul: hangul, t: "input", ch: "3", expect_commit: [], expect_preedit: ["j6w3"])
        // j g s
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["j6w3"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["jgX"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["jgs"])
        // ' '
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["jgs", " "], expect_preedit: [])
        // n f X
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["nXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["nfX"])
        // ' '
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["nfX", " "], expect_preedit: [])
        // m f X
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["mXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["mfX"])
        // j d X
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["mfX"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["jdX"])
        // j 6 s
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["jdX"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "6", expect_commit: [], expect_preedit: ["j6X"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["j6s"])
        // ' '
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["j6s", " "], expect_preedit: [])
        // k v X
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["kXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "v", expect_commit: [], expect_preedit: ["kvX"])
        // kk f w
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: ["kvX"], expect_preedit: ["kXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["kkXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["kkfX"])
        self.test_debug(hangul: hangul, t: "input", ch: "w", expect_commit: [], expect_preedit: ["kkfw"])
        // j g s
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["kkfw"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["jgX"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["jgs"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["jgs"], expect_preedit: [])

         // 고이 접어서 나빌레라.
        // k v X
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["kXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "v", expect_commit: [], expect_preedit: ["kvX"])
        // j d X
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["kvX"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["jdX"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["jdX", " "], expect_preedit: [])
        // l t 3
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["lXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "t", expect_commit: [], expect_preedit: ["ltX"])
        self.test_debug(hangul: hangul, t: "input", ch: "3", expect_commit: [], expect_preedit: ["lt3"])
        // j t X
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["lt3"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "t", expect_commit: [], expect_preedit: ["jtX"])
        // n t X
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: ["jtX"], expect_preedit: ["nXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "t", expect_commit: [], expect_preedit: ["ntX"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["ntX", " "], expect_preedit: [])
        // h f X
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["hXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["hfX"])
        // ; d w
        self.test_debug(hangul: hangul, t: "input", ch: ";", expect_commit: ["hfX"], expect_preedit: [";XX"])
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: [";dX"])
        self.test_debug(hangul: hangul, t: "input", ch: "w", expect_commit: [], expect_preedit: [";dw"])
        // y c X
        self.test_debug(hangul: hangul, t: "input", ch: "y", expect_commit: [";dw"], expect_preedit: ["yXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "c", expect_commit: [], expect_preedit: ["ycX"])
        // y f X
        self.test_debug(hangul: hangul, t: "input", ch: "y", expect_commit: ["ycX"], expect_preedit: ["yXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["yfX"])
        // .
        self.test_debug(hangul: hangul, t: "input", ch: ".", expect_commit: ["yfX", "."], expect_preedit: [])

         // 제 13의 아해가
        // l c X
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["lXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "c", expect_commit: [], expect_preedit: ["lcX"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["lcX", " "], expect_preedit: [])
        // M
        self.test_debug(hangul: hangul, t: "input", ch: "M", expect_commit: ["1"], expect_preedit: [])
        // >
        self.test_debug(hangul: hangul, t: "input", ch: ">", expect_commit: ["3"], expect_preedit: [])
        // j 8 X
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: [], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "8", expect_commit: [], expect_preedit: ["j8X"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["j8X", " "], expect_preedit: [])
        // j f X
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: [], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["jfX"])
        // m r X
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: ["jfX"], expect_preedit: ["mXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "r", expect_commit: [], expect_preedit: ["mrX"])
        // k f X
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: ["mrX"], expect_preedit: ["kXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["kfX"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["kfX"], expect_preedit: [])
        
         // 가자! 더 높은<곳으로>
        // k f X
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["kXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["kfX"])
        // l f X
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: ["kfX"], expect_preedit: ["lXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["lfX"])
        // B
        self.test_debug(hangul: hangul, t: "input", ch: "B", expect_commit: ["lfX", "!"], expect_preedit: [])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: [" "], expect_preedit: [])
        // u t X
        self.test_debug(hangul: hangul, t: "input", ch: "u", expect_commit: [], expect_preedit: ["uXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "t", expect_commit: [], expect_preedit: ["utX"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["utX", " "], expect_preedit: [])
        // h v Q
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["hXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "v", expect_commit: [], expect_preedit: ["hvX"])
        self.test_debug(hangul: hangul, t: "input", ch: "Q", expect_commit: [], expect_preedit: ["hvQ"])
        // j g s
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["hvQ"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["jgX"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["jgs"])
        // Y
        self.test_debug(hangul: hangul, t: "input", ch: "Y", expect_commit: ["jgs", "<"], expect_preedit: [])
        // k v q
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["kXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "v", expect_commit: [], expect_preedit: ["kvX"])
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: [], expect_preedit: ["kvq"])
        // j g X
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["kvq"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["jgX"])
        // y v X
        self.test_debug(hangul: hangul, t: "input", ch: "y", expect_commit: ["jgX"], expect_preedit: ["yXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "v", expect_commit: [], expect_preedit: ["yvX"])
        // P
        self.test_debug(hangul: hangul, t: "input", ch: "P", expect_commit: ["yvX", ">"], expect_preedit: [])
        
        // 도ᅩᅩᅩ
        self.test_debug(hangul: hangul, t: "input", ch: "u", expect_commit: [], expect_preedit: ["uXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "v", expect_commit: [], expect_preedit: ["uvX"])
        self.test_debug(hangul: hangul, t: "input", ch: "v", expect_commit: ["uvX"], expect_preedit: ["XvX"])
        self.test_debug(hangul: hangul, t: "input", ch: "v", expect_commit: ["XvX"], expect_preedit: ["XvX"])
    }
}

class Test32 : TestCase {
    func run() {
        let hangul = Hangul()
        hangul.Start(type: 32)
        
        print("========S3P2===========")
        
         // 얇은 사 하이얀 고깔은
        // jwwe jgs  nf  mf jd jws  kv kkfw jgs
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: [], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "w", expect_commit: [], expect_preedit: ["jwX"])
        self.test_debug(hangul: hangul, t: "input", ch: "w", expect_commit: [], expect_preedit: ["jww"])
        self.test_debug(hangul: hangul, t: "input", ch: "e", expect_commit: [], expect_preedit: ["jwwe"])
        //jgs
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["jwwe"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["jgX"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["jgs"])
        // ' '
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["jgs", " "], expect_preedit: [])
        //
        self.test_debug(hangul: hangul, t: "input", ch: "n", expect_commit: [], expect_preedit: ["nXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["nfX"])
        // ' '
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["nf", " "], expect_preedit: [])
        //
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["mXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["mfX"])
        //jd
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["mf"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["jdX"])
        //
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["jd"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "w", expect_commit: [], expect_preedit: ["jwX"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["jws"])
        // ' '
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["jws", " "], expect_preedit: [])
        //kv
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["kXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "v", expect_commit: [], expect_preedit: ["kvX"])
        //kkfw
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: ["kv"], expect_preedit: ["kXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["kkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["kkf"])
        self.test_debug(hangul: hangul, t: "input", ch: "w", expect_commit: [], expect_preedit: ["kkfw"])
        //jgs
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["kkfw"], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["jgX"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["jgs"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["jgs"], expect_preedit: [])
        
        // 좌구 윈터 l/f kb jods 'r
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["lXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "/", expect_commit: [], expect_preedit: ["l/X"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["l/f"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: ["l/f"], expect_preedit: ["kXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "b", expect_commit: [], expect_preedit: ["kbX"])
        
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["kb", " "], expect_preedit: [])
        
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: [], expect_preedit: ["jXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "o", expect_commit: [], expect_preedit: ["joX"])
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["jod"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["jods"])
        self.test_debug(hangul: hangul, t: "input", ch: "'", expect_commit: ["jods"], expect_preedit: ["'XX"])
        self.test_debug(hangul: hangul, t: "input", ch: "r", expect_commit: [], expect_preedit: ["'rX"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["jgs"], expect_preedit: [])
        
        //떪다 uurwz uf
        self.test_debug(hangul: hangul, t: "input", ch: "u", expect_commit: [], expect_preedit: ["uXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "u", expect_commit: [], expect_preedit: ["uuX"])
        self.test_debug(hangul: hangul, t: "input", ch: "r", expect_commit: [], expect_preedit: ["uur"])
        self.test_debug(hangul: hangul, t: "input", ch: "w", expect_commit: [], expect_preedit: ["uurw"])
        self.test_debug(hangul: hangul, t: "input", ch: "z", expect_commit: [], expect_preedit: ["uurwz"])
        
        self.test_debug(hangul: hangul, t: "input", ch: "u", expect_commit: ["uurwz"], expect_preedit: ["uXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["ufX"])
    }
}

class Test002 : TestCase {
    func run() {
        let hangul = Hangul()
        hangul.Start(type: 2)
        
        print("========002===========")
        
        // 얇은 사 하이얀 고깔은
        // d i fq
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "i", expect_commit: [], expect_preedit: ["diX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["dif"])
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: [], expect_preedit: ["difq"])
        // d m s
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: ["difq"], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["dmX"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["dms"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["dms", " "], expect_preedit: [])
        // t k X
        self.test_debug(hangul: hangul, t: "input", ch: "t", expect_commit: [], expect_preedit: ["tXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["tkX"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["tkX", " "], expect_preedit: [])
        // g k X
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["gXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["gkX"])
        // d l X
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["gkd"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: ["gkX"], expect_preedit: ["dlX"])
        // d i s
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["dld"])
        self.test_debug(hangul: hangul, t: "input", ch: "i", expect_commit: ["dlX"], expect_preedit: ["diX"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["dis"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["dis", " "], expect_preedit: [])
        // r h X
        self.test_debug(hangul: hangul, t: "input", ch: "r", expect_commit: [], expect_preedit: ["rXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["rhX"])
        // R k f
        self.test_debug(hangul: hangul, t: "input", ch: "R", expect_commit: [], expect_preedit: ["rhR"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: ["rhX"], expect_preedit: ["RkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["Rkf"])
        // d m s
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: ["Rkf"], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["dmX"])
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["dms"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["dms"], expect_preedit: [])
        
        // 발바리 (밟 -> 발바 -> 발발 -> 발바리) 겹받침이었다가 다음 글자의 초성으로 한글자만 넘어가는것 테스트
        // q k f q k f l
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: [], expect_preedit: ["qXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["qkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["qkf"])
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: [], expect_preedit: ["qkfq"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: ["qkf"], expect_preedit: ["qkX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["qkf"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: ["qkX"], expect_preedit: ["flX"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["flX"], expect_preedit: [])
        
        // 고이 접어서 나빌레라.
        // r h X
        self.test_debug(hangul: hangul, t: "input", ch: "r", expect_commit: [], expect_preedit: ["rXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["rhX"])
        // d l X
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["rhd"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: ["rhX"], expect_preedit: ["dlX"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["dlX", " "], expect_preedit: [])
        // w j q
        self.test_debug(hangul: hangul, t: "input", ch: "w", expect_commit: [], expect_preedit: ["wXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: [], expect_preedit: ["wjX"])
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: [], expect_preedit: ["wjq"])
        // d j X
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: ["wjq"], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: [], expect_preedit: ["djX"])
        // t j X
        self.test_debug(hangul: hangul, t: "input", ch: "t", expect_commit: [], expect_preedit: ["djt"])
        self.test_debug(hangul: hangul, t: "input", ch: "j", expect_commit: ["djX"], expect_preedit: ["tjX"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["tjX", " "], expect_preedit: [])
        // s k X
        self.test_debug(hangul: hangul, t: "input", ch: "s", expect_commit: [], expect_preedit: ["sXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["skX"])
        // q l f
        self.test_debug(hangul: hangul, t: "input", ch: "q", expect_commit: [], expect_preedit: ["skq"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: ["skX"], expect_preedit: ["qlX"])
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["qlf"])
        // f p X
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: ["qlf"], expect_preedit: ["fXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "p", expect_commit: [], expect_preedit: ["fpX"])
        // f k X
        self.test_debug(hangul: hangul, t: "input", ch: "f", expect_commit: [], expect_preedit: ["fpf"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: ["fpX"], expect_preedit: ["fkX"])
        // .
        self.test_debug(hangul: hangul, t: "input", ch: ".", expect_commit: ["fkX", "."], expect_preedit: [])
        
        // 제 13의 아해가
        // w p X
        self.test_debug(hangul: hangul, t: "input", ch: "w", expect_commit: [], expect_preedit: ["wXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "p", expect_commit: [], expect_preedit: ["wpX"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["wpX", " "], expect_preedit: [])
        // 1
        self.test_debug(hangul: hangul, t: "input", ch: "1", expect_commit: ["1"], expect_preedit: [])
        // 3
        self.test_debug(hangul: hangul, t: "input", ch: "3", expect_commit: ["3"], expect_preedit: [])
        // d ml X
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "m", expect_commit: [], expect_preedit: ["dmX"])
        self.test_debug(hangul: hangul, t: "input", ch: "l", expect_commit: [], expect_preedit: ["dmlX"])
        // " "
        self.test_debug(hangul: hangul, t: "input", ch: " ", expect_commit: ["dmlX", " "], expect_preedit: [])
        // d k X
        self.test_debug(hangul: hangul, t: "input", ch: "d", expect_commit: [], expect_preedit: ["dXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: [], expect_preedit: ["dkX"])
        // g o X
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["dkg"])
        self.test_debug(hangul: hangul, t: "input", ch: "o", expect_commit: ["dkX"], expect_preedit: ["goX"])
        // r k X
        self.test_debug(hangul: hangul, t: "input", ch: "r", expect_commit: [], expect_preedit: ["gor"])
        self.test_debug(hangul: hangul, t: "input", ch: "k", expect_commit: ["goX"], expect_preedit: ["rkX"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["rkX"], expect_preedit: [])
        
        // ᄏᄏᄏᄏ 도ᅩᅩᅩᅩ
        self.test_debug(hangul: hangul, t: "input", ch: "z", expect_commit: [], expect_preedit: ["zXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "z", expect_commit: ["zXX"], expect_preedit: ["zXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "z", expect_commit: ["zXX"], expect_preedit: ["zXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "e", expect_commit: ["zXX"], expect_preedit: ["eXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: [], expect_preedit: ["ehX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: ["ehX"], expect_preedit: ["XhX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: ["XhX"], expect_preedit: ["XhX"])
        self.test_debug(hangul: hangul, t: "input", ch: "h", expect_commit: ["XhX"], expect_preedit: ["XhX"])
        self.test_debug(hangul: hangul, t: "flush", ch: "", expect_commit: ["XhX"], expect_preedit: [])
        
        self.test_debug(hangul: hangul, t: "input", ch: "g", expect_commit: [], expect_preedit: ["gXX"])
        self.test_debug(hangul: hangul, t: "input", ch: "o", expect_commit: [], expect_preedit: ["goX"])
        self.test_debug(hangul: hangul, t: "input", ch: "T", expect_commit: [], expect_preedit: ["goT"])
        self.test_debug(hangul: hangul, t: "input", ch: "S", expect_commit: ["goT"], expect_preedit: ["SXX"])
    }
    
    
}
