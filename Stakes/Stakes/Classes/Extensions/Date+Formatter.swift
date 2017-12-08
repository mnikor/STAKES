//
//  Date+Formatter.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/21/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation

extension Date {
    
    // MARK: Date Formats
    enum SSDateFormat: String {
        case monthDayYear = "MMMM dd YYYY"
        case weekdayDayMonthYear = "EEEE dd MMMM YYYY"
    }
    
    
    // MARK: Date formatter for Current Locale and TimeZone
    static func formatter(date: Date, with format: SSDateFormat) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
    
    
    // MARK: Amount days between two date
    static func daysBetween(firstDate: Date, and secondDate: Date) -> Int {
        
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day ?? 0
    }
}
