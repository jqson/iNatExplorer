//
//  TaxonManager.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/22/24.
//

import Foundation

class FilterManager {
    
    enum Constants {
        static let taxonKey = "taxonFilter"
    }
    
    static let shared = FilterManager();
    private init() {
        loadTaxonFilter()
    }
    
    private(set) var taxonFilter: [Taxon] = []
    
    func taxonInFilter(_ taxon: Taxon) -> Bool {
        return taxonFilter.contains(taxon)
    }
    
    func addTaxon(_ taxon: Taxon) {
        guard !taxonInFilter(taxon) else { return }
        
        taxonFilter.append(taxon)
        saveTaxonFilter()
    }
    
    func removeTaxon(_ taxon: Taxon) {
        guard taxonInFilter(taxon) else { return }
        
        taxonFilter.removeAll(where: { $0.id == taxon.id })
        saveTaxonFilter()
    }
    
    private func loadTaxonFilter() {
        taxonFilter = loadCodableArray(for: Constants.taxonKey)
    }
    
    private func saveTaxonFilter() {
        saveCodableArray(key: Constants.taxonKey, array: taxonFilter)
    }
    
    private func saveCodableArray(key: String, array: [Codable]) {
        let encoder = JSONEncoder()
        let dataArray: [Data] = array.compactMap { value in
            try? encoder.encode(value)
        }
        UserDefaults.standard.set(dataArray, forKey: key)
    }
    
    private func loadCodableArray<T: Codable>(for key: String) -> [T] {
        guard let dataArray = UserDefaults.standard.array(forKey: key) as? [Data] else {
            return []
        }
        
        let decoder = JSONDecoder();
        return dataArray.compactMap {
            try? decoder.decode(T.self, from: $0)
        }
    }
}
