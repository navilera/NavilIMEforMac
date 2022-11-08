//
//  SingletonHotfix.swift
//  NavilIME
//
//  Created by Manwoo Yi on 11/7/22.
//

import Foundation

class Hotfix {
    static let shared = Hotfix()
    
    let pattern:[String] = [
        "```c"
    ]
    
    let circular_stack = CircularStack(count:10)
    
    private init() { }
    
    func add(_ elelemt: String) {
        self.circular_stack.push(elelemt)
    }
    
    func check() -> String? {
        for pat in self.pattern {
            let latest = self.circular_stack.pop(pat.count, update: false)
            if latest == pat {
                let ret = self.circular_stack.pop(pat.count, update: true)
                return ret
            }
        }
        return nil
    }
}

class CircularStack {
    var array: [String]
    var stack_top = 0

    public init(count: Int) {
        self.array = [String](repeating: "", count: count)
    }

    func push(_ element: String) {
        self.stack_top %= self.array.count
        self.array[self.stack_top] = element
        self.stack_top += 1
    }

    func pop(_ len:Int, update:Bool) -> String {
        var peeked_str:String = ""
        var cur:Int = 0
        let last_idx = self.stack_top - 1
        for idx in 0..<len {
            cur = last_idx - idx
            if cur < 0 {
                cur += self.array.count
            }
            peeked_str = self.array[cur] + peeked_str
        }
        if update == true {
            self.stack_top = cur
        }
        return peeked_str
    }
}
