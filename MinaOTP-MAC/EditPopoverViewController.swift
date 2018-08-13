//
//  EditPopoverViewController.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/8/6.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa

class EditPopoverViewController: NSViewController,NSTextFieldDelegate {

    let cancleButton = CustomFlatButton().customFlatButton(frame: NSRect(x: 12, y: 12, width: 48, height: 24), title: NSLocalizedString("cancle", comment: ""))
    let saveButton = CustomFlatButton().customFlatButton(frame: NSRect(x: 140, y: 12, width: 48, height: 24), title: NSLocalizedString("save", comment: ""))
    var editRow:Int = -1
    let textColor = NSColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)

    override func loadView() {
        self.view = NSView(frame: CGRect(x: 0, y: 0, width: 200, height: 250))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        let defaults = UserDefaults.standard
        var allItems  = defaults.value(forKey: "MinaOtpMAC") as? [String] ?? []
        let totpDic = Tools().totpDictionaryFormat(code: allItems[editRow])
        remarkTextField.stringValue = (totpDic["remark"] as? String)!
        issuerTextField.stringValue = (totpDic["issuer"] as? String)!
        secretTextFiled.stringValue = (totpDic["secret"] as? String)!
    }
    override func awakeFromNib() {

    }
    private func config() {
        self.view.addSubview(cancleButton)
        self.view.addSubview(saveButton)
        self.view.addSubview(self.remarkTitleTextField)
        self.view.addSubview(self.remarkTextField)
        self.view.addSubview(self.issuerTitleTextField)
        self.view.addSubview(self.issuerTextField)
        self.view.addSubview(self.secretTitleTextField)
        self.view.addSubview(self.secretTextFiled)

        cancleButton.target = self
        saveButton.target = self
        cancleButton.action = #selector(self.cancleButtonAction)
        saveButton.action = #selector(self.saveButtonAction(button:))

        saveButton.isEnabled = false
    }
    lazy var remarkTitleTextField: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 220, width: 180, height: 18), textColor: textColor, text: NSLocalizedString("remark_placeholder", comment: ""), font: 10)
        lab.isEditable = false
        lab.delegate = self
        return lab
    }()
    lazy var remarkTextField: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 185, width: 180, height: 35), textColor: textColor, text: "", font: 12)
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
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 160, width: 180, height: 18), textColor: textColor, text: NSLocalizedString("issuer_placeholder", comment: ""), font: 10)
        lab.isEditable = false
        return lab
    }()
    lazy var issuerTextField: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 125, width: 180, height: 35), textColor: textColor, text: "", font: 12)
        lab.delegate = self
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
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 100, width: 180, height: 18), textColor: textColor, text: NSLocalizedString("secret_placeholder", comment: ""), font: 10)
        lab.isEditable = false
        lab.delegate = self
        return lab
    }()
    lazy var secretTextFiled: NSTextField = {
        let lab = Tools().generateTextField(frame: NSRect(x: 12, y: 55, width: 180, height: 45), textColor: textColor, text: "", font: 12)
        lab.delegate = self
        lab.isBordered = true
        lab.focusRingType = .none
        lab.isBezeled = true
        lab.bezelStyle = .squareBezel
        lab.layer?.borderWidth = 1
        lab.layer?.borderColor = NSColor.mainColor.cgColor
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
        NotificationCenter.default.post(name: NSNotification.Name("reloadData"), object: self, userInfo: ["type":"edit_cancle"])
    }

    @objc func saveButtonAction(button: NSButton) {
        print("saveButtonAction")
        let otp = Tools().totpStringFormat(remark: self.remarkTextField.stringValue, issuer: self.issuerTextField.stringValue, secret: self.secretTextFiled.stringValue)

        // 将数据保存到UserDefaults
        let defaults = UserDefaults.standard
        var allItems  = defaults.value(forKey: "MinaOtpMAC") as? [String] ?? []
        allItems.remove(at: editRow)
        allItems.insert(otp, at: editRow)
        defaults.set(allItems, forKey: "MinaOtpMAC")
        NotificationCenter.default.post(name: NSNotification.Name("reloadData"), object: self, userInfo: ["type":"edit_save"])
    }

    override func viewWillAppear() {
        super.viewWillAppear()
    }
}
