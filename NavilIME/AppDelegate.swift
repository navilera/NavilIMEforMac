//
//  AppDelegate.swift
//  NavilIME
//
//  Created by Manwoo Yi on 9/3/22.
//

import Cocoa
import InputMethodKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var scrollView: NSScrollView!
    
    var server = IMKServer()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Insert code here to initialize your application
        server = IMKServer(name: Bundle.main.infoDictionary?["InputMethodConnectionName"] as? String, bundleIdentifier: Bundle.main.bundleIdentifier)
        NSLog("tried connection")
        
        // 디버깅 할 때는 로그를 봐야 하므로 아래 주석을 순서대로 사용한다.
        //PrintLog.shared.scrollView = self.scrollView      // Debuging mode ON
        PrintLog.shared.scrollView = nil                    // Debuging mode OFF
        
        // 재부팅 후 나오는 윈도우를 바로 끔 (디버그 모드일 땐 안끔)
        if PrintLog.shared.scrollView == nil {
            if let w = NSApplication.shared.windows.first {
                w.close()
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Insert code here to tear down your application
    }
}

