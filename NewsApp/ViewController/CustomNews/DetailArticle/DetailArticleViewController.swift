//
//  DetailArticleViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/26/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import SwiftDate
import SDWebImage
class DetailArticleViewController: BaseViewController {
    
    // MARK: - protocol properties
    // MARK: - UI Components
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - internal properties
    var article: Article?
    init(article: Article?) {
        self.article = article
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    // MARK: - private
    private func setupView(){
        self.titleLabel.text = article?.title
        self.descriptionLabel.text = article?.articleDescription
        self.authLabel.text = "By " + (article?.author ?? "...").uppercased()
        self.dateLabel.text = article?.publishedAt?.toFormat("dd MMM yyyy 'at' HH:mm")
        self.contentLabel.text = article?.content
        if let urlString = article?.urlToImage, let url = URL(string: urlString) {

            imageView.sd_setImage(with: url, placeholderImage: R.image.no_image(), options: .scaleDownLargeImages, context: nil, progress: nil, completed: nil)
        } else {
            
            imageView.sd_cancelCurrentImageLoad()
            imageView.image = R.image.no_image()
        }

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async {
            var height: CGFloat = 0
              for view in self.contentView.subviews {
                  height += view.frame.height
              }
              self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: height + 70)
        }
    }
    @IBAction func actionLearnMore(_ sender: Any) {
        guard let urlString = article?.url, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
}
