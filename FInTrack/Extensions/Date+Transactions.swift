//
//  Date+Transactions.swift
//  FInTrack
//
//  Created by Karan Khullar on 07/10/24.
//

import Foundation


extension Date {
    
    var year: Int {
        Calendar.current.dateComponents([.year], from: self).year ?? 1
    }
    
    var month: Int {
        Calendar.current.dateComponents([.month], from: self).month ?? 1
    }
    var dateNumber: Int {
        Calendar.current.dateComponents([.day], from: self).day ?? 0
    }
    
    var monthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    static func monthString(from month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM" // Full month name
        return dateFormatter.string(from: Calendar.current.date(from: DateComponents(year: 2020, month: month))!)
    }
    
    static func getStartAndEndDates(year: Int, month: Int) -> (startDate: Date, endDate: Date)? {
        var components = DateComponents()
        components.year = year
        components.month = month
        
        // Get the start date (first day of the month)
        guard let startDate = Calendar.current.date(from: components) else {
            return nil
        }
        
        // Get the range of days in the month
        let range = Calendar.current.range(of: .day, in: .month, for: startDate)
        let endDay = range?.count ?? 0
        
        // Create the end date (last day of the month) with time set to 23:59:59
        components.day = endDay
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        guard let endDate = Calendar.current.date(from: components) else {
            return nil
        }
        
        return (startDate, endDate)
    }
    
}
