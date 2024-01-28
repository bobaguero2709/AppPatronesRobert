//
//  UserDefaultsHelper.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/28/24.
//

import Foundation

class UserDefaultsHelper{
    private static let userDefaults = UserDefaults.standard
    
    private enum Constant {
        static let tokenKey = "KCToken"
        static let allHeroes = "KCAllHeroes"
    }
    
    static func getToken() -> String? {
        userDefaults.string(forKey: Constant.tokenKey)
    }
    
    static func save(token: String){
        userDefaults.set(token,forKey: Constant.tokenKey)
    }
    
    static func deleteToken(){
        userDefaults.removeObject(forKey: Constant.tokenKey)
    }
}
