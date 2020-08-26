//
//  TopHeadlineCell.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/25/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import FoldingCell
import SDWebImage
import SwiftDate
import SDWebImage
import CocoaLumberjack
protocol TopHeadlineCellDelegate: class {
    func topHeadlineCell(_ topHeadlineCell: TopHeadlineCell, tappedImage article: Article?)
    func topHeadlineCell(_ topHeadlineCell: TopHeadlineCell, learnMore article: Article?)
    
}
class TopHeadlineCell: FoldingCell {
    weak var delegate:TopHeadlineCellDelegate?
    var article: Article?
    
    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var bigImage: UIImageView!
    
    @IBOutlet weak var smallTitle: UILabel!
    @IBOutlet weak var bigTitle: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var resizeSmallImage = CGSize.zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         resizeSmallImage = CGSize(width: smallImage.frame.size.width * UIScreen.main.scale, height: smallImage.frame.size.height * UIScreen.main.scale)

    }
    func bindData(article: Article?) {
        self.article = article
        smallTitle.text = article?.title
        bigTitle.text = article?.title
        sourceLabel.text = article?.source?.name
        authorLabel.text = "By " + (article?.author ?? "...")
        publishedAtLabel.text = article?.publishedAt?.toFormat("dd MMM yyyy 'at' HH:mm")
        descriptionLabel.text = article?.articleDescription
        if let urlString = article?.urlToImage, let url = URL(string: urlString) {
            smallImage.sd_setImage(with: url, placeholderImage: R.image.no_image(), options: .retryFailed , context: [SDWebImageContextOption.imageThumbnailPixelSize : resizeSmallImage], progress: nil, completed: nil)
            
            bigImage.sd_setImage(with: url, placeholderImage: R.image.no_image(), options: .scaleDownLargeImages, context: nil, progress: nil, completed: nil)
            
        }
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func actionLearnMore(_: AnyObject) {
        print("actionLearnMore💙")
        delegate?.topHeadlineCell(self, learnMore: article)
    }
    @IBAction func actionOpenImage(_: AnyObject) {
        print("actionOpenImage💙")
        delegate?.topHeadlineCell(self, tappedImage: article)
    }
    
}
