//
//  AddBuddyViewController.swift
//  PokeBuddy
//
//  Created by Deniz Turan Çağlarca on 14.09.2021.
//

import UIKit

class AddBuddyViewController: UIViewController {

    private var viewModel: AddBuddyViewModel?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        createViewModel()
    }
    
    override func loadView() {
        let view = AddBuddyView()
        view.setup(viewController: self)
        self.view = view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createViewModel() {
        self.viewModel = AddBuddyViewModel(controller: self)
    }
    
    func onAddBuddyButtonClicked(buddyName: String, isNew: Bool?, buddyStatus: String?) {
        guard let isNew = isNew else {return}
        viewModel?.onAddBuddyButtonClicked(buddyName: buddyName, isNew: isNew, buddyStatus: buddyStatus)
    }
}
