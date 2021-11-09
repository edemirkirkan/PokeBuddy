//
//  ActivitiesTabView.swift
//  PokeBuddy
//
//  Created by Deniz Turan Çağlarca on 16.09.2021.
//

import UIKit

class ActivitiesTabView: UIView {
    @IBOutlet var contentView: ActivitiesTabView!

    override init(frame: CGRect){
        super.init(frame: frame)
        Bundle.main.loadNibNamed("ActivitiesTabView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
