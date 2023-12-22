//
//  MyPageCoordinatorImpl.swift
//  Plu-iOS
//
//  Created by 김민재 on 12/12/23.
//

import UIKit

protocol MypageAlarmResultDelegate: AnyObject {
    func isAccept()
}

final class MyPageCoordinatorImpl: MyPageCoordinator {
    weak var delegate: MypageAlarmResultDelegate?
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func showMyPageViewController() {
        let mypageViewController = MyPageViewController(coordinator: self)
        self.navigationController?.pushViewController(mypageViewController, animated: true)
    }
    
    func presentAlarmPopUpViewController() {
        let popUpCoordinator = PopUpCoordinatorImpl(navigationController: self.navigationController)
        popUpCoordinator.alarmDelegate = self
        popUpCoordinator.show(type: .alarm(.mypage))
    }
    
    func showProfileEditViewController() {
        let manager = NicknameManagerStub()
        let viewModel = NicknameEditViewModelImpl(nickNameManager: manager, coordinator: self)
        let profileEditViewController = NicknameEditViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(profileEditViewController, animated: true)
    }
    
    func showResignViewController() {
        let adaptor = ResignAdaptor(coordinator: self)
        let manager = ResignManagerImpl()
        let viewModel = ResignViewModelImpl(adaptor: adaptor, manager: manager)
        let resignViewController = ResignViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(resignViewController, animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyPageCoordinatorImpl: AlarmDelegate {
    func isAccept() {
        self.delegate?.isAccept()
    }
}
