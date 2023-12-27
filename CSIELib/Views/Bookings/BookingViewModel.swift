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
    @Published var booking: Booking? = nil
    @Published var bookings: [Booking] = []
    @Published var error: Error?
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func fetchBookingsForDateAndSeat(_ date: Date, _ seat: Seat) {
        listenerRegistration?.remove()
        listenerRegistration = db.collection("bookings")
            .whereField("date", isEqualTo: date)
            .whereField("seat.id", isEqualTo: seat.id)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    self.error = error
                } else {
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
    
    func fetchUserBookings() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        listenerRegistration?.remove()
        listenerRegistration = db.collection("students").document(uid).collection("bookings")
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    self.error = error
                } else {
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
    
    func createBooking(_ booking: Booking) {
        do {
            let _ = try db.collection("bookings").addDocument(from: booking)
        } catch let error {
            print("Error writing booking to Firestore: \(error)")
            self.error = error
        }
    }
    
    func createUserBooking(_ booking: Booking) {
        createBooking(booking)
        guard let email = Auth.auth().currentUser?.email else {
            print("User not logged in")
            return
        }
        
            // Assuming the student number is the part before "@" in the email
        let studentNumber = String(email.split(separator: "@")[0])
        
        do {
            let studentDocument = db.collection("students").document(studentNumber)
            
                // Convert the booking to a dictionary
            let bookingData = try booking.asDictionary()
            
                // Add the booking to the "bookings" array in the student document
            studentDocument.updateData([
                "bookings": FieldValue.arrayUnion([bookingData])
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                }
            }
        } catch let error {
            print("Error writing booking to Firestore: \(error)")
            self.error = error
        }
    }


}

extension Booking {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

