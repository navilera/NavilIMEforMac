//
//  SingletonMenu.swift
//  NavilIME
//
//  Created by Manwoo Yi on 9/29/22.
//

import Foundation
import Cocoa

class HangulMenu {
    static let shared = HangulMenu()
    
    var selected_keyboard:Int
    var menu:NSMenu
    
    private init() {
        self.selected_keyboard = Hangul.hangul_keyboard[0].id
        self.menu = NSMenu()
        
        for keyboard_inst in Hangul.hangul_keyboard {
            let keyboard_menuitem = NSMenuItem()
            keyboard_menuitem.title = keyboard_inst.name
            keyboard_menuitem.tag = keyboard_inst.id
            keyboard_menuitem.action = #selector(NavilIMEInputController.select_menu(_:))
            keyboard_menuitem.isEnabled = true
            if keyboard_inst.id == self.selected_keyboard {
                keyboard_menuitem.state = NSControl.StateValue.on
            }
            self.menu.addItem(keyboard_menuitem)
        }
        self.menu.autoenablesItems = true
    }
}
