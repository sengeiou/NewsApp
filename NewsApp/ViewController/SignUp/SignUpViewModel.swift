//
//  SignUpViewModel.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/27/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

protocol SignUpViewModel: class {
    var basicViewModel:BasicViewModel { get }
    var errorValidattion : PublishSubject<String> { get }
    var success: PublishSubject<Void> { get }
    func signUp(name:String?,
                password: String?,
                confirmpassword: String?)
    
}
