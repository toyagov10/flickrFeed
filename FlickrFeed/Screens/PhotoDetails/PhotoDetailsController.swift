//
//  PhotoDetailsController.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import UIKit

class PhotoDetailsController: UIViewController {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: Constants.fontSize)
        titleLabel.text = "-"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let photoData: PhotoData
    private let viewAdapter = PhotoDetailsAdapter()
    
    // MARK: - VC Lifecycle
    init(photoData: PhotoData) {
        self.photoData = photoData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
        imageView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
       
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.sideInset),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Constants.sideInset),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.sideInset),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.sideInset),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        viewAdapter.prepare(imageView: imageView, titleLabel: titleLabel, activityIndicator: activityIndicator)
        viewAdapter.photoData = photoData
    }
}

// MARK: - Constants
private extension PhotoDetailsController {
    
    struct Constants {
        static let sideInset: CGFloat = 8.0
        static let fontSize: CGFloat = 25.0
    }
}
