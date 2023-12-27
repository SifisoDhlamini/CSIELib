//
//  Booking.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/20.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Booking: Identifiable, Codable {
    @DocumentID var id: String?
    var date: Date
    var startTime: Date
    var endTime: Date
    var duration: Int
    var seat: Seat
    var studentNumber: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case startTime
        case endTime
        case duration
        case seat
        case studentNumber
    }
    
    init(date: Date, startTime: Date, endTime: Date, duration: Int, seat: Seat, studentNumber: String) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.seat = seat
        self.studentNumber = studentNumber
    }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timestampDate = try container.decode(Double.self, forKey: .date)
        date = Date(timeIntervalSince1970: timestampDate)
        let timestampStartTime = try container.decode(Double.self, forKey: .startTime)
        startTime = Date(timeIntervalSince1970: timestampStartTime)
        let timestampEndTime = try container.decode(Double.self, forKey: .endTime)
        endTime = Date(timeIntervalSince1970: timestampEndTime)
        duration = try container.decode(Int.self, forKey: .duration)
        seat = try container.decode(Seat.self, forKey: .seat)
        studentNumber = try container.decode(String.self, forKey: .studentNumber)
    }

    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(duration, forKey: .duration)
        try container.encode(seat, forKey: .seat)
        try container.encode(studentNumber, forKey: .studentNumber)
    }
}

