//
//  UserDefaultUtils.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 15/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

class UserDefaultsUtils {
    static var shared = UserDefaultsUtils()
    
    static var keyUsername = "key_username"
    static var keyIsLogin = "key_isLogin"
    static var keyRole = "key_role"
    static var keyPetshopId = "key_petshopId"
    
    let userDefault = UserDefaults.standard
    
    
    // MARK: - username
    func setUsername(value: String) {
        userDefault.set(value, forKey: UserDefaultsUtils.keyUsername)
    }
    
    func getUsername() -> String {
        let data =  userDefault.string(forKey: UserDefaultsUtils.keyUsername) ?? ""
        return data
    }
    
    // MARK: - Is Login
    func setIsLogin(value: Bool) {
        userDefault.set(value, forKey: UserDefaultsUtils.keyIsLogin)
    }
    
    func getIsLogin() -> Bool {
        let data =  userDefault.bool(forKey: UserDefaultsUtils.keyIsLogin)
        return data
    }
    
    // MARK: - Role
    func setRole(value: String) {
        userDefault.set(value, forKey: UserDefaultsUtils.keyRole)
    }
    
    func getRole() -> String {
        let data =  userDefault.string(forKey: UserDefaultsUtils.keyRole) ?? ""
        return data
    }
    
    // MARK: - petshopID
    func setPetshopId(value: String) {
        userDefault.set(value, forKey: UserDefaultsUtils.keyPetshopId)
    }
    
    func getPetshopId() -> String {
        let data =  userDefault.string(forKey: UserDefaultsUtils.keyPetshopId) ?? ""
        return data
    }
    
    func removePetshopId() {
        userDefault.removeObject(forKey: UserDefaultsUtils.keyPetshopId)
    }
}
