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
//                    .shadow(
//                        color: .primary,
//                        radius: CGFloat(10),
//                        x: CGFloat(5), y: CGFloat(10))
                Button{
                    Task {
                        do {
                            try await Authentication().googleOauth()
                        } catch let e {
                            print(e)
                            err = e.localizedDescription
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
