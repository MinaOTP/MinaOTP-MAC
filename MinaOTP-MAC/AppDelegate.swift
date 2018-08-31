//
//  AppDelegate.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/7/31.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa
import Carbon
import Foundation

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate, NSMenuDelegate{

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover.init()
    let popoverVC = PopoverViewController()

    struct GitHubInfoModel:Codable {
        var tag_name:String
        var name:String
        var html_url:String
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        if let button = statusItem.button{
            button.image = NSImage.init(named: NSImage.Name(rawValue: "close"))
            button.image?.size = NSSize(width: 20, height: 20)
            button.action = #selector(AppDelegate.mouseDownAction)
            button.sendAction(on: [.leftMouseDown, .rightMouseDown])
            button.target = self
            button.toolTip = NSLocalizedString("tool_tip", comment: "")
        }
        statusItem.highlightMode = true

        popover.behavior = NSPopover.Behavior(rawValue: 1)!
        popover.appearance = NSAppearance.init(named: .vibrantLight)
        popover.contentViewController = popoverVC
        popover.delegate = self
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { (event) in
            if event.type == .leftMouseDown || event.type == .rightMouseDown{
                self.statusItem.button?.state = NSControl.StateValue.off
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
            statusItem.button?.state = NSControl.StateValue.off
            leftMouseDownAction()
        }else if event?.type == .rightMouseDown{
            rightMouseDownAction()
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
        menu.addItem(withTitle: NSLocalizedString("export_help", comment: ""), action: #selector(exportDemoAction), keyEquivalent: "")
        menu.addItem(withTitle: NSLocalizedString("check_releases", comment: ""), action: #selector(checkReleases), keyEquivalent: "")
        menu.addItem(withTitle: NSLocalizedString("help", comment: ""), action: #selector(helpAction), keyEquivalent: "")
        menu.addItem(withTitle: NSLocalizedString("exit", comment: ""), action: #selector(exitAction), keyEquivalent: "")
        statusItem.popUpMenu(menu)
    }
    @objc func helpAction() {
        NSWorkspace.shared.open(NSURL.init(string: "https://github.com/MinaOTP/MinaOTP-MAC")! as URL)
    }
    @objc func exitAction() {
        NSApp.terminate(nil)
    }
    @objc func checkReleases() {
        let requestUrl = NSURL.init(string: "https://api.github.com/repos/MinaOTP/MinaOTP-MAC/releases/latest")
        let request = URLRequest.init(url: requestUrl! as URL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            DispatchQueue.main.async {
                self.dealRequestData(data: data!)
            }
        }
        task.resume()
    }
    func dealRequestData (data: Data){
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(GitHubInfoModel.self, from: data as Data)
            print(model.tag_name)
            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            print(version)

            if version != model.tag_name {
                Tools().showAlert(message: NSLocalizedString("has_new_version", comment: ""))
            }else{
                Tools().showAlert(message: NSLocalizedString("no_new_version", comment: ""))
            }

        } catch {
            print("error")
        }
    }
    @objc func exportDemoAction() {
        let savePanel = NSSavePanel()
        savePanel.title = NSLocalizedString("export_title", comment: "")
        savePanel.nameFieldStringValue = "minaOTP_example.json"
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        let i = savePanel.runModal()
        if i == NSApplication.ModalResponse.OK {
            let temArray = [["remark":"remark_value", "secret":"secret_value", "issuer":"issuer_value"], ["remark":"remark_value", "secret":"secret_value", "issuer":"issuer_value"]]
            let temJsonData = try! JSONSerialization.data(withJSONObject: temArray, options: .prettyPrinted)
            let temJsonStr = String.init(data: temJsonData, encoding: .utf8)
            do {
                try temJsonStr?.write(to: savePanel.url!, atomically: true, encoding: .utf8)
                Tools().showAlert(message: NSLocalizedString("export_sucess", comment: ""))
            } catch {
                Tools().showAlert(message: NSLocalizedString("export_failure", comment: ""))
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

        guard let keyCombo = KeyCombo(doubledCocoaModifiers: .command) else { return }
        let hotKey = HotKey(identifier: "CommandDoubleTap",
                             keyCombo: keyCombo,
                             target: self,
                             action: #selector(AppDelegate.tappedDoubleCommandKey))
        hotKey.register()

        
    }
    @objc func tappedDoubleCommandKey() {
        if self.popover.isShown {
            self.popover.close()
        }else{
            leftMouseDownAction()
        }
    }
    func removeHotKey() {

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

