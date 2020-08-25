//
//  BaseViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/25/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController,NVActivityIndicatorViewable {
    init() {
        let nibName = String(describing: type(of: self))
        if Bundle.main.path(forResource: nibName, ofType: "nib") != nil {
            super.init(nibName: nibName, bundle: nil)
        } else {
            super.init(nibName: nil, bundle: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showLoading(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size,message: "Loading...", type: NVActivityIndicatorType.lineScale, color: UIColor.green, fadeInAnimation: nil)

    }
    func hideLoading(){
        self.stopAnimating(nil)
    }
    func showAlert(with message: String) {
        showAlert(with: message, allowCancel: false, completionOK: nil, completionCancel: nil)
    }

    func showAlert(with message: String, allowCancel: Bool = false, completionOK: (() -> Void)?,completionCancel: (() -> Void)?) {
   
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        if allowCancel {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                completionCancel?()
            }
            alertController.addAction(cancelAction)
        }

        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            completionOK?()
        }
        alertController.addAction(OKAction)

        present(alertController, animated: true)
    }

}
