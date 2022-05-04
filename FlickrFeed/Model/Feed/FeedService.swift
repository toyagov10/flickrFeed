//
//  FeedService.swift
//  FlickrFeed
//
//  Created by Anatoliy Yagov on 03.05.2022.
//

import Foundation

protocol FeedService {
    typealias Response = Result<PhotoFeedServiceResponse, PhotoFeedServiceError>
    typealias Completion = (Response) -> Void
    
    func getFeed(page: Int, pageSize: Int, completion: @escaping Completion)
}

class FeedServiceImpl: FeedService {
    private let url = "https://www.flickr.com/services/rest/"

    private let session: URLSession
    private let decoder = JSONDecoder()
    private let appSettingsPlistReader = AppSettingsPlistReader()

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getFeed(page: Int, pageSize: Int, completion: @escaping Completion) {
        guard let apiKey = appSettingsPlistReader.customizationSettings(
            prefix: "flickr_data"
        )["flickr_api_key"] as? String else {
            completion(.failure(.apiKeyNotFound))
            return
        }
        var query = URLComponents(string: url)
        query?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "method", value: "flickr.interestingness.getList"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(pageSize)"),
            URLQueryItem(name: "extras", value: "url_m")
        ]
        guard let url = query?.url else {
            completion(.failure(.brokenQuery))
            return
        }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else {
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(.network))
                }
            } else if let data = data, let decodedResponse = try? self.decoder.decode(PhotoFeedServiceResponse.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            }
        }
        task.resume()
    }
}
