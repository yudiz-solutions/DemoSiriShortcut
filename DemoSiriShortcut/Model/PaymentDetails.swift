//
//  PaymentDetails.swift
//  DemoSiriShortcut
//
//  Created by Yudiz Solutions on 29/08/18.
//  Copyright © 2018 Yudiz Solutions. All rights reserved.
//

import UIKit

/// PaymentDetails
class PaymentDetails {
    
    /// Static variable(s)
    static let defaultKey: String = "defaultSiriKey" // Key for Payment Value
    static let appGroupId: String = "group.com.yudiz.iCloudYudiz" // App Group Id
    
    /// To set initial value when app loads
    ///
    /// - Parameter amount: amount that is passed for initial value
    static func setBalance(amount: Int) {
        guard let defaults = UserDefaults(suiteName: appGroupId) else { return }
        defaults.set(amount, forKey: defaultKey)
        defaults.synchronize()
    }
    
    /// To check the balance of user
    ///
    /// - Returns: it returns available amount
    static func checkBalance() -> Int? {
        guard let defaults = UserDefaults(suiteName: appGroupId) else { return nil }
        defaults.synchronize()
       
        let balance = defaults.integer(forKey: defaultKey)
        return balance
    }
    
    /// To withraw the money
    ///
    /// - Parameter amount: money to be withrawn
    /// - Returns: available balance after process
    static func withdraw(amount: Int) -> Int? {
        guard let defaults = UserDefaults(suiteName: appGroupId) else { return nil }
        defaults.synchronize()
        
        let balance = defaults.integer(forKey: defaultKey)
        let newBalance =  balance - amount
        if newBalance < 0 {
            return nil
        } else {
            defaults.set(newBalance, forKey: defaultKey)
            return newBalance
        }
    }
    
    @discardableResult // It is used to remove warning of unused return value
    /// To request the money
    ///
    /// - Parameter amount: money to be request
    /// - Returns: available balance after process
    static func deposit(amount: Int) -> Int? {
        guard let defaults = UserDefaults(suiteName: appGroupId) else { return nil }
        defaults.synchronize()
        
        let balance = defaults.integer(forKey: defaultKey)
        let newBalance =  balance + amount
        defaults.set(newBalance, forKey: defaultKey)
       
        return newBalance
    }
}

