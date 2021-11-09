//
//  NotificationsViewModel.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 15.09.2021.
//

import Foundation
import RxSwift
import RxCocoa

public class NotificationsViewModel {
    
    private var disposable: Disposable?
    private var postDisposable: Disposable?
    private let controller: NotificationsViewController
    private let repository: NotificationsRepository
    public var notificationThirtyMinEnabled: BehaviorRelay<Bool?> = BehaviorRelay(value: false)
    
    init (controller: NotificationsViewController) {
        self.repository = NotificationsRepository()
        self.controller = controller
    }

    func getCurrentNotificationsInfo() {
        self.getNotificationsInfo()
    }
    
    func postCurrentNotificationsInfo(notificationThirtyMinEnabled: Bool) {
        self.postNotificationsInfo(notificationThirtyMinEnabled: notificationThirtyMinEnabled)
    }
    
    private func getNotificationsInfo() {
        repository.getNotificationsPrefrences()
        disposable?.dispose()
        
        disposable = repository.notificationsRequestObservable
            .subscribe(onNext: { result in
                switch result {
                    case .Loading:
                        self.controller.isLoading = true
                        break
                    case .Loaded(let notificationsModel):
                        if notificationsModel.success {
                            self.onSuccess(responseModel: notificationsModel)
                        }
                        else {
                            print(notificationsModel.msg)
                        }
                        self.controller.isLoading =  false
                        break
                    default:
                        self.controller.isLoading =  false
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
    
    private func postNotificationsInfo(notificationThirtyMinEnabled: Bool) {
        repository.postNotificationsPrefrences(notificationThirtyMinEnabled: notificationThirtyMinEnabled)
        postDisposable?.dispose()
        
        postDisposable? = repository.notificationsPostRequestObservable
            .subscribe(onNext: { result in
                switch result {
                    case .Loaded(let notificationsModel):
                        if !notificationsModel.success {
                            print(notificationsModel.msg)
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
    private func onSuccess(responseModel: NotificationsResponseModel){
        self.notificationThirtyMinEnabled.accept(responseModel.notificationThirtyMinEnabled)
    }
}

