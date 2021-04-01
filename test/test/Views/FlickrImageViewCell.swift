//
//  FlickrImageView.swift
//  test
//
//  Created by magnod on 2021-03-31.
//

import Foundation
import UIKit
import Combine

class FlickrImageViewCell: UICollectionViewCell {
    
    private var image: UIImageView?
    func downloadImage(flickrImage: FlickrImage) {
        let image = UIImageView(frame: frame)
        image.image = UIImage(named: "Fallback")
        image.isHidden = true
        addSubview(image)
        image.frame = bounds
        self.image = image
        
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.color = UIColor(rgb: 0xFFFFFF)
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height)
        spinner.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        addSubview(spinner)
        spinner.startAnimating()
        
        if let url = URL(string: flickrImage.getImageUrl(size: .largeThumbnail)) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image?.isHidden = false
                    self?.image?.image = UIImage(data: data)
                    spinner.stopAnimating()
                }
            }.resume()
        }
    }
}
