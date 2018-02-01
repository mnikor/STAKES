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
    @IBOutlet weak var descriptionLabel: SSBaseLabel!
    @IBOutlet weak var confirmPurchaseButton: SSCenterActionButton!
    
    
    // MARK: Public Properties
    var goal: Goal?
    
    
    // MARK: Private Properties
    private let nibName = "SSPurchaseAlertView"
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
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
                    self?.delegate?.closeCustomAlert()
                }
 
                /*
                if let error = error {
                    SSMessageManager.showAlertWith(error: error, onViewController: nil)
                } else {
                    
                    action.isPurchased = true
                    if self?.goal!.getActionsForPurchase().count == 0 {
                        self?.delegate?.closeCustomAlert()
                    }
                }
                */
            })
        }
    }
    
    @IBAction func tappedCloseAlertButton(_ sender: UIButton) {
        self.delegate?.actionCustomAlert!()
    }
    
    
    // MARK: Private funcs
    
    // Load Xib
    private func xibSetup() {
        
        let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        settingsUI()
    }
    
    private func settingsUI() {
        
        descriptionLabel.textColor = UIColor.colorFrom(colorType: .blackTitleAlert)
    }
}
