//
//  ImageDropViewController.swift
//  DragDropDemo
//
//  Created by Eric Miller on 6/9/17.
//  Copyright © 2017 Handsome. All rights reserved.
//

import UIKit

class ImageDropViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dragInteractionEnabled = true
        collectionView.dropDelegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension ImageDropViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ImageCollectionViewCell
        cell.setImage(images[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDropDelegate
extension ImageDropViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let canHandle = session.hasItemsConforming(toTypeIdentifiers: UIImage.readableTypeIdentifiersForItemProvider)
        return canHandle
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        for item in coordinator.items {
            let itemProvider = item.dragItem.itemProvider
            guard itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
            
            var placeholderContext: UICollectionViewDropPlaceholderContext? = nil
            
            let progress = itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        placeholderContext?.commitInsertion(dataSourceUpdates: { (placeholderIndexPath) in
                            self.addImage(image, at: placeholderIndexPath)
                        })
                    } else {
                        placeholderContext?.deletePlaceholder()
                    }
                }
            })
            
            placeholderContext = coordinator.drop(item.dragItem, toPlaceholderInsertedAt: destinationIndexPath, withReuseIdentifier: "placeholderCell", cellUpdateHandler: { (cell) in
                guard let placeholderCell = cell as? ImagePlaceholderCollectionViewCell else { return }
                placeholderCell.configure(with: progress)
            })
        }
        
        coordinator.session.progressIndicatorStyle = .none
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let proposal = UICollectionViewDropProposal(dropOperation: .copy, intent: .insertAtDestinationIndexPath)
        return proposal
    }
    
    // MARK: Private
    private func addImage(_ image: UIImage, at indexPath: IndexPath) {
        images.insert(image, at: indexPath.item)
    }
}
