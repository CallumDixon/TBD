//
//  DataInterfaceViewModel.swift
//  TBD
//
//  Created by Callum Dixon on 22/06/2022.
//

import Foundation
import AppKit

final class DataInterfaceViewModel {
    
    var userData:[UserData] = []
    var foregroundApp: String?
    var currentDateTime: Date
    let userDataUserDefaultsKey = "TBDData"
    
    init(){
        userData = (UserDefaults.standard.array(forKey: userDataUserDefaultsKey) as? [UserData] ?? [UserData]())
        currentDateTime = Date.now
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(foreGroundAppDidChange), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }
    
    @objc func foreGroundAppDidChange(){
        if let name = NSWorkspace.shared.frontmostApplication?.localizedName {
            
            // The current application session has ended
            // Therefore we retreive the current name, calculate the time elapsed and pass this to the addUserDateItem function
            
            let newSessionDateTime = Date.now
            
            if let foregroundApp = self.foregroundApp {
                addUserDataItem(name: foregroundApp, time: DateInterval(start: currentDateTime, end: newSessionDateTime))
            }
             
            // Sets the current foreground app and its start date/time
            self.foregroundApp = name
            self.currentDateTime = newSessionDateTime
        }
    }
    
    func addUserDataItem(name: String, time: DateInterval) {
        
        userData.append(UserData(name: name, time: time))
        UserDefaults.standard.set(userData, forKey: userDataUserDefaultsKey)
    }
    
    func removeUserData(){
        UserDefaults.standard.removeObject(forKey: userDataUserDefaultsKey)
    }
}
