//
//  SearchFlickr.swift
//  test
//
//  Created by Magnus Nordin on 2021-03-30.
//

import Foundation

class SearchFlickr {
    private let baseUrl: String
    
    init(apiKey: String) {
        baseUrl = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&format=rest&text="
    }
    func search(term: String, completionHandler: @escaping (Result<Data, Error>) -> Void){
        let searchUrl = "\(baseUrl)\(term)"
        guard let url = URL(string: searchUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let responseData = data, error == nil else {
                completionHandler(.failure(error ?? GenericError.noData))
                return
            }
            completionHandler(.success(responseData))
        }.resume()
    }
}

enum GenericError: Error {
    case noData
}
