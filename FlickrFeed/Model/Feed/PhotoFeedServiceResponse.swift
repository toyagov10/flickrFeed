//
//  PhotoFeedServiceResponse.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import Foundation

struct PhotoFeedServiceResponse {

    let pagesCount: Int
    let pageSize: Int
    let photosData: [PhotoData]
}

extension PhotoFeedServiceResponse: Decodable {
    
    private enum RootKeys: String, CodingKey {
        case photos
    }

    private enum ResponseKeys: String, CodingKey {
        case pagesCount = "pages"
        case pageSize = "perpage"
        case photo
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: RootKeys.self)
        let additionalInfo = try values.nestedContainer(keyedBy: ResponseKeys.self, forKey: .photos)
        pagesCount = try additionalInfo.decode(Int.self, forKey: .pagesCount)
        pageSize = try additionalInfo.decode(Int.self, forKey: .pageSize)
        photosData = try additionalInfo.decode([PhotoData].self, forKey: .photo)
    }
}
