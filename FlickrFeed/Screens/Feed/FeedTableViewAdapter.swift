//
//  FeedTableViewAdapter.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import Foundation
import UIKit

class FeedTableViewAdapter: NSObject {

    private let viewModel: FeedViewModel
    private var tableView: UITableView? = nil
    
    private var cellToUrlMap: [UITableViewCell: URL] = [:]
    
    private var imageCache: [URL: UIImage] = [:]
    private let imageProvider = ImageLoader()
    
    var router: FeedControllerRouter?
    
    public init(viewModel: FeedViewModel = FeedViewModelImpl()) {
        self.viewModel = viewModel
        super.init()
    }
    
    func prepare(tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.register(
            FeedTableViewCell.self,
            forCellReuseIdentifier: String(describing: FeedTableViewCell.self)
        )
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.viewModel.listener = self
    }
    
    func onViewDidLoad() {
        self.viewModel.requestFirstPage()
    }
}

// MARK: - UITableViewDataSource
extension FeedTableViewAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.photosData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FeedTableViewCell.self),
            for: indexPath
        ) as? FeedTableViewCell else {
            fatalError("cell must be FeedTableViewCell")
        }
        
        guard let url = viewModel.photosData[indexPath.row].url else {
            return cell
        }
        cellToUrlMap[cell] = url
        
        if let image = imageCache[url] {
            cell.photoImageView.image = image
        } else {
            cell.photoImageView.image = nil
            cell.activityIndicator.startAnimating()
            imageProvider.getImage(by: url) { [weak self] in
                guard let self = self else {
                    return
                }
                self.imageCache[url] = $0
                if url == self.cellToUrlMap[cell] {
                    cell.photoImageView.image = $0
                    cell.activityIndicator.stopAnimating()
                }
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FeedTableViewAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.openPhotoDetails(photoData: viewModel.photosData[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.requestNextPageIfNeeded(visibleIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photoData = viewModel.photosData[indexPath.row]
        return tableView.bounds.width / (photoData.size.width / photoData.size.height)
    }
}

// MARK: - UITableViewDelegate
extension FeedTableViewAdapter: FeedViewModelListener {
    func onFeedPostsChange(viewModel: FeedViewModel) {
        tableView?.reloadData()
    }
    
    func onError(_ error: String, viewModel: FeedViewModel) {
        router?.showError(message: error, retryCallback: { [unowned self] in
            self.viewModel.requestFirstPage()
        })
    }
}
