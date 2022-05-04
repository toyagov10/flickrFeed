//
//  FeedViewModel.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import Foundation

protocol FeedViewModelListener: AnyObject {
    func onFeedPostsChange(viewModel: FeedViewModel)
    func onError(_ error: String, viewModel: FeedViewModel)
}

protocol FeedViewModel: AnyObject {
    
    var photosData: [PhotoData] { get }
    
    func requestFirstPage()
    func requestNextPageIfNeeded(visibleIndex: Int)
    
    var listener: FeedViewModelListener? { get set }
}

class FeedViewModelImpl: FeedViewModel {
    private let defaultPageSize: Int = 100
    
    private var pagesCount: Int = 0
    private var currentPage: Int = 0
    
    private(set) var photosData: [PhotoData] = [] {
        didSet {
            listener?.onFeedPostsChange(viewModel: self)
        }
    }
    private let feedService: FeedService
    
    weak var listener: FeedViewModelListener?
    
    init(feedService: FeedService = FeedServiceImpl()) {
        self.feedService = feedService
    }
    
    private func fetchPhotos(page: Int) {
        feedService.getFeed(page: page, pageSize: defaultPageSize) { [weak self] in
            guard let self = self else {
                return
            }
            switch $0 {
            case .success(let response):
                self.photosData.append(contentsOf: response.photosData.filter {
                    $0.url != nil
                })
                self.pagesCount = response.pagesCount
            case .failure:
                self.listener?.onError("Error. Try again later...", viewModel: self)
            }
        }
    }
    
    func requestFirstPage() {
        currentPage = 1
        fetchPhotos(page: currentPage)
    }
    
    func requestNextPageIfNeeded(visibleIndex: Int) {
        let isRangeValid = visibleIndex > defaultPageSize * (currentPage - 1) && visibleIndex < defaultPageSize * currentPage
        let needsRequest = visibleIndex >= defaultPageSize * currentPage - defaultPageSize / 2
        
        if needsRequest && isRangeValid && currentPage < pagesCount {
            currentPage += 1
            fetchPhotos(page: currentPage)
        }
    }
}
