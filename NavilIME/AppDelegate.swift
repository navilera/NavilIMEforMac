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
    
    @IBOutlet weak var dubul_no_shift_checkbox: NSButton!
    
    var server = IMKServer()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Insert code here to initialize your application
        server = IMKServer(name: Bundle.main.infoDictionary?["InputMethodConnectionName"] as? String, bundleIdentifier: Bundle.main.bundleIdentifier)
        NSLog("tried connection")
        
        // 디버깅 할 때는 로그를 봐야 하므로 아래 주석을 순서대로 사용한다.
        //PrintLog.shared.scrollView = self.scrollView      // Debuging mode ON
        PrintLog.shared.scrollView = nil                    // Debuging mode OFF
        
        if PrintLog.shared.scrollView == nil {
            self.scrollView.isHidden = true
        }
        
        // 재부팅 후 나오는 윈도우를 바로 끔
        if let w = NSApplication.shared.windows.first {
            w.close()
        }
        
        // 옵션 윈도우 위젯 연결
        OptHandler.shared.dubul_no_shift_checkbox = self.dubul_no_shift_checkbox
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    @IBAction func opt_dubul_sel_no_shift(_ sender: NSButton) {
        let no_shift_checkbox = sender
        if no_shift_checkbox.state == NSControl.StateValue.on {
            PrintLog.shared.Log(log: "No shift off")
            OptHandler.shared.Dubul_no_shift(sel: 1)
        } else {
            PrintLog.shared.Log(log: "No shift on")
            OptHandler.shared.Dubul_no_shift(sel: 0)
        }
    }
}

