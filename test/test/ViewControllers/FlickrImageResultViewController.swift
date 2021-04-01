//
//  FlickrImageResultViewController.swift
//  test
//
//  Created by magnod on 2021-03-31.
//

import UIKit

class FlickrImageResultViewController: UICollectionViewController {
    private var selectedImage: Int = -1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x59abff)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(rgb: 0xFFFFFF)]
    }
        
    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection sectionIndex: Int) -> Int {
        return AppSharedData.shared.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrImageViewCell", for: indexPath)
        if let imageCell = cell as? FlickrImageViewCell {
            imageCell.downloadImage(flickrImage: AppSharedData.shared.images[indexPath.item])
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = indexPath.item
        performSegue(withIdentifier: "ShowDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ImageDetailsViewController, let detailsVC = segue.destination as? ImageDetailsViewController {
            detailsVC.imageIndex = selectedImage
            collectionView.deselectItem(at: IndexPath(item: selectedImage, section: 0), animated: false)
            selectedImage = -1
        }
    }
}
