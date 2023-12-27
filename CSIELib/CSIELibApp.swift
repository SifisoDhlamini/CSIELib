//
//  CSIELibApp.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/19.
//

import SwiftUI
import Firebase
import GoogleSignIn

class ViewModelManager: ObservableObject {
    @Published var bookingViewModel = BookingViewModel()
    
    
}


class ViewRouter: ObservableObject {
    @Published var currentPage: String
    @Published var isBookingsListActive: Bool = false
    init(currentPage: String = "home") {
        self.currentPage = currentPage
    }
}

@main
struct CSIELibApp: App {
    @StateObject private var viewModelManager = ViewModelManager()
    @StateObject var viewRouter = ViewRouter()
    init() {
            // Firebase initialization
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModelManager)
                .environmentObject(viewRouter)
                .onOpenURL { url in
                        //Handle Google Oauth URL
                    GIDSignIn.sharedInstance.handle(url)
                }
        }  
    }
}
