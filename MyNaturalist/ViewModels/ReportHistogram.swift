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
    
    @Published private(set) var lastYearCounts: [Histogram] = []
    
    func fetchData(taxonId: Int) async {
        guard
            let response = await NetworkRequest.getObservationHistogram(
                taxonId: taxonId, interval: .day
            ),
            let dayCounts = response.results.day
        else {
            return
        }
        
        let dayHists = DateUtil.getPastYearDateList().map {
            Histogram(label: $0, value: dayCounts[$0] ?? 0)
        }
        
        
        var weekHists: [Histogram] = []
        var days = 0
        var weekSum = 0
        var weekCount = 0
        for dayHist in dayHists {
            days += 1;
            weekSum += dayHist.value
            
            if days == 7 {
                weekCount += 1;
                weekHists.append(.init(label: String(weekCount), value: weekSum))
                days = 0
                weekSum = 0
            }
        }
        
        lastYearCounts = weekHists
    }
}
