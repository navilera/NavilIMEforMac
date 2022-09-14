//
//  SingletonPrintLog.swift
//  NavilIME
//
//  Created by Manwoo Yi on 9/13/22.
//

import Foundation
import Cocoa

class PrintLog {
    static let shared = PrintLog()

    var scrollView: NSScrollView!
    
    private init() { }
    
    func Log(log:String) {
        self.scrollView.documentView?.insertText(log + "\n")
    }
}
