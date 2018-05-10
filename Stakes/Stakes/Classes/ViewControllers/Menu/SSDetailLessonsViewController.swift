//
//  SSDetailLessonsViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/12/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit
import WebKit

class SSDetailLessonsViewController: SSBaseDetailViewController {
    
    
    // MARK:  - Public Properties
    var content: String!
    
    
    // MARK:  - Private Properties
    private var webView: WKWebView!
    
    
    // MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // WebView settings
        let frame = CGRect(x: 0.0, y: 0, width: view.frame.width, height: view.frame.height)
        webView = WKWebView(frame: frame, configuration: WKWebViewConfiguration())
        
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        
        //view = webView
        view.addSubview(webView)
        webView.backgroundColor = .darkGray
        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // Disable Copy/Paste functon
        NotificationCenter.default.addObserver(self, selector: #selector(hideEditingMenu), name: NSNotification.Name.UIMenuControllerDidShowMenu, object: nil)
        
        // Load Lesson pdf files
        if let fileURL = Bundle.main.url(forResource: content, withExtension: "pdf", subdirectory: nil, localization: nil)  {
            
            webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
            if content.elementsEqual("1") || content.elementsEqual("2") {
                makeCreateActionButton()
            }
            
        } else {
            
            SSMessageManager.showCustomAlertWith(message: .error, onViewController: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIMenuControllerDidShowMenu, object: nil)
    }
    
    
    // MARK:  - Private funcs
    
    
    private func makeCreateActionButton() {
        
        rightActionButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        let shareImage = UIImage(named: "share")
        rightActionButton.isEnabled = true
        rightActionButton.imageView?.tintColor = UIColor.colorFrom(colorType: .red)
        rightActionButton.setImage(shareImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightActionButton.backgroundColor = .clear
        view.addSubview(rightActionButton)
    }
    
    @objc private func rightButtonAction(_ sender: UIButton) {
        
        let shareImage = webView.makeScreenshot() ?? UIImage()
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
        
        let fileURL = Bundle.main.url(forResource: content, withExtension: "pdf", subdirectory: nil, localization: nil)
        let dataFile: Data = try! Data(contentsOf: fileURL!)
        var activityItems = [Any]()
        if let shareURL = URL(string: SSConstants.appStoreLink) {
            activityItems = [shareURL, shareImage, dataFile]
        } else {
            activityItems = [shareImage, dataFile]
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: activities)
        activityVC.completionWithItemsHandler = { [weak self] (activity, success, items, error) in
            guard success else {
                return
            }
        }
        self.present(activityVC, animated: true, completion: nil)
        
//        let fileURL = Bundle.main.url(forResource: content, withExtension: "docx", subdirectory: nil, localization: nil)
//        let dataFile: Data = try! Data(contentsOf: fileURL!)
//
//        let activityItems = [dataFile]
//
//        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
//        activityVC.completionWithItemsHandler = {(activity, success, items, error) in
//
//        }
//
//        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func instagramShare(_ image: UIImage) {
        
        let instagramManager = SSInstagramShareManager()
        
        // Option 1
        instagramManager.post(image: image, result: { [weak self] bool in
            
            if bool {
                
                // When posted to Instagram
//                self?.points.add(10)
//                self?.points.updatePointsLabel(withAnimation: true)
            }
        })
    }
    
    // Disable Copy/Paste functon
    @objc func hideEditingMenu() {
        UIMenuController.shared.setMenuVisible(false, animated: false)
    }
}


// MARK:  - WKNavigationDelegate

extension SSDetailLessonsViewController: WKNavigationDelegate, UIScrollViewDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("")
        webView.scrollView.contentSize = CGSize(width: webView.scrollView.contentSize.width, height: webView.scrollView.contentSize.height + 70)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        webView.scrollView.contentSize = CGSize(width: webView.scrollView.contentSize.width, height: webView.scrollView.contentSize.height + 70)
    }
}
