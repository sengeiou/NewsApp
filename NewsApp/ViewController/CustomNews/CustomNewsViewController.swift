//
//  CustomNewsViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/25/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SearchTextField

class CustomNewsViewController: BaseViewController, UITextFieldDelegate {
    
    // MARK: - protocol properties
    private var viewModel:CustomNewsViewModel
    
    // MARK: - UI Components
    @IBOutlet weak var searchText: SearchTextField!
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl : UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    // MARK: - internal properties

    // MARK: - lifecycle
    init(viewModel:CustomNewsViewModel = CustomNewsViewModelImpl() ) {
        self.viewModel = viewModel
        super.init(basicViewModel: viewModel.basicViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
        bindData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    // MARK: - IBAction
    @IBAction func actionSearch(_ sender: Any) {
        guard let text = self.searchText.text else {
            return
        }
        self.viewModel.addToStringData(text: text)
        self.searchText.filterStrings(self.viewModel.stringData)
        self.searchText.resignFirstResponder()  //if desired
        self.viewModel.searchEverything(text: text)
        self.searchText.hideResultsList()

    }
    
    // MARK: - private
    private func bindData() {
        searchText.itemSelectionHandler = { [weak self](result,index) in
            guard let self = self else { return }
            let item = result[index]
            self.searchText.text = item.title
            self.actionSearch(self)
        }
        self.viewModel.listArticles
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] listArticles in
                guard let self = self else { return }
                if listArticles.count == 0 {
                    self.tableView.isHidden = true
                } else {
                    self.tableView.isHidden = false
                }
                self.tableView.reloadData()
            }).disposed(by: rx.disposeBag)
        
        self.viewModel.endLoadingAnimation
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
            }).disposed(by: rx.disposeBag)
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchEverything(text: self.searchText.text)
        }).disposed(by: rx.disposeBag)
        self.viewModel.showToast.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: {[weak self] message in
            guard let self = self else { return }
            self.view.makeToast(message)
        }).disposed(by: rx.disposeBag)
    }
    private func setupData() {
        self.showLoading()
        self.viewModel.getTopHeadlineData()
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(R.nib.customNewsTableViewCell)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        
    }
    func setupView(){
        setupTableView()
        self.title = "Search Article"
        searchText.delegate = self
        searchText.filterStrings(self.viewModel.stringData)
        searchText.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        searchText.maxResultsListHeight = 160
        searchText.startVisible = true

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.actionSearch(self)
        return true
    }

}
extension CustomNewsViewController: UITableViewDataSource{
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.listArticles.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.customNewsTableViewCell, for: indexPath)!
        let article = self.viewModel.listArticles.value[indexPath.row]
        cell.bindData(article: article)
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    

}
extension CustomNewsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.viewModel.listArticles.value[indexPath.row]
        let detailVC = DetailArticleViewController(article: article)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
