//
//  BookingListView.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/20.
//

import SwiftUI

struct BookingListView: View {
    @ObservedObject var viewModel = BookingViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.bookings) { booking in
                NavigationLink(destination: BookingDetailView(booking: booking)) {
                    VStack(alignment: .leading) {
                        Text("Date: \(booking.date, formatter: dateFormatter)")
                    }
                }
            }
            .navigationTitle("Bookings")
            .onAppear {
                viewModel.fetchUserBookings()
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

struct BookingDetailView: View {
    var booking: Booking
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Date: \(booking.date, formatter: dateFormatter)")
            Text("Start Time: \(booking.startTime, formatter: timeFormatter)")
            Text("End Time: \(booking.endTime, formatter: timeFormatter)")
            Text("Duration: \(booking.duration) hours")
            Text("Seat Number: \(booking.seat.seatNum)")
            Text("Row: \(booking.seat.row.rawValue.capitalized)")
        }
        .navigationTitle("Booking Details")
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}


#Preview {
    BookingListView()
}
