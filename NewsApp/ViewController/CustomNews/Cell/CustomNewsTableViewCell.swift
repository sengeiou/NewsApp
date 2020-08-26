//
//  CustomNewsTableViewCell.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/26/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftDate
import SDWebImage
import CocoaLumberjack

class CustomNewsTableViewCell: UITableViewCell {
    var article: Article?
    @IBOutlet weak var imageArticle: UIImageView!
    @IBOutlet weak var titleArticle: UILabel!
    @IBOutlet weak var dateArticle: UILabel!
    var resizeSmallImage = CGSize.zero
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        resizeSmallImage = CGSize(width: imageArticle.frame.size.width * UIScreen.main.scale, height: imageArticle.frame.size.height * UIScreen.main.scale)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func bindData(article: Article?) {
        self.article = article
        self.titleArticle.text = article?.title
        dateArticle.text = article?.publishedAt?.toFormat("dd MMM yyyy 'at' HH:mm")
        if let urlString = article?.urlToImage, let url = URL(string: urlString) {
            imageArticle.sd_setImage(with: url, placeholderImage: R.image.no_image(), options: .queryMemoryDataSync , context: [SDWebImageContextOption.imageThumbnailPixelSize : resizeSmallImage], progress: nil, completed: nil)
            
        } else {
            imageArticle.sd_cancelCurrentImageLoad()
            imageArticle.image = R.image.no_image()
        }
    }
}
