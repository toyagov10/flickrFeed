//
//  PhotoFeedServiceError.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import Foundation

enum PhotoFeedServiceError: Error {
    case apiKeyNotFound
    case brokenQuery
    case network
}

