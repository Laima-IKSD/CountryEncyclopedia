//
//  FavoriteToggle.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 09/01/2026.
//


import SwiftUI

struct FavoriteToggle: View {
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "star")
                .foregroundStyle(.yellow)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isOn ? "Noņemt no favorītiem" : "Pievienot favorītiem")
    }
}

