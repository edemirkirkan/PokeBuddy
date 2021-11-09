//
//  BuddyProfileMenuCell.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 8.09.2021.
//

import UIKit

class BuddyProfileMenuCell: UITableViewCell {
    
    lazy var buttonView: UIButton = {
        let button = UIButton(frame: CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.width - 40, height: 56))
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(buttonView)
    }
    
    func configure(isBold: Bool, text: String, textColorName: String, backgroundColorName: String ) {
        self.layer.cornerRadius = 14
        self.clipsToBounds = true
        buttonView.setTitle(text, for: .normal)
        let labelColor = UIColor(named: textColorName)
        buttonView.setTitleColor(labelColor, for: .normal)
        self.backgroundColor = UIColor(named: backgroundColorName)
        if (isBold) {
            buttonView.titleLabel?.font =  UIFont(name: "Lato-Bold", size: 20)
        }
        else {
            buttonView.titleLabel?.font = UIFont(name: "Lato-Regular", size: 17)
        }
    }
}
