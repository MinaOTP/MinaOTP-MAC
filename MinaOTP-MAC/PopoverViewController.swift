//
//  PopoverViewController.swift
//  MinaOTP-MAC
//
//  Created by 武建明 on 2018/8/1.
//  Copyright © 2018年 Four_w. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSMenuDelegate, NSPopoverDelegate{


    let importButton = CustomFlatButton().customFlatButton(frame: CGRect(x: 12, y: 365, width: 48, height: 24), title: NSLocalizedString("import", comment: ""))
    let exportButton = CustomFlatButton().customFlatButton(frame: CGRect(x: 72, y: 365, width: 48, height: 24), title: NSLocalizedString("export", comment: ""))
    let addButton = CustomFlatButton().customFlatButton(frame: CGRect(x: 240, y: 365, width: 48, height: 24), title: NSLocalizedString("add", comment: "add"))
    var totpArray = [String]()
    var oldTimeStamp = 0
    let kCellHeight = CGFloat(60)
    var clickedRow: Int = -1

    override func loadView() {
        self.view = NSView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.clear.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()

        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: NSNotification.Name(rawValue:"reloadData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: NSNotification.Name(rawValue:"addData"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didScroll), name: NSView.boundsDidChangeNotification, object: totpTableView.enclosingScrollView?.contentView)
    }
    override func awakeFromNib() {
    }
    //MARK: - Lazy
    struct OtpModel:Codable {
        var secret:String
        var issuer:String
        var remark:String
    }
    lazy var editPopoverView : NSPopover = {
        let pop = NSPopover()
        pop.behavior = .transient
        //pop.appearance = NSAppearance.init(named: .vibrantLight)
        pop.delegate = self
        return pop
    }()
    lazy var totpTableView: NSTableView = {
        let tab = NSTableView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tab.delegate = self;
        tab.dataSource = self;
        tab.enclosingScrollView?.drawsBackground = false
        tab.backgroundColor = .clear
        tab.headerView = NSTableHeaderView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "column1"))
        column1.width = 300
        tab.addTableColumn(column1)
        tab.target = self
        tab.doubleAction = #selector(self.tableViewDoubleClick)
        let menu = NSMenu()
        menu.delegate = self
        tab.menu = menu
        tab.draggingDestinationFeedbackStyle = .gap
        return tab
    }()
    lazy var bgScrollView: NSScrollView = {
        let scrollView = NSScrollView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 350))
        scrollView.contentView.backgroundColor = .clear
        scrollView.documentView = totpTableView
        totpTableView.enclosingScrollView?.drawsBackground = false
        return scrollView
    }()
    lazy var progressView:ProgressView = {
        let view = ProgressView.init(frame: CGRect(x: 0, y: 350, width: 300, height: 2))
        view.layer?.backgroundColor = NSColor.clear.cgColor
        return view
    }()
    lazy var timer:Timer! = {
        let t = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(t, forMode: RunLoop.Mode.common)
        return t
    }()
    private func config() {
        self.view.addSubview(importButton)
        self.view.addSubview(exportButton)
        self.view.addSubview(addButton)
        self.view.addSubview(self.bgScrollView)
        self.view.addSubview(self.progressView)
        importButton.target = self
        exportButton.target = self
        addButton.target = self
        importButton.action = #selector(self.importButtonAction)
        exportButton.action = #selector(self.exportButtonAction)
        addButton.action = #selector(self.addButtonAction(button:))


        totpTableView.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
    }
    // MARK: - Action
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()
        clickedRow = totpTableView.clickedRow
        menu.addItem(withTitle: NSLocalizedString("delete", comment: ""), action: #selector(deleteRowAction), keyEquivalent: "")
        menu.addItem(withTitle: NSLocalizedString("edit", comment: ""), action: #selector(editRowAction), keyEquivalent: "")
    }
    func menuWillOpen(_ menu: NSMenu) {
        print("menuWillOpen")
        stopTimer()
    }
    func menuDidClose(_ menu: NSMenu) {
        print("menuDidClose")
        startTimer()
    }
    func reloadData() {
        totpArray.removeAll()
        let defaults = UserDefaults.standard
        totpArray  = defaults.value(forKey: "MinaOtpMAC") as? [String] ?? []
        totpTableView.reloadData()
    }
    func startTimer() {
        print("计时器开始")
        self.reloadData()
        if totpArray.count > 0 {
            totpTableView.reloadData()
            oldTimeStamp = Int(Date().timeIntervalSince1970)/30
            self.timer.fireDate = Date.distantPast
        }else{
            self.progressView.setProgress(value: 0.00)
        }
    }
    func stopTimer() {
        print("计时器停止")
        self.timer.fireDate = Date.distantFuture
    }
    @objc func notificationAction(nofi : Notification){
        let type = nofi.userInfo!["type"]
        if (type as! String) == "edit_save" {
            ShowTips().showTip(message: "修改成功", view: self.view)
            editPopoverView.close()
        }else if (type as! String) == "reload" {
            startTimer()
        }else if (type as! String) == "close" {
            stopTimer()
        }else if (type as! String) == "edit_cancel" {
            editPopoverView.close()
        }else if (type as! String) == "add_success_from_textfield" {
            self.totpTableView.scrollRowToVisible(totpArray.count-1)
        }
    }
    func popoverWillClose(_ notification: Notification) {
        print("popoverWillClose")
        startTimer()
    }
    func popoverWillShow(_ notification: Notification) {
        print("popoverWillShow")
        stopTimer()
    }
    @objc func timerAction() {
        let nowTimeStamp = Int(Date().timeIntervalSince1970)/30
        let progress = Date().timeIntervalSince1970/30-Double(nowTimeStamp)
        self.progressView.setProgress(value: CGFloat(progress))
        if nowTimeStamp != self.oldTimeStamp{
            totpTableView.reloadData()
            oldTimeStamp = nowTimeStamp
        }
    }
    @objc func deleteRowAction() {
        print("deleteRowAction")
        print(clickedRow)
        totpArray.remove(at: clickedRow)
        totpTableView.removeRows(at: [clickedRow], withAnimation: .slideRight)
        let defaults = UserDefaults.standard
        defaults.set(self.totpArray, forKey: "MinaOtpMAC")
    }
    @objc func editRowAction() {
        stopTimer()
        let rect = totpTableView.rect(ofRow: clickedRow)
        let super_rect = totpTableView.convert(rect, to: self.view)
        let editVC = EditPopoverViewController()
        editVC.editRow = clickedRow
        self.editPopoverView.contentViewController = editVC
        self.editPopoverView.show(relativeTo: super_rect, of: self.view, preferredEdge: NSRectEdge.maxX)

    }
    @objc func tableViewDoubleClick() {
        print(totpTableView.selectedRow)
        let view = totpTableView.view(atColumn: 0, row: totpTableView.selectedRow, makeIfNecessary: false)
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        let res = pasteboard.setString((view as! CellView).codeTextField.stringValue, forType: .string)
        if res {
            ShowTips().showTip(message: NSLocalizedString("copy_success", comment: ""), view: self.view)
        }
    }
    @objc func importButtonAction() {
        let openPanel = NSOpenPanel.init()
        openPanel.prompt = NSLocalizedString("choose_title", comment: "")
        openPanel.allowedFileTypes = ["json"]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        let code = openPanel.runModal()
        if code.rawValue == 1{
            let jsonData = NSData.init(contentsOf: openPanel.url!)
            let decoder = JSONDecoder()
            do {
                let otpModelArray = try decoder.decode([OtpModel].self, from: jsonData! as Data)

                // 将数据保存到UserDefaults
                let defaults = UserDefaults.standard
                var allItems  = defaults.value(forKey: "MinaOtpMAC") as? [String] ?? []

                for item in otpModelArray{
                    let otp = Tools().totpStringFormat(remark: item.remark, issuer: item.issuer, secret: item.secret)
                    allItems.append(otp)
                }
                defaults.set(allItems, forKey: "MinaOtpMAC")
                Tools().showAlert(message: NSLocalizedString("add_success_tip", comment: ""))

            } catch let error{
                print(error)
                Tools().showAlert(message: NSLocalizedString("parse_failed", comment: ""))
            }
        }
    }

    @objc func exportButtonAction() {
        let savePanel = NSSavePanel()
        savePanel.title = NSLocalizedString("export_title", comment: "")
        savePanel.nameFieldStringValue = "minaOTP.json"
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        let i = savePanel.runModal()
        if i == NSApplication.ModalResponse.OK {

            // 将数据保存到UserDefaults
            let defaults = UserDefaults.standard
            let allItems  = defaults.value(forKey: "MinaOtpMAC") as? [String] ?? []
            var temArray = [Any]()
            for item in allItems{
                let otpDic = Tools().totpDictionaryFormat(code: item)
                temArray.append(otpDic)
            }
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
    @objc func addButtonAction(button: NSButton) {
        print("addButtonAction")
        let temWindow = AddWindow.init(contentRect: NSRect(x: 0, y: 0, width: 480, height: 320), styleMask: .closable, backing: .buffered, defer: true)
        let windowVC = NSWindowController.init(window: temWindow)
        windowVC.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    // MARK: - TableViewDelegate,TableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return totpArray.count
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return kCellHeight
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        var view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellIdentifier"), owner: self)
        if (view==nil) {
            view = CellView.init(frame: CGRect(x: 0, y: 0, width: 400, height: kCellHeight))
            (view as! CellView).identifier = NSUserInterfaceItemIdentifier(rawValue: "cellIdentifier");
        }
        let totpDic = Tools().totpDictionaryFormat(code: totpArray[row])
        (view as! CellView).remarkTextField.stringValue = (totpDic["remark"] as? String)!
        (view as! CellView).issuerTextField.stringValue = (totpDic["issuer"] as? String)!
        (view as! CellView).codeTextField.stringValue = GeneratorTotp.generateOTP(forSecret: totpDic["secret"] as? String)
//        (view as! CellView).hotKeyTextField.stringValue = "⌘\(row)"

        return view;
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let tableRowView = CSTableRowView()
        tableRowView.isGroupRowStyle = false
        return tableRowView
    }

    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return true
    }
//
//    func tableView(_ tableView: NSTableView, didDrag tableColumn: NSTableColumn) {
//        print("拖动")
//    }

    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
        pboard.declareTypes([NSPasteboard.PasteboardType.string], owner: self)
        pboard.setData(data, forType: NSPasteboard.PasteboardType.string)
        return true
    }
    func tableView(tableView: NSTableView, writeRowsWithIndexes rowIndexes: NSIndexSet, toPasteboard pboard: NSPasteboard) -> Bool {
        pboard.declareTypes([NSPasteboard.PasteboardType.string], owner: self)
        pboard.setString("currencyCode", forType: NSPasteboard.PasteboardType.string)
        return true
    }

    func tableView(_ tableView: NSTableView, didDrag tableColumn: NSTableColumn) {
        print("asasasdad")
    }
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {
        stopTimer()
        print("开始拖动")
    }
    func tableView(_ tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
        print("拖动结束")
    }
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {

        if dropOperation == .above {
            print("插入")
            return .move
        }
        return []
    }
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {

        if info.draggingSource as! NSTableView == totpTableView{
            let data = info.draggingPasteboard.data(forType: NSPasteboard.PasteboardType.string)
            let rowIndexes:NSIndexSet = NSKeyedUnarchiver.unarchiveObject(with: data!) as! NSIndexSet

            if rowIndexes.firstIndex == row{
                totpTableView.reloadData()
                startTimer()
                return true
            }
            let value:String = totpArray[rowIndexes.firstIndex]
            totpArray.remove(at: rowIndexes.firstIndex)
            if rowIndexes.firstIndex < row{
                totpArray.insert(value, at: row-1)
            }else{
                totpArray.insert(value, at: row)
            }
            let defaults = UserDefaults.standard
            defaults.set(totpArray, forKey: "MinaOtpMAC")
            totpTableView.reloadData()
            startTimer()
            return true
        }
        return false

    }
}
