//
//  PlaceManager.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/10/24.
//

import Foundation

class PlaceManager {
    
    private var placeDict: [Int: String]
    
    static let shared: PlaceManager = {
        return PlaceManager()
    }()
    
    private init() {
        placeDict = [:]
    }
    
    func addPlaces(_ newPlaces: [Int: String]) {
        placeDict.merge(newPlaces, uniquingKeysWith: { (_, new) in new })
    }
    
    func getPlace(id: Int?) -> String? {
        guard let id = id else { return nil }
        
        return placeDict[id]
    }
}
