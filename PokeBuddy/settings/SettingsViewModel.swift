//
//  SettingsViewModel.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 15.09.2021.
//

import Foundation
import RxSwift
import RxCocoa

public class SettingsViewModel {
    
    private var disposable: Disposable?
    private let controller: SettingsTabViewController
    private let repository: SettingsRepository
    
    init (controller: SettingsTabViewController) {
        self.repository = SettingsRepository()
        self.controller = controller
    }

    func onLogOutButtonClicked() {
        logoutUser()
    }
    
    private func logoutUser() {
        repository.logout()
        disposable?.dispose()
        
        disposable = repository.logoutRequestObservable
            .subscribe(onNext: { result in
                switch result {
                    case .Loaded(let logoutModel):
                        if logoutModel.success {
                            AuthenticationManager().deleteToken()
                        }
                        else {
                            print(logoutModel.msg)
                        }
                        break
                default:
                        break
                }}, onError: { error in
                    print("error. VM")
                    print(error.localizedDescription)
                },  onCompleted: {
                    print("Completed event. VM")
                }, onDisposed: {
                    print("Disposed event. VM")
                }
            )
    }
}
