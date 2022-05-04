//
//  PhotoDetailsViewModel.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import Foundation
import UIKit

class PhotoDetailsAdapter {
    
    private let photoLoader = ImageLoader()
  
    var photoData: PhotoData? {
        didSet {
            guard photoData != oldValue, let photoData = photoData, let url = photoData.url else {
                return
            }
            self.activityIndicator?.startAnimating()
            photoLoader.getImage(by: url) { [weak self] in
                guard let self = self else {
                    return
                }
                self.imageView?.image = $0
                self.activityIndicator?.stopAnimating()
            }
            titleLabel?.text = photoData.title.isEmpty ? "-" : photoData.title
        }
    }
    
    private var imageView: UIImageView?
    private var titleLabel: UILabel?
    private var activityIndicator: UIActivityIndicatorView?

    func prepare(imageView: UIImageView, titleLabel: UILabel, activityIndicator: UIActivityIndicatorView) {
        self.imageView = imageView
        self.titleLabel = titleLabel
        self.activityIndicator = activityIndicator
    }
}
