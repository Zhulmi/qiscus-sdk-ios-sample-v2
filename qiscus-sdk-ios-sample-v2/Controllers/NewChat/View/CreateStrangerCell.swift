
//
//  CreateStrangerCell.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/10/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import UIKit

class CreateStrangerCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: NSLayoutConstraint!
    
    var item: ChatNewViewModelItem? {
        didSet {
            guard let item = item as? ChatNewViewModelCreateStrangerItem else {
                return
            }
            
            self.target(forAction: item.action, withSender: item.target)
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
