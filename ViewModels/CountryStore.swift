//
//  CountryStore.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 08/01/2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class CountryStore: ObservableObject {
    @Published var all: [Country] = []
    @Published var searchText: String = ""

    // Glabā favorītus @AppStorage kā JSON string (nevis [String])
    @AppStorage("favoriteCCA3") private var favoriteRaw: String = "[]"
    @Published private(set) var favorites: Set<String> = []

    @Published private(set) var rankByPop: [String: Int] = [:]
    private let api = CountryAPI()

    init() {
        // Inicializē favorites no JSON
        if let data = favoriteRaw.data(using: .utf8),
           let arr = try? JSONDecoder().decode([String].self, from: data) {
            favorites = Set(arr)
        } else {
            favorites = []
        }
    }

    func load() async {
        do {
            let data = try await api.fetchAll()
            self.all = data.sorted { $0.name.common.localizedCompare($1.name.common) == .orderedAscending }

            // Populācijas reitings (globāli): augošā vieta pēc dilstošas populācijas
            let descPop = data.sorted { $0.population > $1.population }
            for (i, c) in descPop.enumerated() {
                rankByPop[c.cca3] = i + 1
            }
        } catch {
            print("Fetch failed:", error)
        }
    }

    // Diakritiku + lielo/mazo burtu ignorējoša meklēšana
    var filtered: [Country] {
        guard !searchText.isEmpty else { return all }
        let q = searchText
        return all.filter { c in
            func match(_ s: String?) -> Bool {
                guard let s else { return false }
                return s.range(of: q, options: [.caseInsensitive, .diacriticInsensitive]) != nil
            }
            if match(c.name.common) || match(c.name.official) { return true }
            if let t = c.translations, t.values.contains(where: { match($0.common) || match($0.official) }) { return true }
            if let langs = c.languages, langs.values.contains(where: { match($0) }) { return true }
            if match(c.cca2) || match(c.cca3) { return true }
            if let cap = c.capital?.first, match(cap) { return true }
            return false
        }
    }

    func toggleFavorite(_ country: Country) {
<<<<<<< HEAD
=======
        // Šī metode IR klases iekšpusē (skat. figūriekavas faila beigās)
>>>>>>> 022980f (Salabota karte - lai rādītu pareizas lokācijas punktusy)
        if favorites.contains(country.cca3) {
            favorites.remove(country.cca3)
        } else {
            favorites.insert(country.cca3)
        }

        // Persistē uz @AppStorage kā JSON
        if let json = try? JSONEncoder().encode(Array(favorites)) {
            favoriteRaw = String(decoding: json, as: UTF8.self)
        }
    }

<<<<<<< HEAD
    // Emoji karogs sarakstam (CCA2 -> reģionu indikatoru simboli)
=======
    // 🇱🇻 Emoji karogs sarakstam (CCA2 -> reģionu indikatoru simboli)
>>>>>>> 022980f (Salabota karte - lai rādītu pareizas lokācijas punktusy)
    func emojiFlag(cca2: String) -> String {
        let base: UInt32 = 0x1F1E6
        return String(cca2.uppercased().unicodeScalars.map {
            Character(UnicodeScalar(base + ($0.value - 65))!)
        })
    }
}
