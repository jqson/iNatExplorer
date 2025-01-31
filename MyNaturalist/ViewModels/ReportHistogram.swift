//
//  ReportHistogram.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 1/30/25.
//

import Foundation

struct Histogram {
    let label: String
    let value: Int
}

@MainActor class ReportHistogramViewModel: ObservableObject {
    
    @Published private(set) var counts: [Histogram] = []
    
    func fetchData(taxonId: Int) async {
        guard let response = await NetworkRequest.getObservationHistogram(taxonId: taxonId) else {
            return
        }
        
        counts = response.results.day.map({
            .init(label: $0.key, value: $0.value)
        }).sorted(by: { $0.label < $1.label })
    }
}
