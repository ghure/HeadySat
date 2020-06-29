//
//  WithLabelTableViewCell.swift
//  HeadySat
//
//  Created by Captain on 6/29/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import UIKit

class WithLabelTableViewCell: UITableViewCell {

    class var identifier: String {
        return String(describing: self)
    }
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var visualView: UIVisualEffectView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
