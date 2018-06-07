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
    @IBOutlet fileprivate weak var notificationImageView: UIImageView!

    @IBOutlet weak var titleColor: UILabel!
    @IBOutlet weak var descColor: UILabel!
    override var isSelected: Bool {
        didSet {
            notificationImageView.isHidden = !isSelected
            
            if isSelected {
                backgroundColor = UIColor(red: 108.0/255.0, green: 105.0/255.0, blue: 164.0/255.0, alpha: 1)
                
                titleColor.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                descColor.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            } else {
                backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
                
                titleColor.textColor = #colorLiteral(red: 0.4, green: 0.3882352941, blue: 0.6156862745, alpha: 1)
                descColor.textColor = #colorLiteral(red: 0.968627451, green: 0, blue: 0.02719719128, alpha: 1)
            }
        }
    }
    
    
    
    func configure(withImage image: UIImage, userName: String, messageText: String, dateText: String) {
        chatImageView.image = image
        userNameLabel.text = userName
        messageLabel.text = messageText
        dateLabel.text = dateText
    }
}
