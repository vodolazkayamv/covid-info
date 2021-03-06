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
    let countriesVC : CountryCardsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardsTableVC") as! CountryCardsTableViewController
    let newsVC_Health : NewsCardsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsTableVC") as! NewsCardsTableViewController
    let newsVC_Top : NewsCardsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsTableVC") as! NewsCardsTableViewController
    let newsVC_Business : NewsCardsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsTableVC") as! NewsCardsTableViewController
    
//    let aggregatorVC : AggregatorViewController = AggregatorViewController();
    
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

        APIWorker.askCovid19API_Summary()
        APIWorker.askNewsApi_Health()
        
        self.newsVC_Health.title = NSLocalizedString("Health Control news", comment: "Новости здравоохранения")
        self.newsVC_Top.title = NSLocalizedString("Breaking News", comment: "Главные новости")
        self.newsVC_Business.title = NSLocalizedString("Business News", comment: "Новости бизнеса")
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveCovid19APICountryData(_:)), name: .didReceiveCovid19APICountryData, object: APIWorker.self)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveNewsHealthData(_:)), name: .didReceiveNewsHealthData, object: APIWorker.self)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveNewsTopData(_:)), name: .didReceiveNewsTopData, object: APIWorker.self)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveNewsBusinessData(_:)), name: .didReceiveBusinessData, object: APIWorker.self)
        
    }
    
    
    // MARK: - Page Control
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.countriesVC, self.newsVC_Health, self.newsVC_Top, self.newsVC_Business
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
        
        if (self.presentationIndex(for: pageVC) == 1) {
            APIWorker.askNewsApi_Top()
        }
        if (self.presentationIndex(for: pageVC) == 2) {
            APIWorker.askNewsApi_Business()
        }
    }
    
    
    //MARK: - Notifications
    @objc func onDidReceiveNewsHealthData(_ notification: Notification)
    {
        if let dataReceived = notification.userInfo as? [String: NewsApiResponse]
        {
            for (_, data) in dataReceived
            {
                self.newsVC_Health.articles = data.articles
            }
        }
    }
    
    @objc func onDidReceiveNewsTopData(_ notification: Notification)
    {
        if let dataReceived = notification.userInfo as? [String: NewsApiResponse]
        {
            for (_, data) in dataReceived
            {
                self.newsVC_Top.articles = data.articles
            }
        }
    }
    
    @objc func onDidReceiveNewsBusinessData(_ notification: Notification)
    {
        if let dataReceived = notification.userInfo as? [String: NewsApiResponse]
        {
            for (_, data) in dataReceived
            {
                self.newsVC_Business.articles = data.articles
            }
        }
    }
    
//    @objc func onDidReceiveCountryData(_ notification: Notification)
//    {
//        if let dataReceived = notification.userInfo as? [String: [JHUCountryInfo]]
//        {
//            for (_, dataArray) in dataReceived
//            {
//                self.countriesVC.cards = dataArray
//            }
//        }
//    }
    
    @objc func onDidReceiveCovid19APICountryData(_ notification: Notification)
    {
        if let dataReceived = notification.userInfo as? [String: [CardInfo]]
        {
            for (_, data) in dataReceived
            {
                self.countriesVC.cards = data
            }
        }
    }
}


