//
//  ReportHistogram.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 1/30/25.
//

import Foundation

struct Histogram {
    enum Constants {
        static let historicalLegend = "Historical (scale: 1/%d)"
        static let pastYearLegend = "Past Year"
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
    @Published private(set) var pastYearHistogram: Histogram = .init(legend: "", counts: [])
    
    private(set) var ready: Bool = false
    private(set) var currMonthDay: Date = Date()
    private(set) var dateRange: ClosedRange<Date> = Date.now...Date.now
    
    private var pastYearCounts: [(Date, Int)] = []
    private var allYearsCounts: [Int] = []
    
    func fetchData(taxonId: Int) async {
        async let pastYear: () = fetchPastYearCounts(taxonId: taxonId)
        async let allYear: () = fetchAllYearCounts(taxonId: taxonId)
        
        let _ = await [pastYear, allYear]
        
        guard pastYearCounts.count >= 52, allYearsCounts.count >= 52 else {
            print("Histogram data error!")
            return
        }
        
        guard let startDate = pastYearCounts.first?.0 else { return }
        
        let calendar = Calendar.current
        let startYear = calendar.component(.year, from: startDate)
        let firstDayOfYear = DateComponents(calendar: calendar, year: startYear).date!
        let lastDayOfYear = DateComponents(calendar: calendar, year: startYear + 1).date!
        
        var dateComponents = calendar.dateComponents([.month, .day], from: Date())
        dateComponents.year = startYear
        currMonthDay = Calendar.current.date(from: dateComponents)!
        
        dateRange = firstDayOfYear...lastDayOfYear
        
        pastYearHistogram = .init(
            legend: Histogram.Constants.pastYearLegend,
            counts: Array(0..<52).map {
                .init(date: pastYearCounts[$0].0, count: Double(pastYearCounts[$0].1))
            }
        )
        
        let historicalCounts = Array(0..<52).map {
            max(allYearsCounts[$0] - pastYearCounts[$0].1, 0)
        }
        
        guard
            let pastYearMax = pastYearCounts.map({ $0.1 }).max(),
            pastYearMax > 0,
            let historicalMax = historicalCounts.max()
        else {
            print("Histogram data error!")
            return
        }
        
        let pastYearSum = pastYearCounts.map({ $0.1 }).reduce(0, +)
        let historicalSum = historicalCounts.reduce(0, +)
        
        let maxCountScale = max(historicalMax / pastYearMax, 1)
        let averageCountScale = max(historicalSum / pastYearSum, 1)
        
        let scale = min(maxCountScale, averageCountScale)
        
        historicalHistogram = .init(
            legend: String(format: Histogram.Constants.historicalLegend, scale),
            counts: Array(0..<52).map {
                let historicalDisplay = Double(historicalCounts[$0]) / Double(scale)
                return .init(date: pastYearCounts[$0].0, count: historicalDisplay)
            }
        )
        
        ready = true
    }
    
    private func fetchPastYearCounts(taxonId: Int) async {
        guard
            let response = await NetworkRequest.getObservationHistogram(
                taxonId: taxonId, interval: .day
            ),
            let dayCounts = response.results.day
        else {
            return
        }
        
        let pastYearDates = DateUtil.getPastYearDateList()
        
        pastYearDates.forEach {
            print($0.monthDayDate)
            print($0.str)
        }
        
        var pastYearWeekCounts: [(Date, Int)] = []
        var days = 0
        var weekSum = 0
        var weekCount = 0
        var weekDate: Date = .now
        for dateWithStr in pastYearDates {
            if days == 1 {
                weekDate = dateWithStr.monthDayDate
            }
            days += 1;
            weekSum += dayCounts[dateWithStr.str] ?? 0
            
            if days == 7 {
                weekCount += 1;
                pastYearWeekCounts.append((weekDate, weekSum))
                days = 0
                weekSum = 0
            }
        }
        
        pastYearCounts = pastYearWeekCounts
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
