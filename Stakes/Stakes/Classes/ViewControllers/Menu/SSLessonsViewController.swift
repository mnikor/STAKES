//
//  SSLessonsViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/12/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSLessonsViewController: SSBaseViewController {
    
    
    // MARK:  - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    
    
    // MARK:  - Private properties
    private var collectionViewControl: CollectionViewControl!
    
    
    // MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init CollectionViewControl
        let cellSize: CGSize = CGSize(width: 90.0, height: 122.0)
        collectionViewControl = CollectionViewControl(collectionView: collectionView,
                                                      cellID: SSLessonsCollectionViewCell.reuseID,
                                                      and: cellSize)
        collectionViewControl.minimumInteritemSpacing = 10.0
        collectionViewControl.minimumLineSpacing = 10.0
        
        if SSLessonsManager.instance.lessonsArray.count > 12 {
        SSLessonsManager.instance.lessonsArray.removeSubrange(12...SSLessonsManager.instance.lessonsArray.count - 1)
        }
        
        
        collectionViewControl.dataSource = SSLessonsManager.instance.lessonsArray
        collectionViewControl.parentVC = self
        
        self.setTitle("Lessons")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SSLessonsManager.instance.updateTrackingLesson()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        settingsUI()
    }
    
    
    // MARK:  - Action funcs
    @IBAction func tappedInfoButton(_ sender: UIButton) {
        SSMessageManager.showCustomAlertWith(message: .knowledge, onViewController: self)
    }
    
    @IBAction func tappedLockButton(_ sender: UIButton) {
        
        SSAnalyticsManager.logEvent(.unlockPressed)
        
        SSMessageManager.showCustomAlertWithAction(message: .unlockLesson, onViewController: self) { [weak self] in
            
            self?.collectionView.reloadData()
            self?.disableLockButton()
        }
    }
    
    
    // MARK:  - Private funcs
    private func settingsUI() {
        
        // Lock button settings. NOTE: keyImageView must be last in footerView.subviews
        let keyImage = UIImageView(image: UIImage(named: "key")?.withRenderingMode(.alwaysTemplate))
        keyImage.frame.size = CGSize(width: 38.0, height: 34.0)
        keyImage.tintColor = UIColor.colorFrom(colorType: .red)
        footerView.addSubview(keyImage)
        
        keyImage.translatesAutoresizingMaskIntoConstraints = false
        keyImage.centerXAnchor.constraint(equalTo: lockButton.centerXAnchor).isActive = true
        keyImage.centerYAnchor.constraint(equalTo: lockButton.centerYAnchor).isActive = true
        keyImage.widthAnchor.constraint(equalToConstant: 38).isActive = true
        keyImage.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        keyImage.center = lockButton.center
        lockButton.backgroundColor = .clear
        disableLockButton()
    }
    
    private func disableLockButton() {
        
        // If all Lessons were unlocked
        if SSLessonsManager.instance.trackingLesson == nil {
            
            lockButton.isEnabled = false
            if let keyImage = footerView.subviews.last as? UIImageView {
                keyImage.tintColor = .lightGray
            }
        }
    }
}
