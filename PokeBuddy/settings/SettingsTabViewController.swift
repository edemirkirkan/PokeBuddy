//
//  SettingsTabViewController.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 10.08.2021.
//

import Foundation
import UIKit

class SettingsTabViewController: UIViewController {
    private var viewModel: SettingsViewModel?
    private var mainView: SettingsView { return view as! SettingsView }
    
    init() {
        super.init(nibName: "SettingsView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createViewModel()
    }
    
    private func createViewModel() {
        self.viewModel = SettingsViewModel(controller: self)
    }
    
    override func loadView() {
        self.view = SettingsView()
        self.mainView.setup(viewController: self)
        self.configureCellTapGestures()
    }
    
    func onLogOutButtonClicked() {
        self.viewModel?.onLogOutButtonClicked()
        NavigationManager.present(from: self, to: LoginViewController())
    }
    
    func onNotificationsButtonClicked() {
        self.navigationController?.pushViewController(NotificationsViewController(), animated: false)
    }
    
    @objc func signOutUser(sender: UITapGestureRecognizer) {
      
        self.onLogOutButtonClicked()
    }
    
    @objc func navigateNotifications(sender: UITapGestureRecognizer) {
        self.onNotificationsButtonClicked()
    }
    
    private func configureCellTapGestures() {
        let notificationsTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateNotifications(sender:)))
        self.mainView.notificationsCell?.addGestureRecognizer(notificationsTapGesture)
        let logoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.signOutUser(sender:)))
        self.mainView.logoutCell?.addGestureRecognizer(logoutTapGesture)
    }
}
