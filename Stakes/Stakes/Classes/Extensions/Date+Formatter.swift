//
//  Date+Formatter.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/21/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation


// MARK: Date Formats
enum SSDateFormat: String {
    case monthDayYear = "MMMM dd YYYY"
    case weekdayDayMonthYear = "EEEE dd MMMM YYYY"
    case mainFormat = "yyyy/MM/dd"
}


extension Date {
    
    
    // MARK: Date formatter for Current Locale and TimeZone
    static func formatter(date: Date, with format: SSDateFormat) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
    
    // MARK: String from Date with format "Month Day th, Year"
    
    func dateWithFormatToString() -> String {
        
        let dateText = Date.formatter(date: self, with: .monthDayYear)
        let dateParts = dateText.components(separatedBy: " ")
        if dateParts.count == 3 {
            return "\(dateParts[0])  \(dateParts[1])th, \(dateParts[2])"
        } else {
            return dateText
        }
    }
    
    
    // MARK: Add custom Date Time, for saving to Calendar
    func addCustomDateTime() -> Date? {
        
        let userCalendar = Calendar.current
        var components = userCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                         from: self)
        
        components.hour = 9
        components.minute = 00
        components.second = 00
        
        return userCalendar.date(from: components)
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
