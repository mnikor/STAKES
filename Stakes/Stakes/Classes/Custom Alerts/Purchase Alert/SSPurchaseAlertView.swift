//
//  SSPurchaseAlertView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 1/10/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSPurchaseAlertView: SSBaseCustomAlertView {
    
    
    // MARK: Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var descriptionLabel: SSBaseLabel!
    @IBOutlet weak var confirmPurchaseButton: SSCenterActionButton!
    @IBOutlet weak var alertImageView: UIImageView!
    
    
    // MARK: Public Properties
    var goal: Goal?
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadFromNib()
        settingsUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.loadFromNib()
        settingsUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bounds = contentView.bounds
    }
    
    
    // MARK: Actions funcs
    @IBAction func tappedConfirmButton(_ sender: SSCenterActionButton) {
        
        confirmPurchaseButton.isUserInteractionEnabled = false
        let ignoreError = "Cannot connect to iTunes Store"
        
        // Purchase
        for action in goal!.getActionsForPurchase() {
            
            guard let id = SSConstants.getPurchaseID(action.stake) else {
                
                SSMessageManager.showAlertWith(title: .error, and: .error, onViewController: nil)
                confirmPurchaseButton.isUserInteractionEnabled = true
                return
            }
            
            SSPurchaseManager.shared.purchaseProduct(productId: id, completion: { [weak self] error in
                
                if let error = error {
                    
                    if error.localizedDescription != ignoreError {
                        SSMessageManager.showAlertWith(error: error, onViewController: nil)
                    }
                    self?.confirmPurchaseButton.isUserInteractionEnabled = true
                    return
                }
                
                action.isPurchased = true
                if self?.goal!.getActionsForPurchase().count == 0 {
                    
                    self?.goal?.changeStatus(.wait)
                    self?.delegate?.closeCustomAlert()
                }
            })
        }
    }
    
    @IBAction func tappedCloseAlertButton(_ sender: UIButton) {
        self.delegate?.actionCustomAlert!()
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        let mainColor = UIColor.colorFrom(colorType: .blackTitleAlert)
        
        descriptionLabel.textColor = mainColor
        confirmPurchaseButton.titleColor = mainColor
    }
}
