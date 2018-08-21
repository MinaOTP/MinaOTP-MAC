//
//  AddWindowController.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/8/7.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa

class AddWindow: NSWindow, NSTextFieldDelegate, ScanWindowDelegate{

    let cancelButton = CustomFlatButton().customFlatButton(frame: NSRect(x: 12, y: 12, width: 48, height: 24), title: NSLocalizedString("cancel", comment: ""))
    let saveButton = CustomFlatButton().customFlatButton(frame: NSRect(x: 420, y: 12, width: 48, height: 24), title: NSLocalizedString("save", comment: ""))
    let chooseButton = CustomFlatButton().customFlatButton(frame: NSRect(x: 318, y: 290, width: 150, height: 24), title: NSLocalizedString("choose_qr_image_btn_title", comment: ""))

    let scanButton = CustomFlatButton().customFlatButton(frame: NSRect(x: 12, y: 290, width: 150, height: 24), title: NSLocalizedString("scan_qr_image_btn_title", comment: ""))


    let textColor = NSColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
            config()
    }

    private func config() {
        self.center()
        self.toolbar?.isVisible = false

        self.styleMask = [.titled, .closable]
        self.title = NSLocalizedString("add_title", comment: "")

        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true

        self.isOpaque = false
        self.backgroundColor = NSColor.clear
        self.titlebarAppearsTransparent = true
        self.backgroundColor = NSColor(calibratedRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        self.isMovableByWindowBackground = true

        self.contentView?.addSubview(cancelButton)
        self.contentView?.addSubview(saveButton)
        self.contentView?.addSubview(chooseButton)
        self.contentView?.addSubview(scanButton)
        self.contentView?.addSubview(self.remarkTextField)
        self.contentView?.addSubview(self.issuerTextField)
        self.contentView?.addSubview(self.secretTextFiled)
        self.contentView?.addSubview(self.remarkTitleTextField)
        self.contentView?.addSubview(self.issuerTitleTextField)
        self.contentView?.addSubview(self.secretTitleTextField)

        cancelButton.target = self
        saveButton.target = self
        chooseButton.target = self
        scanButton.target = self
        cancelButton.action = #selector(self.cancelButtonAction)
        chooseButton.action = #selector(self.chooseButtonAction)
        saveButton.action = #selector(self.saveButtonAction(button:))
        scanButton.action = #selector(self.scanButtonAction)
        saveButton.isEnabled = false
    }
    // MARK: - Lazy
    lazy var remarkTitleTextField: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 270, width: 200, height: 18), textColor: textColor, text: NSLocalizedString("remark_placeholder", comment: ""), font: 12)
        lab.isEditable = false
        lab.delegate = self
        return lab
    }()
    lazy var remarkTextField: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 13, y: 230, width: 455, height: 40), textColor: textColor, text: "", font: 12)
        lab.delegate = self
        lab.isBordered = true
        lab.focusRingType = .none
        lab.isBezeled = true
        lab.bezelStyle = .squareBezel
        lab.layer?.borderWidth = 1
        lab.layer?.borderColor = NSColor.mainColor.cgColor
        return lab
    }()
    lazy var issuerTitleTextField: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 200, width: 200, height: 18), textColor: textColor, text: NSLocalizedString("issuer_placeholder", comment: ""), font: 12)
        lab.isEditable = false
        lab.delegate = self
        return lab
    }()
    lazy var issuerTextField: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 13, y: 160, width: 455, height: 40), textColor: textColor, text: "", font: 12)
        lab.delegate = self
        lab.isBordered = true
        lab.focusRingType = .none
        lab.isBezeled = true
        lab.bezelStyle = .squareBezel
        lab.layer?.borderWidth = 1
        lab.layer?.borderColor = NSColor.mainColor.cgColor
        return lab
    }()
    lazy var secretTitleTextField: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 130, width: 200, height: 18), textColor: textColor, text: NSLocalizedString("secret_placeholder", comment: ""), font: 12)
        lab.isEditable = false
        lab.delegate = self
        return lab
    }()
    lazy var secretTextFiled: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 13, y: 90, width: 455, height: 40), textColor: textColor, text: "", font: 12)
        lab.delegate = self
        lab.isBordered = true
        lab.focusRingType = .none
        lab.isBezeled = true
        lab.bezelStyle = .squareBezel
        lab.layer?.borderWidth = 1
        lab.layer?.borderColor = NSColor.mainColor.cgColor
        return lab
    }()
    // MARK: - FUNC
    override func controlTextDidChange(_ obj: Notification) {
        if self.remarkTextField.stringValue.count == 0 || self.issuerTextField.stringValue.count == 0 || self.secretTextFiled.stringValue.count == 0{
            saveButton.isEnabled = false
        }else{
            saveButton.isEnabled = true
        }

    }
    @objc func cancelButtonAction() {
        self.close()
    }
    @objc func scanButtonAction() {
        print("扫描")
//        ScanQRCodeOnScreen()
        let temWindow = ScanWindow.init(contentRect: NSRect(x: 0, y: 0, width: 300, height: 300), styleMask: .closable, backing: .buffered, defer: true)
        let windowVC = NSWindowController.init(window: temWindow)
        temWindow.scanDelegate = self
        windowVC.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    @objc func saveButtonAction(button: NSButton) {
        let otp = Tools().totpStringFormat(remark: self.remarkTextField.stringValue, issuer: self.issuerTextField.stringValue, secret: self.secretTextFiled.stringValue)

        // 将数据保存到UserDefaults
        let defaults = UserDefaults.standard
        var allItems  = defaults.value(forKey: "MinaOtpMAC") as? [String] ?? []
        allItems.append(otp)
        defaults.set(allItems, forKey: "MinaOtpMAC")
        ShowTips().showTip(message: NSLocalizedString("add_success_tip", comment: ""), view: self.contentView!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.close()
        }
    }

    @objc func chooseButtonAction() {
        let openPanel = NSOpenPanel.init()
        openPanel.prompt = NSLocalizedString("choose_title", comment: "")
        openPanel.allowedFileTypes = NSImage.imageTypes
        let code = openPanel.runModal()
        if code.rawValue == 1{
            self.readQRCode(qrImage: CIImage.init(contentsOf: openPanel.url!)!)
        }
    }

    func readQRCode(qrImage: CIImage) {

        let context = CIContext.init(options: nil)
        let detector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        let features = detector?.features(in: qrImage)
        if features?.count == 1{
            let feature: CIQRCodeFeature = features?.first as! CIQRCodeFeature
            guard let result = feature.messageString else { return }
            self.otpFormat(code: result)
        }else{
            Tools().showAlert(message: NSLocalizedString("image_error_tip", comment: ""))
        }
    }
    func otpFormat(code: String) {
        if code.contains("otpauth://totp/") == false || code.contains("?secret=") == false || code.contains("&issuer=") == false{
            Tools().showAlert(message: NSLocalizedString("image_content_error_tip", comment: ""))
            return
        }
        let totpDic = Tools().totpDictionaryFormat(code: code)
        remarkTextField.stringValue = totpDic["remark"] as! String
        issuerTextField.stringValue = totpDic["issuer"] as! String
        secretTextFiled.stringValue = totpDic["secret"] as! String
        saveButton.isEnabled = true
    }
    //MARK: - ScanWindowDelegate
    func scanSuccess(code: String) {
        self.becomeFirstResponder()
        self.otpFormat(code: code)
    }
}
