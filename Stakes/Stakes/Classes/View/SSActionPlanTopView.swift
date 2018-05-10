//
//  SSActionPlanTopView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 2/23/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSActionPlanTopView: UIView {
    
    
    // MARK: Outlets
    @IBOutlet weak var topViewGoalSection: UIView!
    @IBOutlet weak var topViewActionSection: UIView!
    @IBOutlet weak var topViewMiddleSection: UIView!
    @IBOutlet weak var topViewSeparateSection: UIView!
    @IBOutlet weak var nextActionLabel: SSBaseLabel!
    @IBOutlet weak var underlineView: SSUnderlineView!
    
    
    // MARK: Public Properties
    var hideTopView: Bool = false {
        didSet {
            self.subviews.forEach { $0.isHidden = hideTopView }
        }
    }
    
    
    // MARK: Private Properties
    private var goal: Goal!
    private weak var controller: UIViewController?
    private let goalCell = UINib(nibName: GoalWithImageHomeTableViewCell.reuseID, bundle: nil).instantiate(withOwner: self, options: nil)[0] as! GoalWithImageHomeTableViewCell
    private let actionCell = UINib(nibName: SSActionPlanTableViewCell.reuseID, bundle: nil).instantiate(withOwner: self, options: nil)[0] as! SSActionPlanTableViewCell
    
    private var actions: [Action] {
        return goal != nil ? goal!.getActionsSortByStatus() : [Action]()
    }
    private var hasActions: Bool {
        return actions.count != 0
    }
    
    
    // MARK: Public funcs
    
    // Make Top Table View
    func settingsTopContentViewFor(_ vc: SSSelectCircleButtonDelegate, selectedGoal: Goal) {
        
        goal = selectedGoal
        controller = vc as? SSActionPlanViewController
        backgroundColor = .clear
        
        goalCell.delegate = vc
        actionCell.delegate = vc
        goalCell.backgroundColor = .clear
        actionCell.backgroundColor = .clear
        
        underlineView.setCustomColor(color: .underlineView, alpha: 0.43)
        nextActionLabel.textColor = UIColor.colorFrom(colorType: .nextAction)
        topViewSeparateSection.backgroundColor = UIColor.colorFrom(colorType: .defaultBlack).withAlphaComponent(0.15)
    }
    
    func getCurrentViewHeight() -> CGFloat? {
        
        guard hasActions else { return nil }
        
        goalCell.configCellBy(goal!)
        actionCell.configCellBy(actions.first!)
        goalCell.editButton.isEnabled = false
        
        // Insert Cell to View
        insert(cell: goalCell, to: topViewGoalSection)
        insert(cell: actionCell, to: topViewActionSection)
        
        // Calculate Height Constant and Update Top View Height
        topViewGoalSection.frame.size.height = goalCell.adaptiveContentView.frame.height
        
        return topViewGoalSection.frame.height + topViewMiddleSection.frame.height + topViewActionSection.frame.height
    }
    
    
    // MARK: Action funcs
    
    // Tapped Action Cell in Top View
    @IBAction func actionCellTapped(_ sender: UITapGestureRecognizer) {
        
        let createActionVC = SSCreateActionViewController.instantiate(.home) as! SSCreateActionViewController
        createActionVC.goal = goal
        createActionVC.editAction = actions.first
        controller?.navigationController?.pushViewController(createActionVC, animated: true)
    }
    
    // Tapped Goal Cell in Top View
    @IBAction func goalCellTapped(_ sender: UITapGestureRecognizer) {
        
        let editGoalVC = SSCreateGoalViewController.instantiate(.home) as! SSCreateGoalViewController
        editGoalVC.editGoal = goal
        controller?.navigationController?.pushViewController(editGoalVC, animated: true)
    }
    
    
    // MARK: Private funcs
    private func insert(cell: UITableViewCell, to viewCell: UIView) {
        
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        if viewCell.subviews.count == 1 {
            viewCell.subviews.first?.removeFromSuperview()
        }
        viewCell.addSubview(cell)
        
        NSLayoutConstraint.activate([
            cell.contentView.leftAnchor.constraint(equalTo: viewCell.leftAnchor),
            cell.contentView.rightAnchor.constraint(equalTo: viewCell.rightAnchor),
            cell.contentView.topAnchor.constraint(equalTo: viewCell.topAnchor),
            cell.contentView.bottomAnchor.constraint(equalTo: viewCell.bottomAnchor)
            ])
    }
}
