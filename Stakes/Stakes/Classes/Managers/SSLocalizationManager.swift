//
//  SSLocalizationManager.swift
//  KADER
//
//  Created by Anton Klysa on 3/30/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation
import UIKit

//easy to use string localization extension
extension String {
    func localized() -> String {
        return SSLocalizationManager.sharedManager.localizedString(for: self)
    }
}

//provide custom localization
class SSLocalizationManager: NSObject {
    enum Language: String {
        case english = "en"
        case franch = "fr"
        case arabic = "ar"
        
        func useRTL() -> Bool {
            return self == .arabic
        }
    }
    
    //MARK: - Props -

    private var bundle: Bundle? = nil
    
    private let kLanguage = "kLanguage"
    var language: Language {
        get {
            //get saved language
            if let sharedLang = UserDefaults.standard.string(forKey: kLanguage) {
                return Language(rawValue: sharedLang)!
            }
            return .english
        }
        set(value) {
            //save language
            UserDefaults.standard.set(value.rawValue, forKey: kLanguage)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK - Static
    
    static var sharedManager = SSLocalizationManager()
    
    
    //MARK - Initialization
    
    override init() {
        super.init()
        setLanguage(lang: self.language)
    }
    
    
    //MARK - Main
    
    func setLanguage(lang: Language) {
        //set the same lang, so just skip
//        if bundle != nil && lang == language {
//            return
//        }
        self.language = lang
        //try to get custom localization bundle
        guard let path = Bundle.main.path(forResource: lang.rawValue, ofType: "lproj") else {
            //fuck...
            return
        }
        //yahoo!
        self.bundle = Bundle(path: path) ?? Bundle.main
        
        //update UI appearence based on localization
        configUIAppearance()
    }
    
    func localizedString(for key: String) -> String {
        //if bundle not exist then use default localization
        if bundle == nil {
            return NSLocalizedString(key, comment: "")
        }
        //use custom localization
        return bundle!.localizedString(forKey: key, value: "", table: nil)
    }
    
    func localizedStoryboard(name: String) -> UIStoryboard {
        
    	let path = Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle: Bundle = Bundle(path: path!)!
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    //MARK: - Private Funcs -
    
    private func configUIAppearance() {
        UIView.appearance().semanticContentAttribute = language.useRTL() ? .forceRightToLeft : .forceLeftToRight
        
        //setGlobalWritingDirection
        if UIView.isRTL() {
            UITextField.appearance().makeTextWritingDirectionLeftToRight(nil)
            UITextView.appearance().makeTextWritingDirectionLeftToRight(nil)
        } else {
            UITextField.appearance().makeTextWritingDirectionLeftToRight(nil)
            UITextView.appearance().makeTextWritingDirectionRightToLeft(nil)
        }
    }
}
