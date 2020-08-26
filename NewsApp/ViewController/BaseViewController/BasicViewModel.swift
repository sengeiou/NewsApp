//
//  BasicViewModel.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/26/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

protocol BasicViewModel: AlertPresentableViewModel, LoadingIndicatorViewModel {
}

protocol AlertPresentableViewModel {
    var alertModel: BehaviorRelay<AlertModel?> { get set }
}
protocol LoadingIndicatorViewModel {
    var showLoading: BehaviorRelay<Bool> { get set }
}
