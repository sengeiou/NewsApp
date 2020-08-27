//
//  CustomNewsImpl.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/26/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CocoaLumberjack

class CustomNewsViewModelImpl: NSObject, CustomNewsViewModel {
    let api: Provider<APITarget>
    var listArticles:BehaviorRelay<[Article]> = BehaviorRelay(value: [])
    let basicViewModel:BasicViewModel
    let endLoadingAnimation: PublishSubject<Void> = PublishSubject()
    let showToast: PublishSubject<String> = PublishSubject()
    var stringData = ["bitcoin", "apple", "earthquake", "animal"]
    
    init(basicViewModel:BasicViewModel = BasicViewModelImpl(),
         api: ProviderAPIBasic<APITarget> = ProviderAPIBasic<APITarget>()) {
        self.api = api
        self.basicViewModel = basicViewModel

    }
    func addToStringData(text: String) {
        if !(stringData.contains(text)) {
            stringData.append(text)
        }
    }
    func searchEverything(text: String?) {
        guard let text = text, text != "" else {
            getTopHeadlineData()
            return
        }
        let searchParams = SearchConditionsParams(category: nil, country: nil, language: nil, q: text)
        api.request(.everything(searchParams: searchParams))
            .filterSuccessfulStatusCodes()
            .map(ArticleResponse.self, atKeyPath: nil, using: JSONDecoder.decoderISO8601DateAPI(), failsOnEmptyData: true)
            .subscribe({[weak self] event in
                guard let self = self else { return }
                switch event {
                case .success(let response):
                    if let articles = response.articles {
                        self.listArticles.accept(articles)
                    }
                    break
                case .error(_):
                    self.showToast.onNext("Load data fail")
                    break
                }
                self.basicViewModel.showLoading.accept(false)
                self.endLoadingAnimation.onNext(())
            }).disposed(by: rx.disposeBag)
    }
    
    func getTopHeadlineData() {
        let searchParams = SearchConditionsParams(category: nil, country: "us", language: nil, q: nil)
        api.request(.top_headlines(searchParams: searchParams))
            .filterSuccessfulStatusCodes()
            .map(ArticleResponse.self, atKeyPath: nil, using: JSONDecoder.decoderISO8601DateAPI(), failsOnEmptyData: true)
            .subscribe({[weak self] event in
                guard let self = self else { return }
                switch event {
                case .success(let response):
                    if let articles = response.articles {
                        self.listArticles.accept(articles)
                    }
                    break
                case .error(_):
                    self.showToast.onNext("Load data fail")
                    break
                }
                self.basicViewModel.showLoading.accept(false)
                self.endLoadingAnimation.onNext(())
            }).disposed(by: rx.disposeBag)
    }
}
