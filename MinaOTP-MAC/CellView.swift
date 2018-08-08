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
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        self.layer?.addSublayer(self.lineLayer)
        print(self.bounds.size.height/2)
    }

    lazy var codeTextField: NSTextField = {
        let lab = NSTextField.init(frame: CGRect(x: 200, y: 20, width: 100, height: 20))
        lab.textColor = NSColor.orange
        lab.stringValue = ""
        lab.isBordered = false
        lab.isEditable = false
        lab.font = NSFont.systemFont(ofSize: 20)
        lab.backgroundColor = NSColor.clear
        return lab
    }()

    lazy var issuerTextField: NSTextField = {
        let lab = NSTextField.init(frame: CGRect(x: 10, y: 10, width: 100, height: 12))
        lab.textColor = NSColor.orange
        lab.stringValue = ""
        lab.isBordered = false
        lab.isEditable = false
//        lab.backgroundColor = NSColor.red
        lab.font = NSFont.systemFont(ofSize: 10)
        return lab
    }()

    lazy var remarkTextField: NSTextField = {
        let lab = NSTextField.init(frame: CGRect(x: 2, y: 24, width: 160, height: 20))
        lab.textColor = NSColor.orange
        lab.stringValue = ""
        lab.isBordered = false
//        lab.backgroundColor = NSColor.red
        lab.font = NSFont.systemFont(ofSize: 14)
        return lab
    }()
    lazy var lineLayer: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1)
        line.backgroundColor = NSColor.init(red: 0.93, green: 0.93, blue: 0.93, alpha: 1).cgColor
        return line
    }()
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
