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
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl : UIRefreshControl = UIRefreshControl()
    
    // MARK: - internal properties
    enum Const {
        static let closeCellHeight: CGFloat = 90
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    var cellHeights: [CGFloat] = []

    // MARK: - lifecycle
    init(viewModel:TopHeadlineViewModel? = TopHeadlineViewModelImpl() ) {
        super.init()
        self.viewModel = viewModel
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    // MARK: - private
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(R.nib.topHeadlineCell)
        tableView.tableFooterView = UIView()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    func setupView(){
        setupTableView()
        self.title = "Top Headline"
    }
    // MARK: Actions
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
}
extension TopHeadlineViewController: UITableViewDataSource{
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 10
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
        
    }
    
    func topHeadlineCell(_ topHeadlineCell: TopHeadlineCell, learnMore article: Article?) {
        let webView = WebViewController()
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    
}
