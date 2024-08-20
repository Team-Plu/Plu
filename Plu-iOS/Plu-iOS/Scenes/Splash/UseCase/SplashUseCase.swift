//
//  SplashUseCase.swift
//  Plu-iOS
//
//  Created by uiskim on 8/19/24.
//

import Foundation

import RxSwift

protocol SplashUseCase {
    func tryAutoLogin() -> Single<Bool>
}

final class SplashUseCaseImpl: SplashUseCase {
    
    var disposeBag = DisposeBag()
    
    let authRepository: AuthRepository
    let userdefaultsRepository: UserDefaultsRepository
    
    init(authRepository: AuthRepository, userdefaultsRepository: UserDefaultsRepository) {
        self.authRepository = authRepository
        self.userdefaultsRepository = userdefaultsRepository
    }
    func tryAutoLogin() -> Single<Bool> {
        return .create { single in
            let tokens = self.userdefaultsRepository.getToken()
            guard let accessToken = tokens.accessToken, let refreshToken = tokens.refreshToken else {
                single(.success(false))
                return Disposables.create()
            }

            self.authRepository.refreshToken(accessToken: accessToken, refreshToken: refreshToken)
                .subscribe { token in
                    self.userdefaultsRepository.setToken(token: .init(accessToken: token.accessToken, refreshToken: token.refreshToken))
                    single(.success(true))
                } onFailure: { _ in
                    single(.success(false))
                }
                .disposed(by: self.disposeBag)

            
            return Disposables.create()
        }
    }
}
