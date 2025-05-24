//
//  DateUtil.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 2/2/25.
//

import Foundation

typealias DateWithString = (date: Date, str: String)

class DateUtil {
    
    enum Constants {
        static let dateFormat = "yyyy-MM-dd"
        static let mdFormat = "MM-dd"
        static let dateFormatDayLen = mdFormat.count
    }
    
    static func getPastYearDateString() -> String {
        let calendar = Calendar.current
        let today = Date()
        let lastYearDate = calendar.date(byAdding: DateComponents(year: -1, day: -1), to: today)!
        
        let DateFormatter = DateFormatter()
        DateFormatter.dateFormat = Constants.dateFormat
        return DateFormatter.string(from: lastYearDate)
    }
    
    static func getPastYearDateList() -> [DateWithString] {
        let calendar = Calendar.current
        let today = Date()
        let fromDate = calendar.date(byAdding: DateComponents(year: -1, day: -1), to: today)!
        let toDate = calendar.date(byAdding: .day, value: -1, to: today)!

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = Constants.dateFormat
        
        let mdDateFormatter = DateFormatter()
        mdDateFormatter.dateFormat = Constants.mdFormat

        var dates: [DateWithString] = []
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        calendar.enumerateDates(startingAfter: fromDate, matching: components, matchingPolicy: .nextTime) { date, strict, stop in
            guard let date = date else { return }
            
            guard date <= toDate else {
                stop = true
                return
            }
            
            let dateStr = dateFormatter.string(from: date)
            let axisDate = mdDateFormatter.date(
                from: String(dateStr.suffix(Constants.dateFormatDayLen))
            )!
            
            dates.append((date: axisDate, str: dateFormatter.string(from: date)))
        }
        
        dates.sort {
            $0.str.suffix(Constants.dateFormatDayLen) < $1.str.suffix(Constants.dateFormatDayLen)
        }
        
        return dates
    }
}
