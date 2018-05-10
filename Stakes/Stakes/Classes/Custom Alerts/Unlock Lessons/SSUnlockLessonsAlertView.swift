//
//  UnlockLessonsAlertView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/12/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSUnlockLessonsAlertView: SSBaseCustomAlertView {
    
    
    // MARK: Prices enum
    enum Price: String {
        case oneLesson, threeLessons, tenLessons
    }
    
    
    // MARK: Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var descriptionLabel: SSBaseLabel!
    @IBOutlet weak var unlockButton: SSCenterActionButton!
    
    @IBOutlet weak var firstPriceLabel: UILabel!
    @IBOutlet weak var firstImageView: UIImageView!
    
    @IBOutlet weak var secondPriceLabel: UILabel!
    @IBOutlet weak var secondImageView: UIImageView!
    
    @IBOutlet weak var thirdPriceLabel: UILabel!
    @IBOutlet weak var thirdImageView: UIImageView!
    
    
    // MARK: Private properties
    private var choosenPrice: Price = .tenLessons
    private var checkmarkImages: [Price : UIImageView] {
        return [.oneLesson : firstImageView,
                .threeLessons : secondImageView,
                .tenLessons : thirdImageView]
    }
    
    
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
    @IBAction func tappedCloseAlertButton(_ sender: UIButton) {
        self.delegate?.closeCustomAlert()
    }
    
    @IBAction func tappedUnlockButton(_ sender: SSCenterActionButton) {
        
        // Disable button while perform Purchase
        unlockButton.isUserInteractionEnabled = false
        
        // Get Purchase ID
        let bundleID = Bundle.main.bundleIdentifier!
        let id = bundleID + "." + choosenPrice.rawValue
        
        SSPurchaseManager.shared.purchaseProduct(productId: id, completion: { [weak self] error in
            
            if let error = error {
                let ignoreError = "Cannot connect to iTunes Store"
                if error.localizedDescription != ignoreError {
                    SSMessageManager.showAlertWith(error: error, onViewController: nil)
                }
                self?.unlockButton.isUserInteractionEnabled = true
                return
            }
            
            // Purchase is completed
            self?.unlockLessonsAfterPurchase()
        })
    }
    
    
    @IBAction func tappedFirstPriceButton(_ sender: UIButton) {
        showCheckmark(for: .oneLesson)
        choosenPrice = .oneLesson
    }
    
    @IBAction func tappedSecondPriceButton(_ sender: UIButton) {
        showCheckmark(for: .threeLessons)
        choosenPrice = .threeLessons
    }
    
    @IBAction func tappedThirdPriceButton(_ sender: UIButton) {
        showCheckmark(for: .tenLessons)
        choosenPrice = .tenLessons
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        // Disable unlockButton if all Lessons unlocked
        if SSLessonsManager.instance.trackingLesson == nil {
            unlockButton.isEnabled = false
        }
    }
    
    // Hide/Show price checkmark image
    private func showCheckmark(for number: Price) {
        for image in checkmarkImages.values {
            image.isHidden = true
        }
        
        checkmarkImages[number]?.isHidden = false
    }
    
    // Logic a unlock Lessons after Purchase
    private func unlockLessonsAfterPurchase() {
        
        // Lessons count for unlock
        var unlockLessonsCount: Int = 0
        switch choosenPrice {
        case .oneLesson: unlockLessonsCount = 1
        case .threeLessons: unlockLessonsCount = 3
        case .tenLessons: unlockLessonsCount = 10
        }
        
        let lessonsCount = SSLessonsManager.instance.lessonsArray.count
        let trackingLesson = SSLessonsManager.instance.trackingLesson!
        let trackingLessonID = trackingLesson.idWrapper
        var nextLessonID = trackingLessonID + 1
        
        // Unlock tracking Lesson
        trackingLesson.setIsLocked(false)
        trackingLesson.setIsTracking(false)
        
        // If need to unlock 3 or 10 lessons
        if unlockLessonsCount > 1 {
            
            for count in 1...unlockLessonsCount {
                
                if trackingLessonID + count <= lessonsCount {
                    
                    // Set next Lesson ID
                    nextLessonID = trackingLessonID + count
                    
                    // Unlock Lesson
                    let nextLesson = Lesson.getLessonBy(id: nextLessonID)
                    nextLesson?.setIsLocked(false)
                }
            }
        }
        
        // Set new Tracking Lesson
        if nextLessonID < lessonsCount {
            let newTrackingLesson = Lesson.getLessonBy(id: nextLessonID)
            newTrackingLesson?.setIsLocked(true)
            newTrackingLesson?.setIsTracking(true)
        }
        
        // Updated collectionView
        self.delegate?.actionCustomAlert!()
    }
}
