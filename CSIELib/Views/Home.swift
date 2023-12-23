    //
    //  Home.swift
    //  CSIELib
    //
    //  Created by Sifiso Dhlamini on 2023/12/19.
    //

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

extension DateFormatter {
    static var dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // "EEEE" represents the full day of the week
        return formatter
    }()
}

struct Home: View {
    @State private var err: String = ""
    @State private var selectedDate: Date?
    @State private var bookingsForWeek: [Date: [Booking]] = [:]
    
        // Function to get the dates for the current week
    private func getDatesForCurrentWeek() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        let startDate = calendar.date(byAdding: .day, value: 2 - weekday, to: today)!
        return (0..<5).map { calendar.date(byAdding: .day, value: $0, to: startDate)! }
    }
    
    func fetchBookings(for date: Date) async throws -> [Booking] {
        let db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.string(from: date)
        
        let docRef = db.collection("bookings").whereField("date", isEqualTo: dateString)
        let snapshot = try await docRef.getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: Booking.self) }
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image(.verticalLibrary)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.3)
                
                VStack {
                    List {
                        ForEach(getDatesForCurrentWeek(), id: \.self) { date in
                            let bookingsForDate = bookingsForWeek[date] ?? []
                            let allSeatsBooked = bookingsForDate.allSatisfy { $0.seat.booked }
                            
//                            if date < Date() || allSeatsBooked {
//                                HStack {
//                                    Spacer()
//                                    Text(date, formatter: DateFormatter.dayOfWeekFormatter)
//                                        .frame(width: 100, alignment: .leading)
//                                    Divider()
//                                    Text(date, style: .date)
//                                        .font(.headline)
//                                    Spacer()
//                                }
//                                .opacity(0.5)
//                            } else {
                                NavigationLink(
                                    destination: RowView(date: date),
                                    label: {
                                        HStack {
                                            Spacer()
                                            Text(date, formatter: DateFormatter.dayOfWeekFormatter)
                                                .frame(width: 100, alignment: .leading)
                                            Divider()
                                            Text(date, style: .date)
                                                .font(.headline)
                                            Spacer()
                                        }
                                    }
                                )
                            //}
                        }
                    }
                    
                    NavigationLink(
                        destination: BookingListView(),
                        label: {
                            Text("View Current Bookings")
                                .foregroundColor(.blue)
                                .font(.headline)
                        }
                    )
                }
                .frame(width: 400, height: 300)
                .background(Color.clear)
            }
            .navigationTitle("CSIELib")
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
        .alert(isPresented: Binding<Bool>(
            get: { !$err.wrappedValue.isEmpty },
            set: { if !$0 { $err.wrappedValue = "" } }
        )) {
            Alert(title: Text("Error"), message: Text(err), dismissButton: .default(Text("OK")))
        }
        .task {
            do {
                for date in getDatesForCurrentWeek() {
                    bookingsForWeek[date] = try await fetchBookings(for: date)
                }
            } catch {
                err = "Something went wrong with fetching the bookings: \(error)"
            }
        }
    }
}


#Preview {
    Home()
        .environment(\.locale, .init(identifier: "en"))
        .previewDisplayName("Home Preview")
}

    //                HStack {
    //                    Image(systemName: "hand.wave.fill")
    //                    if let displayName = Auth.auth().currentUser?.displayName {
    //                        Text("Hello " + displayName)
    //                    } else {
    //                        Text("Hello Username not found")
    //                    }
    //                }
    //                Button{
    //                    if Auth.auth().currentUser != nil {
    //                        Task {
    //                            do {
    //                                try await Authentication().logout()
    //                            } catch let e {
    //                                err = e.localizedDescription
    //                            }
    //                        }
    //                    } else {
    //                            // Handle the case where there is no user signed in
    //                        err = "No user signed in"
    //                    }
    //                }label: {
    //                    Text("Log Out").padding(8)
    //                }.buttonStyle(.borderedProminent)
