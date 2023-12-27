//
//  SeatView.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/23.
//

import SwiftUI
import Firebase

struct SeatView: View {
    let date: Date
    let rowSeats: RowSeats
    @EnvironmentObject var viewModelManager: ViewModelManager
    //@StateObject private var viewModel = BookingViewModel()
    @State private var bookings: [Booking] = []
    @State private var selectedSeat: Seat?
    @State private var isLinkActive: Bool = false
    @State var err = ""
    
    var body: some View {
        NavigationView{
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(Array(rowSeats.seats.enumerated()), id: \.offset) { index, seat in
                    Button(action: {
                        viewModelManager.bookingViewModel.selectSeat(seat)
                        isLinkActive = true
                    }) {
                        Text("Seat \(seat.seatNum)")
                            .frame(width: 100, height: 100)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    .background(
                        NavigationLink(
                            destination: BookingPageView(seat: seat, date: date).environmentObject(viewModelManager),
                            isActive: $isLinkActive,
                            label: { EmptyView() }
                        )
                    )
                }
            }
            //.onAppear(perform: viewModelManager.bookingViewModel.fetchStudentNumber)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        do {
                            try await Authentication().logout()
                        } catch let e {
                            err = e.localizedDescription
                        }
                    }
                }) {
                    Text("Logout")
                }
            }
        }
    }
}






#Preview {
        // Create some dummy seats
    Group {
            //        SeatView(date: Date(), rowSeats: RowSeats(row: .window))
            //        SeatView(date: Date(), rowSeats: RowSeats(row: .middle))
        SeatView(date: Date(), rowSeats: RowSeats(row: .cubicle))
    }
}
