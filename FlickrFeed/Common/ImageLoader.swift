//
//  ImageLoader.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import Foundation
import UIKit

class ImageLoader {
    typealias Completion = (UIImage?) -> Void
    
    func getImage(by url: URL, completion: @escaping Completion) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data) ?? nil)
            }
        }
    }
}
