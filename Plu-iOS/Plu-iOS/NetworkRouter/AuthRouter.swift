//
//  AuthRouter.swift
//  Plu-iOS
//
//  Created by uiskim on 8/13/24.
//

import Foundation

import Alamofire

enum AuthRouter: URLRequestConvertible {
    
    case socialLogin(type: SocialLoginType, token: String, fcmToken: String)
    case signIn(type: SocialLoginType, token: String, fcmToken: String, nickname: String)
    case reissueToken(accessToken: String, refreshToken: String)
    
    
    var method: HTTPMethod {
        switch self {
        case .socialLogin, .signIn, .reissueToken:
            return .post
        }
    }
    
    var baseURL: String {
        return "http://3.38.38.136"
    }
    
    var path: String {
        switch self {
        case .socialLogin:
            return "/api/v1/auth/login"
        case .signIn:
            return "/api/v1/auth/signup"
        case .reissueToken:
            return "/api/v1/auth/refresh"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        switch self {
        case .socialLogin(let type, let token, let fcmToken):
            var parameters: [String: Any] = [:]
            parameters["socialType"] = type.rawValue
            parameters["token"] = token
            parameters["fcmToken"] = fcmToken
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        case .signIn(let type, let token, let fcmToken, let nickname):
            var parameters: [String: Any] = [:]
            parameters["socialType"] = type.rawValue
            parameters["token"] = token
            parameters["fcmToken"] = fcmToken
            parameters["nickname"] = nickname
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        case .reissueToken(let accessToken, let refreshToken):
            var parameters: [String: Any] = [:]
            parameters["accessToken"] = accessToken
            parameters["refreshToken"] = refreshToken
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
        
        return urlRequest
    }
    
}
