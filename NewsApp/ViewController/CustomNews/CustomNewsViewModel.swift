//
//  CustomNewsViewModel.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/26/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CustomNewsViewModel: class {
    var basicViewModel:BasicViewModel { get }
    var listArticles:BehaviorRelay<[Article]> { get }
    var endLoadingAnimation: PublishSubject<Void> { get }
    var showToast: PublishSubject<String> { get }

    func searchEverything(text: String?)

}
