//
//  ContentView.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/19.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    
    var body: some View {
        VStack {
            switch viewRouter.currentPage {
                case "home":
                    if userLoggedIn {
                        Home()
                    } else {
                        Login()
                    }
                case "booking":
                    BookingListView()
                        // Add more cases as needed
                default:
                    if userLoggedIn {
                        Home()
                    } else {
                        Login()
                    }
            }
        }.onAppear{
                //Firebase state change listener
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
