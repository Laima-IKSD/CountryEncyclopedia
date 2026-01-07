//
//  Country.swift
//  CountryEncyclopedia
//
//  Created by Laima Sleiere on 08/01/2026.
//

import Foundation
import CoreLocation

struct Country: Identifiable, Decodable {
    var id: String { cca3 }
    
    let name: Name
    let translations: [String: Translation]?
    let cca2: String
    let cca3: String
    let population: Int
    let latlng: [Double]?
    let capital: [String]?
    let capitalInfo: CapitalInfo?
    let borders: [String]?
    let languages: [String: String]?
    
    // koordinātes, prioritāri capitalInfo, or valsts latling
    var coordinate: CLLocationCoordinate2D? {
        if let coords = capitalInfo?.latlng, coords.count == 2 {
            return CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1])
        } else if let coords = latlng, coords.count == 2 {
            return CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1])
        } else {
            return nil
        }
        
    }
    
    //Saraksta karodziņa emocijzīme no CCA2
    var flagEmotion: String {
        let base: UInt32 = 127397
        return cca2.uppercased().unicodeScalars.reduce(into: "") { result, scalar in
            result.unicodeScalars.append(UnicodeScalar(base + scalar.value)!)
        }
    }
}

struct Name: Decodable {
    let common: String
    let official: String
}

struct Translation: Decodable {
    let common: String?
    let official: String?
}

struct CapitalInfo: Decodable {
    let latlng: [Double]?
}
