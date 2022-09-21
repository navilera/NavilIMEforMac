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
        
        if t == "input" {
            // 백스페이스
            if ch == "//b" {
                let _ = hangul.Backspace()
            } else {
                eaten = hangul.Process(ascii: ch)
                if eaten == false {
                    hangul.Flush()
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
        
        let commit_unicode:[unichar] = hangul.GetCommit()
        let preedit_unicode:[unichar] = hangul.GetPreedit()
        var commited:String = String(utf16CodeUnits:commit_unicode , count: commit_unicode.count)
        let preediting:String = String(utf16CodeUnits: preedit_unicode, count: preedit_unicode.count)
        
        if eaten == false {
            commited += ch
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
        hangul.Start(type: "318")

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
    }
}
