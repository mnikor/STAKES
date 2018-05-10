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
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var goalImageView: UIImageView!
    
    var deleteButton: UIButton!
    
    
    // MARK: Public Properties
    var editGoal: Goal?
    
    
    // MARK: Private Properties
    private var isChoosenImage = false
    private var imagePickerController = UIImagePickerController()
    private var goalNameTextView: SSNameTextView {
        return createGoalView.goalNameTextView
    }
    private var goalNameTextField: SSGoalTextField {
        return createGoalView.goalNameTextField
    }
    private var dueDateTextField: SSDueDateTextField {
        return createGoalView.dueDateTextField
    }
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Points delegate
        points.delegate = self
        
        // TextField delegate
        goalNameTextView.delegate = self
        dueDateTextField.delegate = self
        
        goalNameTextField.isHidden = true
        settingsUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createGoalView.dueDateTextField.resizeFont()
    }
    
    
    // MARK: Action funcs
    @IBAction func tappedSaveButton(_ sender: SSCenterActionButton) {
        
        guard fieldsValidation() else { return }
        
        if let goal = editGoal {
            
            // Change Due Date -10 points
            let date = dueDateTextField.selectedDate!
            let oldDate = goal.date! as Date
            if oldDate < date {
                
                points.deduct(10)
                
                // Analytics. Capture "Number of due date changed"
                SSAnalyticsManager.logEvent(.dueDateChanged)
            }
            
            goal.changeGoal(name: goalNameTextView.text!, date: date, image: isChoosenImage ? goalImageView.image : nil)
            navigationController?.popViewController(animated: true)
            
        } else {
            let actionPlanVC = SSActionPlanViewController.instantiate(.home) as! SSActionPlanViewController
            actionPlanVC.goal = createGoal()
            navigationController?.pushViewController(actionPlanVC, animated: true)
        }
    }
    
    @IBAction func tappedChooseImageButton(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = .savedPhotosAlbum
            imagePickerController.allowsEditing = false
            
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        saveButton.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        goalNameTextView.setPlaceholderText("Type your goal")
        dueDateTextField.attributedPlaceholder = NSAttributedString(string: "Select your due date", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black.withAlphaComponent(0.1)])
        dueDateTextField.isUserInteractionEnabled = true
        
        // Settings GoalImageView
        goalImageView.layer.masksToBounds = true
        goalImageView.layer.cornerRadius = 10.0
        if let goal = editGoal, let image = goal.image as? UIImage {
            goalImageView.image = image
            goalImageView.makeBorder(width: .small, color: UIColor.lightGray)
            addDeleteButton()
        }
        
        // Set values for Edit Goal Screen
        if let goal = editGoal {
            
            let goalDate = goal.date! as Date
            dueDateTextField.selectedDate = goalDate
            dueDateTextField.text = dueDateTextField.selectedDateToString(date: goalDate)
            goalNameTextView.text = goal.name
            saveButton.isEnabled = true
            isChoosenImage = goal.image != nil
        }
    }
    
    override func createCirclesBackground() {
        
        let circleView = UIImageView(image: UIImage(named: "background_goal"))
        circleView.frame = self.view.frame
        view.insertSubview(circleView, at: 0)
    }
    
    // Add new Goal
    private func createGoal() -> Goal {
        let goal = Goal()
        
        goal.make(name: goalNameTextView.text, date: dueDateTextField.selectedDate!, image: isChoosenImage ? goalImageView.image : nil)
        return goal
    }
    
    // Check all Text Fields isn't Empty for activate Save Button
    private func fieldsValidation() -> Bool {
        
        goalNameTextView.endEditing(true)
        dueDateTextField.endEditing(true)
        return !goalNameTextView.isEmpty && !dueDateTextField.isEmpty
    }
}

extension SSCreateGoalViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case dueDateTextField: dueDateTextField.setTextFrom(textField)
        default: break
        }
        saveButton.isEnabled = fieldsValidation()
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


extension SSCreateGoalViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        goalNameTextView.textViewDidEndEditing(textView)
        saveButton.isEnabled = fieldsValidation()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return goalNameTextView.setCharactersLimitFor(textView: textView, range: range, string: text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        goalNameTextView.textViewDidBeginEditing(textView)
    }
    
    @objc private func deleteImageAction() {
        goalImageView.image = nil
        isChoosenImage = false
        goalImageView.isUserInteractionEnabled = false
        goalImageView.layer.borderColor = UIColor.clear.cgColor
        deleteButton.removeFromSuperview()
    }
    
    private func addDeleteButton() {
        deleteButton = UIButton()
        goalImageView.isUserInteractionEnabled = true
        goalImageView.addSubview(deleteButton)
        deleteButton.setImage(UIImage(named: "trash_icon"), for: .normal)
        deleteButton.contentMode = .scaleAspectFill
        deleteButton.addTarget(self, action: #selector(deleteImageAction), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.trailingAnchor.constraint(equalTo: goalImageView.trailingAnchor, constant: -5).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: goalImageView.bottomAnchor, constant: -10).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}

extension SSCreateGoalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePickerController.dismiss(animated: true, completion: nil)
        goalImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        goalImageView.makeBorder(width: .small, color: UIColor.lightGray)
        
        addDeleteButton()
        isChoosenImage = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
