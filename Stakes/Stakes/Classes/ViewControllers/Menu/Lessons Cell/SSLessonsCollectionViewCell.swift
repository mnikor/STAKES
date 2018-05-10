//
//  SSLessonsCollectionViewCell.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/12/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSLessonsCollectionViewCell: UICollectionViewCell {
    
    
    // MARK:  - Outlets
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lockImageViewConstaint: NSLayoutConstraint!
    
    
    // MARK:   - Private properties
    private weak var viewController: UIViewController?
    private var lesson: Lesson!
}


// MARK:   - CollectionViewCellProtocol

extension SSLessonsCollectionViewCell: CollectionViewCellProtocol {
    
    var parentVC: UIViewController? {
        set {
            viewController = newValue
        }
        get {
            return viewController
        }
    }
    
    func configure(withModel model: AnyObject) -> UICollectionViewCell {
        
        guard let tLesson = model as? Lesson else { return self }
        lesson = tLesson
        
        mainImageView.image = tLesson.mainImage
        lockImageView.image = tLesson.lockImage
        titleLabel.text = tLesson.title
        let str = NSMutableAttributedString(string: tLesson.title!)
        
        for i in 0..<tLesson.title!.count {
            let startIndex = tLesson.title!.index(tLesson.partialTitle.startIndex, offsetBy: i)
            let endIndex = tLesson.title!.index(tLesson.partialTitle.startIndex, offsetBy: i)
            if tLesson.title![startIndex...endIndex].lowercased() != tLesson.title![startIndex...endIndex] {
                let range: NSRange = NSMakeRange(i, 1)
                str.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15), range: range)
            }
        }
        
        titleLabel.attributedText = str
        
        titleLabel.isHidden = tLesson.isLocked
        lockImageView.isHidden = !tLesson.isLocked
        if lockImageView.isHidden {
            lockImageViewConstaint.constant = 16
        } else {
            lockImageViewConstaint.constant = 28
        }
        
        if tLesson.isTracking {
            titleLabel.isHidden = false
            titleLabel.text = tLesson.partialTitle
        }
        
        return self
    }
    
    func didSelectActionInCell() {
        
        if !lesson.isLocked {
            
            SSAnalyticsManager.logEvent(stringEvent: "The lesson \((lesson.content)!) was opened")
            
            let detailLessonsVC = SSDetailLessonsViewController.instantiate(.menu) as! SSDetailLessonsViewController
            detailLessonsVC.content = lesson.content
            viewController?.navigationController?.pushViewController(detailLessonsVC, animated: true)
        }
    }
}
