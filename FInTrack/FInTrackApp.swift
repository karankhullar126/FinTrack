//
//  FInTrackApp.swift
//  FInTrack
//
//  Created by Karan Khullar on 06/10/24.
//

import SwiftUI
import SwiftData

@main
struct FInTrackApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Category.self,
            Transaction.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State var shouldShowDashboard: Bool = UserDefaults.standard.bool(forKey: UserDefaultKeys.welcomeScreen)

    var body: some Scene {
        WindowGroup {
            if shouldShowDashboard {
                MainLandingView()
            } else {
                WelcomeUI(shouldShowDashBoard: self.$shouldShowDashboard)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
