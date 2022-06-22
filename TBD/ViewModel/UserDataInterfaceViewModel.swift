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
    var currentSession: String?
    var currentSessionStartTime: Date
    let userDataUserDefaultsKey = "TBDData"
    
    init(){
        currentSessionStartTime = Date.now
        
        // Comment out to persist data between sessions
        removeUserDataAll()

        userData = getUserDataAll()
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(foreGroundAppDidChange), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }
    
    @objc func foreGroundAppDidChange(){
        if let name = NSWorkspace.shared.frontmostApplication?.localizedName {
            
            let currentTime = Date.now
            
            // End the current Session
            endSession(currentSessionEndTime: currentTime)
             
            // And start the new one
            startSession(name: name, newSessionStartTime: currentTime)
            
        }
    }
    
    func endSession(currentSessionEndTime: Date){
        
        if let foregroundApp = self.currentSession {
            
            if foregroundApp != "Aria" {
                addUserDataItem(name: foregroundApp, dateInterval: DateInterval(start: currentSessionStartTime, end: currentSessionEndTime))

            }
        }
    }
    
    func startSession(name: String, newSessionStartTime: Date){
        
        self.currentSession = name
        self.currentSessionStartTime = newSessionStartTime
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
