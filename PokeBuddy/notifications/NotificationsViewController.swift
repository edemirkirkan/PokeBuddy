//
//  NotificationsViewController.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 15.09.2021.
//

import UserNotifications
import UIKit
import RxSwift

class NotificationsViewController: UIViewController {
    
    private var mainView: NotificationsView { return view as! NotificationsView }
    private var viewModel: NotificationsViewModel?
    private let disposeBag = DisposeBag()
    var notificationThirtyMinEnabled: Bool = false {
           willSet {
               if (newValue != notificationThirtyMinEnabled) {
                   mainView.setSwitch(notificationThirtyMinEnabled: newValue)
                   if (newValue) {
                       // set timer to 30 and then send notification
                       // self.sendNotificationAfterThirtyMinutes()
                   }
                   else {
                       // reset timer
                   }
               }
           }
    }

    var isLoading = false {
            didSet {
                if (!isLoading) {
                    mainView.loadingSpinner?.stopAnimating()
                    mainView.loadingScreen?.isHidden = true
                }
                else {
                    mainView.loadingSpinner?.startAnimating()
                    mainView.loadingScreen?.isHidden = false
                }
            }
        }
    
    init() {
        super.init(nibName: "NotificationsView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.configureViewController(controller: self)
        self.createViewModel()
        let center = UNUserNotificationCenter.current()
        let promptedBefore = UserDefaults.standard.bool(forKey: "promptedBefore")
        if !promptedBefore  {
            self.mainView.notificationsSwitch?.setOn(false, animated: true)
            self.viewModel?.postCurrentNotificationsInfo(notificationThirtyMinEnabled: false)
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                UserDefaults.standard.setValue(granted, forKey: "notificationsEnabled")
            }
            UserDefaults.standard.set(true, forKey: "promptedBefore")
        }
        
        else {
            if (!UserDefaults.standard.bool(forKey: "notificationsEnabled")) {
                self.notificationThirtyMinEnabled = false
            }
            else {
                self.viewModel?.getCurrentNotificationsInfo()
                self.viewModel?.notificationThirtyMinEnabled.asObservable().subscribe(onNext: {
                           [unowned self] value in
                    self.notificationThirtyMinEnabled = value ?? false
                         })
                         .disposed(by: disposeBag)
            }
        }
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                UserDefaults.standard.setValue(true, forKey: "notificationsEnabled")
            }
            else {
                UserDefaults.standard.setValue(false, forKey: "notificationsEnabled")
            }
        }
    }
    
    override func loadView() {
        self.view = NotificationsView()
        self.mainView.setup(viewController: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIView.setAnimationsEnabled(true)
        self.navigationController?.popViewController(animated: false)
        self.viewModel?.postCurrentNotificationsInfo(notificationThirtyMinEnabled: self.notificationThirtyMinEnabled)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.setAnimationsEnabled(false)
    }
    
    func postCurrentNotificationsInfo(notificationThirtyMinEnabled: Bool) {
        self.notificationThirtyMinEnabled = notificationThirtyMinEnabled
        self.viewModel?.postCurrentNotificationsInfo(notificationThirtyMinEnabled: notificationThirtyMinEnabled)
    }

    private func createViewModel() {
        self.viewModel = NotificationsViewModel(controller: self)
    }
    
    func showPermissionPrompt() {
        let allowAction = UIAlertAction(title: ResourcesManager.getString(forKey: "notifications_permission_allow"), style: .default) { (action:UIAlertAction!) in
            self.onAllowButtonClicked()
        }
        let donAllowAction = UIAlertAction(title: ResourcesManager.getString(forKey: "notifications_permission_dont_allow"), style: .cancel) { (action:UIAlertAction!) in
            self.onDontAllowButtonClicked()
        }
        NavigationManager.showConfirmationPrompt( ResourcesManager.getString(forKey: "notifications_permission_title"), ResourcesManager.getString(forKey: "notifications_permission_text"), controller: self, leftAction: donAllowAction, rightAction: allowAction)
    }
    
    func onAllowButtonClicked() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { _ in
            self.navigationController?.popViewController(animated: false)
        }
        UserDefaults.standard.setValue(true, forKey: "notificationsEnabled")
        
    }
    
    func onDontAllowButtonClicked() {
        UserDefaults.standard.setValue(false, forKey: "notificationsEnabled")
    }
    
    private func sendNotificationAfterThirtyMinutes() {
        // TODO 
    }
}
