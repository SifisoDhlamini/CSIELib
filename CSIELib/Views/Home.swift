    //
    //  Home.swift
    //  CSIELib
    //
    //  Created by Sifiso Dhlamini on 2023/12/19.
    //

import SwiftUI
import Firebase
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
    
        // Function to get the dates for the current week
    private func getDatesForCurrentWeek() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        let startDate = calendar.date(byAdding: .day, value: 2 - weekday, to: today)!
        return (0..<5).map { calendar.date(byAdding: .day, value: $0, to: startDate)! }
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
                            NavigationLink(
                                destination: BookingPageView(date: date),
                                label: {
                                    HStack {
                                        Spacer()
                                        Text(date, formatter: DateFormatter.dayOfWeekFormatter)
                                            .foregroundColor(date < Date() ? .primary : .gray)
                                            .frame(width: 100, alignment: .leading)
                                        Text(date, style: .date)
                                            .font(.headline)
                                            .foregroundColor(date < Date() ? .primary : .gray)
                                            .opacity(date < Date() ? 0.5 : 1.0)
                                        Spacer()
                                    }
                                    
                                }
                            )
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
                .navigationTitle("Make a booking")
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
