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
    let count: Double
    
    var periodStr: String {
        self.period.rawValue
    }
}

@MainActor class ReportHistogramViewModel: ObservableObject {
    
    @Published private(set) var weeklyCounts: [Histogram] = []
    
    private(set) var dateRange: ClosedRange<Date> = Date.now...Date.now
    
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
        
        guard
            let lastYearMax = lastYearCounts.map({ $0.1 }).max(),
            let allYearsMax = allYearsCounts.max()
        else {
            print("Histogram data error!")
            return
        }
        
        let scale: Double = Double(allYearsMax / lastYearMax)
        
        weeklyCounts = Array(0..<52).flatMap {
            let date = lastYearCounts[$0].0
            return [
                Histogram(date: date, period: .allYears, count: Double(allYearsCounts[$0]) / scale),
                Histogram(date: date, period: .lastYear, count: Double(lastYearCounts[$0].1)),
            ]
        }
        
        guard let startDate = weeklyCounts.first?.date else { return }
        
        let calendar = Calendar.current
        let startYear = calendar.component(.year, from: startDate)
        let firstDayOfYear = DateComponents(calendar: calendar, year: startYear).date!
        let lastDayOfYear = DateComponents(calendar: calendar, year: startYear + 1).date!
        
        dateRange = firstDayOfYear...lastDayOfYear
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
            if days == 1 {
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
