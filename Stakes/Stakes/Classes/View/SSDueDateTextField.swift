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
    var selectedDate: Date?
    
    
    // MARK: Private Properties
    private let locale = Locale.current
    private let timeZone = TimeZone.current
    
    
    // MARK: Overriden funcs
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        tintColor = .clear
        configDatePicker()
    }
    
    
    // MARK: Button actions
    @objc func dateSelected(_ sender: UIDatePicker) {
        
        selectedDate = sender.date
        text = selectedDateToString(date: selectedDate!)
    }
    
    @objc func tappedDatePickerDoneButton(_ sender: Any) {
        
        self.resignFirstResponder()
    }
    
    
    // MARK: Public funcs
    
    func selectedDateToString(date: Date) -> String {
        let dateText = Date.formatter(date: date, with: .monthDayYear)
        return self.additionFor(dateText)
    }
    
    // Call in textFieldDidEndEditing func of UITextFieldDelegate
    func setTextFrom(_ textField: UITextField) {
        
        guard selectedDate != nil else {
            selectedDate = Date()
            text = selectedDateToString(date: selectedDate!)
            return
        }
        
        if validate(selectedDate: selectedDate!) {
            text = textField.text
        } else {
            SSMessageManager.showAlertWith(title: .warning, and: .dueDateWarning, onViewController: nil)
            selectedDate = Date()
            text = nil
        }
    }
    
    // Call in shouldChangeCharactersIn func of UITextFieldDelegate
    func setCharactersLimitFor(textField: UITextField, range: NSRange, string: String) -> Bool {
        return false
    }
    
    
    // MARK: Private funcs
    private func validate(selectedDate: Date) -> Bool {
        let userCalendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = userCalendar
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let selectedDateString = dateFormatter.string(from: selectedDate)
        let currentDateString = dateFormatter.string(from: Date())
        
        let selectedFormatterDate = dateFormatter.date(from: selectedDateString)!
        let currentFormatterDate = dateFormatter.date(from: currentDateString)!
        
        return selectedFormatterDate >= currentFormatterDate
    }
    
    private func configDatePicker(){
        
        // Date Formate
        datePicker.datePickerMode = .date
        datePicker.timeZone = timeZone
        datePicker.locale = locale
        datePicker.date = Date()
        datePicker.addTarget(self, action:  #selector(self.dateSelected), for: .valueChanged)
        
        // Create ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Create Done button
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action:  #selector(tappedDatePickerDoneButton))
        
        doneButton.tintColor = UIColor.colorFrom(colorType: .red)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        
        // Add Datepicker and Toolbar to textField
        inputAccessoryView = toolbar
        inputView = datePicker
    }
}
