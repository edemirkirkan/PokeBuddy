//
//  ResourceManager.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 17.08.2021.
//

import Foundation
import UIKit

class ResourcesManager {
    static func getString(forKey: String) -> String {
        return NSLocalizedString(forKey, comment: "")
    }
    static func setScreenTitle(viewController: UIViewController, titleName: String) {
        let customFont = UIFont(name: "Lato-Semibold", size: 17.0)
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont!]
        viewController.title = titleName
    }
    static func setNavBarTintColor(viewController: UIViewController, color: UIColor) {
        viewController.navigationController?.navigationBar.tintColor = color
    }
    
    static func setBackgroundColor(viewController: UIViewController) {
        viewController.view.backgroundColor = UIColor(named: "PokeBuddy Background")
    }
    static func setBackgroundColor(view: UIView) {
        view.backgroundColor = UIColor(named: "PokeBuddy Background")
    }
    static func setNavBarItem(viewController: UIViewController, imageName: String, style: UIBarButtonItem.Style, target: Any?, action: Selector?) {
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: imageName),
            style: style,
            target: target,
            action: action
        )
    }
    static func setTabBarItem(tabController: UINavigationController, titleName: String, imageName: String, tagIndex: Int) {
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "Lato-Regular", size: 10)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        tabController.tabBarItem = UITabBarItem(
            title: titleName,
            image: UIImage(named: imageName),
            tag: tagIndex
        )
    }
}
