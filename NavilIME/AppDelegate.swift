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
        
        PrintLog.shared.scrollView = self.scrollView
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Insert code here to tear down your application
    }
    
    func debugOutLog(log:String) {
        self.scrollView.documentView?.insertText(log+"\n")
    }

}

