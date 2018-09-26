//
//  StatusItemView.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/8/8.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa
class StatusItemView: NSControl {

    var statusItem = NSStatusItem.init()
    let image = NSImage.init(named: "icon")
    weak var delegate : StatusItemViewDelegate?

    override init(frame frameRect: NSRect) {
        super.init(frame: NSZeroRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        statusItem.drawStatusBarBackground(in: self.bounds, withHighlight: false)
        let imageRect = NSInsetRect(NSRect(x: (self.bounds.size.width-18)/2, y: (self.bounds.size.height-18)/2, width: 18, height: 18), 0, 0)
        self.image?.draw(in: imageRect, from: NSZeroRect, operation: .color, fraction: 1)
    }
    override func moveDown(_ sender: Any?) {
        self.setNeedsDisplay()
    }
    override func rightMouseDown(with event: NSEvent) {
//        NSApp.sendAction(righeAction, to: self.target, from: self)
        self.setNeedsDisplay()
        self.delegate?.rightMouseDownAction()
    }
    override func mouseDown(with event: NSEvent) {
        self.setNeedsDisplay()
        self.delegate?.leftMouseDownAction()
    }

}
protocol StatusItemViewDelegate: class {
    func rightMouseDownAction()
    func leftMouseDownAction()
}


