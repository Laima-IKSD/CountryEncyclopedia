//
//  Country.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 08/01/2026.
//


import Foundation
import CoreLocation

struct Country: Identifiable, Decodable, Equatable, Hashable {
    struct Name: Decodable { let common: String; let official: String }
    struct Translation: Decodable { let common: String?; let official: String? }
    struct Flags: Decodable { let png: String?; let svg: String?; let alt: String? }
    struct CapitalInfo: Decodable { let latlng: [Double]? }

    // Saraksta laukiem
    let name: Name
    let cca2: String
    let cca3: String
    let population: Int
    let translations: [String: Translation]?
    let languages: [String: String]?
    let capital: [String]?
    let flags: Flags?
    let borders: [String]?
    let capitalInfo: CapitalInfo?
    let latlng: [Double]?

    var countryLatLng: [Double]? = nil
    var id: String { cca3 }

    // Hashable/Equatable tikai pēc ID
    static func == (lhs: Country, rhs: Country) -> Bool { lhs.cca3 == rhs.cca3 }
    func hash(into hasher: inout Hasher) { hasher.combine(cca3) }
    
    // UI papildinājumiem
    var commonName: String { name.common }
    var officialName: String? { name.official }
    var capitalName: String? { capital?.first }
    
    // Karoga emoji no cca2
    var flagEmoji: String {
        String(cca2.uppercased().unicodeScalars.map {
            UnicodeScalar(127397 + Int($0.value))!
        }.map { String($0) }.joined())
        
    }
    
    /// Kartes koordinātas
    var coordinate: CLLocationCoordinate2D? {
        if let cap = capitalInfo?.latlng, cap.count == 2 {
            return .init(latitude: cap[0], longitude: cap[1])
        }
        if let c = countryLatLng, c.count == 2 {
            return .init(latitude: c[0], longitude: c[1])
        }
        return nil

    }
    
    /// Formatēta valodu rinda (piem., "Latvian, Russian")
     var languagesList: String {
         guard let langs = languages, !langs.isEmpty else { return "—" }
         return langs.values.sorted().joined(separator: ", ")
     }

     /// FlagsAPI URL detaļu skatam (bitmap PNG)
     /// https://flagsapi.com/:cca2/:style/:size.png
     var flagsAPIURL: URL? {
         URL(string: "https://flagsapi.com/\(cca2)/flat/128.png")
     }
 

}
