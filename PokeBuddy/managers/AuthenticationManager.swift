//
//  AuthenticationManager.swift
//  PokeBuddy
//
//  Created by Deniz Turan Çağlarca on 13.08.2021.
//

import Foundation
import RxSwift
import RxCocoa

class AuthenticationManager {
    private let userDefaults: UserDefaults
    
    let loginSubject: ReplaySubject<Bool> = ReplaySubject<Bool>.create(bufferSize: 1)
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveToken(token: String?) {
        guard let token = token else {
            userDefaults.removeObject(forKey: "registrationToken")
            userDefaults.synchronize()
            loginSubject.onNext(false)
            return
        }
        userDefaults.set(token, forKey: "registrationToken")
        saveNewState()
        loginSubject.onNext(true)
    }
    
    func deleteToken() {
        userDefaults.removeObject(forKey: "registrationToken")
        userDefaults.synchronize()
        saveNewState()
        loginSubject.onNext(false)
    }
    
    func getToken() -> String? {
        let registrationToken: String? = userDefaults.object(forKey: "registrationToken") as? String
        return registrationToken
    }
    
    private func saveNewState(){
        let isSaved = userDefaults.synchronize()
        if !isSaved {
            print("Could not save.")
        }
    }
}
