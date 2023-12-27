//
//  CSIELibApp.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/19.
//

import SwiftUI
import Firebase
import GoogleSignIn

class ViewRouter: ObservableObject {
    @Published var currentPage: String
    init(currentPage: String = "home") {
        self.currentPage = currentPage
    }
}

@main
struct CSIELibApp: App {
    @StateObject var viewRouter = ViewRouter()
    init() {
            // Firebase initialization
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewRouter)
                .onOpenURL { url in
                    //Handle Google Oauth URL
                GIDSignIn.sharedInstance.handle(url)
            }
        }  
    }
}
