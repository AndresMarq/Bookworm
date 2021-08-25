//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Andres Marquez on 2021-07-15.
//

import SwiftUI

@main
struct BookwormApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
        .onChange(of: scenePhase) {(newScenePhase) in
            switch newScenePhase {
            case.background:
                print("Scene is in background")
                persistenceController.save()
            case.inactive:
                print("Scene is inactive")
            case.active:
                print("Scene is active")
            @unknown default:
                print("Apple must have changed something")
            }
        }
    }
}
