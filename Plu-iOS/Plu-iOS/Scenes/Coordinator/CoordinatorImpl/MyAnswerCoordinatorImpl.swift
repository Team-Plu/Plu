//
//  MyAnswerCoordinatorImpl.swift
//  Plu-iOS
//
//  Created by uiskim on 2023/12/12.
//

import UIKit

final class MyAnswerCoordinatorImpl: MyAnswerCoordinator {
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func showMyAnswerViewController() {
        let myAnswerViewController = MyAnswerViewController(coordinator: self)
        self.navigationController?.pushViewController(myAnswerViewController, animated: true)
    }
    
    func presentRegisterPopUpViewController() {
        let popUpCoordinator = PopUpCoordinatorImpl(navigationController: self.navigationController)
        popUpCoordinator.registerDelgate = self
        popUpCoordinator.show(type: .register)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyAnswerCoordinatorImpl: RegisterDelegate {
    func register() {
        print("나의답변을 등록한다고 합니다")
        self.pop()
    }
}
