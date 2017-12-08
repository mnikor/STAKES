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
    
    // MARK: Public Properties
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = SSCoreDataManager.instance.fetchedResultsController(entityName: .goal, keyForSort: "date", predicate: ["status": GoalStatusType.wait.rawValue])
    
    
    // MARK: Private Properties
    private var hideActionButton = true
    private var selectedGoalButton: SSSelectCircleGoalButton?
    private var focusedIndexPath = IndexPath(row: 0, section: 0)
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table cell class from nib
        let cellNib = UINib(nibName: SSHomeTableViewCell.reuseID, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: SSHomeTableViewCell.reuseID)
        let cellShortNib = UINib(nibName: SSHomeShortTableViewCell.reuseID, bundle: nil)
        tableView.register(cellShortNib, forCellReuseIdentifier: SSHomeShortTableViewCell.reuseID)
        
        // CoreData fetch data
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        settingsUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideActionButton = false
        updateActionButtons(nil)
        tableView.reloadData()
    }
    
    
    // MARK: Action funcs
    
    // Right Button action
    @objc func rightButtonAction(_ sender: UIButton) {
        
        let createGoalVC = UIStoryboard.ssInstantiateVC(.home, typeVC: .createGoalVC)
        navigationController?.pushViewController(createGoalVC, animated: true)
    }
    
    // Select Goal by Right Circle
    @IBAction func selectedGoal(_ sender: SSSelectCircleGoalButton) {
        
        updateActionButtons(sender)
        selectedGoalButton = sender
    }
    
    // Delete Goal action on DeleteCompleteView
    @IBAction func tappedDeleteGoal(_ sender: SSBaseButton) {
        
        SSMessageManager.showAlertWithCancelButton(title: .warning, message: .goalDeleted, onViewController: self, action: { self.deleteGoal() })
        
        // Update Goal Select button on the left
        updateActionButtons(selectedGoalButton)
    }
    
    // Complete Goal Action on DeleteCompleteView
    @IBAction func tappedCompleteGoal(_ sender: SSBaseButton) {
        
        selectedGoalButton?.selectedGoal?.changeStatus(.complete)
        SSMessageManager.showAlertWith(title: .success, and: .goalAchieved, onViewController: self)
        updateActionButtons(selectedGoalButton)
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        rightActionButton.setImage(UIImage(named: "red_plus"), for: .normal)
        rightActionButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        view.addSubview(rightActionButton)
        
        self.createCirclesBackground()
        self.setTitle("it's")
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.remembersLastFocusedIndexPath = true
        
        for view in deleteCompleteView.subviews {
            guard let button = view as? SSBaseButton else { return }
            button.makeBorder(width: .small, color: button.titleColor(for: .normal)!)
        }
    }
    
    private func updateActionButtons(_ button: SSSelectCircleGoalButton?) {
        
        rightActionButton.isHidden = hideActionButton
        hideActionButton = !hideActionButton
        deleteCompleteView.isHidden = hideActionButton
        
        guard let selectButton = button else { return }
        
        if hideActionButton {
            selectButton.backgroundColor = .white
            selectedGoalButton?.backgroundColor = .white
        } else {
            selectButton.backgroundColor = UIColor(cgColor: selectButton.layer.borderColor!)
        }
    }
    
    private func deleteGoal() {
        
        selectedGoalButton?.selectedGoal?.deleteGoal()
        self.updatePointsLabel()
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
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SSHomeShortTableViewCell.reuseID, for: indexPath) as! SSHomeShortTableViewCell
            cell.configCellBy(goal)
            return cell
        }
    }
}


// MARK: Table View Delegate

extension SSHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 280
        } else {
            return 117
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGoal = fetchedResultsController.object(at: indexPath) as! Goal
        focusedIndexPath = indexPath
        
        let actionPlanVC = UIStoryboard.ssInstantiateVC(.home, typeVC: .actionPlanVC) as! SSActionPlanViewController
        actionPlanVC.goal = selectedGoal
        
        navigationController?.pushViewController(actionPlanVC, animated: true)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return focusedIndexPath
    }
}


// MARK: Fetched Results Controller Delegate

extension SSHomeViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        // Update Points Label
        updatePointsLabel()
        
        //TableView reloadData after finished of deleteRows animation
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
            self.tableView.reloadData()
        })
        
        tableView.beginUpdates()
        switch type {
        case .update: break
        case .insert:
            if let indexPathInsert = newIndexPath {
                tableView.insertRows(at: [indexPathInsert], with: .left)
            }
        case .move:
            if let indexPathMove = indexPath {
                tableView.deleteRows(at: [indexPathMove], with: .left)
            }
            if let newIndexPathMove = newIndexPath {
                tableView.insertRows(at: [newIndexPathMove], with: .left)
            }
        case .delete:
            if let indexPathDelete = indexPath {
                tableView.deleteRows(at: [indexPathDelete], with: .left)
            }
        }
        tableView.endUpdates()
        
        CATransaction.commit()
    }
}

