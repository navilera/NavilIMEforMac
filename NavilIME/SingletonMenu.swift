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
    
    var self_eng_mode:Bool = false
    
    let user_default_key = "keyboard"
    
    func change_selected_keyboard(id:Int) {
        self.selected_keyboard = id
        UserDefaults.standard.set(id, forKey: user_default_key)
        UserDefaults.standard.synchronize()
    }
    
    private init() {
        let saved_keyboard = UserDefaults.standard.integer(forKey: user_default_key)
        if saved_keyboard != 0 {
            self.selected_keyboard = saved_keyboard
        } else {
            self.selected_keyboard = Hangul.hangul_keyboard[0].id
        }
        
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
        
        // 옵션
        let option_menuitem = NSMenuItem()
        option_menuitem.title = "옵션"
        option_menuitem.tag = OptHandler.shared.opt_menu_tag
        option_menuitem.action = #selector(NavilIMEInputController.select_menu(_:))
        option_menuitem.isEnabled = true
        self.menu.addItem(option_menuitem)
        
        self.menu.autoenablesItems = true
    }
}
