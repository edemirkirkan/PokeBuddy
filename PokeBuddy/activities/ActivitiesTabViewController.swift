//
//  ActivitiesTabViewController.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 10.08.2021.
//

import Foundation
import UIKit

class ActivitiesTabViewController: UIViewController {
    //private var viewModel: ActivitiesTabViewModel
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = ActivitiesTabView()
    }

    required init?(coder: NSCoder) {
       super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenTitle = ResourcesManager.getString(forKey: "activities_screen_title")
        ResourcesManager.setScreenTitle(viewController: self, titleName: screenTitle)
        ResourcesManager.setNavBarTintColor(viewController: self, color: UIColor.red)
        ResourcesManager.setBackgroundColor(viewController: self)
        ResourcesManager.setNavBarItem(viewController: self, imageName: "activities_nav_bar_icon", style: .plain, target: self, action: nil)
    }
    
}
