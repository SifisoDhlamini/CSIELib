//
//  Seat.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/20.
//

import Foundation
import SwiftUI

struct Seat: Codable, Identifiable {
    var id = UUID()
    var seatNum: Int
    var row: Row
    var booked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case seatNum
        case row
        case booked
    }
    
    init(seatNum: Int, row: Row, booked: Bool) {
        self.seatNum = seatNum
        self.row = row
        self.booked = booked
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        seatNum = try container.decode(Int.self, forKey: .seatNum)
        row = try container.decode(Row.self, forKey: .row)
        booked = try container.decode(Bool.self, forKey: .booked)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(seatNum, forKey: .seatNum)
        try container.encode(row, forKey: .row)
        try container.encode(booked, forKey: .booked)
    }
}

