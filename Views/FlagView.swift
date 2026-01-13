//
//  FlagView.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 09/01/2026.
//

import SwiftUI

struct FlagView: View {
    let cca2: String

    var body: some View {
        AsyncImage(url: URL(string: "https://flagsapi.com/\(cca2)/flat/160.png")) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFit().frame(height: 100)
            case .failure(_):
                Text(emojiFlag(cca2: cca2)).font(.system(size: 64))
            case .empty:
                ProgressView()
            @unknown default:
                EmptyView()
            }
        }
    }

    private func emojiFlag(cca2: String) -> String {
        let base: UInt32 = 0x1F1E6
        return String(cca2.uppercased().unicodeScalars.map {
            Character(UnicodeScalar(base + ($0.value - 65))!)
        })
    }
}
