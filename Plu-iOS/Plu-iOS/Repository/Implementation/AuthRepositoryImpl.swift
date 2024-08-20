//
//  AuthRepositoryImpl.swift
//  Plu-iOS
//
//  Created by uiskim on 8/19/24.
//

import Foundation

import RxSwift

final class AuthRepositoryImpl: AuthRepository {
    
    let request: NetworkRequest
    
    init(request: NetworkRequest) {
        self.request = request
    }
    
    func login(type: SocialLoginType, token: String, fcmToken: String) -> Single<SocialLoginEntity> {
        let result: Single<SocialLoginDTO?> = request.request(AuthRouter.socialLogin(type: type, token: token, fcmToken: fcmToken))
        return result
            .compactMap { $0 }
            .map { SocialLoginEntity(accessToken: $0.accessToken, refreshToken: $0.refreshToken) }
            .asObservable()
            .asSingle()
    }
    
    func refreshToken(accessToken: String, refreshToken: String) -> Single<ReissueTokenEntity> {
        let result: Single<ReissueTokenDTO?> = request.request(AuthRouter.reissueToken(accessToken: accessToken, refreshToken: refreshToken))
        return result
            .compactMap { $0 }
            .map { ReissueTokenEntity(accessToken: $0.accessToken, refreshToken: $0.refreshToken) }
            .asObservable()
            .asSingle()
    }
    
    func signIn(type: SocialLoginType, token: String, fcmToken: String, nickName: String) -> Single<SignInEntity> {
        let result: Single<SignInDTO?> = request.request(AuthRouter.signIn(type: type, token: token, fcmToken: fcmToken, nickname: nickName))
        return result
            .compactMap { $0 }
            .map { SignInEntity(accessToken: $0.accessToken, refreshToken: $0.refreshToken) }
            .asObservable()
            .asSingle()
    }
}
