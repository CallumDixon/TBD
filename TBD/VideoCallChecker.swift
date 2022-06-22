//
//  VideoCallChecker.swift
//  TBD
//
//  Created by Callum Dixon on 21/06/2022.
//

import Foundation
import Cocoa
import RxSwift
import RxRelay

class VideoCallChecker {
    
    let isInCall = BehaviorRelay<Bool>(value: false)
    let center = NSWorkspace.shared.notificationCenter
    
    init(){
        
        searchForZoom()
        
        center.addObserver(forName: NSWorkspace.didLaunchApplicationNotification,object: nil, queue: OperationQueue.main) { (notification: Notification) in
            if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
                if let name = app.localizedName{
                    if name.contains("zoom"){
                        self.isInCall.accept(true)
                    }
                }

            }
        }
        
        center.addObserver(forName: NSWorkspace.didTerminateApplicationNotification, object: nil, queue: OperationQueue.main) {(notification: Notification) in
            if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
                if let name = app.localizedName{
                    if name.contains("zoom"){
                        self.isInCall.accept(false)
                    }
                }
            }
        }
    }
    
    func searchForZoom() {
        
        for app in NSWorkspace.shared.runningApplications{
            
            if let name = app.localizedName{
                if name.contains("zoom"){
                    self.isInCall.accept(true)
                }
            }
        }
    }
}
