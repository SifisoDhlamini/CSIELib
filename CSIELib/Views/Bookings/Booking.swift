//
//  Booking.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/20.
//

import Foundation
import FirebaseFirestoreSwift

struct Booking: Identifiable, Codable {
    @DocumentID var id: String?
    var date: Date
    var startTime: Date
    var endTime: Date
    var duration: Int
    var seat: Seat
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case startTime
        case endTime
        case duration
        case seat
    }
    
    init(date: Date, startTime: Date, endTime: Date, duration: Int, seat: Seat) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.seat = seat
    }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        startTime = try container.decode(Date.self, forKey: .startTime)
        endTime = try container.decode(Date.self, forKey: .endTime)
        duration = try container.decode(Int.self, forKey: .duration)
        seat = try container.decode(Seat.self, forKey: .seat)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(duration, forKey: .duration)
        try container.encode(seat, forKey: .seat)
    }
}

