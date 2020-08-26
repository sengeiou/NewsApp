//
//  ChatDetailViewPhotoViewModel.swift
//  WITHOUT_IOS
//
//  Created by Tai Ma on 7/3/20.
//  Copyright © 2020 WITHOUT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol DetailViewPhotoViewModel: class {
    var basicViewModel: BasicViewModel { get }
    var showToast: PublishSubject<String> { get }
    var urlString: String { get }
    func downloadImage()
}
