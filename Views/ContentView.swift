

import SwiftUI

struct ContentView: View {
    @StateObject private var store = CountryStore()

    var body: some View {
        NavigationStack {
            List {
                if !store.favorites.isEmpty {
                    Section("Favorīti") {
                        ForEach(store.filtered.filter { store.favorites.contains($0.cca3) }) { c in
                            CountryRow(
                                country: c,
                                rank: store.rankByPop[c.cca3],
                                flagEmoji: store.emojiFlag(cca2: c.cca2),
                                onFav: { store.toggleFavorite(c) }
                            )
                        }
                    }
                }
                Section("Visas valstis") {
                    ForEach(store.filtered) { c in
                        CountryRow(
                            country: c,
                            rank: store.rankByPop[c.cca3],
                            flagEmoji: store.emojiFlag(cca2: c.cca2),
                            onFav: { store.toggleFavorite(c) }
                        )
                    }
                }
            }
            .navigationTitle("Country Encyclopedia")
            .searchable(text: $store.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .task { await store.load() }
        }
    }
}

private struct CountryRow: View {
    let country: Country
    let rank: Int?
    let flagEmoji: String
    let onFav: () -> Void

    var body: some View {
        NavigationLink(value: country) {
            HStack {
                // Emoji karogs sarakstam
                Text(flagEmoji)
                VStack(alignment: .leading) {
                    Text(country.name.common).font(.headline)
                    Text(country.name.official).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                if let r = rank { Text("#\(r)").font(.footnote).foregroundStyle(.tertiary) }
                FavoriteToggle(isOn: false, action: onFav) // vienkārša zvaigznīte
            }
        }
        .navigationDestination(for: Country.self) { c in
            CountryDetailView(country: c)
        }
    }
}
