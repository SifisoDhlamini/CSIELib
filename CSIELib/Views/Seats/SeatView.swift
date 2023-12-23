//
//  SeatView.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/23.
//

import SwiftUI

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}

struct SeatView: View {
    let date: Date
    let rowSeats: RowSeats
    @StateObject private var viewModel = BookingViewModel();    
    @State private var bookings: [Booking] = [] // You'll need to fetch the bookings for the selected date and row
    
    var body: some View {
            // Define the grid columns
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        LazyVGrid(columns: columns) {
            ForEach(0..<rowSeats.seats.count, id: \.self) { index in
                let seat = rowSeats.seats[index]
                let booking = bookings.first(where: { $0.seat.id == seat.id })
                let isBooked = booking != nil
                let isAvailable = !isBooked && isWithinWorkingHours(booking?.startTime, booking?.endTime)
                
                Button(action: {
                        // Handle seat selection
                    if isAvailable {
                        handleSeatSelection(seat)
                    }
                }) {
                    Text("Seat \(seat.seatNum)")
                        .frame(width: 100, height: 100)
                        .background(isAvailable ? Color.green : Color.red)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
        .onAppear {
                // Fetch the bookings for the selected date and row
            fetchBookings()
        }
    }
    
    func isWithinWorkingHours(_ startTime: Date?, _ endTime: Date?) -> Bool {
        guard let startTime = startTime, let endTime = endTime else { return false }
        let calendar = Calendar.current
        let startHour = calendar.component(.hour, from: startTime)
        let endHour = calendar.component(.hour, from: endTime)
        return startHour >= 8 && endHour <= 17
    }
    
    func fetchBookings() {
        viewModel.fetchBookingsForDateAndSeat(date, rowSeats.seats.first!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            bookings = viewModel.bookings.filter { booking in
                booking.date >= date.startOfDay && booking.date < date.endOfDay && rowSeats.seats.contains(where: { $0.id == booking.seat.id })
            }
        }
    }
    
    func handleSeatSelection(_ seat: Seat) {
            // Implement your logic to handle the seat selection
    }
}




#Preview {
        // Create some dummy seats
    Group {
        //SeatView(date: Date(), rowSeats: RowSeats(row: .window))
        //SeatView(date: Date(), rowSeats: RowSeats(row: .middle))
        SeatView(date: Date(), rowSeats: RowSeats(row: .cubicle))
    }
}
