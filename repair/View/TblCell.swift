//
//  TblCell.swift
//  repairforget2
//
//  Created by Ahmad Karkouty on 5/28/18.
//  Copyright © 2018 Ahmad Karkouti. All rights reserved.
//

import UIKit

class TblCell: UITableViewCell {

    @IBOutlet var pendingImage: UIImageView!
    @IBOutlet var deviceLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
