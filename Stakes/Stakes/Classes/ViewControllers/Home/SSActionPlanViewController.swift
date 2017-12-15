//
//  SSActionPlanViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSActionPlanViewController: SSBaseDetailViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var containerViewTop: UIView!
    @IBOutlet weak var tableViewBottom: UITableView!
    @IBOutlet weak var expandConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var expandConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var emptyActionPlanView: UIView!
    @IBOutlet weak var deleteCompleteView: UIView!
    @IBOutlet weak var tipLabel: SSBaseLabel!
    @IBOutlet weak var expandButton: SSCenterActionButton!
    @IBOutlet weak var titleUnderlineView: SSUnderlineView!
    
    
    // MARK: Public Properties
    var goal: Goal?
    var isExpanded = false
    
    
    // MARK: Private Properties
    private var selectedCellCircleButton: SSSelectCircleButton?
    
    var showEmptyView: Bool {
        return actions.count == 0
    }
    private var actions: [Action] {
        return goal != nil ? goal!.getActions() : [Action]()
    }
    private var tableViewTop: UITableView {
        return containerViewTop.subviews.first as! UITableView
    }
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table cell class from nib
        let cellNib = UINib(nibName: SSActionPlanTableViewCell.reuseID, bundle: nil)
        tableViewBottom.register(cellNib, forCellReuseIdentifier: SSActionPlanTableViewCell.reuseID)
        
        settingsUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUIAfterAction()
        showHideEptyView()
        expandAction()
        tableViewTop.isHidden = isExpanded
        
        // Delegate for Cells from tableViewTop
        for cell in tableViewTop.visibleCells {
            let cellWithCircle = cell as? SSBaseTableViewCell
            cellWithCircle?.delegate = self
        }
    }
    
    // Pass Goal to Container View with Top table view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SSSelectedGoalTableViewController.reuseID {
            if let expandVC = segue.destination as? SSSelectedGoalTableViewController {
                expandVC.goal = goal
            }
        }
    }
    
    // Navigation Controller left button back action
    override func backAction() {
        
        if let homeVC = navigationController?.viewControllers.first{
            navigationController?.popToViewController(homeVC, animated: true)
        }
    }
    
    
    // MARK: Action funcs
    
    // Delete Goal action on DeleteCompleteView
    @IBAction func tappedDeleteButton(_ sender: SSBaseButton) {
        
        if selectedCellCircleButton?.typeButton == SSCircleButtonType.goal {
            
            SSMessageManager.showCustomAlertWithAction(title: .warning,
                                                       and: .goalDeleted,
                                                       onViewController: self,
                                                       action: { self.delete(isGoal: true) })
        } else {
            SSMessageManager.showCustomAlertWithAction(title: .warning,
                                                       and: .actionDeleted,
                                                       onViewController: self,
                                                       action: { self.delete(isGoal: false) })
        }
        
        updateUIAfterAction()
    }
    
    // Complete Goal action on DeleteCompleteView
    @IBAction func tappedCompleteButton(_ sender: SSBaseButton) {
        
        if let selectedAction = selectedCellCircleButton?.selectedAction {
            
            selectedAction.changeStatus(.complete)
            if goal?.calculateСompletion() == 100 {
                SSMessageManager.showMainCustomAlertWith(title: .success, and: .goalAchieved, onViewController: nil)
            } else {
                SSMessageManager.showCustomAlertWith(type: .completeAction, onViewController: self)
            }
        } else {
            
            goal?.changeStatus(.complete)
            SSMessageManager.showMainCustomAlertWith(title: .success, and: .goalAchieved, onViewController: nil)
        }
        
        updateUIAfterAction()
    }
    
    // Right Button action Create Action rightButtonActionShare
    @objc func rightButtonActionCreate(_ sender: UIButton) {
        
        openCreateActionVC(editAction: nil)
    }
    
    // Right Button action Share
    @objc func rightButtonActionShare(_ sender: UIButton) {
        
        SSMessageManager.showCustomAlertWith(type: .shareGoal, onViewController: self)
    }
    
    // Expand/Reduce Actions
    @IBAction func tappedExpandButton(_ sender: SSCenterActionButton) {
        
        if isExpanded { tableViewTop.isHidden = !isExpanded }
        isExpanded = !isExpanded
        
        showDeleteCompleteView(false)
        showCreateActionButton()
        UIView.animate(withDuration: 0.5, animations: {
            self.expandAction()
            self.view.layoutIfNeeded()
        }) { (bool) in
            if bool { self.tableViewTop.isHidden = self.isExpanded }
        }
    }
    
    // MARK: Private funcs
    private func settingsUI() {
        
        titleUnderlineView.setCustomColor(color: .underlineView, alpha: 0.43)
        tipLabel.textColor = UIColor.colorFrom(colorType: .light)
        
        self.setTitle("Action Plan")
        self.createCirclesBackground()
        
        tableViewBottom.tableFooterView = UIView()
        tableViewBottom.backgroundColor = .clear
        
        for view in deleteCompleteView.subviews {
            guard let button = view as? SSBaseButton else { return }
            button.makeBorder(width: .small, color: button.titleColor(for: .normal)!)
        }
    }
    
    private func showDeleteCompleteView(_ bool: Bool) {
        
        deleteCompleteView.isHidden = !bool
        rightActionButton.isHidden = bool
        selectedCellCircleButton?.isSelectedView = bool
    }
    
    private func delete(isGoal: Bool) {
        
        // Delete selected action or goal from Core Data
        if isGoal {
            // Delete Goal
            goal?.deleteGoal()
        } else {
            // Delete Action
            goal!.delete(selectedCellCircleButton!.selectedAction!)
        }
        
        //TableView reloadData after deleteRows animation finished
        let tableView = (isExpanded ? tableViewBottom : tableViewTop)!
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
            self.tableViewTop.reloadData()
            self.tableViewBottom.reloadData()
        })
        
        tableView.beginUpdates()
        
        if isExpanded {
            tableView.deleteRows(at: [selectedCellCircleButton!.indexPath], with: .left)
        }
        
        tableView.endUpdates()
        
        CATransaction.commit()
        
        self.updatePointsLabel()
        showHideEptyView()
    }
    
    private func expandAction() {
        
        let buttonTitle = isExpanded ? "Collapse Actions" : "Expand Actions"
        expandButton.setTitle(buttonTitle, for: .normal)
        
        expandConstraintTop.constant = isExpanded ? 0.0 : -454
        expandConstraintBottom.constant = isExpanded ? 68.0 : 193.0
    }
    
    private func openCreateActionVC(editAction: Action?) {
        
        let createActionVC = UIStoryboard.ssInstantiateVC(.home, typeVC: .createActionVC) as! SSCreateActionViewController
        createActionVC.goal = goal
        createActionVC.editAction = editAction
        navigationController?.pushViewController(createActionVC, animated: true)
    }
    
    private func showHideEptyView() {
        
        emptyActionPlanView.isHidden = !showEmptyView
        expandButton.isHidden = showEmptyView
        containerViewTop.isHidden = showEmptyView
        showCreateActionButton()
    }
    
    private func showCreateActionButton() {
        
        // Clear actions for rightActionButton
        rightActionButton.removeTarget(nil, action: nil, for: .allEvents)
        
        if showEmptyView || isExpanded {
            
            rightActionButton.setImage(UIImage(named: "red_plus"), for: .normal)
            rightActionButton.addTarget(self, action: #selector(rightButtonActionCreate), for: .touchUpInside)
        } else {
            let shareImage = UIImage(named: "share")
            
            rightActionButton.imageView?.tintColor = UIColor.colorFrom(colorType: .red)
            rightActionButton.setImage(shareImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            rightActionButton.addTarget(self, action: #selector(rightButtonActionShare), for: .touchUpInside)
        }
        view.addSubview(rightActionButton)
    }
    
    // Update Points Label, DeleteCompleteView and TableViews
    private func updateUIAfterAction() {
        
        tableViewBottom.reloadData()
        tableViewTop.reloadData()
        updatePointsLabel()
        showDeleteCompleteView(false)
    }
}


// MARK:Table View Data Source

extension SSActionPlanViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TODO: Config Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: SSActionPlanTableViewCell.reuseID, for: indexPath) as! SSActionPlanTableViewCell
        cell.configCellBy(actions[indexPath.row], at: indexPath)
        cell.delegate = self
        
        return cell
    }
}


// MARK: Table View Delegate
extension SSActionPlanViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        openCreateActionVC(editAction: actions[indexPath.row])
    }
}


// MARK: Select Goal by Right Circle

extension SSActionPlanViewController: SSSelectCircleButtonDelegate {
    
    func selectCircleButton(_ sender: SSSelectCircleButton) {
        
        if selectedCellCircleButton != sender {
            selectedCellCircleButton?.isSelectedView = false
        }
        
        selectedCellCircleButton = sender
        showDeleteCompleteView(sender.isSelectedView)
    }
}
