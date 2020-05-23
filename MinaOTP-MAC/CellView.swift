//
//  CellView.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/8/3.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa

class CellView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.addSubview(self.codeTextField)
        self.addSubview(self.issuerTextField)
        self.addSubview(self.remarkTextField)
//        self.addSubview(self.hotKeyTextField)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        self.layer?.addSublayer(self.lineLayer)
        print(self.bounds.size.height/2)
    }

    lazy var codeTextField: NSTextField = {
        let lab = NSTextField.init(frame: CGRect(x: 198, y: 30, width: 90, height: 20))
        lab.textColor = .labelColor //NSColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        lab.stringValue = ""
        lab.isBordered = false
        lab.isEditable = false
        lab.font = NSFont.boldSystemFont(ofSize: 20)
        lab.alignment = NSTextAlignment.right
        lab.backgroundColor = NSColor.clear
//        lab.backgroundColor = NSColor.red
        return lab
    }()
    lazy var remarkTextField: NSTextField = {
        let lab = NSTextField.init(frame: CGRect(x: 12, y: 30, width: 160, height: 20))
        lab.textColor = .labelColor //NSColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        lab.stringValue = ""
        lab.isBordered = false
        lab.isEditable = false
        lab.backgroundColor = NSColor.clear
        lab.alignment = NSTextAlignment.left
        lab.font = NSFont.systemFont(ofSize: 14)
//        lab.backgroundColor = NSColor.red
        return lab
    }()
    lazy var issuerTextField: NSTextField = {
        let lab = NSTextField.init(frame: CGRect(x: 14, y: 10, width: 100, height: 12))
        lab.textColor = .labelColor //NSColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        lab.stringValue = ""
        lab.isBordered = false
        lab.isEditable = false
        lab.backgroundColor = NSColor.clear
        lab.alignment = NSTextAlignment.left
        lab.font = NSFont.systemFont(ofSize: 10)
        return lab
    }()
    lazy var hotKeyTextField: NSTextField = {
        let lab = NSTextField.init(frame: CGRect(x: 263, y: 10, width: 25, height: 12))
        lab.textColor = .labelColor // NSColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        lab.stringValue = ""
        lab.isBordered = false
        lab.isEditable = false
        lab.backgroundColor = NSColor.clear
        lab.alignment = NSTextAlignment.right
        lab.font = NSFont.systemFont(ofSize: 10)
        return lab
    }()

    lazy var lineLayer: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1)
        line.backgroundColor = NSColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5).cgColor
        return line
    }()
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
