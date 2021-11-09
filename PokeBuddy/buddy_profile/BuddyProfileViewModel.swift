//
//  BuddyProfileViewModel.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 7.09.2021.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleSignIn
import FirebaseAuth
import Firebase
import GoogleSignIn

public class BuddyProfileViewModel {
    
    private var disposable: Disposable?
    private var deleteDisposable: Disposable?
    private let controller: BuddyProfileTabViewController
    private let repository: BuddyProfileRepository
    public var buddyName: BehaviorRelay<String?> =  BehaviorRelay(value: "")
    public var heartCount: BehaviorRelay<String?> = BehaviorRelay(value: "")
    public var estimatedDays: BehaviorRelay<String?> =  BehaviorRelay(value: "")
    public var isNew: BehaviorRelay<Bool?> =  BehaviorRelay(value: true)

    
    init (controller: BuddyProfileTabViewController) {
        self.repository = BuddyProfileRepository()
        self.controller = controller
        getBuddy()
    }
    
    private func getBuddy()  {
        repository.get()
        disposable?.dispose()
        
        disposable = repository.buddyProfileRequestObservable
            .subscribe(onNext: { result in
                switch result {
                    case .Loading:
                        self.controller.isLoading = true
                    case .Loaded(let responseModel):
                        if responseModel.success {
                            self.onSuccess(responseModel: responseModel)
                        }
                        else {
                            self.onFail(responseModel: responseModel)
                        }
                        self.controller.isLoading = false
                        break
                default:
                    self.controller.isLoading = false
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
    
    private func onSuccess(responseModel: BuddyProfileResponseModel){
        self.buddyName.accept(responseModel.buddyName)
        self.heartCount.accept("\(responseModel.heartCount)")
        self.estimatedDays.accept("\(responseModel.estimatedDays) days")
        self.isNew.accept(responseModel.isNew)
    }
    
    private func onFail(responseModel: BuddyProfileResponseModel) {
        let authFailMsgTitle = ResourcesManager.getString(forKey: "auth_fail_msg_title")
        let authFailMsgText = ResourcesManager.getString(forKey: "auth_fail_msg_text")
        let buddyFailMsgTitle = ResourcesManager.getString(forKey: "buddy_fail_msg_title")
        let buddyFailMsgText = ResourcesManager.getString(forKey: "buddy_fail_msg_text")
        if (responseModel.msg == "Authorization failed. Please log in with a valid auth token.") {
            NavigationManager.showMessagePromptAndNavigate(authFailMsgTitle, authFailMsgText, controller: self.controller, toControler: LoginViewController())
        }
        if (responseModel.msg ==  "This user has no buddy") {
            NavigationManager.showMessagePromptAndNavigate(buddyFailMsgTitle, buddyFailMsgText, controller: self.controller, toControler: AddBuddyViewController())
        }
    }
    
    func onDeleteButtonClicked() {
        deleteBuddy()
    }
    
    private func deleteBuddy()  {
        repository.delete()
        deleteDisposable?.dispose()
        
        deleteDisposable = repository.buddyProfileDeleteRequestObservable
            .subscribe(onNext: { result in
                switch result {
                    case .Loaded(let deleteModel):
                        if deleteModel.success {
                            self.onSucessDelete(deleteResponseModel: deleteModel)
                        }
                        else {
                            print(deleteModel.msg)
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
    
    private func onSucessDelete(deleteResponseModel: DeleteBuddyResponseModel) {
        NavigationManager.present(from: self.controller, to: NavigationManager.createNavigationController(viewController: AddBuddyViewController()))
    }
}

