
import SwiftUI

struct ContentView: View {
    @StateObject private var store = CountryStore()

    var body: some View {
        NavigationStack {
            List {
                // FAVORĪTI
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
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                }

                // VISAS VALSTIS
                Section("Visas valstis") {
                    ForEach(store.filtered) { c in
                        CountryRow(
                            country: c,
                            rank: store.rankByPop[c.cca3],
                            flagEmoji: store.emojiFlag(cca2: c.cca2),
                            isFavorite: store.favorites.contains(c.cca3),
                            onFav: { store.toggleFavorite(c) }
                        )
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .navigationTitle("Country Encyclopedia")
            .searchable(text: $store.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Meklēt valsti, valodu, kodu…")
            .task { await store.load() }
            .listStyle(.plain)
            .scrollContentBackground(.hidden) // caurspīdīgs fons
            .background(
                LinearGradient(colors: [.indigo.opacity(0.12), .blue.opacity(0.08)],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
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
            HStack(spacing: 16) {
                Text(flagEmoji)
                    .font(.system(size: 36))

                VStack(alignment: .leading, spacing: 4) {
                    Text(country.name.common)
                        .font(.headline)
                    Text(country.name.official)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 10) {
                        Text("Kods: \(country.cca2)/\(country.cca3)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if let r = rank {
                            Text("#\(r)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Spacer()

                Button(action: onFav) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundStyle(isFavorite ? .yellow : .secondary)
                        .imageScale(.medium)
                        .padding(8)
                        .background(isFavorite ? Color.yellow.opacity(0.15) : Color.secondary.opacity(0.12))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(12)
            .background(.thinMaterial) // kartītes efekts
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
    }
}
