//
//  AppDelegate.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/7/31.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa
import Carbon

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate, NSMenuDelegate{

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover.init()
    let popoverVC = PopoverViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

//        addLocalHotKey(keyCode: UInt32(kVK_ANSI_0))

        if let button = statusItem.button{
            button.image = NSImage.init(named: NSImage.Name(rawValue: "close"))
            button.image?.size = NSSize(width: 20, height: 20)
            button.action = #selector(AppDelegate.mouseDownAction)
            button.sendAction(on: [.leftMouseDown, .rightMouseDown])
            button.target = self
            button.toolTip = "魔镜魔镜,老子是不是最帅的人?"
        }
        statusItem.highlightMode = true

        popover.behavior = NSPopover.Behavior(rawValue: 1)!
        popover.appearance = NSAppearance.init(named: .vibrantLight)
        popover.contentViewController = popoverVC
        popover.delegate = self
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { (event) in
            if event.type == .leftMouseDown || event.type == .rightMouseDown{
                if self.popover.isShown {
                    self.popover.close()
                }
            }
        }
        addHotKey()


    }
    @objc func mouseDownAction() {
        let event = NSApp.currentEvent
        if event?.type == .leftMouseDown{
            print("左边的")
            leftMouseDownAction()
            statusItem.button?.state = NSControl.StateValue.off
        }else if event?.type == .rightMouseDown{
            print("右边的")
            rightMouseDownAction()
            statusItem.button?.state = NSControl.StateValue.mixed
        }else{
            print("谁点的")
        }
    }
    func leftMouseDownAction() {
        popover.show(relativeTo: (statusItem.button?.bounds)!, of: (statusItem.button)!, preferredEdge: NSRectEdge.maxY)
    }
    func rightMouseDownAction() {
        let menu = NSMenu.init()
        menu.delegate = self
        menu.addItem(withTitle: "  下载导入格式文件  ", action: #selector(exportDemoAction), keyEquivalent: "")
        menu.addItem(withTitle: "  帮助  ", action: #selector(helpAction), keyEquivalent: "")
        menu.addItem(withTitle: "  退出  ", action: #selector(exitAction), keyEquivalent: "")
        statusItem.popUpMenu(menu)
    }
    @objc func helpAction() {
        NSWorkspace.shared.open(NSURL.init(string: "https://github.com/wjmwjmwb/MinaOTP-MAC")! as URL)
    }
    @objc func exitAction() {
        NSApp.terminate(nil)
    }
    @objc func exportDemoAction() {
        let savePanel = NSSavePanel()
        savePanel.title = "选择文件导出位置"
        savePanel.nameFieldStringValue = "minaOTP_example.json"
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        let i = savePanel.runModal()
        if i == NSApplication.ModalResponse.OK {

            // 将数据保存到UserDefaults
            let temArray = [["remark":"备注0", "secret":"密钥0", "issuer":"发行者0"], ["remark":"备注1", "secret":"密钥1", "issuer":"发行者1"]]
            let temJsonData = try! JSONSerialization.data(withJSONObject: temArray, options: .prettyPrinted)
            let temJsonStr = String.init(data: temJsonData, encoding: .utf8)
            do {
                try temJsonStr?.write(to: savePanel.url!, atomically: true, encoding: .utf8)
                Tools().showAlert(message: "导出成功")
            } catch {
                Tools().showAlert(message: "导出失败,请重新尝试")
            }
        }
    }
    func popoverWillShow(_ notification: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name("reloadData"), object: self, userInfo: ["type":"reload"])
        statusItem.button?.image = NSImage.init(named: NSImage.Name(rawValue: "open"))
        statusItem.button?.image?.size = NSSize(width: 20, height: 20)

    }
    func popoverDidClose(_ notification: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name("reloadData"), object: self, userInfo: ["type":"close"])
        statusItem.button?.image = NSImage.init(named: NSImage.Name(rawValue: "close"))
        statusItem.button?.image?.size = NSSize(width: 20, height: 20)
    }

    func addHotKey() {

        guard let keyCombo3 = KeyCombo(doubledCocoaModifiers: .command) else { return }
        let hotKey3 = HotKey(identifier: "CommandDoubleTap",
                             keyCombo: keyCombo3,
                             target: self,
                             action: #selector(AppDelegate.tappedDoubleCommandKey))
        hotKey3.register()

        
    }
    @objc func tappedDoubleCommandKey() {
        print("1231231")
        leftMouseDownAction()
    }
    func removeHotKey() {

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

