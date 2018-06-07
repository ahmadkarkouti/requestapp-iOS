//
//  AccountViewController.swift
//  repair
//
//  Created by Ahmad Karkouty on 6/3/18.
//  Copyright © 2018 Ahmad Karkouti. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class AccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func logoutClick(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to Logout?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
        
        try! Auth.auth().signOut()
        if Auth.auth().currentUser == nil {
            let MainNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(MainNavigationController, animated: true, completion: nil)
        }
        }
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
}
