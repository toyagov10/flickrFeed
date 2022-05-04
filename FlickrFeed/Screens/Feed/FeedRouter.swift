//
//  FeedRouter.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import Foundation
import UIKit

protocol FeedControllerRouter {
    
    func openPhotoDetails(photoData: PhotoData)
    func showError(message: String, retryCallback: @escaping () -> Void)
}

class FeedControllerRouterImpl: BaseControllerRouter, FeedControllerRouter {
    
    func openPhotoDetails(photoData: PhotoData) {
        let photoDetailsController = PhotoDetailsController(photoData: photoData)
        viewController.navigationController?.pushViewController(
            photoDetailsController,
            animated: true
        )
    }
    
    func showError(message: String, retryCallback: @escaping () -> Void) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            retryCallback()
        }))

        viewController.present(alert, animated: true, completion: nil)
    }
}
