//
//  ViewController.swift
//  covid-info
//
//  Created by Masha Vodolazkaya on 31/03/2020.
//  Copyright © 2020 Masha Vodolazkaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    let pageVC : UIPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageVC") as! UIPageViewController
    
    override func viewWillAppear(_ animated: Bool) {
        self.containerStackView.addArrangedSubview(pageVC.view)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addChild(pageVC)
        pageVC.dataSource = self
        pageVC.delegate = self
        
        if let firstVC = pages.first
        {
            pageVC.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            titleLabel.text = firstVC.title
        }
        
        
        
    }
    
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "RedVC"),
            self.getViewController(withIdentifier: "CardsTableVC"),
            self.getViewController(withIdentifier: "RedVC")
        ]
    }()
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageVC.viewControllers?.first,
            let firstViewControllerIndex = pages.firstIndex(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = pages.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed) { return }
        self.titleLabel.text = pageViewController.viewControllers!.first!.title
    }
    
}


