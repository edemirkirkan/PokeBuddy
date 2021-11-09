//
//  BuddyProfileView.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 7.09.2021.
//

import UIKit

class BuddyProfileView: UIView {
    
    private var viewController: BuddyProfileTabViewController?
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var hideView: UIView?
    @IBOutlet weak var longSeperator: UIView?
    @IBOutlet weak var shortSeperator: UIView?
    @IBOutlet weak var heartCountText: UILabel?
    @IBOutlet weak var estimatedDaysText: UILabel?
    @IBOutlet weak var buddyNameLabel: UILabel?
    @IBOutlet weak var heartCountLabel: UILabel?
    @IBOutlet weak var estimatedDaysLabel: UILabel?
    @IBOutlet weak var loadingScreen: UIView?
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView?
    var slideUpMenu = UITableView()
    var slideUpMenuContainerView = UIView()
    var buddyName: String = "" {
        didSet {
            buddyNameLabel?.text = buddyName
        }
    }
    var heartCount: String = "" {
        didSet {
            heartCountLabel?.text = heartCount
        }
    }
    var estimatedDays: String = "" {
        didSet {
            estimatedDaysLabel?.text = estimatedDays
        }
    }
        
    var isNew: Bool = false {
        didSet {
            toggleView(isNew: isNew)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("BuddyProfileView", owner: self, options: nil)
        addSubview(contentView!)
        contentView?.frame = bounds
        contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        super.awakeFromNib()
        self.configureStaticLabels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setup(viewController: BuddyProfileTabViewController) {
        ResourcesManager.setScreenTitle(viewController: viewController, titleName: ResourcesManager.getString(forKey: "buddy_profile_screen_title"))
        ResourcesManager.setNavBarTintColor(viewController: viewController, color: UIColor.black)
        ResourcesManager.setBackgroundColor(view: self)
        ResourcesManager.setNavBarItem(viewController: viewController, imageName: "my_buddy_nav_bar_icon", style: .plain, target: self, action: #selector(self.onMenuButtonClicked(_:)))
    }
    
    private func toggleView(isNew: Bool) {
        if (isNew) {
            self.hideView?.isHidden = true
            self.longSeperator?.isHidden = true
            self.shortSeperator?.isHidden = false
        }
        else {
            self.hideView?.isHidden = false
            self.longSeperator?.isHidden = false
            self.shortSeperator?.isHidden = true
        }
    }
    
    private func configureStaticLabels() {
        self.heartCountText?.text = ResourcesManager.getString(forKey: "buddy_profile_heart_text")
        self.estimatedDaysText?.text = ResourcesManager.getString(forKey: "buddy_profile_time_text")
    }
    
    func configureController(controller: BuddyProfileTabViewController) {
        self.viewController = controller
    }
    
    private func configureSlideUpMenu() {
        self.slideUpMenu.delegate = self
        self.slideUpMenu.dataSource = self
        self.slideUpMenu.register(BuddyProfileMenuCell.self, forCellReuseIdentifier: "BuddyProfileMenuCell")
        self.slideUpMenu.frame = CGRect(x: 20, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width - 40 , height: 180)
        self.slideUpMenu.separatorStyle = .none
        self.slideUpMenu.backgroundColor = UIColor.clear
        self.slideUpMenu.isOpaque = false
    }
    
    @objc func onMenuButtonClicked(_ sender:UIBarButtonItem!) {
        configureSlideUpMenu()
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        slideUpMenuContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        slideUpMenuContainerView.frame = self.contentView!.frame
        window?.addSubview(slideUpMenuContainerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeSlideUpMenu))
        slideUpMenuContainerView.addGestureRecognizer(tapGesture)
        
        slideUpMenuContainerView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        self.slideUpMenuContainerView.alpha = 0.8
        }, completion: nil)
        
        
        window?.addSubview(slideUpMenu)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.slideUpMenuContainerView.alpha = 0.8
            self.slideUpMenu.frame = CGRect(x: 20, y: UIScreen.main.bounds.size.height - 180, width: UIScreen.main.bounds.size.width - 40, height: 180)
        }, completion: nil)
    }
    
    @objc func closeSlideUpMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        self.slideUpMenuContainerView.alpha = 0
                        self.slideUpMenu.frame = CGRect(x: 20, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width - 40, height: 180)
        }, completion: nil)
    }
}

extension BuddyProfileView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BuddyProfileMenuCell", for: indexPath) as! BuddyProfileMenuCell
            
            if (indexPath.section == 0) {
                let deleteText = ResourcesManager.getString(forKey: "buddy_profile_delete_text")
                cell.buttonView.addTarget(self.viewController, action: #selector(self.viewController?.onDeleteButtonClicked(_:)), for: .touchUpInside)
                cell.configure(isBold: false, text: deleteText , textColorName: "PokeBuddy ErrorRed", backgroundColorName: "PokeBuddy OpaqueWhite")
            }
            
            if (indexPath.section == 1) {
                let cancelText = ResourcesManager.getString(forKey: "buddy_profile_cancel_text")
                cell.buttonView.addTarget(self.viewController, action: #selector(self.viewController?.onCancelButtonClicked(_:)), for: .touchUpInside)
                cell.configure(isBold: true, text: cancelText, textColorName: "PokeBuddy TextTitle", backgroundColorName: "White")
            }
            return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return CGFloat(54)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return CGFloat(8)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
    }
}
