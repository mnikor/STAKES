//
//  SSCreateActionViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

// TODO: Delete Action Name TextField in Storyboard
class SSCreateActionViewController: SSBaseDetailViewController {
    
    
    // MARK: Outlets
    
    // Text Fields
    @IBOutlet weak var actionNameTextView: SSNameTextView!
    @IBOutlet weak var dueDateTextField: SSDueDateTextField!
    
    // Labels
    @IBOutlet weak var stakeLabel: SSBaseLabel!
    @IBOutlet weak var pointsLabel: SSBaseLabel!
    @IBOutlet weak var dueDateLabel: SSBaseLabel!
    @IBOutlet weak var optionalLabel: SSBaseLabel!
    @IBOutlet weak var pointsTitleLabel: SSBaseLabel!
    @IBOutlet weak var actionableStepLabel: SSBaseLabel!
    
    // Views
    @IBOutlet weak var stakeSlider: TGPDiscreteSlider!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var createGoalView: UIView!
    
    // Buttons
    @IBOutlet weak var stakeButton: UIButton!
    @IBOutlet weak var saveActionButton: SSCenterActionButton!
    
    
    // MARK: Public Properties
    var goal: Goal?
    var editAction: Action?
    
    
    // MARK: Private Properties
    private let mainTextColor = UIColor.colorFrom(colorType: .createActionBlack)
    private let redTextColor = UIColor.colorFrom(colorType: .red)
    private let stakes: [Float] = Array(SSConstants.stakes.keys).sorted(by: { $0 < $1 })
    private var selectedStake: Float {
        let selectedValue = Int(stakeSlider.value)
        return stakes[selectedValue]
    }
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Points delegate
        points.delegate = self
        
        // TextField delegate
        dueDateTextField.delegate = self
        actionNameTextView.delegate = self
        
        settingsUI()
        hideKeyboardWhenTappedAround()
    }
    
    override func createCirclesBackground() {
        let circleView = UIImageView(image: UIImage(named: "background_add_action"))
        circleView.frame = self.view.frame
        view.insertSubview(circleView, at: 0)
    }
    
    
    // MARK: Action funcs
    
    // Save Action Button
    @IBAction func tappedSaveActionButton(_ sender: SSCenterActionButton) {
        
        guard fieldsValidation() else { return }
        
        if showMessageEmptyStake() {
            
            SSMessageManager.showCustomAlertWithAction(message: .emptyStake, onViewController: self, action: { [weak self] in
                
                self?.saveAction()
            })
        } else {
            saveAction()
        }
    }
    
    // Choosen Stake field
    @IBAction func tappedStakeButton(_ sender: UIButton) {
        
        hideStakePlaceHolderColor()
        stakeButton.setTitle(sender.currentTitle, for: .normal)
        
        setStakeSliderValue()
        pointsLabel.text = points.getPointsFor(stake: selectedStake)
    }
    
    // Slider changed value
    @objc func stakesSliderValueChanged(_ sender: TGPDiscreteSlider) {
        
        hideStakePlaceHolderColor()
        stakeButton.setTitle(selectedStake.stakeString(), for: .normal)
        pointsLabel.text = points.getPointsFor(stake: selectedStake)
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        let placeholderTextColor = UIColor.black.withAlphaComponent(0.1)
        
        // Settings for Texts
        actionNameTextView.setPlaceholderText("Type your action step")
        dueDateTextField.textColor = mainTextColor
        stakeButton.setTitleColor(placeholderTextColor, for: .normal)
        optionalLabel.textColor = placeholderTextColor
        pointsLabel.textColor = placeholderTextColor
        dueDateTextField.attributedPlaceholder = NSAttributedString(string: "Select your due date", attributes: [NSAttributedStringKey.foregroundColor: placeholderTextColor])
        stakeButton.titleLabel?.font = UIFont(name: SSConstants.fontType.helvetica.rawValue, size: 26.0)
        
        // Settings for Labels
        dueDateLabel.textColor = redTextColor
        actionableStepLabel.textColor = redTextColor
        stakeLabel.textColor = redTextColor
        pointsTitleLabel.textColor = redTextColor
        
        // Settings for Save Button
        saveActionButton.isEnabled = false
        
        // Set values for Edit Action Screen
        if editAction != nil {
            setActionValues(action: editAction!)
            hideStakePlaceHolderColor()
            saveActionButton.isEnabled = true
        }
        
        // Settings for Slider
        addSlider()
        
        // Set values
        setStakeSliderValue()
        pointsLabel.text = points.getPointsFor(stake: selectedStake)
    }
    
    // Settings for Slider
    private func addSlider() {
        stakeSlider.backgroundColor = .clear
        stakeSlider.minimumValue = 0.0
        stakeSlider.incrementValue = 1
        stakeSlider.tickCount = stakes.count
        stakeSlider.tintColor = redTextColor
        stakeSlider.thumbTintColor = redTextColor
        stakeSlider.addTarget(self, action: #selector(stakesSliderValueChanged), for: .valueChanged)
    }
    
    // Save Action
    private func saveAction() {
        
        let actionName = actionNameTextView.text!
        let actionDate = dueDateTextField.selectedDate!
        
        if editAction == nil {
            
            // Add new Action
            _ = goal?.createAction(name: actionName, date: actionDate, stake: selectedStake)
            returnToActionPlanVC()
            
            // In App Purchase Warning show 2 times
            if showInAppPurchaseWarning() {
                SSMessageManager.showCustomAlertWith(message: .inAppPurchasesWarning, onViewController: self)
            }
        } else {
            
            // Edit selected Action
            
            // Delete stake -10 points
            if editAction!.stake != 0.0 && selectedStake == 0.0 {
                
                SSMessageManager.showCustomAlertWithAction(message: .deleteStake, onViewController: self, action: { [weak self] in
                    
                    self?.points.deduct(10)
                    self?.changeAction(name: actionName, date: actionDate)
                })
                
            } else {
                
                let oldStake = editAction!.stake
                changeAction(name: actionName, date: actionDate)
                
                if oldStake != selectedStake {
                    
                    // Analytics. Capture "Number of times stake is changed"
                    SSAnalyticsManager.logEvent(.amountStakeChanges)
                }
                
                // In App Purchase Warning show 2 times
                if showInAppPurchaseWarning() {
                    SSMessageManager.showCustomAlertWith(message: .inAppPurchasesWarning, onViewController: self)
                }
            }
        }
    }
    
    private func changeAction(name: String, date: Date) {
        
        // Change Due Date -2 points
        let oldDate = editAction!.date! as Date
        if oldDate < date {
            
            points.deduct(2)
            
            // Analytics. Capture "Number of due date changed"
            SSAnalyticsManager.logEvent(.dueDateChanged)
        }
        
        editAction!.changeAction(name: name, date: date, stake: selectedStake)
        returnToActionPlanVC()
    }
    
    // Return to Action Plan VC with expanded state
    private func returnToActionPlanVC() {
        
        navigationController?.popViewController(animated: true)
        let actionPlanVC = navigationController?.viewControllers.last as? SSActionPlanViewController
        actionPlanVC?.isExpanded = true
    }
    
    // Check for alert message if saving empty stake 5 times
    private func showMessageEmptyStake() -> Bool {
        
        guard editAction == nil && selectedStake == 0.0 else { return false }
        
        let userDefaults = UserDefaults.standard
        let key = SSConstants.keys.kActionWithoutStake.rawValue
        let countOfShows = userDefaults.integer(forKey: key)
        if countOfShows == 4 {
            
            userDefaults.set(0, forKey: key)
            return true
        } else {
            
            userDefaults.set(countOfShows + 1, forKey: key)
            return false
        }
    }
    
    // Check for alert message if saving empty stake 5 times
    private func showInAppPurchaseWarning() -> Bool {
        
        guard selectedStake != 0.0 else { return false }
        
        let userDefaults = UserDefaults.standard
        let key = SSConstants.keys.kShowWarningInAppPurchases.rawValue
        let countOfShows = userDefaults.integer(forKey: key)
        if countOfShows == 2 {
            
            return false
        } else {
            
            userDefaults.set(countOfShows + 1, forKey: key)
            return true
        }
    }
    
    // Set values
    private func setActionValues(action: Action) {
        
        let actionDate = action.date! as Date
        dueDateTextField.selectedDate = actionDate
        actionNameTextView.text = action.name
        dueDateTextField.text = dueDateTextField.selectedDateToString(date: actionDate)
        stakeButton.setTitle(action.stake.stakeString(), for: .normal)
    }
    
    // Set value for stake slider
    private func setStakeSliderValue() {
        
        var sliderValue = Int()
        if let editActionStake = editAction?.stake {
            sliderValue = stakes.index(of: editActionStake) ?? Int(0.0)
        } else {
            sliderValue = stakes.index(of: 9.99) ?? Int(0.0)
        }
        
        stakeSlider.value = CGFloat(sliderValue)
    }
    
    // Change stake and points color
    private func hideStakePlaceHolderColor() {
        starImageView.image = UIImage(named: "red_white_star")
        stakeButton.setTitleColor(mainTextColor, for: .normal)
        pointsLabel.textColor = mainTextColor
        optionalLabel.isHidden = true
    }
    
    // Check all Text Fields isn't Empty for activate Save Button
    private func fieldsValidation() -> Bool {
        
        actionNameTextView.endEditing(true)
        dueDateTextField.endEditing(true)
        return !actionNameTextView.isEmpty && !dueDateTextField.isEmpty
    }
}

extension SSCreateActionViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case dueDateTextField: dueDateTextField.setTextFrom(textField)
        default: break
        }
        saveActionButton.isEnabled = fieldsValidation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case dueDateTextField: return dueDateTextField.shouldReturn(textField)
        default: return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case dueDateTextField:
            return dueDateTextField.setCharactersLimitFor(textField: textField, range: range, string: string)
        default: return true
        }
    }
}

extension SSCreateActionViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        actionNameTextView.textViewDidEndEditing(textView)
        saveActionButton.isEnabled = fieldsValidation()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        return actionNameTextView.setCharactersLimitFor(textView: textView, range: range, string: text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        actionNameTextView.textViewDidBeginEditing(textView)
    }
}
