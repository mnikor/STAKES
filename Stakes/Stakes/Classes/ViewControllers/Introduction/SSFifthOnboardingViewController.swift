//
//  SSFifthOnboardingViewController.swift
//  Stakes
//
//  Created by Anton Klysa on 3/20/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit
import CoreData

final class SSFifthOnboardingViewController: SSBaseViewController {
    
    
    //MARK: props
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tableViewControl: TableViewControl!
    private var levels: [Level] {
        return SSLevelsManager.instance.levels
    }

    
    
    //MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(levels)

        var dataSourceArray: [Level] = []
        for type in LevelsType.types {
            let level = Level(type: type)
            dataSourceArray.append(level)
        }
        
        dataSourceArray[0].status = .active
        dataSourceArray[1].status = .progress
        dataSourceArray[1].image = "advanced_active"
        dataSourceArray[1].completionPercentage = 80
        dataSourceArray[2].image = "serialAchiever_active"
        dataSourceArray[3].image = "pro_active"
        dataSourceArray[4].image = "grandmaster_active"

        
        // Init TableControl
        tableViewControl = TableViewControl(tableView: tableView, cellID: SSLevelsTableViewCell.reuseID)
        tableViewControl.sections = [Section(dataSource: dataSourceArray)]
        tableView.reloadData()
        
        settingsUI()
    }
    
    
    //MARK: private funcs
    
    private func settingsUI() {
        
        // TableView
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        // For small iPhone's screens
        if tableView.frame.height + 100 < view.frame.height {
            tableView.isScrollEnabled = false
        }
    }
    
    
}
