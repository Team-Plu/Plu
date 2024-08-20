//
//  SocialLoginType.swift
//  Plu-iOS
//
//  Created by uiskim on 8/19/24.
//

import Foundation

enum SocialLoginType {
    case kakao, apple
    
    var rawValue: String {
        switch self {
        case .kakao:
            return "KAKAO"
        case .apple:
            return "APPLE"
        }
    }
}
