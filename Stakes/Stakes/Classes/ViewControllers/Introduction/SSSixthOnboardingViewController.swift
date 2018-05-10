//
//  SSSixthOnboardingViewController.swift
//  Stakes
//
//  Created by Anton Klysa on 3/20/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit
import CoreData

class SSSixthOnboardingViewController: SSBaseViewController {
    
    
    //MARK: props
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var collectionViewControl: CollectionViewControl!
    
    //MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllerProps()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rightActionButton.setImage(UIImage(named: "arrow"), for: .normal)
        rightActionButton.layer.cornerRadius = rightActionButton.frame.height / 2
        rightActionButton.backgroundColor = .clear
        rightActionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        rightActionButton.removeFromSuperview()
    }
    
    
    //MARK: private actions
    
    private func setupControllerProps() {
        // Init CollectionViewControl
        let cellSize: CGSize = CGSize(width: 90.0, height: 122.0)
        collectionViewControl = CollectionViewControl(collectionView: collectionView,
                                                      cellID: SSLessonsCollectionViewCell.reuseID,
                                                      and: cellSize)
        collectionViewControl.minimumInteritemSpacing = 10.0
        collectionViewControl.minimumLineSpacing = 10.0
        var dataSourceArray: [Lesson] = []
        for item in SSLessonsManager.instance.lessonsArray {
            let managerContext = SSCoreDataManager.instance.managedObjectContext
            let lessonObject: Lesson = Lesson(entity: NSEntityDescription.entity(forEntityName: "Lesson", in:managerContext)!, insertInto: managerContext)
            lessonObject.color = item.color
            lessonObject.content = item.content
            lessonObject.goalDate = item.goalDate
            lessonObject.id = item.id
            lessonObject.isLocked = item.isLocked
            lessonObject.isTracking = item.isTracking
            lessonObject.points = item.points
            lessonObject.title = item.title
            dataSourceArray.append(lessonObject)
        }
        dataSourceArray.removeSubrange(3...dataSourceArray.count - 1)
        for item in dataSourceArray {
            item.isLocked = false
            item.points = 100.0
        }
        collectionViewControl.dataSource = dataSourceArray
        collectionViewControl.parentVC = self
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        
        UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.getSlideMenuController()
        rightActionButton.removeFromSuperview()
    }
    
}
