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
                FlagView(cca2: country.cca2)

<<<<<<< HEAD
                // PNG karogs no FlagsAPI — LV/flat/160.png
                FlagView(cca2: country.cca2)

                Text(country.name.common).font(.largeTitle).bold()
                Text("Oficiālais: \(country.name.official)").foregroundStyle(.secondary)
                Text("Kods: \(country.cca2)/\(country.cca3) · Populācija: \(country.population)")

=======
                Text(country.name.common).font(.largeTitle).bold()
                Text("Oficiālais: \(country.name.official)").foregroundStyle(.secondary)
                Text("Kods: \(country.cca2)/\(country.cca3) · Populācija: \(country.population)")

>>>>>>> 022980f (Salabota karte - lai rādītu pareizas lokācijas punktusy)
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
<<<<<<< HEAD
                Map(position: $camera)
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

=======
                
                Map(position: $camera) {
                    if let coords = detail?.capitalInfo?.latlng ?? detail?.latlng ?? country.latlng,
                        coords.count == 2 {
                        Marker(country.capital?.first ?? country.name.common,
                                coordinate: CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1]))
                        }
                    }
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 12))


>>>>>>> 022980f (Salabota karte - lai rādītu pareizas lokācijas punktusy)
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
<<<<<<< HEAD
=======
                
                //Debug
                print("Capital coords:", det.capitalInfo?.latlng ?? [])
                print("Country coords:", det.latlng ?? [])
                print("Border:", det.borders ?? [])
                
>>>>>>> 022980f (Salabota karte - lai rādītu pareizas lokācijas punktusy)
                let coord = det.capitalInfo?.latlng ?? det.latlng ?? country.latlng
                if let c = coord, c.count == 2 {
                    camera = .camera(MapCamera(
                        centerCoordinate: CLLocationCoordinate2D(latitude: c[0], longitude: c[1]),
                        distance: 600_000
                    ))
<<<<<<< HEAD
                }
            } catch {
                // TODO: paziņojums lietotājam
=======
                } else {
                    camera = .automatic
                }
            } catch {
                print("Neizdevās ielādēt detaļas:", error)
>>>>>>> 022980f (Salabota karte - lai rādītu pareizas lokācijas punktusy)
            }
        }
        .navigationTitle(country.name.common)
        .navigationBarTitleDisplayMode(.inline)
    }
}

<<<<<<< HEAD
// Kaimiņa “mini” skats — parāda nosaukumu
=======
// Kaimiņa “mini” skats — parāda nosaukumu (vajadzības gadījumā var paplašināt)
>>>>>>> 022980f (Salabota karte - lai rādītu pareizas lokācijas punktusy)
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
<<<<<<< HEAD

=======
>>>>>>> 022980f (Salabota karte - lai rādītu pareizas lokācijas punktusy)
