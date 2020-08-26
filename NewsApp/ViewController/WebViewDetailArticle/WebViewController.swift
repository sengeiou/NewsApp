//
//  WebViewController.swift
//  WITHOUT_IOS
//
//  Created by Hien Pham on 5/13/20.
//  Copyright © 2020 WITHOUT. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import CocoaLumberjack

class WebViewController: BaseViewController, UIWebViewDelegate {
    public var bottomToolBarHidden : Bool = false
    private(set) var request : URLRequest
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet private weak var toolbar : UIView?
    @IBOutlet private var backwardButton : UIButton?
    @IBOutlet private var forwardButton : UIButton?
    private var lastRequest : URLRequest?
    @IBOutlet private weak var bottomToolBarHeightConstraint : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        self.reloadWebView()
    }
    
    init(request: URLRequest) {
        self.request = request
        super.init()
    }
    
    convenience init?(urlString: String) {
        if let url: URL = URL(string: urlString) {
            var request: URLRequest = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            request.timeoutInterval = 2
            self.init(request: request)
        } else {
            return nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func reloadWebView() {
        basicViewModel.showLoading.accept(true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        if self.lastRequest == nil {
            self.webView.load(request)
        } else {
            self.webView.reload()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshDisplay()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
    }
    
    private func refreshDisplay() {
        self.bottomToolBarHeightConstraint?.constant = self.bottomToolBarHidden ? 0 : 44;
        self.toolbar?.isHidden = self.bottomToolBarHidden;
    }
    
    private func titleFormatFromString(title : String) -> String {
        let strings : Array<String> = title.components(separatedBy: "\n")
        var string : String = title;
        if strings.count > 1 {
            string = strings.first!
            string = string.appending("...")
        }
        return string;
    }
    
    private func updateBackwardAndForwardButtons() {
        self.backwardButton?.isEnabled = self.webView.canGoBack;
        self.forwardButton?.isEnabled = self.webView.canGoForward;
    }

    @IBAction private func backward(sender: Any) {
        self.webView.goBack()
        self.updateBackwardAndForwardButtons()
    }
    
    @IBAction private func forward(sender: Any) {
        self.webView.goForward()
        self.updateBackwardAndForwardButtons()
    }
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        lastRequest = request
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.onFinishLoading()
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onFinishLoading()
    }
    
    private func onFinishLoading() {
        basicViewModel.showLoading.accept(false)
        if webView.isLoading {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
        self.updateBackwardAndForwardButtons()
        webView.evaluateJavaScript("document.title", completionHandler: { (value: Any?, error: Error?) in
            let webTitle : String = self.titleFormatFromString(title: (value as? String ?? ""))
            self.title = webTitle
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onFailLoading(with: error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        onFailLoading(with: error)
    }
    
    private func onFailLoading(with error: Error) {
        DDLogError("WebView didFailLoadWithError: \(String(describing: error))")
        if !webView.isLoading {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            basicViewModel.showLoading.accept(false)
        }
        let code = (error as NSError).code
        if code != NSURLErrorCancelled {
//            basicViewModel.alertModel.accept(AlertModel(message: error.localizedDescription))
        }
        self.updateBackwardAndForwardButtons()
    }
}
