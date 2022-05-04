//
//  BaseRouter.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import Foundation
import UIKit

class BaseControllerRouter {
    
    private(set) weak var viewController: UIViewController!
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}
