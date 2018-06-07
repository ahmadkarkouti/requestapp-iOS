//
//  YALChatDemoCollectionViewCell.swift
//  repair
//
//  Created by Ahmad Karkouty on 6/1/18.
//  Copyright © 2018 Ahmad Karkouti. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var chatImageView: UIImageView!
    @IBOutlet fileprivate weak var userNameLabel: UILabel!
    @IBOutlet fileprivate weak var messageLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!

    @IBOutlet weak var titleColor: UILabel!
    @IBOutlet weak var descColor: UILabel!
    
    public var mayBe: UIColor?
    
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                backgroundColor = UIColor(red: 108.0/255.0, green: 105.0/255.0, blue: 164.0/255.0, alpha: 1)
                
                titleColor.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                descColor.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            } else {
                backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
                
                titleColor.textColor = #colorLiteral(red: 0.4, green: 0.3882352941, blue: 0.6156862745, alpha: 1)
                mayBe = descColor.textColor
//                descColor.textColor = #colorLiteral(red: 0.968627451, green: 0, blue: 0.02719719128, alpha: 1)
//                var Status = ""
//                let myStatus = requestList[myIndex].Status!
//                switch myStatus {
//                case "0":
//                    Status = "Status: Pending"
//                    descColor.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//                case "1":
//                    Status = "Status: Approved"
//                    descColor.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//                case "2":
//                    Status = "Status: In Progress"
//                    descColor.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
//                case "3":
//                    Status = "Status: Completed"
//                    descColor.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
//                case "4":
//                    Status = "Status: Refused"
//                    descColor.textColor = #colorLiteral(red: 0.8874454128, green: 0, blue: 0.04979250122, alpha: 1)
//                case "5":
//                    Status = "Status: Refund"
//                    descColor.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
//                default:
//                    print()
//                }
            }
        }
    }
    
    
    
    func configure(withImage image: UIImage, userName: String, messageText: String, dateText: String, statusColor: UIColor) {
        chatImageView.image = image
        userNameLabel.text = userName
        messageLabel.text = messageText
        dateLabel.text = dateText
        descColor.textColor = statusColor
    }
}
