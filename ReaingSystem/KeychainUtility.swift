//
//  KeyCHainUtility.swift
//  数据持久化之KeyChain
//  info.plist需要配置参数 AppIdentifierPrefix
//
//  Created by 魏辉 on 16/8/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation

class KeychainUtility: NSObject {
    private var service = ""
    private var group = ""
    
    init(service: String, group: String) {
        super.init()
        self.service = service
        self.group = group
    }
    
    private func prepareDic(key: String) -> [String: AnyObject] {
        var dic = [String: AnyObject]()
        //设定keyChain类型
        dic[kSecClass as String] = kSecClassGenericPassword
        //目标资料库 Keychain Group
        dic[kSecAttrService as String] = self.service
        //发布者代号，用户不同APP之间传值
        dic[kSecAttrAccessGroup as String] = self.group
        //Hashtable的Key值
        dic[kSecAttrAccount as String] = key
        return dic
    }
    
    func insert(data: NSData, key: String) -> Bool {
        var dic = prepareDic(key)
        //key值相对应的value
        dic[kSecValueData as String] = data
        let status = SecItemAdd(dic, nil)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    func query(key: String) -> NSData? {
        var dic = prepareDic(key)
        dic[kSecReturnData as String] = kCFBooleanTrue
        var data: AnyObject?
        let status: OSStatus?
        do {
            status = try withUnsafeMutablePointer(&data) {
                SecItemCopyMatching(dic, UnsafeMutablePointer($0))
            }
        } catch {
            return nil
        }
        if status == errSecSuccess {
            return data as? NSData
        } else {
            return nil
        }
    }
    
    func update(data: NSData, key: String) -> Bool {
        var query = prepareDic(key)
        var dic = [String: AnyObject]()
        dic[kSecValueData as String] = data
        let status = SecItemUpdate(query, dic)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
        
    }
    
    func deleteData(key: String) -> Bool {
        var dic = prepareDic(key)
        let status = SecItemDelete(dic)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
}











