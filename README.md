# CountryEncyclopedia
Country Encyclopedia (iOS · SwiftUI)
A compact iOS app that displays country information with search, details, map view, and favorites.

Features

Data Source: https://restcountries.com/v3.1/all
Search:

Search by common/official name, ISO codes, capital, languages, and translations.
Diacritic-insensitive (e.g., typing Läti or Letónia finds Latvia).


List View:

Shows country name, official name, population, global rank, and flag emoji.


Detail View:

Flag image from https://flagsapi.com/#quick.
Map with capital or country coordinates.
Neighboring countries with navigation.
Languages with quick filter to other countries speaking the same language.


Favorites:

Mark/unmark countries as favorites (stored locally).

Tech Stack

Language: Swift
Framework: SwiftUI
Platform: iOS (latest major version)
Networking: URLSession (native)
Map: MapKit

API Endpoints

All countries (list):
https://restcountries.com/v3.1/all?fields=name,cca2,cca3,population,translations,languages,capital,flags,borders,capitalInfo


Country details:
https://restcountries.com/v3.1/alpha/{cca3}?fields=name,cca2,cca3,population,translations,languages,capital,flags,borders,latlng,capitalInfo


Neighbors:
https://restcountries.com/v3.1/alpha?codes=CODE1,CODE2&fields=name,cca2,cca3,population,flags,capital,capitalInfo,latlng




Installation & Run

Clone the repository:
Shellgit clone https://github.com/Laima-IKSD/CountryEncyclopedia.gitShow more lines

Open CountryEncyclopedia.xcodeproj in Xcode.
Select an iOS Simulator or a connected device.
Build & Run (⌘R).


Notes

Uses fields parameter to limit payload size for performance.
Fallback for coordinates: if capitalInfo.latlng is missing, uses latlng from details.
Favorites stored in UserDefaults.


Possible Improvements

Unit tests for search and ranking.
Pull-to-refresh (implemented).
Accessibility labels for VoiceOver.
App icon and accent color customization.
