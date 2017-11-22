//
//  UIStoryboard+Stakes.swift
//  Stakes
//
//  Created by Anton Klysa on 11/8/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation
import UIKit

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
        case timelineVC = "SSTimelineViewController"
        case expandVC = "SSExpandViewController"
        case editActionVC = "SSEditActionViewController"
        
        // Menu
        case menuVC = "SSMenuViewController"
        case achievedGoalsVC = "SSAchievedGoalsViewController"
        case settingsVC = "SSSettingsViewController"
        case feedbackVC = "SSFeedbackViewController"
    }
    
    //MARK: Storyboards

    enum StakesType: String {
        case main = "Main"
        case home = "Home"
        case menu = "Menu"
    }
    
    class func ssStoryboard(type: StakesType) -> UIStoryboard {
        let path = Bundle.main.resourcePath!.appending("/Resources/Storyboards")
        let storyboard = UIStoryboard(name: type.rawValue, bundle: Bundle(path: path))
        //SSLocalizationManager.sharedManager.localizedStoryboard(name: type.rawValue)
        return storyboard
    }
    
    func ssInstantiateViewController(type: SSViewControllerType) -> UIViewController {
        return instantiateViewController(withIdentifier: type.rawValue)
    }
}
