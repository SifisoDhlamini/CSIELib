    //
    //  Authentication.swift
    //  CSIELib
    //
    //  Created by Sifiso Dhlamini on 2023/12/19.
    //

import Foundation
import Firebase
import GoogleSignIn
import SwiftUI

struct Authentication {
    var err: String?
    
    enum AuthenticationError: Error {
        case userNotAuthorized
        case userNotCSIE
        case firebaseClientIDNotFound
        case rootViewControllerNotFound
        case unexpectedErrorOccurred
    }
    
    mutating func googleOauth() async throws -> String {
        self.err = nil
            // Google sign in
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthenticationError.firebaseClientIDNotFound
        }
        
            // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
            // Get rootView
        let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = await scene?.windows.first?.rootViewController else {
            throw AuthenticationError.rootViewControllerNotFound
        }
        
            // Google sign in authentication response
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = result.user
            guard let idToken = user.idToken?.tokenString else {
                throw AuthenticationError.unexpectedErrorOccurred
            }
            
                // Check if the email is a valid school email
            guard user.profile?.email.hasSuffix("@gms.ndhu.edu.tw") == true else {
                throw AuthenticationError.userNotAuthorized
            }
            
                // Extract student number from email
            let email = user.profile?.email ?? ""
            let studentNum = String(email.prefix(while: { $0 != "@" }))
            
                
            
                // Check if user exists in csie_students collection
            let db = Firestore.firestore()
            let docRef = db.collection("csie_students").document("studentNumbers")
            let doc = try await docRef.getDocument()
            guard let studentNumbers = doc.get("studentNumber") as? [String], studentNumbers.contains(studentNum) else {
                throw AuthenticationError.userNotCSIE
            }
            
                // Firebase auth
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            let authResult = try await Auth.auth().signIn(with: credential)
            
                // Set err to "Logged in successfully" here
            self.err = "Logged in successfully"
    
            
            let student: [String: Any] = [
                "uid": authResult.user.uid,
                "displayName": authResult.user.displayName ?? "",
                "email": email,
                "studentNum": studentNum,
                "dailyLimit": [
                    "lastBookedDate": Timestamp(date: Date()),
                    "totalHours": 0
                ],
                "weeklyLimit": [
                    "weekStartDate": Timestamp(date: Date()),
                    "totalHours": 0
                ],
                "bookings": [] // Initialize bookings as an empty array
            ]
            try await db.collection("students").document(authResult.user.uid).setData(student)
        } catch {
            if let authError = error as? Authentication.AuthenticationError {
                switch authError {
                    case .userNotCSIE:
                        self.err = "You are not a CSIE student"
                    case .userNotAuthorized:
                        self.err = "Please enter a valid school email"
                    default:
                        self.err = error.localizedDescription
                }
            } else {
                self.err = error.localizedDescription
            }
        }
        print(err ?? "Something went wrong")
        return err ?? "Something went wrong"
    }

    func logout() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
}



extension String: Error {}

