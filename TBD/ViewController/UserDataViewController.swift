//
//  UserDataViewController.swift
//  TBD
//
//  Created by Callum Dixon on 22/06/2022.
//

import Cocoa

class UserDataViewController: NSViewController {

    
    @IBOutlet weak var tableView: NSTableView!
    
    required init?(coder code: NSCoder){
        super.init(coder: code)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension UserDataViewController: NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return AppDelegate.shared.userData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let userDataItem  = AppDelegate.shared.userData[row]{
            
            if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "IDText"){
                
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "IDText")
                guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else {return nil}
                cellView.textField?.stringValue = userDataItem.name
                return cellView
            }
            
            if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "IDDuration"){
                
                let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "IDDuration")
                guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else {return nil}
                cellView.textField?.doubleValue = userDataItem.time
                return cellView
            } 
        }
            return nil
        }
}
