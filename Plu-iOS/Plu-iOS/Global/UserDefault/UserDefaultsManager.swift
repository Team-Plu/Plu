//
//  UserDefaultsManager.swift
//  Plu-iOS
//
//  Created by 황찬미 on 2023/12/14.
//

import Foundation

// UserDefault에 우리가 저장하는 구조체
struct UserDefaultToken: Codable {
    var refreshToken: String?
    var accessToken: String?
    var kakaoToken: String?
    let fcmToken: String?
    
    var isExistJWT: Bool {
        return !(self.refreshToken == nil)
    }
}


struct UserDefaultsManager {
    @UserDefaultsWrapper(key: UserDefaultKeys.isShownAlarmPopup, defaultValue: false)
    static var isShownAlarmPopup: Bool?
    @UserDefaultsWrapper(key: UserDefaultKeys.token, defaultValue: nil)
    static var tokenKey: UserDefaultToken?
}

@propertyWrapper
/// UserDefault에 set하고 load해오기 위한 Manager
struct UserDefaultsWrapper<T: Codable> {

    private let key: String
    private let defaultValue: T?

    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T? {
        get {
            guard let loadedData = UserDefaults.standard.object(forKey: self.key) as? Data,
                  let decodedObject = try? JSONDecoder().decode(T.self, from: loadedData)
            else { return defaultValue }
            return decodedObject
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: self.key)
            }

        }
    }

}
