//
//  RowView.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/23.
//

import SwiftUI

struct RowView: View {
    @EnvironmentObject var viewModelManager: ViewModelManager
    let date: Date
    
    var body: some View {
            // Create RowSeats instances for each row type
        let windowRowSeats = RowSeats(row: .window)
        let middleRowSeats = RowSeats(row: .middle)
        let cubicleRowSeats = RowSeats(row: .cubicle)
        
       
        
        NavigationView{
            VStack {
                NavigationLink(destination: SeatView(date: date, rowSeats: windowRowSeats).environmentObject(viewModelManager)) {
                    Section{
                        Text("Window Row")
                            .font(.title)
                        Image(.windowSeat)
                            .resizable()
                            .scaledToFit()
                    }
                }
                Divider()
                NavigationLink(destination: SeatView(date: date, rowSeats: middleRowSeats).environmentObject(viewModelManager)) {
                    Section{
                        Text("Middle Row")
                            .font(.title)
                        Image(.centerBarstool)
                            .resizable()
                            .scaledToFit()
                    }
                }
                Divider()
                NavigationLink(destination: SeatView(date: date, rowSeats: cubicleRowSeats).environmentObject(viewModelManager)) {
                    Section{
                        Text("Cubicles Row")
                            .font(.title)
                        Image(.entranceCubicles)
                            .resizable()
                            .scaledToFit()
                    }
                }
                
                //RowNavigation()
                
            }
            .navigationTitle("Select Row")
        }
    }
}

struct RowNavigation: View {
    var body: some View {
        Text("view")
    }
}


#Preview {
    RowView(date: Date())
}
