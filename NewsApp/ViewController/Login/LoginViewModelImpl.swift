//
//  LoginViewModelImpl.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/27/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
typealias PrefsLogin = PrefsAccessToken & PrefsAuthentication

class LoginViewModelImpl: NSObject, LoginViewModel {
    var basicViewModel: BasicViewModel
    var errorValidattion: PublishSubject<String> = PublishSubject()
    var success: PublishSubject<Void> = PublishSubject()
    let api: Provider<APITarget>
    let prefs: PrefsLogin
    let showToast: PublishSubject<String> = PublishSubject()

    init(basicViewModel:BasicViewModel = BasicViewModelImpl(),
         api: ProviderAPIBasic<APITarget> = ProviderAPIBasic<APITarget>(),
         prefs: PrefsSignUp = PrefsImpl.default) {
        self.api = api
        self.basicViewModel = basicViewModel
        self.prefs = prefs

    }
    
    func login(name: String?, password: String?) {
        guard let key = name, let pw = self.prefs.getAuthentication(key: key) else {
            showToast.onNext("User not registered.")
            return
        }
        if pw != password {
            showToast.onNext("Incorrect password.")
        } else {
            success.onNext(())
        }
        
    }
    
}
