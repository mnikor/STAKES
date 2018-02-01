//
//  SSSelectedGoalViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 1/5/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSSelectedGoalViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var nextActionLabel: SSBaseLabel!
    @IBOutlet weak var underlineView: SSUnderlineView!
    @IBOutlet weak var goalCellView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nextActionCellView: UIView!
    
    
    // MARK: Public Properties
    var cells = [SSBaseTableViewCell]()
    var goal: Goal?
    var actions: [Action] {
        return goal != nil ? goal!.getActionsSortByStatus() : [Action]()
    }
    var hasActions: Bool {
        return actions.count != 0
    }
    
    
    // MARK: Private Properties
    private let goalCell = UINib(nibName: SSHomeTableViewCell.reuseID, bundle: nil).instantiate(withOwner: self, options: nil)[0] as! SSHomeTableViewCell
    private let actionCell = UINib(nibName: SSActionPlanTableViewCell.reuseID, bundle: nil).instantiate(withOwner: self, options: nil)[0] as! SSActionPlanTableViewCell
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        settingsUI()
        
        cells.append(goalCell)
        cells.append(actionCell)
        
    }
    
    func add(_ cell: UITableViewCell, viewCell: UIView) {
        
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        viewCell.addSubview(cell)
        
        NSLayoutConstraint.activate([
            cell.contentView.leftAnchor.constraint(equalTo: viewCell.leftAnchor),
            cell.contentView.rightAnchor.constraint(equalTo: viewCell.rightAnchor),
            cell.contentView.topAnchor.constraint(equalTo: viewCell.topAnchor),
            cell.contentView.bottomAnchor.constraint(equalTo: viewCell.bottomAnchor)
            ])
 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        settingsUI()
        guard hasActions else { return }
        
        goalCell.backgroundColor = .clear
        actionCell.backgroundColor = .clear
        add(goalCell, viewCell: goalCellView)
        add(actionCell, viewCell: nextActionCellView)
        updateCells()
    }
    
    
    // MARK: Action funcs
    @IBAction func goalCellTapped(_ sender: UITapGestureRecognizer) {
        
        openEditGoalVC(editGoal: goal)
    }
    
    @IBAction func actionCellTapped(_ sender: UITapGestureRecognizer) {
        
        openEditActionVC(editAction: actions.first)
    }
    
    
    // MARK: Public funcs
    func updateCells() {
        
        guard hasActions else { return }
        
        goalCell.configCellBy(goal!)
        actionCell.configCellBy(actions.first!)
        goalCell.editButton.isEnabled = false
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        middleView.isHidden = !hasActions
        bottomView.isHidden = !hasActions
        underlineView.setCustomColor(color: .underlineView, alpha: 0.43)
        nextActionLabel.textColor = UIColor.colorFrom(colorType: .nextAction)
        bottomView.backgroundColor = UIColor.colorFrom(colorType: .defaultBlack).withAlphaComponent(0.15)
    }
    
    private func openEditActionVC(editAction: Action?) {
        
        let editActionVC = SSCreateActionViewController.instantiate(.home) as! SSCreateActionViewController
        editActionVC.goal = goal
        editActionVC.editAction = editAction
        navigationController?.pushViewController(editActionVC, animated: true)
    }
    
    private func openEditGoalVC(editGoal: Goal?) {
        
        let editGoalVC = SSCreateGoalViewController.instantiate(.home) as! SSCreateGoalViewController
        editGoalVC.editGoal = editGoal
        navigationController?.pushViewController(editGoalVC, animated: true)
    }
}
