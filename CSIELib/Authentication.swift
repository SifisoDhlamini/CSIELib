    //
    //  Authentication.swift
    //  CSIELib
    //
    //  Created by Sifiso Dhlamini on 2023/12/19.
    //

import Foundation
import Firebase
import GoogleSignIn

struct Authentication {
    func googleOauth() async throws {
            // google sign in
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("no firbase clientID found")
        }
        
            // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
            //get rootView
        DispatchQueue.main.async {
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let rootViewController = scene?.windows.first?.rootViewController
            else {
                fatalError("There is no root view controller!")
            }
            
                //google sign in authentication response
            Task {
                do {
                    let result = try await GIDSignIn.sharedInstance.signIn(
                        withPresenting: rootViewController
                    )
                    let user = result.user
                    guard let idToken = user.idToken?.tokenString else {
                        throw "Unexpected error occurred, please retry"
                    }
                    
                        //Firebase auth
                    let credential = GoogleAuthProvider.credential(
                        withIDToken: idToken, accessToken: user.accessToken.tokenString
                    )
                    try await Auth.auth().signIn(with: credential)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func logout() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
}


extension String: Error {}
