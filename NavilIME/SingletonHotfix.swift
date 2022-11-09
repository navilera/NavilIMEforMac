//
//  SingletonHotfix.swift
//  NavilIME
//
//  Created by Manwoo Yi on 11/7/22.
//

import Foundation

class Hotfix {
    static let shared = Hotfix()
    
    let pattern:[[UInt16]] = [
        [0x32, 0x32, 0x32, 0x08],   // ```c  마크다운 코드 블럭 시작, ```ᄎ 을 방지
        [0x1D, 0x07]                // 0x    16진수 prefix, 0ᄐ 을 방지
    ]
    
    // 10 칸이면 충분하다.
    let circular_stack = CircularStack(count:10)
    
    private init() { }
    
    func add(_ elelemt: UInt16) {
        self.circular_stack.push(elelemt)
    }
    
    func check() -> Bool {
        for pat in self.pattern {
            let latest = self.circular_stack.pop(pat.count, update: false)
            if latest == pat {
                _ = self.circular_stack.pop(pat.count, update: true)
                return true
            }
        }
        return false
    }
}

// Circular buffer에 계속 element를 넣는다.
// 값을 읽거나 뺄 때는 last input부터 읽거나 뺀다. (LIFO)
// 즉, 기본적으로 스택이므로 Circular Stack이다.
class CircularStack {
    var stack: [UInt16]
    var stack_top = 0

    public init(count: Int) {
        self.stack = [UInt16](repeating: 0xFF, count: count)
    }

    // 가장 기본적인 circular buffer 구현이다.
    // self.stack_top은 1부터 array.count 까지 계속 반복한다. (중간에 0을 거친다.)
    func push(_ element: UInt16) {
        self.stack_top %= self.stack.count
        self.stack[self.stack_top] = element
        self.stack_top += 1
    }

    // update가 true면 self.stack_top을 바꾼다. 즉, stack에서 elelemnt를 지운다.
    func pop(_ len:Int, update:Bool) -> [UInt16] {
        var peeked_arr:[UInt16] = []
        var cur:Int = 0
        // 마지막 입력은 stack top에서 한 칸 뒤
        let last_idx = self.stack_top - 1
        for idx in 0..<len {
            // 한칸씩 뒤로 가면서 읽는다.
            cur = last_idx - idx
            if cur < 0 {
                // 인덱스가 0보다 뒤로 가면 음수가 되는데
                // 이 때는 다시 (stack.count - 1)로 가야하므로 stack.count를 더한다.
                // ex) 10 칸이면, -1일 때 9가 되야 한다. (-1 + 10 = 9)
                //              -2일 때 8이 되야 한다. (-2 + 10 = 8)
                cur += self.stack.count
            }
            // 일단 배열에 넣고
            peeked_arr.append(self.stack[cur])
        }
        // 뒤집는다.
        peeked_arr.reverse()
        // update가 true면 stack top을 cur로 바꾼다.
        // 새로운 입력은 stack top부터 들어가므로 이렇게 하면 스택에서 데이터를 지운것과 같다.
        if update == true {
            self.stack_top = cur
        }
        return peeked_arr
    }
}
