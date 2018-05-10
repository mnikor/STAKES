//
//  FeedbackHepler.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/7/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class FeedbackHepler {
    
    static func rateApp(appStoreLink: String) {
        
        let app = UIApplication.shared
        if let url = URL(string: appStoreLink + "&action=write-review") {
            
            if #available(iOS 10.3, *) {
                
                app.open(url, options: [:], completionHandler: { (status) in
                    
                    if status {
                        print("Rate Success")
                    } else {
                        SSMessageManager.showAlertWith(title: .error, and: .error, onViewController: nil)
                    }
                })
                
            } else {
                app.openURL(url)
            }
        } else {
            SSMessageManager.showAlertWith(title: .error, and: .error, onViewController: nil)
        }
    }
}
