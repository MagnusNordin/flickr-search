//
//  FlickrImageDetails.swift
//  test
//
//  Created by magnod on 2021-03-31.
//

import Foundation

class LookupFlickrImageDetails {
    private let baseUrl: String
    
    init(apiKey: String) {
        baseUrl = "https://www.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(apiKey)&format=rest"
    }
    
    func lookup(imageData: FlickrImage, completionHandler: @escaping (Result<Data, Error>) -> Void){
        let searchUrl = "\(baseUrl)&photo_id=\(imageData.id)&secret=\(imageData.secret)"
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
