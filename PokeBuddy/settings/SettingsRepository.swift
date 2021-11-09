//
//  SettingsRepository.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 15.09.2021.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

class SettingsRepository {
    private var disposable: Disposable?
    private let networkService: NetworkManager
    init() {
        self.networkService = NetworkManager()
    }
    
    private var _logoutRequestObservable: BehaviorSubject<RequestState<LogoutResponseModel>> = BehaviorSubject.init(value: RequestState.Uninitialized)
    var logoutRequestObservable: Observable<RequestState<LogoutResponseModel>> {
        return _logoutRequestObservable.asObservable()
      }
    
    func logout() {
        _logoutRequestObservable.onNext(RequestState.Loading)
        
        disposable?.dispose()
        
        disposable = networkService.logout()?
            .subscribe(on:SerialDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { result in
                    self._logoutRequestObservable.onNext(RequestState.Loaded(result))
                },
                onError: { error in
                    print(error.localizedDescription)
                },
                onCompleted: {
                    print("Completed event.")
                }, onDisposed: {
                    print("Disposed event.")
                }
            )
    }
}
