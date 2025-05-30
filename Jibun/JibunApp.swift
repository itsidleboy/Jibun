//
//  JibunApp.swift
//  Jibun
//
//  Created by Rahul on 29/05/25.
//

import SwiftUI

@main
struct JibunApp: App {
    @StateObject private var dataManager = DataManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }
    }
}
