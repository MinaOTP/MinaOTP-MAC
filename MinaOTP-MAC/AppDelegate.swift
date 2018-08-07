//
//  AppDelegate.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/7/31.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate{

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover.init()
    let popoverVC = PopoverViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        if let button = statusItem.button{
            button.image = NSImage.init(named: NSImage.Name(rawValue: "StatusIcon"))
            button.action = #selector(AppDelegate.statusItemClick)
            button.target = self
        }

        popover.behavior = NSPopover.Behavior(rawValue: 1)!
        popover.appearance = NSAppearance.init(named: .aqua)
        popover.contentViewController = popoverVC
        popover.delegate = self
        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { (event) in
            if self.popover.isShown {
                self.popover.close()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: NSNotification.Name(rawValue:"addData"), object: nil)
    }
    @objc func notificationAction(nofi : Notification){
        let type = nofi.userInfo!["type"]
        if (type as! String) == "add_success_from_textfield" {
            print("收到通知")
        }
    }
    @objc func statusItemClick() {
        print(statusItem.button?.bounds ?? "123")
        print(statusItem.button ?? "123")
        popover.show(relativeTo: (statusItem.button?.bounds)!, of: statusItem.button!, preferredEdge: NSRectEdge.maxY)
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

