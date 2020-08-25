//
//  WebViewDetailArticleViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/25/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import CocoaLumberjack
class WebViewController: BaseViewController, UIWebViewDelegate {
    // MARK: - protocol properties
    // MARK: - UI Components
    @IBOutlet weak var webView: UIWebView!

    // MARK: - internal properties
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    // MARK: - private
    private func setupView(){
        if let url = URL(string: "https://slate.com/business/2020/08/mail-slowdown-dejoy-usps-numbers.html") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
        
    }

}
