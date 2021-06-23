//
//  NetworkManager.swift
//  NYT-Stories
//
//  Created by Jose Bolivar on 23/6/21.
//

import Foundation

protocol NetworkControllerProtocol: AnyObject {
    func downloadStoriesUrls(completion: @escaping (Result<[Story], NetworkError>) -> Void)
    func downloadImage(from url: URL, completion: @escaping (Data) -> Void)
}

// Error tracking for the API request:
// On a real scenario, more errors would be used/added, for better accuracy tracking
enum NetworkError: Error {
    case requestError
    case timeoutError
    case decodingError
}

class NetworkManager {}

extension NetworkManager: NetworkControllerProtocol {

    func downloadStoriesUrls(completion: @escaping (Result<[Story], NetworkError>) -> Void) {

        var storiesList: [Story] = []          // Array of retrieved stories's urls
        if let storiesUrl = URL(string: AppURL.base + AppURL.Api.topStories + AppURL.Api.apiKey) {
            URLSession.shared.dataTask(with: storiesUrl, completionHandler: { [weak self] (data, response, error) in
                do {
                    guard let responseData = data else {
                        completion(.failure(.requestError))
                        return
                    }
                    let response: APIStoriesResponse = try JSONDecoder().decode(APIStoriesResponse.self, from: responseData)
                    print("number of responses: ", response.numResults as Any)

                    if let responseStories = response.results {
                        responseStories.forEach() {
                            storiesList.append($0)
                        }
                        if response.status == "OK" {
                            completion(.success(storiesList))
                        } else {
                            completion(.failure(.requestError))
                        }
                    }
                } catch {
                    print(error)
                    completion(.failure(.decodingError))
                }
            }).resume()
        }
    }

    func downloadImage(from url: URL, completion: @escaping (Data) -> Void) {

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else { return }
                completion(data)
        }.resume()
    }
}
