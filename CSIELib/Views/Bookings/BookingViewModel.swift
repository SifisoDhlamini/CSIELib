    //
    //  BookingViewModel.swift
    //  CSIELib
    //
    //  Created by Sifiso Dhlamini on 2023/12/20.
    //

import SwiftUI
import Foundation
import Firebase

class BookingViewModel: ObservableObject {
    @Published var booking: Booking? = nil
    @Published var bookings: [Booking] = []
    @Published var error: Error?
    @Published var seats: [Seat] = [] // Initialize with your seats
    @Published var selectedSeat: Seat?
    @Published var studentNumber: String = ""

    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func selectSeat(_ seat: Seat) {
        if let index = seats.firstIndex(where: { $0.id == seat.id }) {
            self.seats[index].booked = true
            self.selectedSeat = seats[index]
        }
    }
    
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
    
    func fetchStudentNumber() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
       // print(userID)
        db.collection("students").document(userID).getDocument { [self] (document, error) in
            //print(document ?? "Could not fetch document")
            if let error = error {
                print("Error getting document: \(error)")
                self.error = error
            } else if let document = document, document.exists {
                print(document.data()?["studentNum"] as? String ?? "")
                self.studentNumber = document.data()?["studentNum"] as? String ?? ""
                print(studentNumber)
                //self.viewModelManager.bookingViewModel.studentNumber = self.studentNumber
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func fetchUserBookings() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        self.listenerRegistration?.remove()
        self.listenerRegistration = self.db.collection("students").document(userID)
            .addSnapshotListener { [self] (documentSnapshot, error) in
                print("Inside snapshot listener")
                if let error = error {
                    print("Error getting document: \(error)")
                    self.error = error
                } else {
                    guard let document = documentSnapshot, document.exists,
                          let bookingsData = document.data()?["bookings"] as? [[String: Any]] else {
                        print("No bookings")
                        return
                    }
                    
                    print("Number of bookings: \(bookingsData.count)")
                    
                    self.bookings = bookingsData.compactMap { (bookingData) -> Booking? in
                        do {
                                // Convert the dictionary to a Booking
                            let booking = try Firestore.Decoder().decode(Booking.self, from: bookingData)
                            return booking
                        } catch let error {
                            print("Error decoding booking: \(error)")
                            return nil
                        }
                    }
                    
                    print("Fetched \(self.bookings.count) bookings")
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
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        do {
            let studentDocument = db.collection("students").document(userID)
            
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

