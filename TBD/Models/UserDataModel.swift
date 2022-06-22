//
//  DataModel.swift
//  TBD
//
//  Created by Callum Dixon on 22/06/2022.
//

import Foundation

struct UserData : Codable {
    let name: String
    let dateInterval: DateInterval
    let time: Double
    
    init(name: String, dateInterval: DateInterval, time: Double){
        self.name = name
        self.dateInterval = dateInterval
        self.time = time
    }
}
