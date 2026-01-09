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
<<<<<<< HEAD
            ForEach(store.all.filter {
                $0.languages?.values.contains(where: {
                    $0.range(of: languageName, options: [.caseInsensitive, .diacriticInsensitive]) != nil
                }) == true
            }) { c in
                Text(c.name.common)
=======
            ForEach(filtered) { c in
                NavigationLink(destination: CountryDetailView(country: c)) {
                    VStack(alignment: .leading) {
                        Text(c.name.common).font(.headline)
                        Text(c.name.official).font(.subheadline).foregroundStyle(.secondary)
                    }
                }
>>>>>>> 022980f (Salabota karte - lai rādītu pareizas lokācijas punktusy)
            }
        }
        .task { await store.load() }
        .navigationTitle(languageName)
    }
<<<<<<< HEAD
=======

    private var filtered: [Country] {
        store.all.filter {
            $0.languages?.values.contains(where: {
                // meklēšana ar diakritikas un lielo/mazo burtu ignorēšanu
                $0.range(of: languageName, options: [.caseInsensitive, .diacriticInsensitive]) != nil
            }) == true
        }
        .sorted { $0.name.common.localizedCompare($1.name.common) == .orderedAscending }
    }
>>>>>>> 022980f (Salabota karte - lai rādītu pareizas lokācijas punktusy)
}
