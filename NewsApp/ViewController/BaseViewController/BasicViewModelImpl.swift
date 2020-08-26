//
//  BasicViewModelImpl.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/26/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import RxCocoa

class BasicViewModelImpl: BasicViewModel {
    var alertModel: BehaviorRelay<AlertModel?> = BehaviorRelay(value: nil)

    var showLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
}
