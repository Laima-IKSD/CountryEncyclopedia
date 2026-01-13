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
    @State private var neighbors: [Country] = []
    @State private var camera: MapCameraPosition = .automatic
    private let api = CountryAPI()

    // Režģis “smukām rindām” (pielāgo kolonnas atkarībā no platuma)
    private let grid = [GridItem(.adaptive(minimum: 140), spacing: 8)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Karogs no FlagsAPI
                FlagView(cca2: country.cca2)

                Text(country.name.common)
                    .font(.largeTitle)
                    .bold()
                Text("Oficiālais: \(country.name.official)")
                    .foregroundStyle(.secondary)
                Text("Kods: \(country.cca2)/\(country.cca3) · Populācija: \(country.population)")

                // Valodas + saite uz citām valstīm ar šo valodu
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

                // KARTE: galvenais marķieris + kaimiņu marķieri
                Map(position: $camera) {
                    if let coords = detail?.capitalInfo?.latlng ?? detail?.latlng ?? country.latlng,
                       coords.count == 2 {
                        Marker(country.capital?.first ?? country.name.common,
                               coordinate: CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1]))
                        .tint(.red)
                    }

                    ForEach(neighbors.sorted { $0.name.common < $1.name.common }, id: \.cca3) { n in
                        if let c = n.capitalInfo?.latlng ?? n.latlng, c.count == 2 {
                            Marker(n.name.common,
                                   coordinate: CLLocationCoordinate2D(latitude: c[0], longitude: c[1]))
                            .tint(.blue)
                        }
                    }
                }
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // KAIMIŅVALSTIS: pilnie nosaukumi "čipos" (skaisti rindās)
                if !neighbors.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Kaimiņvalstis").font(.headline)
                        LazyVGrid(columns: grid, alignment: .leading, spacing: 8) {
                            ForEach(neighbors.sorted { $0.name.common < $1.name.common }, id: \.cca3) { n in
                                NavigationLink {
                                    CountryDetailView(country: n)
                                } label: {
                                    Text(n.name.common)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(.thinMaterial)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .task {
            do {
                // 1) Galvenās valsts detaļas
                let det = try await api.fetchDetails(cca3: country.cca3)
                detail = det

                // Karte – prioritāte capital -> country; pretējā gadījumā pasaules skats
                let coords = det.capitalInfo?.latlng ?? det.latlng ?? country.latlng
                if let c = coords, c.count == 2 {
                    camera = .camera(MapCamera(
                        centerCoordinate: CLLocationCoordinate2D(latitude: c[0], longitude: c[1]),
                        distance: 600_000
                    ))
                } else {
                    camera = .automatic
                }

                // 2) Kaimiņi (pilnie nosaukumi + koordinātes kartē)
                if let borderCodes = det.borders, !borderCodes.isEmpty {
                    neighbors = try await api.fetchNeighbors(cca3Codes: borderCodes)
                } else {
                    neighbors = []
                }

            } catch {
                print("Neizdevās ielādēt detaļas:", error)
            }
        }
        .navigationTitle(country.name.common)
        .navigationBarTitleDisplayMode(.inline)
    }
}
