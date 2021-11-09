//
//  AddBuddyViewModel.swift
//  PokeBuddy
//
//  Created by Deniz Turan Çağlarca on 3.09.2021.
//

import Foundation
import RxSwift
import RxCocoa

class AddBuddyViewModel {
    private let controller: AddBuddyViewController
    private var disposable: Disposable? = nil
    private let addBuddyRepository: AddBuddyRepository

    init(controller: AddBuddyViewController){
        self.controller = controller
        self.addBuddyRepository = AddBuddyRepository()
    }
    
    
    func onAddBuddyButtonClicked(buddyName: String, isNew: Bool, buddyStatus: String?) {
        addBuddyRepository.loadAddBuddyObservable(buddyName: buddyName, isNew: isNew, buddyStatus: buddyStatus)
        
        disposable?.dispose()
        
        disposable = self.addBuddyRepository.addBuddyResponseObservable
            .subscribe(onNext: { result in
                        switch result {
                        case .Loaded(let addBuddyModel):
                            if addBuddyModel.success {
                                NavigationManager.displayMainTabBarScreen(from: self.controller)
                            }
                            break
                            
                        default:
                            break
                        }}, onError: { error in
                            print(error.localizedDescription)
                        },  onCompleted: {
                            print("Completed addBuddy response event.")
                        }, onDisposed: {
                            print("Disposed addBuddy response event.")
                        }
            )
    }
}
