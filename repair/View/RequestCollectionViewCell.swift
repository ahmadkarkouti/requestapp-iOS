//
//  RequestCollectionViewCell.swift
//  repair
//
//  Created by Ahmad Karkouty on 6/1/18.
//  Copyright © 2018 Ahmad Karkouti. All rights reserved.
//

import UIKit

class RequestCollectionViewCell: UICollectionViewCell {
    let myColor = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
    @IBOutlet fileprivate weak var ImageView: UIImageView!
    @IBOutlet fileprivate weak var ImageView2: UIImageView!
    @IBOutlet fileprivate weak var ImageView3: UIImageView!
    
//    override var isSelected: Bool {
//        didSet {
//            
//            if isSelected {
//                backgroundColor = UIColor(red: 108.0/255.0, green: 105.0/255.0, blue: 164.0/255.0, alpha: 1)
//            }
//            } else {
//                for index in 0...3 {
//                    backgroundColor = myColor[index]
//                }
//
//            }
//        }
//    }
    
    
    
    func configure(withImage image: UIImage) {
        ImageView.image = image

    }
    
    func configure2(withImage image: UIImage) {
        ImageView2.image = image

    }
    
    func configure3(withImage image: UIImage) {
        ImageView3.image = image
    }
}

