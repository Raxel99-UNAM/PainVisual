//
//  Item.swift
//  PainVisual
//
//  Created by Raymundo Mondragon Lara on 25/03/24.
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
