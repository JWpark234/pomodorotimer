//
//  pomotimerApp.swift
//  pomotimer
//
//  Created by Jinwoo Park on 2024/01/10.
//

import SwiftUI
import SwiftData


@main
struct pomotimerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }() // ignore this shit

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    // App will resign active (e.g., goes to the background)
                    // Perform necessary tasks
                }
                .onChange(of: scenePhase) { _, newScenePhase in
                    if newScenePhase == .background || newScenePhase == .inactive {
                        // App goes to the background or enters inactive state (e.g., switching to another app)
                        
                    } else if newScenePhase == .active {
                        // App becomes active (e.g., coming back from another app)
                        
                    }
                 }
        }
        .modelContainer(sharedModelContainer)
    }
}



