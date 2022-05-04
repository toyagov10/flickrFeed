//
//  FeedViewController.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import UIKit

class FeedViewController: UIViewController {

    private lazy var tableView = UITableView()

    private let tableViewAdapter: FeedTableViewAdapter
    
    // MARK: - VC Lifecycle
    init(viewModel: FeedViewModel = FeedViewModelImpl()) {
        self.tableViewAdapter = FeedTableViewAdapter(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        tableViewAdapter.router = FeedControllerRouterImpl(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feed"
        tableViewAdapter.prepare(tableView: tableView)
        tableViewAdapter.onViewDidLoad()
    }
}
