//
//  SplashReactor.swift
//  Plu-iOS
//
//  Created by uiskim on 8/20/24.
//

import Foundation
import UserNotifications

import ReactorKit
import RxSwift

protocol SplashNavigation: AnyObject {
    func goToLogin()
    func goToMain()
}

final class SplashReactor: Reactor {
    
    let splashUseCase: SplashUseCase
    
    weak var delegate: SplashNavigation?
    
    var initialState: State
    
    enum Action {
        case viewDidLoad
        case animationFinished
    }
    
    enum Mutation {
        case showRandomSplash(Elements?)
    }
    
    struct State {
        var randomElement: Elements? = nil
    }
    
    init(splashUseCase: SplashUseCase) {
        self.splashUseCase = splashUseCase
        self.initialState = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .animationFinished:
            return splashUseCase.tryAutoLogin()
                .asObservable()
                .flatMap { canAutoLogin -> Observable<Mutation> in
                    canAutoLogin ? self.delegate?.goToMain() : self.delegate?.goToLogin()
                    return Observable.empty()
                }
        case .viewDidLoad:
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { didAllow,Error in
                print(didAllow ? "Push: 권한 허용" : "Push: 권한 거부")
            })
            let randomElement = Elements.allCases.randomElement()
            return .just(.showRandomSplash(randomElement))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .showRandomSplash(let randomElements):
            newState.randomElement = randomElements
        }
        return newState
    }
    
}
