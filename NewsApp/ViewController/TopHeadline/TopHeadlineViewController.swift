//
//  TopHeadlineViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/25/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TopHeadlineViewController: BaseViewController {
    
    // MARK: - protocol properties
    private var viewModel:TopHeadlineViewModel
    
    // MARK: - UI Components
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl : UIRefreshControl = UIRefreshControl()
    
    // MARK: - internal properties
    enum Const {
        static let closeCellHeight: CGFloat = 90
        static let openCellHeight: CGFloat = 488
    }
    var cellHeights: [CGFloat] = []
    
    // MARK: - lifecycle
    init(viewModel:TopHeadlineViewModel = TopHeadlineViewModelImpl() ) {
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
    // MARK: - private
    private func bindData() {
        self.viewModel.listArticles
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] listArticles in
                guard let self = self else { return }
                self.cellHeights = Array(repeating: Const.closeCellHeight, count: listArticles.count)
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
            self.viewModel.getTopHeadlineData()
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
        tableView.register(R.nib.topHeadlineCell)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        
    }
    func setupView(){
        setupTableView()
        self.title = "Top Headline"
    }
}
extension TopHeadlineViewController: UITableViewDataSource{
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.listArticles.value.count
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as TopHeadlineCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topHeadlineCell, for: indexPath)!
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.delegate = self
        let article = self.viewModel.listArticles.value[indexPath.row]
        cell.bindData(article: article)
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TopHeadlineCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
            // fix https://github.com/Ramotion/folding-cell/issues/169
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
}
extension TopHeadlineViewController: UITableViewDelegate{
    
}
extension TopHeadlineViewController: TopHeadlineCellDelegate{
    func topHeadlineCell(_ topHeadlineCell: TopHeadlineCell, tappedImage article: Article?) {
        guard let urlString = article?.urlToImage else { return }
        let vc = DetailViewPhotoViewController(viewModel: DetailViewPhotoViewModelImpl(urlString: urlString))
        vc.modalPresentationStyle = .fullScreen 
        self.present(vc, animated: true, completion: nil)
    }
    
    func topHeadlineCell(_ topHeadlineCell: TopHeadlineCell, learnMore article: Article?) {
        if let urlString = article?.url, let url = URL(string: urlString) {
            let webView = WebViewController(request:URLRequest(url: url))
            webView.modalPresentationStyle = .fullScreen
            self.present(webView, animated: true, completion: nil)
        }
        
    }
    
}
