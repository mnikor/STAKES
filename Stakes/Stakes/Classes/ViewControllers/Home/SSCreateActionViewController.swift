//
//  SSCreateActionViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSCreateActionViewController: SSBaseDetailViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var dueDateTextField: SSDueDateTextField!
    @IBOutlet weak var actionNameTextField: SSGoalTextField!
    @IBOutlet weak var pointsLabel: SSBaseLabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var stakeSlider: UISlider!
    @IBOutlet weak var stakeButton: UIButton!
    @IBOutlet weak var saveActionButton: SSCenterActionButton!
    @IBOutlet weak var optionalLabel: SSBaseLabel!
    
    @IBOutlet weak var dueDateLabel: SSBaseLabel!
    @IBOutlet weak var actionableStepLabel: SSBaseLabel!
    @IBOutlet weak var stakeLabel: SSBaseLabel!
    @IBOutlet weak var pointsTitleLabel: SSBaseLabel!
    
    
    // MARK: Public Properties
    var goal: Goal?
    var editAction: Action?
    
    
    // MARK: Private Properties
    private let mainTextColor = UIColor.colorFrom(colorType: .createActionBlack)
    private let redTextColor = UIColor.colorFrom(colorType: .red)
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dueDateTextField.delegate = self
        actionNameTextField.delegate = self
        
        settingsUI()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: Action funcs
    
    // Save Action Button
    @IBAction func tappedSaveActionButton(_ sender: SSCenterActionButton) {
        
        guard let currentGoal = goal, fieldsValidation() else { return }
        
        let actionName = actionNameTextField.text!
        let actionDate = dueDateTextField.selectedDate!
        let actionStake = optionalLabel.isHidden ? stakeSlider.value : 0.0
        
        if editAction == nil {
            
            // Add new Action
            _ = currentGoal.createAction(name: actionName, date: actionDate, stake: actionStake)
            
        } else {
            
            // Edit selected Action
            editAction?.changeAction(name: actionName, date: actionDate, stake: actionStake)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // Choosen Stake field
    @IBAction func tappedStakeButton(_ sender: UIButton) {
        
        hideStakePlaceHolderColor()
        stakeSlider.isHidden = false
        stakeButton.setTitle(sender.currentTitle, for: .normal)
    }
    
    // Slider changed value
    @IBAction func stakeSlider(_ sender: UISlider) {
        
        stakeButton.setTitle(sender.value.stakeString(), for: .normal)
        pointsLabel.text = SSPoint().getPointsFor(stake: sender.value)
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        let placeholderTextColor = UIColor.fromRGB(rgbValue: 0xC7C7CE) // Placeholder text color
        
        // Settings for Texts
        dueDateTextField.textColor = mainTextColor
        actionNameTextField.textColor = mainTextColor
        optionalLabel.textColor = placeholderTextColor
        pointsLabel.textColor = placeholderTextColor
        stakeButton.titleLabel?.font = UIFont(name: SSConstants.fontType.bigCaslon.rawValue, size: 26.0)
        
        // Settings for Slider
        stakeSlider.tintColor = redTextColor
        stakeSlider.thumbTintColor = redTextColor
        
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
    }
    
    // Set values
    private func setActionValues(action: Action) {
        let actionDate = action.date! as Date
        dueDateTextField.selectedDate = actionDate
        
        actionNameTextField.text = action.name
        dueDateTextField.text = dueDateTextField.selectedDateToString(date: actionDate)
        stakeButton.setTitle(action.stake.stakeString(), for: .normal)
        stakeSlider.value = action.stake
        pointsLabel.text = SSPoint().getPointsFor(stake: action.stake)
    }
    
    private func hideStakePlaceHolderColor() {
        starImageView.image = UIImage(named: "red_white_star")
        stakeButton.setTitleColor(mainTextColor, for: .normal)
        pointsLabel.textColor = mainTextColor
        optionalLabel.isHidden = true
    }
    
    // Check all Text Fields isn't Empty for activate Save Button
    private func fieldsValidation() -> Bool {
        
        actionNameTextField.endEditing(true)
        dueDateTextField.endEditing(true)
        return !actionNameTextField.isEmpty && !dueDateTextField.isEmpty
    }
}

extension SSCreateActionViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        stakeSlider.isHidden = true
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case actionNameTextField: actionNameTextField.setTextFrom(textField)
        case dueDateTextField: dueDateTextField.setTextFrom(textField)
        default: break
        }
        saveActionButton.isEnabled = fieldsValidation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        stakeSlider.isHidden = true
        
        switch textField {
        case dueDateTextField:
            return dueDateTextField.shouldReturn(textField)
        case actionNameTextField:
            return actionNameTextField.shouldReturn(textField)
        default: return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case actionNameTextField:
            return actionNameTextField.setCharactersLimitFor(textField: textField, range: range, string: string)
        case dueDateTextField:
            return dueDateTextField.setCharactersLimitFor(textField: textField, range: range, string: string)
        default: return true
        }
    }
}
