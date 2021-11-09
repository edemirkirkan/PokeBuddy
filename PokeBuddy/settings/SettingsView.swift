//
//  SettingsView.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 14.09.2021.
//

import UIKit

class SettingsView: UIView {
    
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var notificationsCell: UIView?
    @IBOutlet weak var logoutCell: UIView?
    @IBOutlet weak var notificationsLabel: UILabel?
    @IBOutlet weak var logoutLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("SettingsView", owner: self, options: nil)
        addSubview(contentView!)
        contentView?.frame = bounds
        contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        super.awakeFromNib()
        configureCellLabels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(viewController: SettingsTabViewController) {
        ResourcesManager.setScreenTitle(viewController: viewController, titleName: ResourcesManager.getString(forKey: "settings_screen_title"))
        ResourcesManager.setBackgroundColor(view: self)
    }
    
    private func configureCellLabels() {
        notificationsLabel?.text = ResourcesManager.getString(forKey: "notifications_text")
        logoutLabel?.text = ResourcesManager.getString(forKey: "logout_text")
    }
    
    
}
