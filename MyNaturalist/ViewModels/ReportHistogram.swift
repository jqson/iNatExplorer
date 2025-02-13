//
//  ReportHistogram.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 1/30/25.
//

import Foundation

struct Histogram {
    enum Constants {
        static let historicalLegend = "Historical (scale: 1/%d)"
        static let lastYearLegend = "Last Year"
    }
    
    let legend: String
    let counts: [ReportCount]
}

struct ReportCount: Hashable {
    let date: Date
    let count: Double
}

@MainActor class ReportHistogramViewModel: ObservableObject {
    
    @Published private(set) var historicalHistogram: Histogram = .init(legend: "", counts: [])
    @Published private(set) var lastYearHistogram: Histogram = .init(legend: "", counts: [])
    
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
        
        guard let startDate = lastYearCounts.first?.0 else { return }
        
        let calendar = Calendar.current
        let startYear = calendar.component(.year, from: startDate)
        let firstDayOfYear = DateComponents(calendar: calendar, year: startYear).date!
        let lastDayOfYear = DateComponents(calendar: calendar, year: startYear + 1).date!
        
        dateRange = firstDayOfYear...lastDayOfYear
        
        lastYearHistogram = .init(
            legend: Histogram.Constants.lastYearLegend,
            counts: Array(0..<52).map {
                .init(date: lastYearCounts[$0].0, count: Double(lastYearCounts[$0].1))
            }
        )
        
        let historicalCounts = Array(0..<52).map {
            max(allYearsCounts[$0] - lastYearCounts[$0].1, 0)
        }
        
        guard
            let lastYearMax = lastYearCounts.map({ $0.1 }).max(),
            let historicalMax = historicalCounts.max()
        else {
            print("Histogram data error!")
            return
        }
        
        let lastYearSum = lastYearCounts.map({ $0.1 }).reduce(0, +)
        let historicalSum = historicalCounts.reduce(0, +)
        
        let maxCountScale = max(historicalMax / lastYearMax, 1)
        let averageCountScale = max(historicalSum / lastYearSum, 1)
        
        let scale = min(maxCountScale, averageCountScale)
        
        historicalHistogram = .init(
            legend: String(format: Histogram.Constants.historicalLegend, scale),
            counts: Array(0..<52).map {
                let historicalDisplay = Double(historicalCounts[$0]) / Double(scale)
                return .init(date: lastYearCounts[$0].0, count: historicalDisplay)
            }
        )
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
