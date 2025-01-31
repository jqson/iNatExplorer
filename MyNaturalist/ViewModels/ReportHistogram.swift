//
//  ReportHistogram.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 1/30/25.
//

import Foundation

@MainActor class ReportHistogramViewModel: ObservableObject {
    
    @Published private(set) var counts: [String: Int] = [:]
    
    func fetchData(taxonId: Int) async {
        guard let response = await NetworkRequest.getObservationHistogram(taxonId: taxonId) else {
            return
        }
        
        counts = response.results.day
    }
}
