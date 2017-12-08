//
//  SSSelectedGoalTableViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSSelectedGoalTableViewController: UITableViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var nextActionLabelCell: SSBaseTableViewCell!
    @IBOutlet weak var nextActionUnderlineView: SSUnderlineView!
    
    
    // MARK: Private Properties
    private let firstCellName = SSHomeTableViewCell.reuseID
    private let secondCellName = SSActionPlanTableViewCell.reuseID
    
    
    // MARK: Public Properties
    var goal: Goal?
    var actions: [Action] {
        return goal != nil ? goal!.getActions() : [Action]()
    }
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table cell class from nib
        let cellNib = UINib(nibName: firstCellName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: firstCellName)
        let cellShortNib = UINib(nibName: secondCellName, bundle: nil)
        tableView.register(cellShortNib, forCellReuseIdentifier: secondCellName)
        
        settingsUI()
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard actions.count != 0 else {
            return UITableViewCell()
        }
        let separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: firstCellName, for: indexPath) as! SSHomeTableViewCell
            cell.configCellBy(goal!)
            cell.deleteCompleteButton.backgroundColor = UIColor(cgColor: cell.deleteCompleteButton.layer.borderColor!)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: secondCellName, for: indexPath) as! SSActionPlanTableViewCell
            cell.configCellBy(actions.first!, at: indexPath)
            cell.separatorInset = separatorInset
            return cell
        default:
            for view in nextActionLabelCell.contentView.subviews {
                if let cellLabel = view as? SSBaseLabel {
                    cellLabel.textColor = UIColor.fromRGB(rgbValue: 0x4A90E2)
                }
            }
            nextActionLabelCell.separatorInset = separatorInset
            return nextActionLabelCell
        }
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let homeVC = UIStoryboard.getSlideMenuController()
            self.present(homeVC, animated:true, completion: nil)
            CFRunLoopWakeUp(CFRunLoopGetCurrent())
        case 1:
            openCreateActionVC(editAction: actions.first)
        default: break
        }
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        nextActionUnderlineView.setCustomColor(color: .underlineView, alpha: 0.43)
        
        tableView.tableFooterView = UIView()
    }
    
    private func openCreateActionVC(editAction: Action?) {
        
        let createActionVC = UIStoryboard.ssInstantiateVC(.home, typeVC: .createActionVC) as! SSCreateActionViewController
        createActionVC.goal = goal
        createActionVC.editAction = editAction
        navigationController?.pushViewController(createActionVC, animated: true)
    }
}
