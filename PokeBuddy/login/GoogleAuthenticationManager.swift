//
//  GoogleAuthenticationManager.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 3.09.2021.
//

import GoogleSignIn
import FirebaseAuth
import SwiftyJSON

class GoogleAuthenticationManager {
    
    static func signIn(config: GIDConfiguration, controller: LoginViewController, completionHandler: @escaping (String) -> Void) {
        GIDSignIn.sharedInstance.signIn(with: config, presenting: controller) { [unowned controller] user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let selectionMsg = ResourcesManager.getString(forKey: "multi_factor_selection_msg")
            let multiFactorFailMsg = ResourcesManager.getString(forKey: "multi_factor_fail_msg")
            let verificationCodeMsg = ResourcesManager.getString(forKey: "multi_factor_verification_code_msg")
            let finalizeFailMsg = ResourcesManager.getString(forKey: "multi_factor_finalize_fail_msg")
            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
            completionHandler(idToken)
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    let authError = error as NSError
                    if  authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                    let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                    var displayNameString = ""
                    for tmpFactorInfo in resolver.hints {
                      displayNameString += tmpFactorInfo.displayName ?? ""
                      displayNameString += " "
                    }
                    NavigationManager.showTextInputPrompt(
                        withMessage: selectionMsg,
                        controller: controller,
                        completionBlock: { userPressedOK, displayName in
                        var selectedHint: PhoneMultiFactorInfo?
                        for tmpFactorInfo in resolver.hints {
                            if displayName == tmpFactorInfo.displayName {
                            selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                            }
                        }
                            
                        PhoneAuthProvider.provider()
                          .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
                                             multiFactorSession: resolver
                                               .session) { verificationID, error in
                            if error != nil {
                              print(multiFactorFailMsg)
                            }
                            else {
                              NavigationManager.showTextInputPrompt(
                                withMessage: verificationCodeMsg,
                                controller: controller,
                                completionBlock: { userPressedOK, verificationCode in
                                  let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
                                    .credential(withVerificationID: verificationID!,
                                                verificationCode: verificationCode!)
                                  let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
                                    .assertion(with: credential!)
                                  resolver.resolveSignIn(with: assertion!) { authResult, error in
                                    if error != nil {
                                      print(finalizeFailMsg)
                                    } else {
                                      controller.navigationController?.popViewController(animated: true)
                                    }
                                  }
                                }
                              )
                            }
                          }
                      }
                    )
                  }
                    else {
                        print(error.localizedDescription)
                        return
                    }
                    return
                }
            }
        }
    }
}
