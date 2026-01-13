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
            
            VStack(alignment: .leading, spacing: 6) {
                Text(country.name.common)
                    .font(.largeTitle.bold())
                Text("Oficiālais: \(country.name.official)")
                    .foregroundStyle(.secondary)
                Text("Kods: \(country.cca2)/\(country.cca3) · Populācija: \(country.population.formatted())")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

                // Karogs
                AsyncImage(url: URL(string: "https://flagsapi.com/\(country.cca2)/flat/160.png")) { img in
                    img.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 4)

                Text(country.name.common)
                    .font(.largeTitle.bold())
                    .padding(.top)

                Divider()

                // Valodas
                if let langs = country.languages {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Valodas")
                            .font(.title3.bold())
                        ForEach(langs.sorted(by: { $0.key < $1.key }), id: \.key) { _, name in
                            Label(name, systemImage: "globe")
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Karte
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
                .shadow(radius: 4)

                // Kaimiņvalstis
                if !neighbors.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Kaimiņvalstis")
                            .font(.title3.bold())
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 8)]) {
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
                                        .shadow(radius: 1)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        
        .background(
            LinearGradient(colors: [.indigo.opacity(0.2), .blue.opacity(0.1)],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )

        .background(
            LinearGradient(colors: [.indigo.opacity(0.2), .blue.opacity(0.1)],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )

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
                    print("Ielādē kaimiņvalstis:", neighbors.map { $0.name.common })
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
