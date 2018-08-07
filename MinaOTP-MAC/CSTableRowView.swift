//
//  CSTableRowView.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/8/6.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa
class CSTableRowView: NSTableRowView {

    override func drawSelection(in dirtyRect: NSRect) {

    }
    override func drawSeparator(in dirtyRect: NSRect) {
        var sepRect = self.bounds
        sepRect.origin.y = sepRect.maxY-1
        sepRect.size.height = 1;
        sepRect = NSIntersectionRect(sepRect, dirtyRect);
        if (!NSIsEmptyRect(sepRect)) {
            NSColor.init(red: 0.92, green: 0.92, blue: 0.92, alpha: 1).set()
        }else{
            NSColor.clear.set()
        }
        __NSRectFill(sepRect);
    }
}
