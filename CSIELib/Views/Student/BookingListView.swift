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
        NavigationView {
            List(viewModelManager.bookingViewModel.bookings) { booking in
                NavigationLink(destination: BookingDetailView(booking: booking)) {
                    
                    VStack(alignment: .leading) {
                        Text("Date: \(booking.date, formatter: dateFormatter)")
                    }
                }
            }
            .navigationTitle("Bookings")
        }
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
        NavigationView {
            List {
                    // Add details based on the booking, if needed
            }
            .navigationTitle("Booking Details")
        }
    }
}



#Preview {
    BookingListView()
}
