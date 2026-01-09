//
//  CountryAPI.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 08/01/2026.
//


import Foundation

enum ServiceError: Error { case badURL, network, decode }

final class CountryAPI {
    // Sarakstam — tieši 10 lauki
    private let listURL = URL(string:
        "https://restcountries.com/v3.1/all?fields=name,cca2,cca3,population,translations,languages,capital,flags"
    )

    func fetchAll() async throws -> [Country] {
        guard let url = listURL else { throw ServiceError.badURL }
        let (data, resp) = try await URLSession.shared.data(from: url)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw ServiceError.network }
        return try JSONDecoder().decode([Country].self, from: data)
    }

    func fetchDetails(cca3: String) async throws -> Country {
        guard let url = URL(string:
            "https://restcountries.com/v3.1/alpha/\(cca3)?fields=name,cca2,cca3,population,translations,languages,capital,flags,borders,latlng,capitalInfo"
        ) else { throw ServiceError.badURL }
        let (data, resp) = try await URLSession.shared.data(from: url)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw ServiceError.network }
        // Endpoint atgriež masīvu ar 1 elementu
        return try JSONDecoder().decode([Country].self, from: data).first!
    }
}
