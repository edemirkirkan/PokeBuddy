//
//  BuddyProfileRepository.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 13.09.2021.

//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

class BuddyProfileRepository {
    private var disposable: Disposable?
    private var deleteDisposable: Disposable?
    private let networkService: NetworkManager
    
    init() {
        self.networkService = NetworkManager()
    }
    
    private var _buddyProfileRequestObservable: BehaviorSubject<RequestState<BuddyProfileResponseModel>> = BehaviorSubject.init(value: RequestState.Uninitialized)
    var buddyProfileRequestObservable: Observable<RequestState<BuddyProfileResponseModel>> {
        return _buddyProfileRequestObservable.asObservable()
    }
    
    private var _buddyProfileDeleteRequestObservable: BehaviorSubject<RequestState<DeleteBuddyResponseModel>> = BehaviorSubject.init(value: RequestState.Uninitialized)
    var buddyProfileDeleteRequestObservable: Observable<RequestState<DeleteBuddyResponseModel>> {
        return _buddyProfileDeleteRequestObservable.asObservable()
    }
    
    func get() {
        _buddyProfileRequestObservable.onNext(RequestState.Loading)
        
        disposable?.dispose()
        
        disposable = networkService.getBuddyProfile()?
            .subscribe(on:SerialDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { result in
                    self._buddyProfileRequestObservable.onNext(RequestState.Loaded(result))
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
    
    func delete() {
        _buddyProfileDeleteRequestObservable.onNext(RequestState.Loading)
        
        deleteDisposable?.dispose()
        
        deleteDisposable = networkService.deleteBuddyProfile()?
            .subscribe(on:SerialDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { result in
                    self._buddyProfileDeleteRequestObservable.onNext(RequestState.Loaded(result))
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
