//
//  FlickrImage.swift
//  test
//
//  Created by Magnus Nordin on 2021-03-31.
//

import Foundation

struct FlickrImage {
    var id: String
    var title: String
    var server: String
    var secret: String
    var description: String
    var externalUrl: String
    
    init() {
        id = ""
        title = ""
        server = ""
        secret = ""
        description = ""
        externalUrl = ""
    }
    
    func getImageUrl(size: FlickrImageSize) -> String {
        return "https://live.staticflickr.com/\(server)/\(id)_\(secret)_\(size.rawValue).jpg"
    }
}

enum FlickrImageSize: String {
    case smallThumbnail = "s" //thumbnail    75    cropped square
    case mediumThumbnail = "q" //thumbnail    150    cropped square
    case largeThumbnail = "t" //thumbnail    100
    case small240 = "m" //small    240
    case small320 = "n" //small    320
    case small400 = "w" //small    400
    case medium640 = "z" //medium    640
    case medium800 = "c" //medium    800
    case large1024 = "b" //large    1024
    case large1600 = "h" //large    1600    has a unique secret; photo owner can restrict
    case large2048 = "k" //large    2048    has a unique secret; photo owner can restrict
    case extraLarge3k = "3k" //extra large    3072    has a unique secret; photo owner can restrict
    case extraLarge4k = "4k" //extra large    4096    has a unique secret; photo owner can restrict
    case extraLarge4096 = "f" //extra large    4096    has a unique secret; photo owner can restrict; only exists for 2:1 aspect ratio photos
    case extraLarge5k = "5k" //extra large    5120    has a unique secret; photo owner can restrict
    case extraLarge6k = "6k" //extra large    6144    has a unique secret; photo owner can restrict
    case original = "o" //original    arbitrary    has a unique secret; photo owner can restrict; files have full EXIF data; files might not be rotated; files can use an arbitrary file extension
}
