//
//  BookingPageView.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/22.
//

import SwiftUI

struct BookingPageView: View {
    let seat: Seat
    let date: Date
    let studentNumber: String // Assuming you have the student number
    @StateObject private var viewModel = BookingViewModel()
    @State private var availableSlots: [TimeSlot] = []
    @State private var selectedSlots: [TimeSlot] = []
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        NavigationView{
            List(availableSlots, id: \.self) { slot in
                Button(action: {
                    handleSlotSelection(slot)
                }) {
                    Text(slot.displayString)
                        .foregroundColor(selectedSlots.contains(slot) ? .white : .black)
                        .background(selectedSlots.contains(slot) ? Color.blue : Color.clear)
                }
            }            
            .navigationBarItems(trailing: Button("Submit") {
                submitBooking()
            })
        }
        .onAppear {
            fetchAvailableSlots()
        }
    }
    
    
    func handleSlotSelection(_ slot: TimeSlot) {
        if selectedSlots.contains(slot) {
            selectedSlots.removeAll(where: { $0 == slot })
        } else if selectedSlots.count < 6 {
            if selectedSlots.isEmpty || (slot.start == selectedSlots.last!.end) {
                selectedSlots.append(slot)
            }
        }
    }
    
    func submitBooking() {
        for slot in selectedSlots {
            let booking = Booking(date: date, startTime: slot.start, endTime: slot.end, duration: Int(slot.end.timeIntervalSince(slot.start)), seat: seat)
            viewModel.createUserBooking(booking)

        }
            // Redirect to BookingViewList Page
        self.viewRouter.currentPage = "home"
    }
    
    func fetchAvailableSlots() {
        viewModel.fetchBookingsForDateAndSeat(date, seat)
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        var time = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: startOfDay)!
        let endOfDay = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: startOfDay)!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let bookingsForTheDay = viewModel.bookings.filter { booking in
                booking.date >= startOfDay && booking.date < endOfDay && booking.seat.id == seat.id
            }
            
            while time < endOfDay {
                let end = calendar.date(byAdding: .minute, value: 30, to: time)!
                if !bookingsForTheDay.contains(where: { $0.startTime < end && $0.endTime > time }) {
                    availableSlots.append(TimeSlot(start: time, end: end))
                }
                time = end
            }
        }
    }
}

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




#Preview {
    let seat = Seat(seatNum: 1, row: .window, booked: false)
    return BookingPageView(seat: seat, date: Date(), studentNumber: "410921334")
}
