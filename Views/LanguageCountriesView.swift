//
//  LanguageCountriesView.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 09/01/2026.
//


import SwiftUI

/// Skats, kas uzrāda visas valstis, kur valodu sarakstā atrodas `languageName`.
struct LanguageCountriesView: View {
    let languageName: String
    @StateObject private var store = CountryStore()

    var body: some View {
        List {
            ForEach(filtered) { c in
                NavigationLink(destination: CountryDetailView(country: c)) {
                    VStack(alignment: .leading) {
                        Text(c.name.common).font(.headline)
                        Text(c.name.official).font(.subheadline).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .task { await store.load() }
        .navigationTitle(languageName)
    }

    private var filtered: [Country] {
        store.all.filter {
            $0.languages?.values.contains(where: {
                // meklēšana ar diakritikas un lielo/mazo burtu ignorēšanu
                $0.range(of: languageName, options: [.caseInsensitive, .diacriticInsensitive]) != nil
            }) == true
        }
        .sorted { $0.name.common.localizedCompare($1.name.common) == .orderedAscending }
    }
}
