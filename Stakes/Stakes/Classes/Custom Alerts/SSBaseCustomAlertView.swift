//
//  SSBaseCustomAlertView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/13/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit


@objc protocol SSCustomAlertActionDelegate {
    
    // Required func
    func closeCustomAlert()
    
    // Optional func
    @objc optional func actionCustomAlert()
}


class SSBaseCustomAlertView: UIView {
    
    
    // MARK: Delegate
    weak var delegate: SSCustomAlertActionDelegate?
}
