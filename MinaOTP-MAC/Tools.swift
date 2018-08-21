//
//  Tools.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/8/1.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa
import Foundation
import CoreImage


class CustomFlatButton{
    func customFlatButton(frame: CGRect, title: String) -> FlatButton {
    let button = FlatButton.init(frame: frame)
    button.title = title
    button.font = NSFont.boldSystemFont(ofSize: 12)
    button.setButtonType(.momentaryChange)
    button.textColor = NSColor.white
    button.cornerRadius = 4
    button.borderColor = NSColor.mainColor
    button.borderWidth = 1
    button.activeBorderColor = NSColor.mainColor
    button.buttonColor = NSColor.mainColor
    button.focusRingType = .none

    return button
    }
}

extension NSColor {

    class var mainColor: NSColor {
        let color = NSColor.systemBlue
//        let color = NSColor.init(red: 0.00, green: 0.56, blue: 0.98, alpha: 1.00)
        return color
    }

    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}



extension NSBezierPath {

    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)

        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveToBezierPathElement:
                path.move(to: points[0])
            case .lineToBezierPathElement:
                path.addLine(to: points[0])
            case .curveToBezierPathElement:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePathBezierPathElement:
                path.closeSubpath()
            }
        }

        return path
    }
}

class Tools: NSObject {

    public func showAlert(message: String) {

        let alert: NSAlert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: "确定")
        alert.alertStyle = NSAlert.Style.informational
        alert.runModal()
    }

    public func generateTextField(frame: NSRect, textColor: NSColor, text: String, font: CGFloat) -> NSTextField {
        let lab = NSTextField.init(frame: frame)
        lab.wantsLayer = true
        lab.textColor = textColor
        lab.stringValue = text
        lab.isBordered = false
        lab.backgroundColor = NSColor.clear
        lab.font = NSFont.systemFont(ofSize: font)
//        lab.layer?.borderWidth = 1
//        lab.layer?.borderColor = NSColor.orange.cgColor
        return lab
    }

    func totpDictionaryFormat(code: String) -> Dictionary<String, Any> {
        var replaceStr = code
        let breakWords = ["otpauth://totp/", "?secret=", "&issuer="]
        for word in breakWords{
            replaceStr = replaceStr.replacingOccurrences(of: word, with: "#break_words#")
        }
        let resultArray = replaceStr.components(separatedBy: "#break_words#")
        let resultDic = ["remark": resultArray[1], "secret": resultArray[2], "issuer": resultArray[3]]
        return resultDic
    }

    func totpStringFormat(remark: String, issuer:String, secret:String) -> String {
        return "otpauth://totp/\(remark)?secret=\(secret)&issuer=\(issuer)"
    }

}




