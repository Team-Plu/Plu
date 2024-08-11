//
//  MyAnswerCoordinator.swift
//  Plu-iOS
//
//  Created by 김민재 on 12/12/23.
//

import Foundation
import Combine

protocol MyAnswerCoordinator: Coordinator {
    var myAnswerSubject: PassthroughSubject<Void, Never> { get set }
    func showMyAnswerViewController()
    func presentRegisterPopUpViewController(answer: String)
    func pop()
}
