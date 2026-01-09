//
//  Country.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 08/01/2026.
//


import Foundation

struct Country: Identifiable, Decodable, Equatable, Hashable {
    struct Name: Decodable { let common: String; let official: String }
    struct Translation: Decodable { let common: String?; let official: String? }
    struct Flags: Decodable { let png: String?; let svg: String?; let alt: String? }
    struct CapitalInfo: Decodable { let latlng: [Double]? }

    // Saraksta laukiem (no /v3.1/all) — ≤10 fields
    let name: Name
    let cca2: String
    let cca3: String
    let population: Int
    let translations: [String: Translation]?
    let languages: [String: String]?
    let capital: [String]?
    let flags: Flags

    // Detaļām (no /v3.1/alpha/{cca3})
    let borders: [String]?
    let latlng: [Double]?
    let capitalInfo: CapitalInfo?

    var id: String { cca3 }

    // Hashable/Equatable tikai pēc ID, lai nav jāpadara hashable viss iekšējais saturs
    static func == (lhs: Country, rhs: Country) -> Bool { lhs.cca3 == rhs.cca3 }
    func hash(into hasher: inout Hasher) { hasher.combine(cca3) }
}
