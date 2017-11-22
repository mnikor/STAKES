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
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Public Properties
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = SSCoreDataManager.instance.fetchedResultsController(entityName: .goal, keyForSort: "date")
    
    
    // MARK: Private Properties
    private let cellID = "SSHomeViewControllerCell"
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsUI()
        
        // CoreData fetch data
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    // MARK: Action funcs
    @objc func rightButtonAction(_ sender: UIButton) {
        
        // Add new Test Goal
        let goal = Goal()
        goal.make(name: "Test Goal", date: Date(), stake: 999.99)
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        rightActionButton.setImage(UIImage(named: "red_plus"), for: .normal)
        rightActionButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        view.addSubview(rightActionButton)
        tableView.tableFooterView = UIView()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = goal.name! + " - " + String(goal.stake)
        
        return cell
    }
}


// MARK: Table View Delegate

extension SSHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedGoal = fetchedResultsController.object(at: indexPath) as? Goal else { return }
        
        let expandVC = UIStoryboard.ssStoryboard(type: .home).ssInstantiateViewController(type: .expandVC) as! SSExpandViewController
        expandVC.goal = selectedGoal
        navigationController?.pushViewController(expandVC, animated: true)
    }
}


// MARK: Fetched Results Controller Delegate

extension SSHomeViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPathInsert = newIndexPath {
                tableView.insertRows(at: [indexPathInsert], with: .automatic)
            }
        case .update:
            if let indexPathUpdate = indexPath {
                let goal = fetchedResultsController.object(at: indexPathUpdate) as! Goal
                let cell = tableView.cellForRow(at: indexPathUpdate)
                cell!.textLabel?.text = goal.name
            }
        case .move:
            if let indexPathMove = indexPath {
                tableView.deleteRows(at: [indexPathMove], with: .automatic)
            }
            if let newIndexPathMove = newIndexPath {
                tableView.insertRows(at: [newIndexPathMove], with: .automatic)
            }
        case .delete:
            if let indexPathDelete = indexPath {
                tableView.deleteRows(at: [indexPathDelete], with: .automatic)
            }
        }
    }
}

