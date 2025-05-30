//
//  JibunApp.swift
//  Jibun
//
//  Created by Rahul on 29/05/25.
//

import SwiftUI

@main
struct JibunApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
