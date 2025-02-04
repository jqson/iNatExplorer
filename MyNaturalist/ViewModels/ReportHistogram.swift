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
    
    let date: Date
    let period: Period
    let count: Int
    
    var periodStr: String {
        self.period.rawValue
    }
}

@MainActor class ReportHistogramViewModel: ObservableObject {
    
    @Published private(set) var weeklyCounts: [Histogram] = []
    
    private var lastYearCounts: [(Date, Int)] = []
    private var allYearsCounts: [Int] = []
    
    func fetchData(taxonId: Int) async {
        async let lastYear: () = fetchLastYearCounts(taxonId: taxonId)
        async let allYear: () = fetchAllYearCounts(taxonId: taxonId)
        
        let _ = await [lastYear, allYear]
        
        guard lastYearCounts.count >= 52, allYearsCounts.count >= 52 else {
            print("Histogram data error!")
            return
        }
        
        weeklyCounts = Array(0..<52).flatMap {
            let date = lastYearCounts[$0].0
            print(date)
            return [
                Histogram(date: date, period: .allYears, count: allYearsCounts[$0]),
                Histogram(date: date, period: .lastYear, count: lastYearCounts[$0].1),
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
        
        let lastYearDates = DateUtil.getPastYearDateList()
        
        var lastYearWeekCounts: [(Date, Int)] = []
        var days = 0
        var weekSum = 0
        var weekCount = 0
        var weekDate: Date = .now
        for dateWithStr in lastYearDates {
            if days == 0 {
                weekDate = dateWithStr.date
            }
            days += 1;
            weekSum += dayCounts[dateWithStr.str] ?? 0
            
            if days == 7 {
                weekCount += 1;
                lastYearWeekCounts.append((weekDate, weekSum))
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
