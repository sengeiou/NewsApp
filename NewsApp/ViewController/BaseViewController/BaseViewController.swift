//
//  BaseViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/25/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
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
}
