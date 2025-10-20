//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Deepankar Das on 13/10/25.
//
import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Book.self)
    }
}
