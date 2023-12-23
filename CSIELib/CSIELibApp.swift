//
//  CSIELibApp.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/19.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct CSIELibApp: App {
    init() {
            // Firebase initialization
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL { url in
                    //Handle Google Oauth URL
                GIDSignIn.sharedInstance.handle(url)
            }
        }  
    }
}
