//
//  NetworkManager.swift
//  PokeBuddy
//
//  Created by Deniz Turan Çağlarca on 27.08.2021.
//

import Foundation
import RxSwift
import SwiftyJSON

enum ObservableError: Error {
    case UnableToCreate
}

enum RequestState<T> {
    case Uninitialized
    case Loading
    case Loaded(T)
    case Error(String)
}

class NetworkManager {
    func addBuddy(requestModel: AddBuddyRequestModel) -> Observable<AddBuddyResponseModel>? {
        let baseUrl: String = "https://app.pokebuddy.me"
        let urlSession: URLSession = URLSession(configuration: .default)
        guard let endpointUrl = URL(string: baseUrl + "/add_buddy") else {
            return nil
        }

        var request = URLRequest(url: endpointUrl)
        
        configureRequestHeader(request: &request, httpMethod: "POST")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestModel.createJsonObject())
        
        let task: Observable<AddBuddyResponseModel>  = urlSession.rx
            .response(request: request)
            .observe(on: MainScheduler.instance)
            .map { response, data in
                AddBuddyResponseModel(json: try JSON(data: data))
            }
        
        return task
    }
    
    func login(requestModel: LoginRequestModel) -> Observable<LoginResponseModel>? {

        let baseUrl: String = "https://app.pokebuddy.me"
        let urlSession: URLSession = URLSession(configuration: .default)
        guard let endpointUrl = URL(string: baseUrl + "/signin") else {
            return nil
        }
        var request = URLRequest(url: endpointUrl)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestModel.createJsonObject())
        
        let task: Observable<LoginResponseModel>  = urlSession.rx
            .response(request: request)
            .observe(on: MainScheduler.instance)
            .map { response, data in
                LoginResponseModel(json: try JSON(data: data))
            }
        
        return task
    }
    
    func getBuddyProfile() -> Observable<BuddyProfileResponseModel>? {
        let baseUrl: String = "https://app.pokebuddy.me"
        let urlSession: URLSession = URLSession(configuration: .default)
        guard let endpointUrl = URL(string: baseUrl + "/get_buddy") else {
            return nil
        }

        var request = URLRequest(url: endpointUrl)
        
        configureRequestHeader(request: &request, httpMethod: "GET")
       
        let task: Observable<BuddyProfileResponseModel>  = urlSession.rx
            .response(request: request)
           .observe(on: MainScheduler.instance)
            .map { response, data in
                BuddyProfileResponseModel(json: try JSON(data: data))
           }
        return task
    }
    
    func deleteBuddyProfile() -> Observable<DeleteBuddyResponseModel>? {
        let baseUrl: String = "https://app.pokebuddy.me"
        let urlSession: URLSession = URLSession(configuration: .default)
        guard let endpointUrl = URL(string: baseUrl + "/delete_buddy") else {
            return nil
        }

        var request = URLRequest(url: endpointUrl)
        
        configureRequestHeader(request: &request, httpMethod: "DELETE")
       
        let task: Observable<DeleteBuddyResponseModel>  = urlSession.rx
            .response(request: request)
           .observe(on: MainScheduler.instance)
            .map { response, data in
                DeleteBuddyResponseModel(json: try JSON(data: data))
           }
        return task
    }
    
    func logout() -> Observable<LogoutResponseModel>? {
        let baseUrl: String = "https://app.pokebuddy.me"
        let urlSession: URLSession = URLSession(configuration: .default)
        guard let endpointUrl = URL(string: baseUrl + "/logout") else {
            return nil
        }

        var request = URLRequest(url: endpointUrl)
        
        configureRequestHeader(request: &request, httpMethod: "GET")
       
        let task: Observable<LogoutResponseModel>  = urlSession.rx
            .response(request: request)
           .observe(on: MainScheduler.instance)
            .map { response, data in
                LogoutResponseModel(json: try JSON(data: data))
           }
        return task
    }
    
    func getNotifications() -> Observable<NotificationsResponseModel>? {
          let baseUrl: String = "https://app.pokebuddy.me"
          let urlSession: URLSession = URLSession(configuration: .default)
          guard let endpointUrl = URL(string: baseUrl + "/notifications") else {
              return nil
          }

          var request = URLRequest(url: endpointUrl)

          configureRequestHeader(request: &request, httpMethod: "GET")

          let task: Observable<NotificationsResponseModel>  = urlSession.rx
              .response(request: request)
             .observe(on: MainScheduler.instance)
              .map { response, data in
                  NotificationsResponseModel(json: try JSON(data: data))
             }
          return task
    }


    func postNotifications(requestModel: NotificationsRequestModel) -> Observable<NotificationsPostResponseModel>? {
        let baseUrl: String = "https://app.pokebuddy.me"
        let urlSession: URLSession = URLSession(configuration: .default)
        guard let endpointUrl = URL(string: baseUrl + "/notifications") else {
            return nil
        }

        var request = URLRequest(url: endpointUrl)

        configureRequestHeader(request: &request, httpMethod: "POST")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestModel.createJsonObject())

        let task: Observable<NotificationsPostResponseModel>  = urlSession.rx
            .response(request: request)
            .observe(on: MainScheduler.instance)
            .map { response, data in
                NotificationsPostResponseModel(json: try JSON(data: data))
            }
        return task
    }

    private func configureRequestHeader(request: inout URLRequest, httpMethod: String) {
        let token = AuthenticationManager().getToken()
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
    }
}
