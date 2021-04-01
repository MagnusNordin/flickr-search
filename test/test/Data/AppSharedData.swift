//
//  AppSharedData.swift
//  test
//
//  Created by Magnus Nordin on 2021-03-31.
//

import Foundation

class AppSharedData: NSObject {
    private var apiKey = "f99cd8bcc61bd895c6f389db8d5a20d7"
    
    private(set) var images: [FlickrImage] = []
    @Published private(set) var dataParsed = false
    static let shared = AppSharedData()

    // Used for XML parsing
    private var latestImage = FlickrImage()
    private var latestElement = ""
    
    override private init() {}

    func search(term: String) {
        dataParsed = false
        images.removeAll()
        SearchFlickr(apiKey: apiKey).search(term: term) { result in
            switch result {
                case .failure(let error):
                    print("fail", error.localizedDescription)
                case .success(let data):
                    let parser = XMLParser(data: data)
                    parser.delegate = self
                    parser.parse()
            }
        }
    }
    
    func lookupImageData(imageIndex: Int) {
        dataParsed = false
        LookupFlickrImageDetails(apiKey: apiKey).lookup(imageData: images[imageIndex]) { result in
            switch result {
                case .failure(let error):
                    print("fail", error.localizedDescription)
                case .success(let data):
                    let parser = XMLParser(data: data)
                    parser.delegate = self
                    parser.parse()
            }
        }
        
    }
}

extension AppSharedData: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "photo" {
            if let id = attributeDict["id"] {
                latestImage.id = id
            }
            if let title = attributeDict["title"] {
                latestImage.title = title
            }
            if let server = attributeDict["server"] {
                latestImage.server = server
            }
            if let secret = attributeDict["secret"] {
                latestImage.secret = secret
            }
        }
        latestElement = elementName
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        latestElement = ""
        if elementName == "photo" {
            if let row = images.firstIndex(where: {$0.id == latestImage.id}) {
                images[row] = latestImage
            } else {
                images.append(latestImage)
            }
            latestImage = FlickrImage()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if latestElement == "description" {
            latestImage.description = string
        }
        if latestElement == "url" {
            latestImage.externalUrl = string
        }
        if latestElement == "title" {
            latestImage.title = string
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        dataParsed = true
        latestImage = FlickrImage()
    }
}
