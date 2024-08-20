//
//  SplashViewController.swift
//  Plu-iOS
//
//  Created by uiskim on 2023/12/04.
//  Copyright (c) 2023 Splash. All rights reserved.
//

import UIKit

import Alamofire
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

final class SplashViewController: UIViewController, View {

    typealias Reactor = SplashReactor
    var disposeBag = DisposeBag()
    
    private let eyeImageView = PLUImageView(nil)
    private let wordMarkView = PLUImageView(ImageLiterals.Splash.pluWordmarkLarge)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setHierarchy()
        setLayout()
    }
    
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        Observable.just(())
          .map { Reactor.Action.viewDidLoad }
          .bind(to: reactor.action)
          .disposed(by: disposeBag)
        
        Observable.just(())
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .map { Reactor.Action.animationFinished }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.compactMap { $0.randomElement }
            .withUnretained(self)
            .subscribe(onNext: { owner, randomElement in
                owner.view.backgroundColor = .designSystem(randomElement.color)
                owner.eyeImageView.image = randomElement.eyeImage
            })
            .disposed(by: disposeBag)
    }
}

private extension SplashViewController {
    
    func setUI(from element: Elements) {
        self.view.backgroundColor = .designSystem(element.color)
        self.eyeImageView.image = element.eyeImage
    }
    
    func setHierarchy() {
        view.addSubviews(eyeImageView, wordMarkView)
    }
    
    func setLayout() {
        eyeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.25)
            make.height.equalTo(eyeImageView.snp.width).multipliedBy(0.5)
        }
        
        wordMarkView.snp.makeConstraints { make in
            make.top.equalTo(eyeImageView.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.20)
            make.height.equalTo(wordMarkView.snp.width).multipliedBy(0.74)
        }
    }
}

protocol UserDefaultsRepository {
    func getToken() -> PluToken
    func setToken(token: PluToken)
    func removeToken()
}

final class UserDefaultsRepositoryImpl: UserDefaultsRepository {
    
    func getToken() -> PluToken {
        guard let accessToken = self.get(forKey: .accessToken) as? String, let refreshToken = self.get(forKey: .refreshToken) as? String else {
            return .init(accessToken: nil, refreshToken: nil)
        }
        return .init(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func setToken(token: PluToken) {
        self.set(to: token.accessToken, forKey: .accessToken)
        self.set(to: token.refreshToken, forKey: .refreshToken)
    }
    
    func removeToken() {
        self.remove(forKey: .accessToken)
        self.remove(forKey: .refreshToken)
    }
}

extension UserDefaultsRepository {
    
    func set<T>(to: T, forKey: UserDefaultsKeyType) {
        UserDefaults.standard.setValue(to, forKey: forKey.rawValue)
        print("UserDefaultsManager: save \(forKey) complete")
    }
    
    func get(forKey: UserDefaultsKeyType) -> Any? {
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }
    
    func remove(forKey: UserDefaultsKeyType) {
        UserDefaults.standard.removeObject(forKey: forKey.rawValue)
    }
}



