//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Archael dela Rosa on 5/4/23.
//

import SwiftUI

@main
struct FitnessAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
