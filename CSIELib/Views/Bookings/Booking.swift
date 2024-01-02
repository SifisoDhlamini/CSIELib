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
    var id: UUID
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
        self.id = UUID() // Generate a new UUID
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.seat = seat
        self.studentNumber = studentNumber
    }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateFormatter = ISO8601DateFormatter()
        
        id = try container.decode(UUID.self, forKey: .id)
        
        let dateString = try container.decode(String.self, forKey: .date)
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        self.date = date
        
        let startTimeString = try container.decode(String.self, forKey: .startTime)
        guard let startTime = dateFormatter.date(from: startTimeString) else {
            throw DecodingError.dataCorruptedError(forKey: .startTime, in: container, debugDescription: "Start time string does not match format expected by formatter.")
        }
        self.startTime = startTime
        
        let endTimeString = try container.decode(String.self, forKey: .endTime)
        guard let endTime = dateFormatter.date(from: endTimeString) else {
            throw DecodingError.dataCorruptedError(forKey: .endTime, in: container, debugDescription: "End time string does not match format expected by formatter.")
        }
        self.endTime = endTime
        
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

