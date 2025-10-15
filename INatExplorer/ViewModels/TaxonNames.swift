//
//  TaxonNames.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 1/5/25.
//

import Foundation
import SwiftUI

struct TaxonName {
    
    enum Language: String {
        case english = "english"
        case chineseSimplified = "chinese-simplified"
    }
    
    let id: Int
    let language: Language
    let name: String
}


@MainActor
@Observable
class TaxonNamesViewModel {
    
    private(set) var taxonNames: [TaxonName] = []
    private(set) var selectedTaxonName: TaxonName?
    
    func fetchData(taxonId: Int) async {
        guard let taxonNamesResponse = await NetworkRequest.getTaxonNames(taxonId: taxonId) else {
            return
        }
        
        taxonNames = taxonNamesResponse.compactMap {
            guard let language = TaxonName.Language(rawValue: $0.parameterizedLexicon) else {
                return nil
            }
            
            return .init(id: $0.id, language: language, name: $0.name)
        }
        
        selectedTaxonName = taxonNames.first { $0.language == .chineseSimplified }
    }
}
