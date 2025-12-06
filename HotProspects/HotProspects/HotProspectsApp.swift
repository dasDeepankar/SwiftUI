//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Deepankar Das on 29/11/25.
//

import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Prospect.self)
    }
}
