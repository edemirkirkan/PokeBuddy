//
//  AddBuddyRepository.swift
//  PokeBuddy
//
//  Created by Deniz Turan Çağlarca on 13.09.2021.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

class AddBuddyRepository {
    private var disposable: Disposable? = nil
    private let networkService: NetworkManager
    
    init() {
        self.networkService = NetworkManager()
    }
    
    private var _addBuddyResponseObservable: BehaviorSubject<RequestState<AddBuddyResponseModel>> = BehaviorSubject.init(value: RequestState.Uninitialized)
    var addBuddyResponseObservable: Observable<RequestState<AddBuddyResponseModel>> {
        return _addBuddyResponseObservable.asObservable()
    }
    
    func loadAddBuddyObservable(buddyName: String, isNew: Bool, buddyStatus: String?){
        let addBuddyRequest = AddBuddyRequestModel(buddyName: buddyName, isNew: isNew, buddyStatus: buddyStatus)
        
        _addBuddyResponseObservable.onNext(RequestState.Loading)
        
        disposable?.dispose()
        
        disposable = networkService.addBuddy(requestModel: addBuddyRequest)?
            .subscribe(on:SerialDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { result in
                    self._addBuddyResponseObservable.onNext(RequestState.Loaded(result))
                },
                onError: { error in
                    print(error.localizedDescription)
                },
                onCompleted: {
                    print("Completed addBuddy request event.")
                }, onDisposed: {
                    print("Disposed addBuddy request event.")
                }
            )
    }
}
