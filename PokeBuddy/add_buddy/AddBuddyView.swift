//
//  AddBuddyView.swift
//  PokeBuddy
//
//  Created by Deniz Turan Çağlarca on 3.09.2021.
//

import Foundation
import UIKit

class AddBuddyView: UIView {
    @IBOutlet var contentView: AddBuddyView!
    @IBOutlet weak var lbAddBuddyDescription: UILabel!
    @IBOutlet weak var tfBuddyName: UITextField!
    @IBOutlet weak var lbBuddyName: UILabel!
    @IBOutlet weak var tvAddBuddy: UITableView!
    @IBOutlet weak var btnAddAsBuddy: UIButton!
    @IBOutlet weak var csBtnDivider: NSLayoutConstraint!
    @IBOutlet weak var csBuddyNameDividerTop: NSLayoutConstraint!
    @IBOutlet weak var csBuddyNameDividerBottom: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let section_header: [String] = [ResourcesManager.getString(forKey: "add_buddy_buddy_exists_header"),
                                    ResourcesManager.getString(forKey: "add_buddy_buddy_level_header")]
    let section_data: [[String]] = [[ResourcesManager.getString(forKey: "add_buddy_new_buddy_label"),
                                     ResourcesManager.getString(forKey: "add_buddy_existing_buddy_label")],
                                    [ResourcesManager.getString(forKey: "add_buddy_good_buddy_label"),
                                     ResourcesManager.getString(forKey: "add_buddy_great_buddy_label"),
                                     ResourcesManager.getString(forKey: "add_buddy_ultra_buddy_label"),
                                     ResourcesManager.getString(forKey: "add_buddy_best_buddy_label")]]
    
    let buddyStatusData: [String] = ["good_buddy","great_buddy","ultra_buddy","best_buddy"]
    
    var viewController: AddBuddyViewController?
    var section_hidden: Bool = true
    var buddyName: String = ""
    var isNew: Bool?
    var buddyStatus: String?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AddBuddyView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        super.awakeFromNib()
        
        configureTableView()
        configureBtn()
        configureTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureTableView() {
        tvAddBuddy.delegate = self
        tvAddBuddy.dataSource = self
        tvAddBuddy.backgroundColor = UIColor.clear
        let addBuddyNib = UINib(nibName: "AddBuddyCell", bundle: Bundle.main)
        tvAddBuddy.register(addBuddyNib, forCellReuseIdentifier: "AddBuddyCell")
    }
    
    private func configureBtn() {
        btnAddAsBuddy.setTitle(ResourcesManager.getString(forKey: "add_buddy_add_as_buddy_button"), for: .normal)
        btnAddAsBuddy.setTitleColor(UIColor(named: "white"), for: .normal)
        btnAddAsBuddy.layer.cornerRadius = 10
        btnAddAsBuddy.backgroundColor = UIColor(named: "PokeBuddy Green")
        btnAddAsBuddy.adjustsImageWhenHighlighted = true
        enableButton()
        
        csBtnDivider.constant = 1/UIScreen.main.scale
        
        btnAddAsBuddy.addSubview(stackView)
        NSLayoutConstraint(item: stackView!, attribute: NSLayoutConstraint.Attribute.trailingMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: btnAddAsBuddy.titleLabel, attribute: NSLayoutConstraint.Attribute.leadingMargin, multiplier: 1, constant: -8).isActive = true
        
        imgPlus.isHidden = false
        activityIndicator.isHidden = true
    }
    
    private func configureTextView() {
        lbAddBuddyDescription.text = ResourcesManager.getString(forKey: "add_buddy_description")
        lbBuddyName.text = ResourcesManager.getString(forKey: "add_buddy_buddy_name_label")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resignKeyboardOnOutsideTap))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
        
        csBuddyNameDividerTop.constant = 1/UIScreen.main.scale
        csBuddyNameDividerBottom.constant = 1/UIScreen.main.scale
    }
    
    func setup(viewController: AddBuddyViewController) {
        self.viewController = viewController
        contentView.backgroundColor = UIColor(named: "PokeBuddy Background")
        let screenTitle = ResourcesManager.getString(forKey: "add_buddy_screen_title")
        ResourcesManager.setScreenTitle(viewController: viewController, titleName: screenTitle)
    }
    
    func enableButton() {
        if tfBuddyName.text != "" && (isNew == true || (isNew == false && buddyStatus != nil))  {
            btnAddAsBuddy.alpha = 1
            btnAddAsBuddy.isEnabled = true
        }else {
            btnAddAsBuddy.alpha = 0.25
            btnAddAsBuddy.isEnabled = false
        }
    }
    
    @IBAction func onAddBuddyBtnTouch(_ sender: UIButton) {
        sender.alpha = 0.25
        imgPlus.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    @IBAction func onAddBuddyBtnClicked(_ sender: UIButton) {
        sender.alpha = 0.25
        btnAddAsBuddy.isEnabled = false
        viewController?.onAddBuddyButtonClicked(buddyName: buddyName, isNew: isNew, buddyStatus: buddyStatus)
    }
    
}

extension AddBuddyView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section_hidden && section == 1 {
            return 0
        }
        return section_data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddBuddyCell", for: indexPath) as! AddBuddyCell
        cell.lbBuddyType.text = section_data[indexPath.section][indexPath.row]
        cell.backgroundColor = UIColor.white
        
        if indexPath.row == 0 {
            let lineView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0.5))
            lineView.layer.borderWidth = 0.5
            lineView.layer.borderColor = UIColor(red: 0.773, green: 0.773, blue: 0.78, alpha: 1).cgColor
            cell.addSubview(lineView)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if section_hidden {
            return section_data.count - 1
        }
        return section_data.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0.5))
        lineView.layer.borderWidth = 0.5
        lineView.layer.borderColor = UIColor(red: 0.773, green: 0.773, blue: 0.78, alpha: 1).cgColor
        footerView.addSubview(lineView)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.clear
        
        let label = UILabel(frame: CGRect(x: 12, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10))
        label.text = section_header[section]
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = UIColor(named: "PokeBuddy Label")
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tvAddBuddy.cellForRow(at: indexPath) as? AddBuddyCell {
            cell.accessoryType = .checkmark
            cell.lbBuddyType.textColor = UIColor(named: "PokeBuddy Green")
            
            if indexPath.section == 0 && indexPath.row == 0 {
                section_hidden = true
                tvAddBuddy.reloadData()
                
                let _indexPath = IndexPath(row: 1, section: 0)
                let _cell = tvAddBuddy.cellForRow(at: _indexPath) as? AddBuddyCell
                _cell?.accessoryType = .none
                _cell?.lbBuddyType.textColor = UIColor(named: "PokeBuddy TextTitle")
                
                isNew = true
                buddyStatus = nil
                enableButton()
                
            }else if indexPath.section == 0 && indexPath.row == 1 {
                section_hidden = false
                tvAddBuddy.reloadData()
                
                let _indexPath = IndexPath(row: 0, section: 0)
                let _cell = tvAddBuddy.cellForRow(at: _indexPath) as? AddBuddyCell
                _cell?.accessoryType = .none
                _cell?.lbBuddyType.textColor = UIColor(named: "PokeBuddy TextTitle")
                
                isNew = false
                enableButton()
                
            }else if indexPath.section == 1{
                buddyStatus = buddyStatusData[indexPath.row]
                enableButton()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tvAddBuddy.cellForRow(at: indexPath) as? AddBuddyCell {
            cell.accessoryType = .none
            cell.lbBuddyType.textColor = UIColor(named: "PokeBuddy TextTitle")
        }
    }
}


extension AddBuddyView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            buddyName = text
        }
        textField.resignFirstResponder()
        enableButton()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
        return numberOfChars < 13
    }
    
    @objc func resignKeyboardOnOutsideTap() {
        if let text = tfBuddyName.text {
            buddyName = text
        }
        tfBuddyName.resignFirstResponder()
        enableButton()
    }
}
