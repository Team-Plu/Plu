//
//  APIResponse.swift
//  Plu-iOS
//
//  Created by uiskim on 8/19/24.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let code: String?
    let message: String?
    let data: T?
}
