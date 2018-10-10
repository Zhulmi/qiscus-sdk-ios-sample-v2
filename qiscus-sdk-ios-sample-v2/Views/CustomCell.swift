//
//  CustomCell.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by arief nur putranto on 10/10/18.
//  Copyright © 2018 Qiscus Technology. All rights reserved.
//

import UIKit
import Qiscus
import SwiftyJSON
import AlamofireImage
import Alamofire

class CustomCell: QChatCell {

    @IBOutlet weak var ivDisplay: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setupCell(comment: QComment,message: String) {
        let dataJSON = JSON(parseJSON: comment.data)
        let content = dataJSON["content"].dictionary
        let contentJson = JSON(content)
        let banner = contentJson["bannerUrl"].string ?? ""
       
        if !banner.isEmpty {
            Alamofire.request(banner).responseImage { response in
                if let image = response.result.value {
                    self.ivDisplay.image = image
                }
            }
        }
        
    }

}
