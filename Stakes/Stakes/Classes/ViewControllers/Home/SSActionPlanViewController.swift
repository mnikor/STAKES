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
    
    var showEmptyView: Bool {
        return actions.count == 0
    }
    var containerViewController: SSSelectedGoalViewController {
        return childViewControllers.first as! SSSelectedGoalViewController
    }
    
    
    // MARK: Private Properties
    private var selectedCellCircleButton: SSSelectCircleButton?
    private var actions: [Action] {
        return goal != nil ? goal!.getActionsSortByStatus() : [Action]()
    }
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Points delegate
        points.delegate = self
        
        // Register table cell class from nib
        let cellNib = UINib(nibName: SSActionPlanTableViewCell.reuseID, bundle: nil)
        tableViewBottom.register(cellNib, forCellReuseIdentifier: SSActionPlanTableViewCell.reuseID)
        
        createTopViewController()
        settingsUI()
        
        // Check missed actions for Purchase
        showPurchaseAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUIAfterAction()
        showHideEptyView()
        expandAction()
        containerViewTop.isHidden = isExpanded
        
        // Delegate for Cells from containerViewController
        for cell in containerViewController.cells {

            cell.delegate = self
        }
    }
    
    // Navigation Controller left button back action
    override func backAction() {
        
        returnToHome(animated: true)
    }
    
    
    // MARK: Action funcs
    
    // Delete Goal action on DeleteCompleteView
    @IBAction func tappedDeleteButton(_ sender: SSBaseButton) {
        
        if selectedCellCircleButton?.typeButton == SSCircleButtonType.goal {
            
            SSMessageManager.showCustomAlertWithAction(message: .goalDeleted, onViewController: self) { [weak self] in self?.delete(isGoal: true) }
        } else {
            
            SSMessageManager.showCustomAlertWithAction(message: .actionDeleted, onViewController: self) { [weak self] in self?.delete(isGoal: false) }
        }
        
        updateUIAfterAction()
    }
    
    // Complete Goal or Action on DeleteCompleteView
    @IBAction func tappedCompleteButton(_ sender: SSBaseButton) {
        
        guard goal?.status != GoalStatusType.complete.rawValue else {
            SSMessageManager.showAlertWith(title: .error, and: .goalIsAchieved, onViewController: self)
            return
        }
        
        // Complete Action
        if let selectedAction = selectedCellCircleButton?.selectedAction {
            
            selectedAction.changeStatus(.complete)
            showCompleteAlertFor(selectedAction)
            
        // Complete Goal
        } else {
            
            goal?.changeStatus(.complete)
            SSMessageManager.showCustomAlertWith(message: .goalAchieved, onViewController: self)
        }
        
        updateUIAfterAction()
    }
    
    // Right Button action
    @objc func rightButtonAction(_ sender: UIButton) {
        
        if showEmptyView || isExpanded {
            
            // Open Create Action Screen
            openCreateActionVC(editAction: nil)
            
        } else {
            
            shareGoal()
        }
    }
    
    // Expand/Reduce Actions
    @IBAction func tappedExpandButton(_ sender: SSCenterActionButton) {
        
        if isExpanded {
            
            containerViewTop.isHidden = !isExpanded
        }
        isExpanded = !isExpanded
        
        showDeleteCompleteView(false)
        makeCreateActionButton()
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            
            self?.expandAction()
            self?.containerViewController.updateCells()
            self?.view.layoutSubviews()
            
        }) { [weak self] (bool) in
            if bool {
                
                self?.containerViewTop.isHidden = self!.isExpanded
            }
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
            // Delete Goal -50 points
            points.deduct(50)
            goal?.deleteGoal()
            
            returnToHome(animated: false)
        } else {
            // Deleted Action -10 points
            points.deduct(10)
            goal!.delete(selectedCellCircleButton!.selectedAction!)
            
            if goal?.getActions().count == 0 {
                returnToHome(animated: false)
            }
        }
        
        /*
        //TableView reloadData after deleteRows animation finished
        let tableView = (isExpanded ? tableViewBottom : tableViewTop)!
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({ [weak self] in
            
            self?.tableViewTop.reloadData()
            self?.tableViewBottom.reloadData()
        })
        
        tableView.beginUpdates()
        
        if isExpanded {
            tableView.deleteRows(at: [selectedCellCircleButton!.indexPath], with: .left)
        }
        
        tableView.endUpdates()
        
        CATransaction.commit()
        */
        
        updateUIAfterAction()
        points.updatePointsLabel()
        showHideEptyView()
    }
    
    private func expandAction() {
        
        points.updatePointsLabel()
        let newPositionByY = view.frame.height - (expandButton.frame.height + 120.0)
        let buttonTitle = isExpanded ? "Collapse Actions" : "Expand Actions"
        expandButton.setTitle(buttonTitle, for: .normal)
        
        expandConstraintTop.constant = isExpanded ? 0.0 : -containerViewTop.frame.height
        expandConstraintBottom.constant = isExpanded ? -newPositionByY : 0.0
    }
    
    private func openCreateActionVC(editAction: Action?) {
        
        let createActionVC = SSCreateActionViewController.instantiate(.home) as! SSCreateActionViewController
        createActionVC.goal = goal
        createActionVC.editAction = editAction
        navigationController?.pushViewController(createActionVC, animated: true)
    }
    
    private func showHideEptyView() {
        
        emptyActionPlanView.isHidden = !showEmptyView
        expandButton.isHidden = showEmptyView
        makeCreateActionButton()
    }
    
    private func makeCreateActionButton() {
        
        rightActionButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        if showEmptyView || isExpanded {
            
            rightActionButton.setImage(UIImage(named: "red_plus"), for: .normal)
            rightActionButton.isEnabled = goal?.status != GoalStatusType.complete.rawValue
        } else {
            
            let shareImage = UIImage(named: "share")
            rightActionButton.isEnabled = true
            rightActionButton.imageView?.tintColor = UIColor.colorFrom(colorType: .red)
            rightActionButton.setImage(shareImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        view.addSubview(rightActionButton)
    }
    
    // Update Points Label, DeleteCompleteView and TableViews
    private func updateUIAfterAction() {
        
        tableViewBottom.reloadData()
        containerViewController.updateCells()
        containerViewTop.isHidden = isExpanded
        points.updatePointsLabel()
        showDeleteCompleteView(false)
    }
    
    private func showCompleteAlertFor(_ action: Action) {
        
        // Show Last Action Alert
        if goal?.calculateСompletion() == 100 {
            
            SSMessageManager.showLastActionCustomAlert(message: .lastAction, with: goal!, onViewController: self, action: { [weak self] in
                
                self?.openCreateActionVC(editAction: nil)
            })
            
            // Show Complete Action Alert with stake or no
        } else {
            
            if action.stake == 0.0 {
                SSMessageManager.showCustomAlertWith(message: .completedActionNoStake, onViewController: self)
            } else {
                SSMessageManager.showCustomAlertWith(message: .completedAction, onViewController: self)
            }
        }
    }
    
    private func returnToHome(animated: Bool) {
        
        if let homeVC = navigationController?.viewControllers.first {
            navigationController?.popToViewController(homeVC, animated: animated)
        }
    }
    
    private func instagramShare(_ image: UIImage) {
        
        let instagramManager = SSInstagramShareManager()
        
        // Option 1
        instagramManager.post(image: image, result: { [weak self] bool in

            if bool {

                // When posted to Instagram
                self?.points.add(10)
                self?.points.updatePointsLabel()
            }
        })
    }
    
    private func shareGoal() -> Void {
        
        let shareText = "Hey, I am excited to share my goal I set using amazing app \"Bold\""
        let shareImage = containerViewTop.makeScreenshot() ?? UIImage()
        var activities: [UIActivity]? = [UIActivity]()
        let linkedInType = "com.linkedin.LinkedIn.ShareExtension"
        
        // If there is Instagram
        if UIApplication.shared.canOpenURL(SSConstants.instagramURL) {
            
            let instagramActivity = SSCustomActivity(title: "Instagram",
                                                     imageName: "instagram",
                                                     performAction: { [weak self] in self?.instagramShare(shareImage) })
            activities?.append(instagramActivity)
            
        } else {
            activities = nil
        }
        
        var activityItems = [Any]()
        if let shareURL = URL(string: SSConstants.appStoreLink) {
            activityItems = [shareImage, shareText, shareURL]
        } else {
            activityItems = [shareImage, shareText]
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: activities)
        activityVC.completionWithItemsHandler = { [weak self] (activity, success, items, error) in
            
            guard success else { return }
            
            switch activity?.rawValue {
            case linkedInType?,
                 UIActivityType.postToFacebook.rawValue?,
                 UIActivityType.postToTwitter.rawValue?:
                
                self?.points.add(10)
                self?.points.updatePointsLabel()
                
                // Analytics. Capture "Number of times goal is shared"
                SSAnalyticsManager.logEvent(.shareGoal)
            default: break
            }
        }
        
        self.present(activityVC, animated: true, completion: { [weak self] in
            
            // Add Share alert
            let shareViewAlert = SSShareGoalAlertView()
            shareViewAlert.center = self?.view.center ?? .zero
            shareViewAlert.frame.origin.y = 30.0
            UIApplication.shared.keyWindow?.subviews.last?.addSubview(shareViewAlert)
        })
    }
    
    // Make top table view in container view
    private func createTopViewController() {
        
        let controller = SSSelectedGoalViewController.instantiate(.home) as! SSSelectedGoalViewController
        
        controller.goal = goal
        addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerViewTop.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerViewTop.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerViewTop.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerViewTop.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerViewTop.bottomAnchor)
            ])
        
        controller.didMove(toParentViewController: self)
    }
    
    // Check missed status, not purchased, with stake actions for Purchase
    private func showPurchaseAlert() {
        
         if goal!.getActionsForPurchase().count != 0 {
            
            SSMessageManager.showLastActionCustomAlert(message: .unLockGoal, with: goal!, onViewController: self, action: { [weak self] in
                
                // If tapped close button on alert view
                self?.backAction()
            })
        }
    }
}


// MARK:Table View Data Source

extension SSActionPlanViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SSActionPlanTableViewCell.reuseID, for: indexPath) as! SSActionPlanTableViewCell
        cell.configCellBy(actions[indexPath.row])
        cell.delegate = self
        return cell
    }
}


// MARK: Table View Delegate
extension SSActionPlanViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 119
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

