//
//  TabBarViewController.swift
//  luyentienganh
//
//  Created by Cong Nguyen on 8/6/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import SOTabBar
class TabBarViewController: SOTabBarController {
    
    override func loadView() {
        super.loadView()
        SOTabBarSetting.tabBarTintColor = #colorLiteral(red: 2.248547389e-05, green: 0.7047000527, blue: 0.6947537661, alpha: 1)
        SOTabBarSetting.tabBarCircleSize = CGSize(width: 60, height: 60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.delegate = self
        let topHeadline = TopHeadlineViewController()
        let customNews = CustomNewsViewController()
        let profile = ProfileViewController(nib: R.nib.profileViewController)
        
        let topHeadlineNav = UINavigationController(rootViewController: topHeadline)
        topHeadlineNav.tabBarItem = UITabBarItem(title: "Top Headline", image: UIImage(named: "book_green_48pt"), selectedImage: UIImage(named: "book_white_48pt"))
        customNews.tabBarItem = UITabBarItem(title: "Custom News", image: UIImage(named: "chat_green"), selectedImage: UIImage(named: "chat_white"))
        profile.tabBarItem = UITabBarItem(title: "profile", image: UIImage(named: "menu_green"), selectedImage: UIImage(named: "menu_white"))
        
        viewControllers = [topHeadlineNav, customNews, profile]
    }
    
}

extension TabBarViewController: SOTabBarControllerDelegate {
    func tabBarController(_ tabBarController: SOTabBarController, didSelect viewController: UIViewController) {
        print(viewController.tabBarItem.title ?? "")
    }
}
