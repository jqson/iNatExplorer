//
//  ReportHistogram.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 1/30/25.
//

import Foundation

struct Histogram {
    enum Period: String {
        case lastYear = "Last Year"
        case allYears = "All Years"
    }
    
    let label: String
    let period: Period
    let count: Int
    
    var periodStr: String {
        self.period.rawValue
    }
}

@MainActor class ReportHistogramViewModel: ObservableObject {
    
    @Published private(set) var weeklyCounts: [Histogram] = []
    
    private var lastYearCounts: [Int] = []
    private var allYearsCounts: [Int] = []
    
    func fetchData(taxonId: Int) async {
        async let lastYear: () = fetchLastYearCounts(taxonId: taxonId)
        async let allYear: () = fetchAllYearCounts(taxonId: taxonId)
        
        let _ = await [lastYear, allYear]
        
        guard lastYearCounts.count >= 52, allYearsCounts.count >= 52 else {
            print("Histogram data error!")
            return
        }
        
        weeklyCounts = Array(1...52).flatMap {
            [
                Histogram(label: String($0), period: .allYears, count: allYearsCounts[$0 - 1]),
                Histogram(label: String($0), period: .lastYear, count: lastYearCounts[$0 - 1]),
            ]
        }
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
        
        let lastYearDayCounts = DateUtil.getPastYearDateList().map({ dayCounts[$0] ?? 0 })
        
        var lastYearWeekCounts: [Int] = []
        var days = 0
        var weekSum = 0
        var weekCount = 0
        for dayCount in lastYearDayCounts {
            days += 1;
            weekSum += dayCount
            
            if days == 7 {
                weekCount += 1;
                lastYearWeekCounts.append(weekSum)
                days = 0
                weekSum = 0
            }
        }
        
        lastYearCounts = lastYearWeekCounts
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
        
        allYearsCounts = Array(1...52).map({ weekCounts[String($0)] ?? 0 })
    }
}
