//
//  WelcomeUI.swift
//  FInTrack
//
//  Created by Karan Khullar on 06/10/24.
//

import SwiftUI

struct WelcomeUI: View {
    
    @Binding var shouldShowDashBoard: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Image("Welcome")
                    .resizable()
                    .scaledToFit()
                    .padding([.leading, .trailing, .top], 20)
                //Title
                Text(UIStrings.welcomeTitle)
                    .padding([.leading, .trailing, .top], 20)
                    .font(.largeTitle)
                // Description
                Text(UIStrings.welcomeDecription)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 8)
                    .font(.subheadline)
                Spacer()
                Button {
                    withAnimation {
                        self.shouldShowDashBoard = true
                    }
                    UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.welcomeScreen)
                } label: {
                    Text(UIStrings.getStarted)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("Primary"))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
                .padding()
                Spacer()
                
            }
        }
    }
}

#Preview {
    WelcomeUI(shouldShowDashBoard: .constant(false))
}
