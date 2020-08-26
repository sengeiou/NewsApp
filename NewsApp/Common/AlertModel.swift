//
//  AlertModel.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/26/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//
import UIKit

struct AlertModel {
    struct ActionModel {
        var title: String?
        var style: UIAlertAction.Style
        var handler: ((UIAlertAction) -> ())?
    }
    
    var actionModels = [ActionModel]()
    var title: String?
    var message: String?
    var prefferedStyle: UIAlertController.Style
}

extension AlertModel {
    init(message: String) {
        self.init(actionModels: [AlertModel.ActionModel(title: "OK", style: .default, handler: nil)], title: nil, message: message, prefferedStyle: .alert)
    }
}
