//
//  LoginViewModel.swift
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

public class LoginViewModel {
    
    private var disposable: Disposable?
    private let controller: LoginViewController
    private let loginRepository: LoginRepository
    
    init (controller: LoginViewController) {
        self.loginRepository = LoginRepository()
        self.controller = controller
    }

    func onGoogleSignInButtonClicked() {

        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GoogleAuthenticationManager.signIn(config: config, controller: self.controller) { [weak self] idToken in
            self?.loginUser(idToken: idToken)
        }
    }
    
    private func loginUser(idToken: String) {
          loginRepository.signIn(idToken: idToken)
          disposable?.dispose()
          
          disposable = loginRepository.loginRequestObservable
              .subscribe(onNext: { result in
                  switch result {
                  case .Loading:
                      self.controller.isLoading = true
                  case .Loaded(let loginModel):
                    if loginModel.success {
                        AuthenticationManager().saveToken(token: loginModel.authToken)
                        NavigationManager.displayMainTabBarScreen(from: self.controller)
                    }
                    else {
                        print(loginModel.msg)
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
}
