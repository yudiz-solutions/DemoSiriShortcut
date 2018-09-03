//
//  TabelViewCell.swift
//  DemoSiriShortcut
//
//  Created by Yudiz Solutions on 29/08/18.
//  Copyright © 2018 Yudiz Solutions. All rights reserved.
//

import UIKit
import Intents

/// PaymentCell
class PaymentCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    
    /// Weak parent variable
    weak var parentVC: PaymentVC?
    
    /// It will display data in cell label
    ///
    /// - Parameter data: string that you need to display
    func display(_ data: String) {
        lblTitle.text = data
    }
}

// MARK: - IBAction(s)
extension PaymentCell {
    @IBAction func tapSendBtn(_ sender: UIButton) {
        presentAlertForInput(isRequest: false)
    }
    
    @IBAction func tapRequestBtn(_ sender: UIButton) {
        presentAlertForInput(isRequest: true)
    }
    
    @IBAction func tapRefreshBtn(_ sender: UIButton) {
        parentVC?.tableView.reloadData()
    }
    
}

// MARK: - General Methods
extension PaymentCell {
    
    /// Presents Alert controller
    /// To reduce the code of 2 alerts
    /// - Parameter isRequest: for the request or send condition
    func presentAlertForInput(isRequest: Bool) { // if not request money then send money
        
        let alert  = UIAlertController(title: isRequest ? "Request Money" : "Send Money", message: "Enter amount", preferredStyle: .alert)
        
        alert.addTextField { (txtField) in
            txtField.keyboardType = UIKeyboardType.numberPad
            txtField.placeholder = "amount"
            txtField.clearButtonMode = .always
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let amount =  Int(alert.textFields![0].text!) {
                if isRequest {
                    PaymentDetails.deposit(amount: amount)
                    self.donateShortcut(isRequest: isRequest, amount: amount)
                    self.parentVC?.tableView.reloadData()
                } else {
                    guard let _ =  PaymentDetails.withdraw(amount: amount)  else {
                        print("Error in withdraw process")
                        return
                    }
                    self.donateShortcut(isRequest: isRequest, amount: amount)
                    self.parentVC?.tableView.reloadData()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        parentVC?.present(alert, animated: true, completion: nil)
    }
    
    func alertForDonation(_ isRequest: Bool) {
        let alert = UIAlertController(title: isRequest ? "Request Donated" : "Withdraw Donated", message: "Now you can add this process in the shortcut.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        parentVC?.present(alert, animated: true, completion: nil)
    }
    
    
    /// To donate shortcut to the siri
    ///
    /// - Parameters:
    ///   - isRequest: for the two type of actions
    ///   - amount: value that is to performed
    func donateShortcut(isRequest: Bool, amount: Int) {
        
        if isRequest {
            // Deposite process donating for shortcut
            
            // 1. Intent variable
            let intent = DepositeDefinitionIntent()
            intent.amount = NSNumber(value: amount)
            
            //2. Interaction variable
            let interaction = INInteraction(intent: intent, response: nil)

            // 3. Donating interaction
            interaction.donate { (error) in
                guard error == nil else {
                    print("Request problem : \(String(describing: error?.localizedDescription))")
                    return
                }
                // If no error then your shortcut has been successfully added to shortcut
                print("Request Intent Donated")
                self.alertForDonation(isRequest)
            }
        } else {
            let intent = WithdrawDefinitionIntent()
            intent.amount = NSNumber(value: amount)
            
            let interaction = INInteraction(intent: intent, response: nil)
            interaction.donate { (error) in
                guard error == nil else {
                    print("Send Problem : \(String(describing: error?.localizedDescription))")
                    return
                }
                print("Send Intent Donated")
                self.alertForDonation(isRequest)
            }
            
        }
    }
}
