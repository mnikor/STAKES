//
//  SSCalendarSyncManager.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/15/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation
import EventKit


typealias AddEventCompletion = ((_ id: String?) -> Void)?

class SSCalendarSyncManager {
    
    
    static var isEnableService: Bool {
        return UserDefaults.standard.bool(forKey: SSConstants.keys.kSyncWithCalendar.rawValue)
    }
    
    
    // MARK: Add Event to Calendar
    class func addEventToCalendar(title: String, dueDate: Date, completion: AddEventCompletion = nil)  {
        let eventStore = EKEventStore()
        
        // If service enable
        guard isEnableService else {
            
            completion?(nil)
            return
        }
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
        
            if granted && error == nil {
                
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = dueDate
                event.endDate = dueDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("Save event!")
                } catch let catchError as NSError {
                    
                    completion?(nil)
                    SSMessageManager.showAlertWith(error: catchError, onViewController: nil)
                    return
                }
                completion?(event.eventIdentifier)
            } else {
                completion?(nil)
            }
        })
    }
    
    
    // MARK: Edit Event from Calendar
    class func editEventFromCalendar(title: String, dueDate: Date, eventID: String?) {
        let eventStore = EKEventStore()
        
        // If service enable
        guard isEnableService else { return }
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if !granted { return }
            
            if let event = eventStore.event(withIdentifier: eventID ?? "") {
                
                event.title = title
                event.startDate = dueDate
                event.endDate = dueDate
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("Edit event!")
                } catch let catchError as NSError {
                    print(catchError)
                }
            } else {
                print(error ?? "Event nil")
            }
        })
    }
    
    
    // MARK: Delete Event from Calendar
    class func deleteEventFromCalendar(eventID: String?) {
        let eventStore = EKEventStore()
        
        // If service enable
        guard isEnableService else { return }
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if !granted { return }
            
            if let event = eventStore.event(withIdentifier: eventID ?? "") {
                
                do {
                    try eventStore.remove(event, span: .thisEvent)
                    print("Delete event!")
                } catch let catchError as NSError {
                    print(catchError)
                }
            } else {
                print(error ?? "Event nil")
            }
        }
    }
}
