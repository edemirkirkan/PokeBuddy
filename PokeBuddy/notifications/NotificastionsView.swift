//
//  NotificationsView.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 15.09.2021.
//

import UIKit

class NotificationsView: UIView {
    private var viewController: NotificationsViewController?
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var notificationsLabel: UILabel?
    @IBOutlet weak var notificationsSwitch: UISwitch?
    @IBOutlet weak var loadingScreen: UIView?
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("NotificationsView", owner: self, options: nil)
        addSubview(contentView!)
        self.notificationsLabel?.text = ResourcesManager.getString(forKey: "notifications_cell_text")
        self.contentView?.frame = bounds
        self.contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(viewController: NotificationsViewController) {
        let screenTitle = ResourcesManager.getString(forKey: "notifications_text")
        ResourcesManager.setScreenTitle(viewController: viewController, titleName: screenTitle)
        ResourcesManager.setBackgroundColor(view: self)
    }
    
    func setSwitch(notificationThirtyMinEnabled: Bool) {
        self.notificationsSwitch?.setOn(notificationThirtyMinEnabled, animated: false)
    }
    
    func configureViewController(controller: NotificationsViewController) {
        self.viewController = controller
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch) {
        self.viewController?.notificationThirtyMinEnabled = sender.isOn
        if !UserDefaults.standard.bool(forKey: "notificationsEnabled") {
            self.notificationsSwitch?.setOn(false, animated: true)
            self.viewController?.showPermissionPrompt()
        }
    }
}

