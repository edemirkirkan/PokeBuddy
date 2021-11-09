//
//  LoginViewController.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 12.08.2021.
//

import Foundation
import UIKit
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
    
    private var viewModel: LoginViewModel?
    private var mainView: LoginView { return view as! LoginView }
    
    var isLoading = false {
        didSet {
            if (!isLoading) {
                self.mainView.loadingSpinner?.stopAnimating()
                self.mainView.loadingScreen?.isHidden = true
            }
            else {
                self.mainView.loadingSpinner?.startAnimating()
                self.mainView.loadingScreen?.isHidden = false
            }
        }
    }
    
    init() {
        super.init(nibName: "LoginView", bundle: nil)
    }

    required init?(coder: NSCoder) {
       super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createViewModel()
        self.mainView.configureController(controller: self)
    }
  
    override func loadView() {
        self.view = LoginView()
    }
    
    private func createViewModel() {
        self.viewModel = LoginViewModel(controller: self)
    }
    
    func onGoogleSignInButtonClicked() {
        self.viewModel?.onGoogleSignInButtonClicked()
    }
    
    func onAppleSignInButtonClicked() {
        AppleAuthenticationManager().performAuthorizationRequest(viewController: self)
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print(appleIDCredential)
            NavigationManager.present(from: self, to: MainTabBarController())
        case let passwordCredential as ASPasswordCredential:
            print(passwordCredential)
            NavigationManager.present(from: self, to: MainTabBarController())
        default:
            NavigationManager.showMessagePrompt("Couldn't sign in", controller: self)
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

