//
//  ContentView.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/19.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    
    var body: some View {
        VStack {
            if userLoggedIn {
                Home()
            } else {
                Login()
            }
        }.onAppear{
                //Firebase state change listeneer
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
