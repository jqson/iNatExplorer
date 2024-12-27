//
//  TaxonManager.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/22/24.
//

import Foundation

protocol SelectableItem {
    var text: String { get }
    var isSelected: Bool { get set }
}

struct SelectableTaxon: SelectableItem, Codable {
    let taxon: Taxon
    
    var text: String { taxon.name }
    var isSelected: Bool = false
}

class FilterManager: ObservableObject {
    
    enum FilterKey: String {
        case taxon = "taxonFilter"
    }
    
    init() {
        taxonFilter = loadCodableArray(for: .taxon)
        initialized = true
    }
    
    @Published var taxonFilter: [SelectableTaxon] = [] {
        didSet {
            if initialized {
                saveTaxonFilter()
            }
        }
    }
    
    private var initialized = false
    
    func taxonInFilter(_ taxon: Taxon) -> Bool {
        return taxonFilter.contains(where: { $0.taxon.id == taxon.id })
    }
    
    func addTaxon(_ taxon: Taxon) {
        guard !taxonInFilter(taxon) else { return }
        
        taxonFilter.append(.init(taxon: taxon))
    }
    
    func removeTaxon(_ taxon: Taxon) {
        guard taxonInFilter(taxon) else { return }
        
        taxonFilter.removeAll(where: { $0.taxon.id == taxon.id })
    }
    
    private func saveTaxonFilter() {
        saveCodableArray(key: .taxon, array: taxonFilter)
    }
    
    private func clearSavedFilter(_ key: FilterKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    private func saveCodableArray(key: FilterKey, array: [Codable]) {
        let encoder = JSONEncoder()
        let dataArray: [Data] = array.compactMap { value in
            try? encoder.encode(value)
        }
        UserDefaults.standard.set(dataArray, forKey: key.rawValue)
    }
    
    private func loadCodableArray<T: Codable>(for key: FilterKey) -> [T] {
        guard let dataArray = UserDefaults.standard.array(forKey: key.rawValue) as? [Data] else {
            return []
        }
        
        let decoder = JSONDecoder();
        return dataArray.compactMap {
            try? decoder.decode(T.self, from: $0)
        }
    }
}
