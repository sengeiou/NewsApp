//
//  ViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

let api: Provider<APITarget> = ProviderAPIBasic<APITarget>()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let searchParams = SearchConditionsParams(category: nil, country: "us", language: nil)
        api.request(.top_headlines(searchParams: searchParams))
            .filterSuccessfulStatusCodes()
            .subscribe({[weak self] event in
                guard let self = self else { return }
                switch event {
                case .success:
                    break
                case .error(_):
                    break
                }
            }).disposed(by: rx.disposeBag)
    }

}

