//
//  Item.swift
//  pomotimer
//
//  Created by Jinwoo Park on 2024/01/10.
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
