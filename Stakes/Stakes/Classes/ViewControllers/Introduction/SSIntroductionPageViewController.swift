//
//  SSIntroductionPageViewController.swift
//  Stakes
//
//  Created by Anton Klysa on 11/8/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation
import UIKit

class SSIntroductionPageViewController: UIPageViewController {
    
    
    // MARK: Private Properties
    private var pageControl = UIPageControl()
    private var circleView = SSCircleView()
    
    private var orderedViewControllers: [UIViewController] = {
        return [UIStoryboard.ssStoryboard(type: .main).ssInstantiateViewController(type: .firstOnboardingVC),
                UIStoryboard.ssStoryboard(type: .main).ssInstantiateViewController(type: .secondOnboardingVC),
                UIStoryboard.ssStoryboard(type: .main).ssInstantiateViewController(type: .thirdOnboardingVC),
                UIStoryboard.ssStoryboard(type: .main).ssInstantiateViewController(type: .fourthOnboardingVC)]
    }()
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = view.subviews.first as? UIScrollView
        scrollView?.delegate = self
        delegate = self
        dataSource = self
        
        view.backgroundColor = .white
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
        
        stylePageControl()
        circleView.createCircleViewsFor(currentScreen: pageControl.currentPage)
        
        view.addSubview(circleView)
        view.bringSubview(toFront: pageControl)
    }
    
    
    // MARK: Private funcs
    private func stylePageControl() {
        let heightPageControl: CGFloat = 75.0
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - heightPageControl, width:
            UIScreen.main.bounds.width, height: heightPageControl))
        
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.backgroundColor = .clear
        pageControl.numberOfPages = orderedViewControllers.count
        
        view.addSubview(pageControl)
    }
}


//MARK: UIPageViewControllerDataSource

extension SSIntroductionPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        // Set destinationScreen for CircleView
        if viewControllerIndex == 0 {
            circleView.destinationScreen = 1
        } else {
            circleView.destinationScreen = previousIndex
        }
        
        guard previousIndex >= 0 else { return nil }
        guard orderedViewControllers.count > previousIndex else { return nil }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // Set destinationScreen for CircleView
        if orderedViewControllersCount == nextIndex {
            circleView.destinationScreen = viewControllerIndex - 1
        } else {
            circleView.destinationScreen = nextIndex
        }
        
        guard orderedViewControllersCount != nextIndex else {
            if let lastVC = orderedViewControllers[viewControllerIndex] as? SSFourthOnboardingViewController {
                UIApplication.shared.keyWindow?.addSubview(lastVC.rightActionButton)
            }
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}


//MARK: UIPageViewControllerDelegate

extension SSIntroductionPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
        circleView.currentScreen = self.pageControl.currentPage
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
}


//MARK: UIScrollViewDelegate

extension SSIntroductionPageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let width = view.frame.width
        let contentOffsetX = scrollView.contentOffset.x
        guard contentOffsetX != width else { return }
        
        if contentOffsetX < width {
            guard pageControl.currentPage != 0 else { return }
            
            // Swipe left
            let percentSwipingLeft = contentOffsetX / width
            circleView.changeCircleViewsBy(percent: percentSwipingLeft)
            
        } else {
            
            // Swipe right
            let percentSwipingRight = (width * 2 - contentOffsetX) / width
            circleView.changeCircleViewsBy(percent: percentSwipingRight)
        }
    }
}
