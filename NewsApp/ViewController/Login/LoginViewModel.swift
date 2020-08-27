//
//  LoginViewModel.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/27/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginViewModel: class {
    var basicViewModel:BasicViewModel { get }
    var errorValidattion : PublishSubject<String> { get }
    var success: PublishSubject<Void> { get }
    func login(name:String?, password: String?)
    var showToast: PublishSubject<String> { get }

}
