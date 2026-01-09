//
//  CountryDetailView.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 09/01/2026.
//


import SwiftUI
import MapKit

struct CountryDetailView: View {
    let country: Country
    @State private var detail: Country?
    @State private var camera: MapCameraPosition = .automatic
    private let api = CountryAPI()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // PNG karogs no FlagsAPI — LV/flat/160.png
                FlagView(cca2: country.cca2)

                Text(country.name.common).font(.largeTitle).bold()
                Text("Oficiālais: \(country.name.official)").foregroundStyle(.secondary)
                Text("Kods: \(country.cca2)/\(country.cca3) · Populācija: \(country.population)")

                // Valodas + saites uz citām valstīm ar šo valodu
                if let langs = country.languages, !langs.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Valodas").font(.headline)
                        ForEach(langs.sorted(by: { $0.key < $1.key }), id: \.key) { (code: String, name: String) in
                            HStack {
                                Text(name)
                                Spacer()
                                NavigationLink("Citas valstis (\(name))") {
                                    LanguageCountriesView(languageName: name)
                                }
                            }
                        }
                    }
                }

                // Karte (centrē uz capital.latlng, citādi country.latlng)
                Map(position: $camera)
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                // Kaimiņvalstis (cca3 kodi)
                if let borders = detail?.borders, !borders.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Kaimiņvalstis").font(.headline)
                        ForEach(borders, id: \.self) { code in
                            NavigationLink(code) { NeighborDetailView(cca3: code) }
                                .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            .padding()
        }
        .task {
            do {
                let det = try await api.fetchDetails(cca3: country.cca3)
                detail = det
                let coord = det.capitalInfo?.latlng ?? det.latlng ?? country.latlng
                if let c = coord, c.count == 2 {
                    camera = .camera(MapCamera(
                        centerCoordinate: CLLocationCoordinate2D(latitude: c[0], longitude: c[1]),
                        distance: 600_000
                    ))
                }
            } catch {
                // TODO: paziņojums lietotājam
            }
        }
        .navigationTitle(country.name.common)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Kaimiņa “mini” skats — parāda nosaukumu
private struct NeighborDetailView: View {
    let cca3: String
    @State private var detail: Country?
    private let api = CountryAPI()

    var body: some View {
        Group {
            if let d = detail {
                VStack(alignment: .leading, spacing: 12) {
                    Text(d.name.common).font(.title).bold()
                    Text(d.name.official).foregroundStyle(.secondary)
                }
                .padding()
            } else {
                ProgressView()
            }
        }
        .task { detail = try? await api.fetchDetails(cca3: cca3) }
    }
}

