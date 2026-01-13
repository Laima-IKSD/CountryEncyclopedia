
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
                                isFavorite: store.favorites.contains(c.cca3),
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
                            isFavorite: store.favorites.contains(c.cca3),
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
    let isFavorite: Bool
    let onFav: () -> Void

    var body: some View {
        NavigationLink(destination: CountryDetailView(country: country)) {
            HStack {
                Text(flagEmoji)
                VStack(alignment: .leading) {
                    Text(country.name.common).font(.headline)
                    Text(country.name.official).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                if let r = rank {
                    Text("#\(r)").font(.footnote).foregroundStyle(.tertiary)
                }
                Button(action: onFav) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
