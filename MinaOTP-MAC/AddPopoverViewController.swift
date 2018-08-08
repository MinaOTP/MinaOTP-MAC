//
//  AddPopoverViewController.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/8/3.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa

class AddPopoverViewController: NSViewController,NSTextFieldDelegate {

    let cancleButton = CustomFlatButton().customFlatButton(frame: NSRect(x: 12, y: 12, width: 40, height: 20), title: "取消")
    let saveButton = CustomFlatButton().customFlatButton(frame: NSRect(x: 148, y: 12, width: 40, height: 20), title: "保存")
    let chooseButton = CustomFlatButton().customFlatButton(frame: NSRect(x: 50, y: 218, width: 100, height: 20), title: "选取二维码图片")

    override func loadView() {
        self.view = NSView(frame: CGRect(x: 0, y: 0, width: 200, height: 250))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    override func awakeFromNib() {
        //        self.totpTableView.register(NSNib(nibNamed: NSNib.Name(rawValue: "cellIdentifier"), bundle: nil)!, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellIdentifier"))
    }
    private func config() {
        self.view.addSubview(cancleButton)
        self.view.addSubview(saveButton)
        self.view.addSubview(chooseButton)
        self.view.addSubview(self.remarkTextField)
        self.view.addSubview(self.issuerTextField)
        self.view.addSubview(self.secretTextFiled)

        cancleButton.target = self
        saveButton.target = self
        chooseButton.target = self
        cancleButton.action = #selector(self.cancleButtonAction)
        chooseButton.action = #selector(self.chooseButtonAction)
        saveButton.action = #selector(self.saveButtonAction(button:))

        saveButton.isEnabled = false
    }
    lazy var remarkTextField: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 170, width: 180, height: 30), textColor: NSColor.red, text: "", font: 12)
        lab.placeholderString = "请输入remark"
        lab.delegate = self
        return lab
    }()

    lazy var issuerTextField: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 115, width: 180, height: 30), textColor: NSColor.red, text: "", font: 12)
        lab.placeholderString = "请输入issuer"
        lab.delegate = self
        return lab
    }()
    lazy var secretTextFiled: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 65, width: 180, height: 30), textColor: NSColor.red, text: "", font: 12)
        lab.placeholderString = "请输入secret"
        lab.delegate = self
        return lab
    }()
    override func controlTextDidChange(_ obj: Notification) {
        if self.remarkTextField.stringValue.count == 0 || self.issuerTextField.stringValue.count == 0 || self.secretTextFiled.stringValue.count == 0{
            saveButton.isEnabled = false
        }else{
            print("可以输入了")
            saveButton.isEnabled = true
        }

    }
    @objc func cancleButtonAction() {
        print("cancleButtonAction")
    }

    @objc func saveButtonAction(button: NSButton) {
        print("saveButtonAction")
        let otp = Tools().totpStringFormat(remark: self.remarkTextField.stringValue, issuer: self.issuerTextField.stringValue, secret: self.secretTextFiled.stringValue)

        // 将数据保存到UserDefaults
        let defaults = UserDefaults.standard
        var allItems  = defaults.value(forKey: "MinaOtpMAC") as? [String] ?? []
        allItems.append(otp)
        defaults.set(allItems, forKey: "MinaOtpMAC")

        // 发送添加成功通知
        NotificationCenter.default.post(name: NSNotification.Name("addData"), object: self, userInfo: ["type":"add_success_from_textfield"])
    }

    @objc func chooseButtonAction() {
        print("chooseButtonAction")
        let openPanel = NSOpenPanel.init()
        openPanel.prompt = "选择"
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
            print("非二维码图片")
            Tools().showAlert(message: "非二维码图片")
        }
    }
    func otpFormat(code: String) {
        if code.contains("otpauth://totp/") == false || code.contains("?secret=") == false || code.contains("&issuer=") == false{
            Tools().showAlert(message: "二维码内容格式不正确")
            return
        }

        // 将数据保存到UserDefaults
        let defaults = UserDefaults.standard
        var allItems  = defaults.value(forKey: "MinaOtpMAC") as? [String] ?? []
        allItems.append(code)
        defaults.set(allItems, forKey: "MinaOtpMAC")

        NotificationCenter.default.post(name: NSNotification.Name("addData"), object: self, userInfo: ["type":"add_success"])

//        Tools().showAlert(message: "添加成功")

    }
    override func viewWillAppear() {
        super.viewWillAppear()
    }
}
