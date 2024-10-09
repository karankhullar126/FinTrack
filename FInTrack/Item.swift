//
//  Item.swift
//  FInTrack
//
//  Created by Karan Khullar on 06/10/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
