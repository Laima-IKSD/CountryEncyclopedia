//
//  CountryAPI.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 08/01/2026.
//

import Foundation

enum CountryAPIError: Error {
    case badURL
    case network(Error)
    case decoding(Error)
    case empty
}
final class CountryAPI {
    static let shared = CountryAPI()
    private let urlString = "https://restcountries.com/v3.1/all"
    
    /// Nolasa info no REST Countries
    func fetchAllCountries() async throws -> [Country] {
        guard let url = URL(string: urlString) else { throw CountryAPIError.badURL }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw CountryAPIError.empty
            }
            return try JSONDecoder().decode([Country].self, from: data)
        } catch let err as DecodingError {
            throw CountryAPIError.decoding(err)
        } catch {
            throw CountryAPIError.network(error)
        }
    }
}
