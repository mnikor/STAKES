//
//  SSCreateGoalViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/24/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSCreateGoalViewController: SSBaseDetailViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var saveButton: SSCenterActionButton!
    @IBOutlet weak var createGoalView: SSCreateGoalView!
    
    
    // MARK: Private Properties
    private var goalNameTextField: SSGoalTextField {
        return createGoalView.goalNameTextField
    }
    private var dueDateTextField: SSDueDateTextField {
        return createGoalView.dueDateTextField
    }
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalNameTextField.delegate = self
        dueDateTextField.delegate = self
        
        settingsUI()
    }
    
    
    // MARK: Action funcs
    @IBAction func tappedSaveButton(_ sender: SSCenterActionButton) {
        guard fieldsValidation() else { return }
        
        let actionPlanVC = UIStoryboard.ssInstantiateVC(.home, typeVC: .actionPlanVC) as! SSActionPlanViewController
        actionPlanVC.goal = createGoal()
        navigationController?.pushViewController(actionPlanVC, animated: true)
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        hideKeyboardWhenTappedAround()
        goalNameTextField.isUserInteractionEnabled = true
        dueDateTextField.isUserInteractionEnabled = true
    }
    
    // Add new Goal
    private func createGoal() -> Goal {
        let goal = Goal()
        goal.make(name: goalNameTextField.text!, date: dueDateTextField.selectedDate!)
        return goal
    }
    
    // Check all Text Fields isn't Empty for activate Save Button
    private func fieldsValidation() -> Bool {
        
        goalNameTextField.endEditing(true)
        dueDateTextField.endEditing(true)
        return !goalNameTextField.isEmpty && !dueDateTextField.isEmpty
    }
}

extension SSCreateGoalViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case goalNameTextField: goalNameTextField.setTextFrom(textField)
        case dueDateTextField: dueDateTextField.setTextFrom(textField)
        default: break
        }
        saveButton.isEnabled = fieldsValidation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case dueDateTextField: return dueDateTextField.shouldReturn(textField)
        case goalNameTextField: return goalNameTextField.shouldReturn(textField)
        default: return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case goalNameTextField:
            return goalNameTextField.setCharactersLimitFor(textField: textField, range: range, string: string)
        case dueDateTextField:
            return dueDateTextField.setCharactersLimitFor(textField: textField, range: range, string: string)
        default: return true
        }
    }
}
