//
//  NetworkManager.swift
//  MrPoDemo
//
//  Created by Ge Ding on 3/25/21.
//

import Foundation
import Alamofire
typealias NetworkRequestResult = Result<Data, Error>
typealias NetworkRequestCompletion = (NetworkRequestResult) -> Void

private let NetworkAPIBaseURL = "https://raw.githubusercontent.com/xiaoyouxinqing/PostDemo/master/PostDemo/Resources/"

class NetworkManager {
    private init() {}//Singleton单例
    static let shared = NetworkManager()
    var commonHeader: HTTPHeaders{ ["user_id":"123","token":"xxxxxx"] }
    
    //Get
    @discardableResult func requestGet(path: String, parameters: Parameters?, completion: @escaping NetworkRequestCompletion) -> DataRequest {
        AF.request(NetworkAPIBaseURL + path,
                   parameters: parameters,
                   headers: commonHeader,
                   requestModifier: {$0.timeoutInterval = 15})
            .responseData { response in
                switch response.result {
                case let .success(data): completion(.success(data))
                case let .failure(error): completion(.failure(error))
                }
            }
    }
    
    //Post
    @discardableResult func requestPost(path: String, parameters: Parameters?, completion: @escaping NetworkRequestCompletion) -> DataRequest {
        AF.request(NetworkAPIBaseURL + path,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.prettyPrinted,
                   headers: commonHeader,
                   requestModifier: {$0.timeoutInterval = 15})
            .responseData { response in
                switch response.result {
                case let .success(data): completion(.success(data))
                case let .failure(error): completion(.failure(error))
                }
            }
    }
}
