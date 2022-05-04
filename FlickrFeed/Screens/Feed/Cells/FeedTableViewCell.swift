//
//  FeedTableViewCell.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    private(set) lazy var photoImageView = UIImageView()
    private(set) lazy var activityIndicator = UIActivityIndicatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        selectionStyle = .none
        
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photoImageView)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.sideInset),
            photoImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.sideInset),
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.sideInset),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.sideInset),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - Constants
private extension FeedTableViewCell {
    
    struct Constants {
        static let sideInset: CGFloat = 8.0
    }
}
