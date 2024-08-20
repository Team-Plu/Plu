//
//  SocialLoginDTO.swift
//  Plu-iOS
//
//  Created by uiskim on 8/20/24.
//

import Foundation

struct SocialLoginDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
