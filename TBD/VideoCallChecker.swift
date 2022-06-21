//
//  VideoCallChecker.swift
//  TBD
//
//  Created by Callum Dixon on 21/06/2022.
//

import Foundation
import Cocoa

class VideoCallChecker {
    
    public static func zoomIsOpen() -> Bool {
        let running = NSWorkspace.shared.runningApplications
        for app in running{
            if let name = app.localizedName{
                if name.contains("zoom"){
                    return true
                }
            }
        }
        return false
    }
}
