//
//  PaymentVC.swift
//  DemoSiriShortcut
//
//  Created by Yudiz Solutions on 29/08/18.
//  Copyright © 2018 Yudiz Solutions. All rights reserved.
//

import UIKit
import Intents

/// RequestVC
class PaymentVC: UIViewController {
    
    /// IBOutlet(s)
    @IBOutlet var tableView: UITableView!
    
    /// Variable Declaration(s)
    var availableBalance: Int {
        if let balance = PaymentDetails.checkBalance() {
            return balance
        } else {
            return 0
        }
    }
    
    /// View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

// MARK: - UI Related
extension PaymentVC {
    func prepareUI() {
        INPreferences.requestSiriAuthorization { (status) in
        }
        
        prepareData()
    }
    func prepareData() {
        if availableBalance == 0 {
            PaymentDetails.setBalance(amount: 10000)
        }
    }
}

// MARK: - UITableView Delegate and DataSource
extension PaymentVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! PaymentCell
        header.display(section == 0 ? "Available Balance" : "Actions")
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.section)", for: indexPath) as! PaymentCell
        cell.parentVC = self
        if indexPath.section == 0 {
            cell.display(String(describing: availableBalance))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
