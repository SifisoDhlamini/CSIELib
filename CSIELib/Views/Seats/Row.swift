//
//  Row.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/20.
//

import Foundation

enum Row: String, Codable {
    case window
    case middle
    case cubicle
    
    var seatCount: Int {
        switch self {
            case .window:
                return 6
            case .middle:
                return 9
            case .cubicle:
                return 8
        }
    }
}

struct RowSeats: Identifiable, Codable {
    var id: String
    var row: Row
    var seats: [Seat]
    
    enum CodingKeys: String, CodingKey {
        case id
        case row
        case seats
    }
    
    init(row: Row) {
        self.id = UUID().uuidString
        self.row = row
        self.seats = (1...row.seatCount).map { Seat(seatNum: $0, row: row, booked: false) }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        row = try container.decode(Row.self, forKey: .row)
        seats = try container.decode([Seat].self, forKey: .seats)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(row, forKey: .row)
        try container.encode(seats, forKey: .seats)
    }
}

