//
//  TopHeadlineViewModelImpl.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/25/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TopHeadlineViewModelImpl: NSObject, TopHeadlineViewModel {
    let api: Provider<APITarget>
    
    init(api: ProviderAPIBasic<APITarget> = ProviderAPIBasic<APITarget>()) {
        self.api = api
    }
    
    func getTopHeadlineData() {
        let searchParams = SearchConditionsParams(category: nil, country: "us", language: nil)
        api.request(.top_headlines(searchParams: searchParams))
            .filterSuccessfulStatusCodes()
            .map([ArticleResponse].self, atKeyPath: "", using: JSONDecoder.decoderISO8601DateAPI(), failsOnEmptyData: true)
            .subscribe({[weak self] event in
                guard let self = self else { return }
                switch event {
                case .success(let response):
                    
                    break
                case .error(let error):
                    break
                }
            }).disposed(by: rx.disposeBag)
    }
}
