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
    
    @EnvironmentObject var viewModelManager: ViewModelManager
    @StateObject private var viewModel = BookingViewModel()
    @State private var availableSlots: [TimeSlot] = []
    @State private var selectedSlots: [TimeSlot] = []
    @State private var studentNumber: String = ""
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        NavigationStack {
            List(availableSlots, id: \.self) { slot in
                Button(action: {
                    handleSlotSelection(slot)
                }) {
                    Text(slot.displayString)
                        .foregroundColor(selectedSlots.contains(slot) ? .white : .black)
                        .background(selectedSlots.contains(slot) ? Color.blue : Color.clear)
                }
            }
        }
        .navigationBarItems(trailing: HStack {
            Button("Submit") {
                submitBooking()
            }
            
            NavigationLink(
                destination: BookingListView().environmentObject(viewModelManager), // Replace with the actual destination view
                isActive: $viewRouter.isBookingsListActive,
                label: {
                    EmptyView()
                }
            )
        })
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
            let booking = Booking(date: date, startTime: slot.start, endTime: slot.end, duration: Int(slot.end.timeIntervalSince(slot.start)), seat: seat, studentNumber: viewModelManager.bookingViewModel.studentNumber)
            viewModelManager.bookingViewModel.createUserBooking(booking)
        }
            // Redirect to BookingViewList Page
            // Set the isBookingsListActive to true to trigger NavigationLink
        self.viewRouter.isBookingsListActive = true
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





#Preview {
    let seat = Seat(seatNum: 1, row: .window, booked: false)
    return BookingPageView(seat: seat, date: Date())
}
