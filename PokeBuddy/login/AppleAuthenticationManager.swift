//
//  AppleAuthenticationManager.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 29.09.2021.
//

import Foundation
import AuthenticationServices

class AppleAuthenticationManager {
    func performAuthorizationRequest(viewController: LoginViewController) {
        let request = ASAuthorizationAppleIDProvider().createRequest() 
        request.requestedScopes = [.fullName, .email]
         
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = viewController
        controller.presentationContextProvider = viewController
        controller.performRequests()
    }
}
