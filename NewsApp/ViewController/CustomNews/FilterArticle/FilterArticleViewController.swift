//
//  FilterArticleViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/26/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import SearchTextField
import AAPickerView

class FilterArticleViewController: BaseViewController {

    // MARK: - protocol properties
    // MARK: - UI Components
    @IBOutlet weak var searchText: SearchTextField!
    @IBOutlet weak var picker: AAPickerView!
    // MARK: - internal properties
    var stringData = ["bitcoin", "apple", "earthquake", "animal"]

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configPicker()
    }
    // MARK: - private
    private func configPicker() {

        searchText.filterStrings(stringData)
        searchText.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        searchText.maxResultsListHeight = 160

        picker.pickerType = .string(data: stringData)
        picker.heightForRow = 40
        picker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        
        picker.toolbar.barTintColor = .darkGray
        picker.toolbar.tintColor = .black
        
        picker.valueDidSelected = { [weak self](index) in
            guard let self = self else { return }
            print("selectedString ", self.stringData[index as! Int])
            
        }
        
        picker.valueDidChange = { value in
            print(value)
        }
    }

}
