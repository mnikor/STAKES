//
//  SSLevelsTableViewCell.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/15/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSLevelsTableViewCell: UITableViewCell {
    
    
    weak var viewController: UIViewController?
    
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var progressView: BRCircularProgressView!
    @IBOutlet weak var statusImageView: UIImageView!
}

extension SSLevelsTableViewCell: TableViewCellProtocol {
    
    var parentVC: UIViewController? {
        get {
            return viewController
        }
        set {
            viewController = newValue
        }
    }
    
    func configure(withModel model: AnyObject, forSection: Int) -> UITableViewCell {
        guard let level = model as? Level else { return self }
        
        // Set values
        isUserInteractionEnabled = false
        titleLabel.text = level.title
        descriptionLabel.text = level.description
        levelImageView.image = UIImage(named: level.image)
        
        // Hide/Show elements
        tipLabel.isHidden = !level.isCurrentLevel
        progressView.isHidden = level.status != .progress
        
        // Set status images
        switch level.status {
        case .active:
            statusImageView.image = UIImage(named: "level_done")
        case .disable:
            statusImageView.image = UIImage(named: "level_locked")
        case .progress:
            
            let percent: Int = level.completionPercentage
            let progress: CGFloat = CGFloat(percent) / 100
            let circleColor = UIColor.fromRGB(rgbValue: 0xC4C4C4)
            let lightColor = UIColor.fromRGB(rgbValue: 0xE8E7E7)
            let progressFont = UIFont(name: SSConstants.fontType.helvetica.rawValue, size: 10.0)!
            
            progressView.progress = progress
            progressView.setCircleStrokeWidth(2)
            progressView.setProgressText(String(percent) + "%")
            progressView.setProgressTextFont(progressFont, color: circleColor)
            progressView.setCircleStrokeColor(circleColor,
                                              circleFillColor: .white,
                                              progressCircleStrokeColor: circleColor,
                                              progressCircleFillColor: lightColor)
        }
        
        return self
    }
}
