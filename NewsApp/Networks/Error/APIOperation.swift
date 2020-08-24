//
//  APIOperation.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//


import Foundation
import RxSwift

class APIOperation<T>: AsyncOperation {
    private(set) var value: T?
    private(set) var error: Error?
    let single: Single<T>
    private var disposable: Disposable?
    init(single: Single<T>) {
        self.single = single
        super.init()
    }

    override func main() {
        disposable = single.subscribe {[weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .success(let value):
                self.value = value
            case .error(let error):
                self.error = error
            }
            self.state = .isFinished
        }
        disposable?.disposed(by: rx.disposeBag)
    }
    
    override func cancel() {
        disposable?.dispose()
    }
}
