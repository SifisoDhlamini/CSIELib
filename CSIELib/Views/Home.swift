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
    @EnvironmentObject var viewModelManager: ViewModelManager
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
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(getDatesForCurrentWeek(), id: \.self) { date in
                    let calendar = Calendar.current
                    let today = calendar.startOfDay(for: Date())
                    
                    if date <= today {
                        HStack {
                            Spacer()
                            Text(date, formatter: DateFormatter.dayOfWeekFormatter)
                                .frame(width: 100, alignment: .leading)
                            Divider()
                            Text(date, style: .date)
                                .font(.headline)
                            Spacer()
                        }
                        .opacity(0.5)
                    } else {
                        NavigationLink(
                            destination: RowView(date: date).environmentObject(viewModelManager),
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
                    NavigationLink(
                        destination: BookingListView().environmentObject(viewModelManager),
                        label: {
                            Text("View Current Bookings")
                                .foregroundColor(.blue)
                                .font(.headline)
                        }
                    )
                }
                .onAppear {
                    viewModelManager.bookingViewModel.fetchUserBookings()
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
            Home()
                .environment(\.locale, .init(identifier: "en"))
                .previewDisplayName("Home Preview")
        }   
    }
}

#Preview {
    Home()
}
