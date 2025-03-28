//
//  ExperimentingWithMVVMApp.swift
//  ExperimentingWithMVVM
//
//  Created by Conner Yoon on 3/17/25.
//

import SwiftUI
import SwiftData

@main
struct ExperimentingWithMVVMApp: App {
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
    }()
    @StateObject var vm = Library()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LibraryView(library: vm)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
