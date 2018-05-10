//
//  SSBaseDetailViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/24/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSBaseDetailViewController: SSBaseViewController {
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createCirclesBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "left_arrow"), style: .plain, target: self, action: #selector(self.backAction))
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.leftBarButtonItem?.tintColor = .darkGray
    }
    
    
    // MARK: Action funcs
    
    // Navigation Controller left button back action
    @objc func backAction() {
        if navigationController?.viewControllers.count == 1 {
            navigationController?.topViewController?.dismiss(animated: true, completion: nil)
        } else {
           navigationController?.popViewController(animated: true)
        }
    }
}
