
//
//  ContentView.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 08/01/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = CountryStore()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading {
                    ProgressView("Ielādē valstis…")
                } else if let err = store.errorMessage {
                    Text(err)
                        .foregroundStyle(.red)
                        .padding()
                } else {
                    
                    List(Array(filteredCountries.prefix(50))) { (country: Country) in
                        HStack {
                            Text(country.flagEmoji)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(country.name.common)
                                    .font(.headline)
                                Text(country.name.official)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(country.cca2)
                                .font(.caption)
                                .monospaced()
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Countries")
            .searchable(text: $searchText, prompt: "Search countries")
            .task { await store.load() }
        }
    }

    /// Filtrēšana pēc meklēšanas teksta
    var filteredCountries: [Country] {
        let all = store.countries
        let query = normalize(searchText)
        guard !query.isEmpty else { return all }

        return all.filter { country in
            // meklē pēc common/official
            if normalize(country.name.common).contains(query) { return true }
            if normalize(country.name.official).contains(query) { return true }

            // meklē tulkojumos (ja ir)
            if let translations = country.translations {
                let hit = translations.values.contains { tr in
                    let c = normalize(tr.common ?? "")
                    let o = normalize(tr.official ?? "")
                    return c.contains(query) || o.contains(query)
                }
                if hit { return true }
            }
            return false
        }
    }

    /// ]Mazie burti + diakritika (Läti -> lati; Letónia -> letonia)
    func normalize(_ text: String) -> String {
        text
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
    }
}

// #Preview vienmēr atrodas ārpus struct
#Preview {
    ContentView()
}
