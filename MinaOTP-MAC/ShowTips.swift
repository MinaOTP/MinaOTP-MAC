//
//  ShowTips.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/8/6.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa

class ShowTips: NSObject {

    public func showTip(message: String, view: NSView) {
        self.tipTextField.stringValue = "  \(message)  "
        tipTextField.sizeToFit()
        tipTextField.frame = NSRect(x: (view.bounds.size.width-tipTextField.bounds.size.width)/2, y: (view.bounds.size.height-tipTextField.bounds.size.height)/2, width: tipTextField.bounds.size.width, height: tipTextField.bounds.size.height+5)
        view.addSubview(tipTextField)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tipTextField.removeFromSuperview()
        }
    }
    lazy var tipTextField:NSTextField! = {
        let tip = NSTextField.init(frame: NSRect(x: 100, y: 100, width: 100, height: 30))
        tip.wantsLayer = true
        tip.textColor = NSColor.white
        tip.isBordered = false
        tip.backgroundColor = NSColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        tip.font = NSFont.systemFont(ofSize: 18)
        tip.layer?.cornerRadius = 2
        return tip
    }()
}
