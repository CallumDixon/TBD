//
//  DataInterfaceViewModel.swift
//  TBD
//
//  Created by Callum Dixon on 22/06/2022.
//

import Foundation
import AppKit

final class UserDataInterfaceViewModel {
        
    var userData:[UserData?] = []
    var foregroundApp: String?
    var currentDateTime: Date
    let userDataUserDefaultsKey = "TBDData"
    
    init(){
        currentDateTime = Date.now
        
        // Comment out to persist data between sessions
        removeUserDataAll()

        userData = getUserDataAll()
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(foreGroundAppDidChange), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }
    
    @objc func foreGroundAppDidChange(){
        if let name = NSWorkspace.shared.frontmostApplication?.localizedName {
            // The current application session has ended
            // Therefore we retreive the current name, calculate the time elapsed and pass this to the addUserDateItem function
            
            let newSessionDateTime = Date.now
            
            if let foregroundApp = self.foregroundApp {
                addUserDataItem(name: foregroundApp, dateInterval: DateInterval(start: currentDateTime, end: newSessionDateTime))
            }
             
            // Sets the current foreground app and its start date/time
            self.foregroundApp = name
            self.currentDateTime = newSessionDateTime
            
            let allUserData = getUserDataAll().compactMap{$0}
            //print(allUserData)
        }
    }
    
    func getUserDataAll() -> [UserData?]{
        let storedUserData = (UserDefaults.standard.array(forKey: userDataUserDefaultsKey) as? [Data] ?? [Data]())
        let decoder = JSONDecoder()
        
        let decoded = storedUserData.map{item -> UserData? in
            
            do {
                let userDataItem = try decoder.decode(UserData.self, from: item)
                return userDataItem
            }
            catch{
                return(nil)
            }
            
        }
        return decoded
    }
    
    func addUserDataItem(name: String, dateInterval: DateInterval) {
        
        
        
        let newUserData = UserData(name: name, dateInterval: dateInterval, time: dateInterval.duration)
        

        self.userData.append(newUserData)
        
        let encoder = JSONEncoder()

        
        let encoded = self.userData.map{item -> Data? in
            
            do {
                let userDataItem = try encoder.encode(item)
                return userDataItem
            }
            catch{
                return(nil)
            }
        }

        UserDefaults.standard.set(encoded, forKey: userDataUserDefaultsKey)
    }
    
    func removeUserDataAll(){
        UserDefaults.standard.removeObject(forKey: userDataUserDefaultsKey)
    }
}
