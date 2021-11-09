//
//  LoginRepository.swift
//  PokeBuddy
//
//  Created by Bilge Eren on 7.09.2021.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

class LoginRepository {
    private var disposable: Disposable?
    private let networkService: NetworkManager
    init() {
        self.networkService = NetworkManager()
    }
    
    private var _loginRequestObservable: BehaviorSubject<RequestState<LoginResponseModel>> = BehaviorSubject.init(value: RequestState.Uninitialized)
    var loginRequestObservable: Observable<RequestState<LoginResponseModel>> {
        return _loginRequestObservable.asObservable()
      }
    
    func signIn(idToken: String) {
        let loginRequest = LoginRequestModel(idToken: idToken)
        
        _loginRequestObservable.onNext(RequestState.Loading)
        
        disposable?.dispose()
        
        disposable = networkService.login(requestModel: loginRequest)?
            .subscribe(on:SerialDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { result in
                    self._loginRequestObservable.onNext(RequestState.Loaded(result))
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
