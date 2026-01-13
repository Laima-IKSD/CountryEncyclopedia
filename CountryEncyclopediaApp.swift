//
//  CountryEncyclopediaApp.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 08/01/2026.
//


import SwiftUI

@main
struct CountryEncyclopediaApp: App {
    @StateObject private var store = CountryStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .tint(.indigo)
        }
    }
}
