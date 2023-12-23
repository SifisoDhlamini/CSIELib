//
//  RowView.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/23.
//

import SwiftUI

struct RowView: View {
    let date: Date
    
    var body: some View {
            // Create RowSeats instances for each row type
        let windowRowSeats = RowSeats(row: .window)
        let middleRowSeats = RowSeats(row: .middle)
        let cubicleRowSeats = RowSeats(row: .cubicle)
        
        NavigationView{
            VStack {
                NavigationLink(destination: SeatView(date: date, rowSeats: windowRowSeats)) {
                    Section{
                        Text("Window Row")
                            .font(.title)
                        Image(.windowSeat)
                            .resizable()
                            .scaledToFit()
                    }
                }
                Divider()
                NavigationLink(destination: SeatView(date: date, rowSeats: middleRowSeats)) {
                    Section{
                        Text("Middle Row")
                            .font(.title)
                        Image(.centerBarstool)
                            .resizable()
                            .scaledToFit()
                    }
                }
                Divider()
                NavigationLink(destination: SeatView(date: date, rowSeats: cubicleRowSeats)) {
                    Section{
                        Text("Cubicles Row")
                            .font(.title)
                        Image(.entranceCubicles)
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            .navigationTitle("Select Row")
        }
    }
}


#Preview {
    RowView(date: Date())
}
