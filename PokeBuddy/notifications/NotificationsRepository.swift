//
//  NotificationsRepository.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 15.09.2021.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

class NotificationsRepository {
    private var disposable: Disposable?
    private var postDisposable: Disposable?
    private let networkService: NetworkManager
    init() {
        self.networkService = NetworkManager()
    }
    
    private var _notificationsRequestObservable: BehaviorSubject<RequestState<NotificationsResponseModel>> = BehaviorSubject.init(value: RequestState.Uninitialized)
    var notificationsRequestObservable: Observable<RequestState<NotificationsResponseModel>> {
        return _notificationsRequestObservable.asObservable()
    }
    
    private var _notificationsPostRequestObservable: BehaviorSubject<RequestState<NotificationsPostResponseModel>> = BehaviorSubject.init(value: RequestState.Uninitialized)
    var notificationsPostRequestObservable: Observable<RequestState<NotificationsPostResponseModel>> {
        return _notificationsPostRequestObservable.asObservable()
    }
    
    
    func getNotificationsPrefrences() {
        _notificationsRequestObservable.onNext(RequestState.Loading)
        
        disposable?.dispose()
        
        disposable = networkService.getNotifications()?
            .subscribe(on:SerialDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { result in
                    self._notificationsRequestObservable.onNext(RequestState.Loaded(result))
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
    
    func postNotificationsPrefrences(notificationThirtyMinEnabled: Bool) {
        let notificationRequest = NotificationsRequestModel(notificationThirtyMinEnabled: notificationThirtyMinEnabled)
        
        _notificationsPostRequestObservable.onNext(RequestState.Loading)
        
        postDisposable?.dispose()
        
        disposable = networkService.postNotifications(requestModel: notificationRequest)?
            .subscribe(on:SerialDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { result in
                    self._notificationsPostRequestObservable.onNext(RequestState.Loaded(result))
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

