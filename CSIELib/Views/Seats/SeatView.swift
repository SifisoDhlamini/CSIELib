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
    @StateObject private var viewModel = BookingViewModel()
    @State private var bookings: [Booking] = []
    @State private var selectedSeat: Seat? // Add this state variable to keep track of the selected seat
    @State private var isLinkActive: Bool = false // Add this state variable to control the NavigationLink
    @State private var studentNumber: String = ""
    @State var err = ""
    
    var body: some View {
       
        
        NavigationView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(rowSeats.seats.indices, id: \.self) { index in
                    let seat = rowSeats.seats[index]
                    
                    Button(action: {
                        handleSeatSelection(seat)
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
                            destination: BookingPageView(seat: seat, date: date, studentNumber: studentNumber),
                            isActive: $isLinkActive,
                            label: { EmptyView() }
                        )
                    )
                    .onAppear(perform: fetchStudentNumber)
                }
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
    func fetchStudentNumber() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                self.studentNumber = document.data()?["studentNumber"] as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func handleSeatSelection(_ seat: Seat) {
        self.selectedSeat = seat
        self.isLinkActive = true
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
