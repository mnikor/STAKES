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
    
    // Text Fields
    @IBOutlet weak var dueDateTextField: SSDueDateTextField!
    @IBOutlet weak var actionNameTextField: SSGoalTextField!
    
    // Labels
    @IBOutlet weak var stakeLabel: SSBaseLabel!
    @IBOutlet weak var pointsLabel: SSBaseLabel!
    @IBOutlet weak var dueDateLabel: SSBaseLabel!
    @IBOutlet weak var optionalLabel: SSBaseLabel!
    @IBOutlet weak var pointsTitleLabel: SSBaseLabel!
    @IBOutlet weak var actionableStepLabel: SSBaseLabel!
    
    // Views
    @IBOutlet weak var stakeSliderView: UIView!
    @IBOutlet weak var starImageView: UIImageView!
    
    // Buttons
    @IBOutlet weak var stakeButton: UIButton!
    @IBOutlet weak var saveActionButton: SSCenterActionButton!
    
    
    
    // MARK: Public Properties
    var goal: Goal?
    var editAction: Action?
    
    
    // MARK: Private Properties
    private let mainTextColor = UIColor.colorFrom(colorType: .createActionBlack)
    private let redTextColor = UIColor.colorFrom(colorType: .red)
    private let stakes: [Float] = [0.0, 1.99, 2.99, 3.99, 4.99, 5.99, 9.99, 13.99, 19.99, 24.99, 49.99, 99.99, 199.99, 299.99, 499.99, 699.99, 999.99]
    
    private var selectedStake: Float {
        let selectedValue = Int(stakeSlider.value)
        return stakes[selectedValue]
    }
    private var stakeSlider: TGPDiscreteSlider {
        return stakeSliderView.subviews.first as! TGPDiscreteSlider
    }
    
    
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
        let actionStake = optionalLabel.isHidden ? selectedStake : 0.0
        
        if editAction == nil {
            
            // Add new Action
            _ = currentGoal.createAction(name: actionName, date: actionDate, stake: actionStake)
            
        } else {
            
            // Edit selected Action
            editAction?.changeAction(name: actionName, date: actionDate, stake: actionStake)
        }
        
        // Return to Action Plan VC with expanded state
        navigationController?.popViewController(animated: true)
        let actionPlanVC = navigationController?.viewControllers.last as! SSActionPlanViewController
        actionPlanVC.isExpanded = true
    }
    
    // Choosen Stake field
    @IBAction func tappedStakeButton(_ sender: UIButton) {
        
        hideStakePlaceHolderColor()
        stakeSliderView.isHidden = false
        stakeButton.setTitle(sender.currentTitle, for: .normal)
        
        var sliderValue = Int()
        if let editActionStake = editAction?.stake {
            sliderValue = stakes.index(of: editActionStake) ?? Int(0.0)
        } else {
            sliderValue = stakes.index(of: 9.99) ?? Int(0.0)
        }
        
        stakeSlider.value = CGFloat(sliderValue)
        pointsLabel.text = SSPoint().getPointsFor(stake: selectedStake)
    }
    
    // Slider changed value
    @objc func stakesSliderValueChanged(_ sender: TGPDiscreteSlider) {
        
        stakeButton.setTitle(selectedStake.stakeString(), for: .normal)
        pointsLabel.text = SSPoint().getPointsFor(stake: selectedStake)
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
        let slider = TGPDiscreteSlider()
        slider.frame.size = stakeSliderView.frame.size
        slider.backgroundColor = .clear
        slider.minimumValue = 0.0
        slider.incrementValue = 1
        slider.tickCount = stakes.count
        slider.tintColor = redTextColor
        slider.thumbTintColor = redTextColor
        slider.addTarget(self, action: #selector(stakesSliderValueChanged), for: .valueChanged)
        stakeSliderView.addSubview(slider)
        
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
        
        let sliderValue: Int = stakes.index(of: action.stake) ?? Int(0.0)
        stakeSlider.value = CGFloat(sliderValue)
        pointsLabel.text = SSPoint().getPointsFor(stake: selectedStake)
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
        stakeSliderView.isHidden = true
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
        stakeSliderView.isHidden = true
        
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
