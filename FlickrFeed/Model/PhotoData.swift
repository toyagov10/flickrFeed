//
//  FeedService.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import Foundation
import CoreGraphics

struct PhotoData: Equatable {
    let title: String
    let url: URL?
    let size: CGSize
}

extension PhotoData: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case title
        case url = "url_m"
        case height = "height_m"
        case width = "width_m"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        url = URL(string: try values.decode(String.self, forKey: .url))
        let height = try values.decode(CGFloat.self, forKey: .height)
        let width = try values.decode(CGFloat.self, forKey: .width)
        size = CGSize(width: width, height: height)
    }
}
