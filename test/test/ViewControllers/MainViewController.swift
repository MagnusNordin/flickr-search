//
//  MainViewController.swift
//  test
//
//  Created by Magnus Nordin on 2021-03-30.
//

import Combine
import UIKit

class MainViewController: UIViewController {
    private var searchDataAvailableSubscriber: AnyCancellable?
    private var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    private var lookingForData = false
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBAction func doSearch(_ sender: Any) {
        spinner.startAnimating()
        searchButton.isEnabled = false
        if let searchTerm = searchField.text {
            lookingForData = true
            AppSharedData.shared.search(term: searchTerm)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubscribers()

        spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        spinner.color = .white
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        spinner.center = CGPoint(x:view.bounds.size.width / 2, y: view.bounds.size.height - 70)
        view.addSubview(spinner)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setUpSubscribers() {
        
        searchDataAvailableSubscriber = AppSharedData.shared.$dataParsed.sink(receiveValue: { [weak self] isAvailable in
            if isAvailable && self?.lookingForData == true {
                self?.lookingForData = false
                DispatchQueue.main.async() { [weak self] in
                    self?.spinner.stopAnimating()
                    self?.searchButton.isEnabled = true
                    self?.performSegue(withIdentifier: "ShowImagesSegue", sender: nil)
                }
            }
        })
    }
}

