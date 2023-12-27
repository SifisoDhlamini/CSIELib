//
//  ContentView.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/19.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var viewModelManager: ViewModelManager
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    
    var body: some View {
        VStack {
            switch viewRouter.currentPage {
                case "home":
                    if userLoggedIn {
                        Home()
                            .environmentObject(viewModelManager)
                    } else {
                        Login()
                            .environmentObject(viewModelManager)
                    }
                case "booking":
                    BookingListView()
                        .environmentObject(viewModelManager)
                default:
                    if userLoggedIn {
                        Home()
                            .environmentObject(viewModelManager)
                    } else {
                        Login()
                            .environmentObject(viewModelManager)
                    }
            }
        }.onAppear{
            viewModelManager.bookingViewModel.fetchStudentNumber()
            Auth.auth().addStateDidChangeListener{ auth, user in
                if (user != nil) {
                    userLoggedIn = true
                } else {
                    userLoggedIn = false
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
