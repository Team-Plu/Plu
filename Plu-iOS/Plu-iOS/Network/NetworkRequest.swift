//
//  NetworkRequest.swift
//  Plu-iOS
//
//  Created by uiskim on 8/19/24.
//

import Foundation

import Alamofire
import RxSwift

protocol NetworkRequest {
    func request<T: Decodable>(_ endPoint: URLRequestConvertible) -> Single<T?>
}

final class NetworkRequestImpl: NetworkRequest {
    func request<T: Decodable>(_ endPoint: URLRequestConvertible) -> Single<T?> {
        return Single.create { single in
            API.session
                .request(endPoint)
                .validate(statusCode: 200..<300)
                .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                        single(.success(apiResponse.data))
                    } catch {
                        single(.failure(error))
                    }
                case .failure(let error):
                    if let data = response.data, let serverError = try? JSONDecoder().decode(APIResponse<T?>.self, from: data) {
                        single(.failure(NetworkError.clientError(code: serverError.code, message: serverError.message)))
                        return
                    }
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
