//
//  ContactPictureCell.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/11/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import UIKit

class ContactPictureCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    var item: Contact? {
        didSet {
            guard let item = item else {
                return
            }
            
            avatarImageView.loadAsync(item.avatarURL!,
                                      placeholderImage: UIImage(named: "ic_default_avatar"),
                                      header: Helper.headers)
            nameLabel.text  = item.name
            emailLabel.text = item.email
        }
    }
    
//    var item: ContactDetailViewModelItem? {
//        didSet {
//            guard let item = item as? ContactDetailViewModelPictureItem else {
//                return
//            }
//
//            avatarImageView.loadAsync(item.avatarURL,
//                                      placeholderImage: UIImage(named: "ic_default_avatar"),
//                                      header: Helper.headers)
//        }
//    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius  = (avatarImageView.frame.height / 2)
        avatarImageView?.clipsToBounds      = true
        avatarImageView?.contentMode        = .scaleAspectFill
        avatarImageView?.backgroundColor    = UIColor.lightGray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView?.image = nil
    }
    
}
