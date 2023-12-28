    //
    //  BookingListView.swift
    //  CSIELib
    //
    //  Created by Sifiso Dhlamini on 2023/12/20.
    //

import SwiftUI

struct BookingListView: View {
    @EnvironmentObject var viewModelManager: ViewModelManager
    
    var body: some View {
        List(viewModelManager.bookingViewModel.bookings) { booking in
            NavigationLink(destination: BookingDetailView(booking: booking)) {
                VStack(alignment: .leading) {
                    Text("Date: \(booking.date, formatter: dateFormatter)")
                }
            }
        }
        .navigationTitle("Bookings")
        .onAppear {
            viewModelManager.bookingViewModel.fetchUserBookings()
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
        List {
            Section(header: Text("Booking Details")) {
                HStack {
                    Text("Start Time:")
                    Spacer()
                    Text("\(booking.startTime, formatter: timeFormatter)")
                }
                
                HStack {
                    Text("End Time:")
                    Spacer()
                    Text("\(booking.endTime, formatter: timeFormatter)")
                }
                
                HStack {
                    Text("Selected Seat:")
                    Spacer()
                    Text("Seat \(booking.seat.seatNum)")
                }
            }
        }
        .navigationTitle("Booking Details")
    }
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}



#Preview {
    BookingListView()
}
