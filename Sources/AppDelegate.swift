//
//  AppDelegate.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//


import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate var tabBar = UITabBarController()

    override init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.setupTabBar()

        self.window?.rootViewController = self.tabBar
        self.window?.makeKeyAndVisible()

        TransactionManager.shared.loadIfNeeded()

        return true
    }

    private func setupTabBar() {
        let transactions = TransactionsViewController()
        let transactionsNavi = UINavigationController(rootViewController: transactions)

        let about = AboutViewController()
        let aboutNavi = UINavigationController(rootViewController: about)

        self.tabBar.viewControllers = [ transactionsNavi, aboutNavi ]

        // disable editing of tab bar items
        self.tabBar.customizableViewControllers = nil

        self.tabBar.selectedIndex = 0
    }

}
