//
//  MainTabBarController.swift
//  PokeBuddy
//
//  Created by Bilge Eren on 31.07.2021.
//

import UIKit
import AppTrackingTransparency

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTabBar()
        self.showPrivacyDialogue()
    }
    
    private func createTabBar() {
        let activitiesTabController = NavigationManager.createNavigationController(viewController: ActivitiesTabViewController())
        let activitiesTabBarTitle = ResourcesManager.getString(forKey: "activities_tab_bar_title")
        ResourcesManager.setTabBarItem(tabController: activitiesTabController, titleName: activitiesTabBarTitle, imageName: "activities_tab_bar_icon", tagIndex: 0)
        
        let buddyProfileTabController = NavigationManager.createNavigationController(viewController: BuddyProfileTabViewController())
        let buddyProfileTabBarTitle = ResourcesManager.getString(forKey: "buddy_profile_tab_bar_title")
        ResourcesManager.setTabBarItem(tabController: buddyProfileTabController, titleName: buddyProfileTabBarTitle, imageName: "my_buddy_tab_bar_icon", tagIndex: 1)
        
        let settingsTabController = NavigationManager.createNavigationController(viewController: SettingsTabViewController())
        let settingsTabBarTitle = ResourcesManager.getString(forKey: "settings_tab_bar_title")
        ResourcesManager.setTabBarItem(tabController: settingsTabController, titleName: settingsTabBarTitle, imageName: "settings_tab_bar_icon", tagIndex: 2)
        
        self.tabBar.tintColor = .red
        self.setViewControllers([activitiesTabController, buddyProfileTabController, settingsTabController], animated: false)
    }
    
    private func showPrivacyDialogue() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .notDetermined:
                    break
                case .restricted:
                    break
                case .denied:
                    break
                case .authorized:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
}

