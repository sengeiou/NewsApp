//
//  SignUpViewModelImpl.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/27/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CocoaLumberjack
typealias PrefsSignUp = PrefsAccessToken & PrefsAuthentication
class SignUpViewModelImpl: NSObject,SignUpViewModel {
    
    var basicViewModel: BasicViewModel
    let api: Provider<APITarget>
    var errorValidattion: PublishSubject<String> =  PublishSubject()
    var success: PublishSubject<Void> = PublishSubject()
    let prefs: PrefsSignUp
    
    init(basicViewModel:BasicViewModel = BasicViewModelImpl(),
         api: ProviderAPIBasic<APITarget> = ProviderAPIBasic<APITarget>(),
         prefs: PrefsSignUp = PrefsImpl.default) {
        self.api = api
        self.basicViewModel = basicViewModel
        self.prefs = prefs
        
    }
    func signUp(name: String?, password: String?, confirmpassword: String?) {
        guard let un = name, let pw = password, let cpw = confirmpassword else {
            return
        }
        guard self.validatePassword(password: pw, confirmPassword: cpw) else {
            return
        }
        self.prefs.saveAuthentication(key: un, value: pw)
        success.onNext(())
    }
    func validatePassword(password: String?, confirmPassword: String?) -> Bool {
        guard let password = password, let confirmPassword = confirmPassword else {
            errorValidattion.onNext("")
            return false
        }
        
        if password != confirmPassword {
            errorValidattion.onNext("Password do not match")
            return false
        }
        
        if password.count < 6 || password.count > 16 {
            errorValidattion.onNext("Your password must be between 6 and 16 characters")
            return false
        }
        errorValidattion.onNext("")
        return true
    }
}
