//
//  API.swift
//  Plu-iOS
//
//  Created by uiskim on 8/19/24.
//

import Foundation

import Alamofire

enum API {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
}
