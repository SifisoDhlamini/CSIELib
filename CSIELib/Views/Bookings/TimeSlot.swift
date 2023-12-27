//
//  TimeSlot.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/27.
//

import Foundation

struct TimeSlot: Identifiable, Hashable {
    let id = UUID()
    let start: Date
    let end: Date
    
    var displayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}
