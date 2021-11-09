//
//  BuddyProfileTabViewController.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 10.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

class BuddyProfileTabViewController: UIViewController  {
    
    private var viewModel: BuddyProfileViewModel?
    private var mainView: BuddyProfileView { return view as! BuddyProfileView }
    private let disposeBag = DisposeBag()
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
        super.init(nibName: "BuddyProfileView", bundle: nil)
    }

    required init?(coder: NSCoder) {
       super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.configureController(controller: self)
        self.createViewModel()
        self.viewModel?.buddyName.asObservable().subscribe(onNext: { 
                   [unowned self] value in
            self.mainView.buddyName = value ?? ""
                 })
                 .disposed(by: disposeBag)
        self.viewModel?.heartCount.asObservable().subscribe(onNext: {
                   [unowned self] value in
            self.mainView.heartCount = value ?? ""
                 })
                 .disposed(by: disposeBag)
        self.viewModel?.estimatedDays.asObservable().subscribe(onNext: {
                   [unowned self] value in
            self.mainView.estimatedDays = value ?? ""
                 })
                 .disposed(by: disposeBag)
        self.viewModel?.isNew.asObservable().subscribe(onNext: {
                   [unowned self] value in
            self.mainView.isNew = value ?? false
                 })
                 .disposed(by: disposeBag)
    }
    
    override func loadView() {
        self.view = BuddyProfileView()
        self.mainView.setup(viewController: self)
    }
    
    private func createViewModel() {
        self.viewModel = BuddyProfileViewModel(controller: self)
    }
    
    @objc func onDeleteButtonClicked(_ sender:UIBarButtonItem!) {
        self.mainView.closeSlideUpMenu()
        let confirmationTitle = ResourcesManager.getString(forKey: "delete_buddy_confirmation_title")
        let confirmationText = ResourcesManager.getString(forKey: "delete_buddy_confirmation_text")
        let delete = ResourcesManager.getString(forKey: "confirmation_delete_text")
        let cancel = ResourcesManager.getString(forKey: "confirmation_cancel_text")
        let deleteAction = UIAlertAction(title: delete, style: .destructive) { (action:UIAlertAction!) in
            self.viewModel?.onDeleteButtonClicked()
        }
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        NavigationManager.showConfirmationPrompt(confirmationTitle, confirmationText, controller: self, leftAction: deleteAction, rightAction: cancelAction)
    }
    
    @objc func onCancelButtonClicked(_ sender:UIBarButtonItem!) {
        self.mainView.closeSlideUpMenu()
    }
}
