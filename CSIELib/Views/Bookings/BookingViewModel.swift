//
//  BookingViewModel.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/20.
//

import Foundation
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class BookingViewModel: ObservableObject {
    @Published var bookings = [Booking]()
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func fetchBookingsForDateAndSeat(_ date: Date, _ seat: Seat) {
        listenerRegistration?.remove()
        listenerRegistration = db.collection("bookings")
            .whereField("date", isEqualTo: date)
            .whereField("seat.id", isEqualTo: seat.id)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.bookings = documents.compactMap { (queryDocumentSnapshot) -> Booking? in
                    return try? queryDocumentSnapshot.data(as: Booking.self)
                }
            }
    }
    
    func fetchUserBookings() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        listenerRegistration?.remove()
        listenerRegistration = db.collection("students").document(uid).collection("bookings")
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.bookings = documents.compactMap { (queryDocumentSnapshot) -> Booking? in
                    return try? queryDocumentSnapshot.data(as: Booking.self)
                }
            }
    }
}

