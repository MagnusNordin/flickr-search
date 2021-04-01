//
//  ImageDetailsViewController.swift
//  test
//
//  Created by magnod on 2021-03-31.
//

import UIKit
import Combine

class ImageDetailsViewController: UIViewController {
    private var imageDataAvailableSubscriber: AnyCancellable?
    public var imageIndex = -1
    private var lookingForData = false
    private var image:FlickrImage = FlickrImage()
    private var spinner: UIActivityIndicatorView?
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBAction func goToFlickr(_ sender: Any) {
        if let url = URL(string: image.externalUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        spinner.color = .black
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height)
        spinner.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
        view.addSubview(spinner)
        spinner.startAnimating()
        self.spinner = spinner
        
        setUpSubscribers()
        lookingForData = true
        AppSharedData.shared.lookupImageData(imageIndex: imageIndex)
    }
    
    private func updateUI() {
        titleLabel.text = image.title
        descriptionLabel.text = image.description
        if let url = URL(string: image.getImageUrl(size: .small400)) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.spinner?.stopAnimating()
                    self?.imageVIew?.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    private func setUpSubscribers() {
        
        imageDataAvailableSubscriber = AppSharedData.shared.$dataParsed.sink(receiveValue: { [weak self] isAvailable in
            if isAvailable && self?.lookingForData == true {
                self?.lookingForData = false
                DispatchQueue.main.async() { [weak self] in
//                    self?.spinner.stopAnimating()
                    self?.image = AppSharedData.shared.images[self?.imageIndex ?? 0]
                    self?.updateUI()
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
