//
//  NamePictureCell.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/8/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import UIKit

class NamePictureCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var item: ChatDetailViewModelItem? {
        didSet {
            guard let item = item as? ChatDetailViewModelNamePictureItem else {
                return
            }
            
            avatarImageView.loadAsync(item.avatarURL,
                                      placeholderImage: UIImage(named: "avatar"),
                                      header: Helper.headers)
            nameLabel.text = item.name
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
