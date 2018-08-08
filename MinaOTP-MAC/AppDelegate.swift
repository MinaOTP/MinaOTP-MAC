//
//  AppDelegate.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/7/31.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate, NSMenuDelegate{

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover.init()
    let popoverVC = PopoverViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        if let button = statusItem.button{
            button.image = NSImage.init(named: NSImage.Name(rawValue: "statusIcon"))
            button.image?.size = NSSize(width: 20, height: 20)
            button.action = #selector(AppDelegate.mouseDownAction)
            button.sendAction(on: [.leftMouseDown, .rightMouseDown])
            button.target = self
        }
        statusItem.highlightMode = false
//        let statusItemView = StatusItemView.init(frame: NSZeroRect)
//        statusItemView.statusItem = statusItem
//        statusItemView.delegate = self
//        statusItem.view = statusItemView

        popover.behavior = NSPopover.Behavior(rawValue: 1)!
        popover.appearance = NSAppearance.init(named: .aqua)
        popover.contentViewController = popoverVC
        popover.delegate = self
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { (event) in
            if self.popover.isShown {
                self.popover.close()
            }
        }
    }
    @objc func mouseDownAction() {
        let event = NSApp.currentEvent
        if event?.type == .leftMouseDown{
            print("左边的")
            leftMouseDownAction()
            statusItem.button?.state = NSControl.StateValue(rawValue: 0)
        }else if event?.type == .rightMouseDown{
            print("右边的")
            rightMouseDownAction()
            statusItem.button?.state = NSControl.StateValue(rawValue: 0)
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
        menu.addItem(withTitle: "  帮助  ", action: #selector(helpAction), keyEquivalent: "")
        menu.addItem(withTitle: "  退出  ", action: #selector(exitAction), keyEquivalent: "")
        statusItem.popUpMenu(menu)
    }
    @objc func helpAction() {
        NSWorkspace.shared.open(NSURL.init(string: "https://www.baidu.com")! as URL)
    }
    @objc func exitAction() {
        NSApp.terminate(nil)
    }
    func popoverWillShow(_ notification: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name("reloadData"), object: self, userInfo: ["type":"reload"])
    }
    func popoverDidClose(_ notification: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name("reloadData"), object: self, userInfo: ["type":"close"])
    }


    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

