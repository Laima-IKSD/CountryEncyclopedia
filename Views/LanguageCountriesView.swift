//
//  LanguageCountriesView.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 09/01/2026.
//


import SwiftUI

struct LanguageCountriesView: View {
    let languageName: String
    @StateObject private var store = CountryStore()

    var body: some View {
        List {
            ForEach(store.all.filter {
                $0.languages?.values.contains(where: {
                    $0.range(of: languageName, options: [.caseInsensitive, .diacriticInsensitive]) != nil
                }) == true
            }) { c in
                Text(c.name.common)
            }
        }
        .task { await store.load() }
        .navigationTitle(languageName)
    }
}
