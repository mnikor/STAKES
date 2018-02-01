//
//  SSHomeViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit
import CoreData

class SSHomeViewController: SSBaseViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteCompleteView: UIView!
    @IBOutlet weak var tipLabel: SSBaseLabel!
    
    
    // MARK: Public Properties
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = SSCoreDataManager.instance.fetchedResultsController(entityName: .goal, keyForSort: "date", predicate: ["status": GoalStatusType.wait.rawValue])
    
    
    // MARK: Private Properties
    private var goalsStatus: GoalStatusType = .wait
    private var selectedCellCircleButton: SSSelectCircleButton?
    private var focusedIndexPath = IndexPath(row: 0, section: 0)
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table cell class from nib
        let cellNib = UINib(nibName: SSHomeTableViewCell.reuseID, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: SSHomeTableViewCell.reuseID)
        let cellShortNib = UINib(nibName: SSHomeShortTableViewCell.reuseID, bundle: nil)
        tableView.register(cellShortNib, forCellReuseIdentifier: SSHomeShortTableViewCell.reuseID)
        
        // Points delegate
        points.delegate = self
        
        // CoreData fetch data
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        settingsUI()
        checkMissedGoals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        showDeleteCompleteView(false)
    }
    
    
    // MARK: Action funcs
    
    // Right Button action
    @objc func rightButtonAction(_ sender: UIButton) {
        
        let createGoalVC = SSCreateGoalViewController.instantiate(.home)
        navigationController?.pushViewController(createGoalVC, animated: true)
    }
    
    // Delete Goal action on DeleteCompleteView
    @IBAction func tappedDeleteGoal(_ sender: SSBaseButton) {
        
        // Deleted Goal
        SSMessageManager.showCustomAlertWithAction(message: .goalDeleted, onViewController: self) { [weak self] in self?.deleteGoal() }
    }
    
    // Complete Goal Action on DeleteCompleteView
    @IBAction func tappedCompleteGoal(_ sender: SSBaseButton) {
        
        let selectedGoal = selectedCellCircleButton?.selectedGoal
        
        guard selectedGoal?.status != GoalStatusType.complete.rawValue else {
            SSMessageManager.showAlertWith(title: .error, and: .goalIsAchieved, onViewController: self)
            return
        }
        
        selectedGoal?.changeStatus(.complete)
        SSMessageManager.showCustomAlertWith(message: .goalAchieved, onViewController: self)
        points.updatePointsLabel()
        showDeleteCompleteView(false)
    }
    
    
    // MARK: Public funcs
    func filteredGoalBy(_ status: GoalStatusType) {
        
        fetchedResultsController = SSCoreDataManager.instance.fetchedResultsController(entityName: .goal, keyForSort: "date", predicate: ["status": status.rawValue])
        goalsStatus = status
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        rightActionButton.setImage(UIImage(named: "red_plus"), for: .normal)
        rightActionButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        view.addSubview(rightActionButton)
        
        self.createCirclesBackground()
        self.setTitle("it's")
        
        tipLabel.textColor = UIColor.colorFrom(colorType: .light)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.remembersLastFocusedIndexPath = true
        
        for view in deleteCompleteView.subviews {
            guard let button = view as? SSBaseButton else { return }
            button.makeBorder(width: .small, color: button.titleColor(for: .normal)!)
        }
    }
    
    private func showDeleteCompleteView(_ bool: Bool) {
        
        deleteCompleteView.isHidden = !bool
        rightActionButton.isHidden = bool
        selectedCellCircleButton?.isSelectedView = bool
        
        tipLabel.isHidden = tableView.visibleCells.count != 0 || goalsStatus == .complete
    }
    
    private func deleteGoal() {
        
        points.deduct(50)
        selectedCellCircleButton?.selectedGoal?.deleteGoal()
        
        showDeleteCompleteView(false)
    }
    
    private func openEditGoalVC(editGoal: Goal?) {
        
        let editGoalVC = SSCreateGoalViewController.instantiate(.home) as! SSCreateGoalViewController
        editGoalVC.editGoal = editGoal
        navigationController?.pushViewController(editGoalVC, animated: true)
    }
    
    private func checkMissedGoals() {
        
        let goals: [Goal] = fetchedResultsController.fetchedObjects as! [Goal]
        let filteredArray = goals.filter({ $0.status! == GoalStatusType.wait.rawValue })
        
        for goal in filteredArray {
            
            if goal.checkMissedActions() {
                SSMessageManager.showCustomAlertWith(message: .missedAction, onViewController: self)
            }
            
            /* Uncomment if need to change status for Goal
            let goalDueDate = goal.date! as Date
            if goalDueDate < Date().addCustomDateTime()! {
                
                goal.changeStatus(.missed)
            } else {
                
                if goal.checkMissedActions() {
                    SSMessageManager.showCustomAlertWith(message: .missedAction, onViewController: self)
                }
            }
            */
        }
    }
}


// MARK: Table View Data Source

extension SSHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections, let first = sections.first {
            return first.numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let goal = fetchedResultsController.object(at: indexPath) as! Goal
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SSHomeTableViewCell.reuseID, for: indexPath) as! SSHomeTableViewCell
            cell.configCellBy(goal)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SSHomeShortTableViewCell.reuseID, for: indexPath) as! SSHomeShortTableViewCell
            cell.configCellBy(goal)
            cell.delegate = self
            return cell
        }
    }
}


// MARK: Table View Delegate

extension SSHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 280
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGoal = fetchedResultsController.object(at: indexPath) as! Goal
        focusedIndexPath = indexPath
        
        let actionPlanVC = SSActionPlanViewController.instantiate(.home) as! SSActionPlanViewController
        actionPlanVC.goal = selectedGoal
        
        navigationController?.pushViewController(actionPlanVC, animated: true)
    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return focusedIndexPath
    }
}


// MARK: Fetched Results Controller Delegate

extension SSHomeViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        // Update Points Label
        self.points.updatePointsLabel()
        
        // Update Table View
        self.tableView.reloadData()
    }
}


// MARK: Select Goal by Right Circle

extension SSHomeViewController: SSSelectCircleButtonDelegate {
    
    func selectCircleButton(_ sender: SSSelectCircleButton) {
        
        if selectedCellCircleButton != sender {
            selectedCellCircleButton?.isSelectedView = false
        }
        
        selectedCellCircleButton = sender
        showDeleteCompleteView(sender.isSelectedView)
    }
    
    func tappedEditButton(_ goal: Goal?) {
        
        if let goal = goal {
            openEditGoalVC(editGoal: goal)
        }
    }
}
