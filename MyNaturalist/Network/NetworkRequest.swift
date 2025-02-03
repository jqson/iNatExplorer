//
//  NetworkRequest.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/6/24.
//

import Foundation

class NetworkRequest {
    
    enum Constants {
        static let iNatBaseUrl = "https://api.inaturalist.org/v1"
        static let iNatLegacyBaseUrl = "https://www.inaturalist.org"
        
        static let gmsKey = "AIzaSyDQPAmqBULGhHwOj8LPrsHSTn-r-bYfKo4"
        static let geoCodeBaseUrl = "https://maps.googleapis.com/maps/api/geocode/json"
        
        static let coordinates: [URLQueryItem] = [
            .init(name: "nelat", value: "37.8764014352312"),
            .init(name: "nelng", value: "-121.57421471187659"),
            .init(name: "swlat", value: "36.89876283035327"),
            .init(name: "swlng", value: "-122.64812828609534"),
        ]
        
        static let commonParams: [URLQueryItem] = coordinates + [
            .init(name: "quality_grade", value: "research"),
        ]
    }
    
    enum Observation {
        static let endpoint = "/observations?verifiable=true&order_by=observed_on&order=desc&page=1&photos=true"
            + "&locale=en-US&return_bounds=true"
        
        static let taxonIdKey = "taxon_id"
        static let perPageKey = "per_page"
    }
    
    enum SpeciesCounts {
        static let endpoint = "/observations/species_counts?verifiable=true&spam=false"
            + "&locale=en-US&include_ancestors=true"
        
        static let iconicTaxon = "iconic_taxa"
        static let perPageKey = "per_page"
        static let fromDate = "d1"
    }
    
    enum Histogram {
        static let endpoint = "/observations/histogram?verifiable=true&date_field=observed"
        
        static let taxonIdKey = "taxon_id"
        static let intervalKey = "interval"
        
        enum IntervalType: String {
            case day = "day"
            case weekOfYear = "week_of_year"
        }
    }
    
    enum TaxonNames {
        static let endpoint = "/taxon_names.json"
        
        static let perPageKey = "per_page"
        static let taxonIdKey = "taxon_id"
    }
    
    enum ReverseGeo {
        static let keyKey = "key"
        static let coordinatesKey = "latlng"
    }
    
    static func getObservations(taxons: [Taxon]) async -> ObservationResponse? {
        var requestUrl = URL(string: Constants.iNatBaseUrl + Observation.endpoint)
        var queryItems: [URLQueryItem] = []
        
        queryItems += Constants.commonParams
        
        if !taxons.isEmpty {
            let taxonIdValue = taxons.map({ String($0.id) }).joined(separator: ",")
            queryItems.append(.init(name: Observation.taxonIdKey, value: taxonIdValue))
        }
        
        queryItems.append(.init(name: Observation.perPageKey, value: "20"))
        
        requestUrl?.append(queryItems: queryItems)
        
        return try? await NetworkService.sendRequest(url: requestUrl)
    }
    
    static func getSpeciesCounts(category: CategoryStruct) async -> SpeciesCountsResponse? {
        var requestUrl = URL(string: Constants.iNatBaseUrl + SpeciesCounts.endpoint)
        var queryItems: [URLQueryItem] = [
            .init(name: SpeciesCounts.iconicTaxon, value: category.paramValue),
            .init(name: SpeciesCounts.fromDate, value: "2024-01-01"),
        ]
        
        queryItems += Constants.commonParams
        
        requestUrl?.append(queryItems: queryItems)
        
        return try? await NetworkService.sendRequest(url: requestUrl)
    }
    
    static func getObservationHistogram(taxonId: Int, interval: Histogram.IntervalType) async -> HistogramResponse? {
        var requestUrl = URL(string: Constants.iNatBaseUrl + Histogram.endpoint)
        
        var queryItems: [URLQueryItem] = [
            .init(name: Histogram.taxonIdKey, value: String(taxonId)),
            .init(name: Histogram.intervalKey, value: interval.rawValue),
        ]
        
        queryItems += Constants.commonParams
        
        requestUrl?.append(queryItems: queryItems)
        
        return try? await NetworkService.sendRequest(url: requestUrl)
    }
    
    static func getTaxonNames(taxonId: Int) async -> [TaxonNameResponse]? {
        var requestUrl = URL(string: Constants.iNatLegacyBaseUrl + TaxonNames.endpoint)
        requestUrl?.append(
            queryItems: [
                .init(name: TaxonNames.perPageKey, value: "400"),
                .init(name: TaxonNames.taxonIdKey, value: String(taxonId)),
            ]
        )
        
        return try? await NetworkService.sendRequest(url: requestUrl)
    }
    
    static func reverseGeo(coordinates: Coordinates) async -> ReverseGeoResponse? {
        let queryItems: [URLQueryItem] = [
            .init(name: ReverseGeo.keyKey, value: Constants.gmsKey),
            .init(name: ReverseGeo.coordinatesKey, value: "\(coordinates.lat),\(coordinates.lng)"),
        ]
        
        var requestUrl = URL(string: Constants.geoCodeBaseUrl)
        requestUrl?.append(queryItems: queryItems)
        
        return try? await NetworkService.sendRequest(url: requestUrl)
    }
}
