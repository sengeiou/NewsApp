//
//  TopHeadlineCell.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/25/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import FoldingCell
protocol TopHeadlineCellDelegate: class {
    func topHeadlineCell(_ topHeadlineCell: TopHeadlineCell, tappedImage article: Article?)
    func topHeadlineCell(_ topHeadlineCell: TopHeadlineCell, learnMore article: Article?)

}
class TopHeadlineCell: FoldingCell {
    weak var delegate:TopHeadlineCellDelegate?
    var article: Article?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
