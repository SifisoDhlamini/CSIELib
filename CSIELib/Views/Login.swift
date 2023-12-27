//
//  Login.swift
//  CSIELib
//
//  Created by Sifiso Dhlamini on 2023/12/19.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct Login: View {
    @StateObject private var viewModelManager = ViewModelManager()
    @State private var err : String = ""
    
    var body: some View {
        ZStack{
            Image(.verticalLibrary)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.3)
            VStack{
                Image(.csiElogo2Removebg)
                    .shadow(
                        color: .primary,
                        radius: CGFloat(10),
                        x: CGFloat(5), y: CGFloat(10))
                Text("CSIE Library")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(Color.primary)
                Button{
                    Task {
                        do {
                            var auth = Authentication()
                            self.err = try await auth.googleOauth()
                        } catch {
                                // Handle other potential errors here
                            self.err = error.localizedDescription
                        }
                    }
                }label: {
                    HStack {
                        Image(systemName: "person.badge.key.fill")
                        Text("Sign in with Google")
                    }.padding(8)
                }.buttonStyle(.borderedProminent)
                
                Text(err).foregroundColor(.red).font(.caption)
            }
        }
    }
}


#Preview {
    Login()
}
