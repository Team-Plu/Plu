//
//  AuthRepository.swift
//  Plu-iOS
//
//  Created by uiskim on 8/19/24.
//

import Foundation

import RxSwift

protocol AuthRepository {
    func login(type: SocialLoginType, token: String, fcmToken: String) -> Single<SocialLoginEntity>
    func refreshToken(accessToken: String, refreshToken: String) -> Single<ReissueTokenEntity>
    func signIn(type: SocialLoginType, token: String, fcmToken: String, nickName: String) -> Single<SignInEntity>
}
