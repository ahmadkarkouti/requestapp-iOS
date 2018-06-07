//
//  MainInfoViewController.swift
//  repair
//
//  Created by Ahmad Karkouty on 6/3/18.
//  Copyright © 2018 Ahmad Karkouti. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD

class MainInfoViewController: UIViewController {
    
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var pendingImage: UIImageView!
    @IBOutlet weak var pendingLabel: UILabel!
    
    let uid = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    var refHandle: UInt!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        var issues = "Issues: "
        
        let BrokenScreen = requestList[myIndex].BrokenScreen!.boolValue
        let BatteryReplace = requestList[myIndex].BatteryReplace!.boolValue
        let Network = requestList[myIndex].Network!.boolValue
        let Other = requestList[myIndex].Other!.boolValue
        let Spy = requestList[myIndex].Spy!.boolValue
        let VerySlow = requestList[myIndex].VerySlow!.boolValue
        
        if BrokenScreen == true {
            issues += "\n- Broken Screen"
        }
        
        if BatteryReplace == true {
            issues += "\n- Battery Damage"
        }
        
        if Network == true {
            issues += "\n- Network Problems"
        }
        
        if Other == true {
            issues += "\n- Other Issues"
        }
        
        if Spy == true {
            issues += "\n- Suspected Spy"
        }
        
        if VerySlow == true {
            issues += "\n- Very Slow"
        }
        let Device = requestList[myIndex].device!
        let Type = requestList[myIndex].type!
        let Model = requestList[myIndex].model!
        let RushValue = requestList[myIndex].Rush!.boolValue
        let RecValue = requestList[myIndex].Record!.boolValue
        var Rush = ""
        var Rec = ""
        if RushValue == true {
            Rush += "Priority Service"
        }
        if RecValue == true {
            Rec += "Recorded Service"
        }
        
        
        detailLabel.text = "Device: \(Device) \nType: \(Type) \nModel: \(Model) \n\(Rush) \n\(Rec)"
        
        
        issueLabel.text = issues
        switch requestList[myIndex].device! {
            
        case "Mobile":
            //            myImageView = UIImage(named: "Mobile")
            orderImage.image = UIImage(named: "Mobile")
        case "Tablet":
            orderImage.image = UIImage(named: "Tablet")
        //            _ = UIImageView(image: image!)
        case "Computer":
            orderImage.image = UIImage(named: "Computer")
        //            _ = UIImageView(image: image!)
        case "Smart Watch":
            orderImage.image = UIImage(named: "Smart watch")
        //            _ = UIImageView(image: image!)
        case "Other":
            orderImage.image = UIImage(named: "colour")
            //            _ = UIImageView(image: image!)
            
        default:
            orderImage.image = UIImage(named: "colour")
            //            _ = UIImageView(image: image!)
            
            //            myImageView = UIImage(named: image)
        }
        
        switch requestList[myIndex].Status! {
        case "0":
            pendingImage.image = UIImage(named: "pending")
            pendingLabel.text = "Pending"
        case "1":
            pendingImage.image = UIImage(named: "approved")
            pendingLabel.text = "Approved"
        case "2":
            pendingImage.image = UIImage(named: "progress")
            pendingLabel.text = "In Progress"
        case "3":
            pendingImage.image = UIImage(named: "approved")
            pendingLabel.text = "Completed"
        case "4":
            pendingImage.image = UIImage(named: "refused")
            pendingLabel.text = "Refused!"
        case "5":
            pendingImage.image = UIImage(named: "refund")
            pendingLabel.text = "Refund"
        default:
            pendingImage.image = UIImage(named: "pending")
        }
        
        
    }
    
    
    @IBAction func cancelClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Order", message: "Are you sure you want to delete the order?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            
        
        let message = requestList[myIndex]
        if let chatPartnerId = message.id {
            Database.database().reference().child("request").child(self.uid!).child(chatPartnerId).removeValue(completionBlock: {(error, ref) in
                if error != nil {
                    print("Failed to delete message", error!)
                    return
                }
                requestList.remove(at: myIndex)
                self.navigationController?.popViewController(animated: true)
                
                
            })
            }}
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
}
    
    
}
