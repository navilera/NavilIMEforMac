//
//  NavilIMEInputController.swift
//  NavilIME
//
//  Created by Manwoo Yi on 9/4/22.
//

import InputMethodKit

@objc(NavilIMEInputController)
open class NavilIMEInputController: IMKInputController {
    open override func inputText(_ string: String!, client sender: Any!) -> Bool {
        NSLog("inputctl:" + string)

        guard let client = sender as? IMKTextInput else {
            return false
        }
        client.insertText(string+"1", replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
        return true
    }
}
