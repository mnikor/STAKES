//
//  SSDueDateTextField.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/13/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSDueDateTextField: SSBaseTextField {
    
    
    // MARK: Public Properties
    let datePicker = UIDatePicker()
    var selectedDate = Date()
    
    
    // MARK: Private Properties
    private let locale = Locale.current
    private let timeZone = TimeZone.current
    
    
    // MARK: Overriden funcs
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        tintColor = .clear
        configDatePicker()
    }
    
    
    // MARK: Private funcs
    private func configDatePicker(){
        
        // Date Formate
        datePicker.datePickerMode = .date
        datePicker.timeZone = timeZone
        datePicker.locale = locale
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action:  #selector(self.dateSelected), for: UIControlEvents.valueChanged)
        
        inputView = datePicker
    }
    
    private func formatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatter.dateFormat = "MMMM dd YYYY"
        return formatter.string(from: date)
    }
    
    private func additionFor(_ dateText: String) -> String {
        
        let dateParts = dateText.components(separatedBy: " ")
        if dateParts.count == 3 {
            return "\(dateParts[0])  \(dateParts[1])th, \(dateParts[2])"
        } else {
            return dateText
        }
    }
    
    // MARK: Button actions
    @IBAction func dateSelected(_ sender: UIDatePicker) {
        selectedDate = sender.date
        text = additionFor(formatter(date: selectedDate))
    }
}
