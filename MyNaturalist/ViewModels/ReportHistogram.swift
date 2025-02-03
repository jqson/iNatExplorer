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
    @Published private(set) var allYearCounts: [Histogram] = []
    
    func fetchData(taxonId: Int) async {
        async let lastYear: () = fetchLastYearCounts(taxonId: taxonId)
        async let allYear: () = fetchAllYearCounts(taxonId: taxonId)
        
        let _ = await [lastYear, allYear]
    }
    
    private func fetchLastYearCounts(taxonId: Int) async {
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
    
    private func fetchAllYearCounts(taxonId: Int) async {
        guard
            let response = await NetworkRequest.getObservationHistogram(
                taxonId: taxonId, interval: .weekOfYear
            ),
            let weekCounts = response.results.weekOfYear
        else {
            return
        }
        
        var weekHists: [Histogram] = []
        for week in 1...52 {
            let weekStr = String(week)
            weekHists.append(.init(label: weekStr, value: weekCounts[weekStr] ?? 0))
        }
        
        allYearCounts = weekHists
    }
}
