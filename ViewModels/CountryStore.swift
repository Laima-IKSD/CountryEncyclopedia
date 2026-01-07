//
//  CountryStore.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 08/01/2026.
//

import Foundation
import Combine

@MainActor
final class CountryStore: ObservableObject {
    @Published var countries: [Country] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    ///Ielāde + sakārtošana pēc nosaukumiem
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let all = try await CountryAPI.shared.fetchAllCountries()
            countries = all.sorted {
                $0.name.common.localizedCaseInsensitiveCompare($1.name.common) == .orderedAscending
            }
        } catch {
            errorMessage = "Nesanāca ielādēt datus: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
