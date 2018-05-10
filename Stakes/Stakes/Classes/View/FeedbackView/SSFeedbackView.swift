//
//  SSFeedbackView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/7/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit
import MessageUI

class SSFeedbackView: UIView {
    
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: SSBaseLabel!
    @IBOutlet weak var textViewPlaceholderLabel: SSBaseLabel!
    @IBOutlet weak var feedbackTextView: SSFeedbackTextView!
    @IBOutlet weak var sendButton: SSCenterActionButton!
    @IBOutlet weak var contentView: UIView!
    
    
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
    
    
    // MARK: Action funcs
    @IBAction func tappedSendButton(_ sender: SSCenterActionButton) {
        sendFeedback()
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        feedbackTextView.delegate = self
        
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
            
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            rootVC?.present(mailVC, animated: true, completion: nil)
        } else {
            SSMessageManager.showAlertWith(title: .error, and: .error, onViewController: nil)
        }
    }
}



// MARK: UITextViewDelegate

extension SSFeedbackView: UITextViewDelegate {
    
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

extension SSFeedbackView: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
