//
//  ProgressView.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/8/3.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa

class ProgressView: NSView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        print("已经创建")
        self.wantsLayer = true
        self.layer?.addSublayer(self.bottomShapeLayer)
        self.layer?.addSublayer(self.topShapeLayer)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var bottomShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.frame = self.bounds
        layer.fillColor = NSColor.clear.cgColor
        layer.lineWidth = 2
        layer.lineJoin = kCALineJoinMiter
        layer.lineCap = kCALineCapSquare
        layer.strokeColor = NSColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        layer.path = self.bezierPath.cgPath
        layer.strokeEnd = 1
        return layer
    }()
    lazy var topShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.fillColor = NSColor.clear.cgColor
        layer.frame = self.bounds
        layer.lineWidth = 2
        layer.lineJoin = kCALineJoinMiter
        layer.lineCap = kCALineCapSquare
        layer.strokeColor = NSColor.green.cgColor
        layer.path = self.bezierPath.cgPath
        layer.strokeEnd = 0
        return layer
    }()
    lazy var bezierPath: NSBezierPath = {
        let path = NSBezierPath.init()
        path.move(to: CGPoint(x: 0, y: self.bounds.size.height/2))
        path.line(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height/2))
        path.stroke()
        return path
    }()
    func setProgress(value: CGFloat) {
//        if value>0.85 {
//            self.topShapeLayer.strokeColor = NSColor.red.cgColor
//
//        }else{
//            self.topShapeLayer.strokeColor = NSColor.green.cgColor
//        }
        self.topShapeLayer.strokeEnd = value
        self.topShapeLayer.strokeColor = NSColor.systemBlue.cgColor
//        self.topShapeLayer.strokeColor = NSColor.init(red: value, green: (1.0-value)*3, blue: 0, alpha: 1).cgColor
    }

    
}
