//
//  DateUtil.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 2/2/25.
//

import Foundation

class DateUtil {
    
    enum Constants {
        static let dateFormat = "yyyy-MM-dd"
        static let dateFormatDayLen = "MM-dd".count
    }
    
    static func getPastYearDateList() -> [String] {
        let calendar = Calendar.current
        let today = Date()
        let fromDate = calendar.date(byAdding: DateComponents(year: -1, day: -1), to: today)!
        let toDate = calendar.date(byAdding: .day, value: -1, to: today)!

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = Constants.dateFormat

        var dateStrs: [String] = []
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        calendar.enumerateDates(startingAfter: fromDate, matching: components, matchingPolicy: .nextTime) { date, strict, stop in
            guard let date = date else { return }
            
            guard date <= toDate else {
                stop = true
                return
            }
            
            dateStrs.append(dateFormatter.string(from: date))
        }
        
        dateStrs.sort {
            $0.suffix(Constants.dateFormatDayLen) < $1.suffix(Constants.dateFormatDayLen)
        }
        
        return dateStrs
    }
}
