//
//  SSExpandViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSExpandViewController: SSBaseViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Private Properties
    private let cellID = "SSExpandViewControllerCell"
    
    
    // MARK: Public Properties
    var goal: Goal!
    
    var actions: [Action] {
        return goal.getActions()
    }
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsUI()
    }
    
    
    // MARK: Action funcs
    @objc func rightButtonAction(_ sender: UIButton) {
        
        // Add new Test Action
        goal.addToActions(goal.createAction(name: "New action", date: Date()))
        tableView.reloadData()
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        rightActionButton.setImage(UIImage(named: "red_plus"), for: .normal)
        rightActionButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        view.addSubview(rightActionButton)
        tableView.tableFooterView = UIView()
    }
}


// MARK:Table View Data Source

extension SSExpandViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = actions[indexPath.row].name
        
        return cell
    }
}
