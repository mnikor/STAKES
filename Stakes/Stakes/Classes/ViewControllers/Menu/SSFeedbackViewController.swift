//
//  SSFeedbackViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit
import MessageUI
//import StoreKit

class SSFeedbackViewController: SSBaseViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: SSBaseLabel!
    @IBOutlet weak var textViewPlaceholderLabel: SSBaseLabel!
    @IBOutlet weak var feedbackTextView: SSFeedbackTextView!
    @IBOutlet weak var rateButton: SSCenterActionButton!
    @IBOutlet weak var sendButton: SSCenterActionButton!
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackTextView.delegate = self
        
        createCirclesBackground()
        hideKeyboardWhenTappedAround()
        settingsUI()
    }
    
    
    // MARK: Action funcs
    @IBAction func tappedSendButton(_ sender: SSCenterActionButton) {
        sendFeedback()
    }
    
    @IBAction func tappedStarsButton(_ sender: UIButton) {
        rateApp()
    }
    
    @IBAction func tappedRateButton(_ sender: SSCenterActionButton) {
        rateApp()
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        titleLabel.textColor = UIColor.colorFrom(colorType: .blackTitleAlert)
        textViewPlaceholderLabel.textColor = UIColor.colorFrom(colorType: .red).withAlphaComponent(0.5)
        feedbackTextView.makeBorder(width: .small, color: UIColor.colorFrom(colorType: .underlineView))
        checkFeedbackTextView()
    }
    
    private func checkFeedbackTextView() {
        sendButton.isEnabled = !feedbackTextView.isEmpty
        textViewPlaceholderLabel.isHidden = !feedbackTextView.isEmpty
    }
    
    
    private func sendFeedback() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["Boldappme@gmail.com"])
            mailVC.setMessageBody(feedbackTextView.text, isHTML: false)
            mailVC.setSubject("Bold feedback")
            
            present(mailVC, animated: true, completion: nil)
        } else {
            SSMessageManager.showAlertWith(title: .error, and: .error, onViewController: self)
        }
    }
    
    // TODO: Select needed option and paste <Your product url>
    private func rateApp() {
        let app = UIApplication.shared
        
        
        /* --- Option 1
         if #available(iOS 10.3, *) {
         SKStoreReviewController.requestReview()
         }
         */
        
        
        /* --- Option 2
         let appStoreUrlString = "<Your product url>?action=write-review"
         */
        
        
        /* --- Option 3 */
        
        if let url = URL(string: SSConstants.appStoreLink) {
            
            if #available(iOS 10.3, *) {
                
                app.open(url, options: [:], completionHandler: { (status) in
                    
                    if status {
                        print("Rate Success")
                    } else {
                        SSMessageManager.showAlertWith(title: .error, and: .error, onViewController: self)
                    }
                })
                
            } else {
                app.openURL(url)
            }
        } else {
            SSMessageManager.showAlertWith(title: .error, and: .error, onViewController: self)
        }
    }
}


// MARK: UITextViewDelegate

extension SSFeedbackViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        feedbackTextView.textViewDidEndEditing(textView)
        checkFeedbackTextView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return feedbackTextView.setCharactersLimitFor(textView: textView,
                                                      range: range,
                                                      string: text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewPlaceholderLabel.isHidden = true
    }
}


// MARK: MFMailComposeViewControllerDelegate

extension SSFeedbackViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
