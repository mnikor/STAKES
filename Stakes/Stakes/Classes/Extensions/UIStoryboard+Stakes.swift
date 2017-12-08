//
//  UIStoryboard+Stakes.swift
//  Stakes
//
//  Created by Anton Klysa on 11/8/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

extension UIStoryboard {
    
    
    //MARK: View Controllers
    
    enum SSViewControllerType: String {
        
        // Introduction
        case introduction = "SSIntroductionPageViewController"
        case firstOnboardingVC = "SSFirstOnboardingViewController"
        case secondOnboardingVC = "SSSecondOnboardingViewController"
        case thirdOnboardingVC = "SSThirdOnboardingViewController"
        case fourthOnboardingVC = "SSFourthOnboardingViewController"
        
        // Sign In/Up
        case signIn = "SSSignInViewController"
        case signUp = "SSSignUpViewController"
        
        // Home
        case mainNC = "SSMainNavigationController"
        case homeVC = "SSHomeViewController"
        case actionPlanVC = "SSActionPlanViewController"
        case selectedGolaTVC = "SSSelectedGoalTableViewController"
        case createActionVC = "SSCreateActionViewController"
        case createGoalVC = "SSCreateGoalViewController"
        
        // Menu
        case menuVC = "SSMenuViewController"
        case achievedGoalsVC = "SSAchievedGoalsViewController"
        case settingsVC = "SSSettingsViewController"
        case feedbackVC = "SSFeedbackViewController"
    }
    
    
    //MARK: Storyboards

    enum SSStoryboardType: String {
        case main = "Main"
        case home = "Home"
        case menu = "Menu"
    }
    
    
    //MARK: Storyboards
    
    // Instantiate ViewController
    class func ssInstantiateVC(_ storyboard: SSStoryboardType, typeVC: SSViewControllerType) -> UIViewController {
        
        let path = Bundle.main.resourcePath!.appending("/Resources/Storyboards")
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle(path: path))
        
        return storyboard.instantiateViewController(withIdentifier: typeVC.rawValue)
    }
    
    // Instantiate NavigationController
    class func ssInstantiateNavigationFor(_ viewController: UIViewController) -> UINavigationController {
        
        let navigation = UINavigationController(rootViewController: viewController)
        let window = UIApplication.shared.delegate?.window ?? nil
        window?.rootViewController = navigation
        
        return navigation
    }
    
    // Instantiate Storyboard
    class func ssStoryboard(type: SSStoryboardType) -> UIStoryboard {
        let path = Bundle.main.resourcePath!.appending("/Resources/Storyboards")
        let storyboard = UIStoryboard(name: type.rawValue, bundle: Bundle(path: path))
        //SSLocalizationManager.sharedManager.localizedStoryboard(name: type.rawValue)
        return storyboard
    }
    
    // Instantiate Slide Menu Controller
    class func getSlideMenuController() -> UIViewController {
        
        let mainViewController = UIStoryboard.ssInstantiateVC(.home, typeVC: .mainNC)
        let leftViewController = UIStoryboard.ssInstantiateVC(.menu, typeVC: .menuVC)
        
        return SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftViewController)
    }
    
    // Instantiate Slide Menu Controller
    class func getSideMenuControllerFor(_ navigationController: UINavigationController) -> UIViewController {
        
        let leftViewController = UIStoryboard.ssInstantiateVC(.menu, typeVC: .menuVC)
        return SlideMenuController(mainViewController: navigationController, leftMenuViewController: leftViewController)
    }
    
    func ssInstantiateViewController(type: SSViewControllerType) -> UIViewController {
        return instantiateViewController(withIdentifier: type.rawValue)
    }
}
