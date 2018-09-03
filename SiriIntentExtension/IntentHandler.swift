//
//  IntentHandler.swift
//  SiriIntentExtension
//
//  Created by Yudiz Solutions on 29/08/18.
//  Copyright © 2018 Yudiz Solutions. All rights reserved.
//

import Intents

/// IntentHandler
class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}

// MARK: - Deposite Intent Handling
extension IntentHandler: DepositeDefinitionIntentHandling {
    func handle(intent: DepositeDefinitionIntent, completion: @escaping (DepositeDefinitionIntentResponse) -> Void) {
        
        if let amount = intent.amount?.intValue { // 1. Taking amount to be deposite as int
            // 2. Taking new balance by invoking the method
            if let  newBalance = PaymentDetails.deposit(amount: amount) {
                //3. If the process is successful
                let response = DepositeDefinitionIntentResponse(code: DepositeDefinitionIntentResponseCode.sentSuccessfully , userActivity: nil)
                response.availableBalance = NSNumber(value: newBalance)// As we have to give new balance in the response
                completion(response)
            }
        }
    }
}

// MARK: - Withdraw Intent Handling
extension IntentHandler: WithdrawDefinitionIntentHandling {
    func handle(intent: WithdrawDefinitionIntent, completion: @escaping (WithdrawDefinitionIntentResponse) -> Void) {
        if let amount = intent.amount?.intValue {//1. Getting the amount to be withdraw
            if let  newBalance = PaymentDetails.withdraw(amount: amount) {//2. Taking new balance by invoking the method to withdraw
                
                //3.Creating response
                let response = WithdrawDefinitionIntentResponse(code: WithdrawDefinitionIntentResponseCode.successWithAmount , userActivity: nil)
                //4. As we have to give new balance in the response
                response.availableBalance = NSNumber(value: newBalance)
                completion(response)
            } else { // If your balance is less then the amount to be withdraw then error
                let response = WithdrawDefinitionIntentResponse(code: WithdrawDefinitionIntentResponseCode.failDueToLessAmount , userActivity: nil)
                response.availableBalance = NSNumber(value: PaymentDetails.checkBalance()!)
                response.requestAmount = NSNumber(value: amount)
                completion(response)
            }
        }
    }
   
}
