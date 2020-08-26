//
//  TopHeadlineViewModel.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/25/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
protocol TopHeadlineViewModel: class {
    var basicViewModel:BasicViewModel { get }
    var listArticles:BehaviorRelay<[Article]> { get }
    var endLoadingAnimation: PublishSubject<Void> { get }
    var showToast: PublishSubject<String> { get }

    func getTopHeadlineData()

}
