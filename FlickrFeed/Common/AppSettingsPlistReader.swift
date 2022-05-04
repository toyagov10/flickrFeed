//
//  AppSettingsPlistReader.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import Foundation

class AppSettingsPlistReader {
    private let fileName = "ApplicationSettings"
    private lazy var data: [String: Any] = {
        guard let path = Bundle.main.path(
            forResource: fileName,
            ofType: "plist"
        ) else {
            return [:]
        }
        return NSDictionary(contentsOfFile: path) as? [String: Any] ?? [:]
    }()

    func customizationSettings(prefix: String) -> [String: Any] {
        var result = data
        prefix.split(separator: "/").forEach {
            result = result[String($0)] as? [String: Any] ?? [:]
        }
        return result
    }
}
