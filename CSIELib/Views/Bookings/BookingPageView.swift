//
//  BookingPageView.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/22.
//

import SwiftUI

struct BookingPageView: View {
    let date: Date
    
    var body: some View {
            // Your booking page implementation using the selected date
        Text("Booking Page for \(date, style: .date)")
    }
}

#Preview {
    BookingPageView(date:Date())
}
