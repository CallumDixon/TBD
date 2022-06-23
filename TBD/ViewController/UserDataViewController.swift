//
//  UserDataViewController.swift
//  TBD
//
//  Created by Callum Dixon on 22/06/2022.
//

import Cocoa
import Charts

class UserDataViewController: NSViewController {

    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var userDataPieChartView: PieChartView!
    
    required init?(coder code: NSCoder){
        super.init(coder: code)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        var entries : [PieChartDataEntry] = Array()
        
        for data in AppDelegate.shared.userData {
            
            if let row = entries.firstIndex(where: {$0.label == data?.name}){
                
                if let time = data?.time{
                    entries[row].value += time
                }
            }
            
            else {
                
                if let time = data?.time{
                    entries.append(PieChartDataEntry(value: time, label: data?.name))
                }
            }
        }
        
        entries = entries.sorted(by: {$0.value > $1.value})
        entries = Array(entries.prefix(5))
        
                
        
       let dataSet = PieChartDataSet(entries: entries, label : "This shows the 5 apps you spend the most time in.")
        
        dataSet.colors = [NSUIColor(ciColor: .red), NSUIColor(ciColor: .blue), NSUIColor(ciColor: .green), NSUIColor(ciColor: .yellow), NSUIColor(ciColor: .magenta)]
        dataSet.valueColors =  [NSUIColor(ciColor: .black),NSUIColor(ciColor: .black),NSUIColor(ciColor: .black),NSUIColor(ciColor: .black),NSUIColor(ciColor: .black)]
        dataSet.drawValuesEnabled = true

        
        userDataPieChartView.data = PieChartData(dataSet: dataSet)


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
