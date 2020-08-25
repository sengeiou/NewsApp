//
//  TopHeadlineViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/25/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit

class TopHeadlineViewController: BaseViewController {
    
    // MARK: - protocol properties
    private var viewModel:TopHeadlineViewModel?
    
    // MARK: - UI Components
    private var refreshControl : UIRefreshControl = UIRefreshControl()

    // MARK: - internal properties
    // MARK: - lifecycle
    init(viewModel:TopHeadlineViewModel? = TopHeadlineViewModelImpl() ) {
        super.init()
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    // MARK: - private
    func setupView(){
        self.title = "Top Headline"
    }
}
