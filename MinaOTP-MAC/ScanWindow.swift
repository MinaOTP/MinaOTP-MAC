//
//  ScanWindow.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/8/17.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa
import CoreImage
import Foundation


class ScanWindow: NSWindow, NSWindowDelegate{

    let imgView = NSImageView.init()
    weak var scanDelegate : ScanWindowDelegate?

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        config()
        self.delegate = self
    }

    private func config() {
        self.center()
        self.toolbar?.isVisible = false

        self.styleMask = [.titled, .closable, .resizable]
        self.title = NSLocalizedString("scan_title", comment: "")

        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true

        self.isOpaque = false
        self.backgroundColor = NSColor.clear
        self.titlebarAppearsTransparent = true
        self.backgroundColor = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        self.isMovableByWindowBackground = true

        imgView.wantsLayer = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer?.backgroundColor = NSColor.clear.cgColor
        imgView.image = NSImage.init(named: NSImage.Name(rawValue: "image_normal"))
        imgView.imageAlignment = .alignCenter
        imgView.imageScaling = .scaleProportionallyUpOrDown

        self.contentView?.addSubview(imgView)

        let heigtConstraint = NSLayoutConstraint(item: imgView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute:NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 0)
        let weightConstraint = NSLayoutConstraint(item: imgView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute:NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 0)

        let leftConstraint = NSLayoutConstraint(item: imgView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute:NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0)
        let topConstraint = NSLayoutConstraint(item: imgView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute:NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0)
        self.contentView?.addConstraints([leftConstraint, topConstraint, heigtConstraint, weightConstraint])

    }

    func windowDidMove(_ notification: Notification) {
        print("windowDidMove")

        let screenRect = NSScreen.main?.visibleFrame
        let dif = (screenRect?.size.height)!-self.frame.origin.y-self.frame.size.height+23

        let cgImage = CGWindowListCreateImage(CGRect(x: self.frame.origin.x, y: dif, width: self.frame.size.width, height: self.frame.size.height), .optionOnScreenBelowWindow, CGWindowID(self.windowNumber), .bestResolution)
        let detector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        let ciImage = CIImage.init(cgImage: cgImage!)

        let feature = detector?.features(in: ciImage)
        if (feature?.count)! > 0 {
            let f = feature?.first as! CIQRCodeFeature
            if f.messageString?.contains("otpauth://totp/") == false || f.messageString?.contains("secret=") == false || f.messageString?.contains("issuer=") == false{
                imgView.image = NSImage.init(named: NSImage.Name(rawValue: "image_normal"))
            }else{
                imgView.image = NSImage.init(named: NSImage.Name(rawValue: "image_selected"))
                self.delegate = nil
                self.title = NSLocalizedString("scan_qr_success", comment: "")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.scanDelegate?.scanSuccess(code: f.messageString!)
                    self.close()
                }
            }
        }else{
            imgView.image = NSImage.init(named: NSImage.Name(rawValue: "image_normal"))
        }
    }
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        var toHeight = frameSize.height
        if toHeight > 700 {
            toHeight = 700
        }
        if toHeight < 300 {
            toHeight = 300
        }
        return NSSize.init(width: toHeight, height: toHeight)
    }
}

protocol ScanWindowDelegate: class {
    func scanSuccess(code:String)
}
