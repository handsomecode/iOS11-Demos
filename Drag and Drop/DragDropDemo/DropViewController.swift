//
//  SecondViewController.swift
//  DragDropDemo
//
//  Created by Eric Miller on 6/8/17.
//  Copyright © 2017 Handsome. All rights reserved.
//

import UIKit

class DropViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var colors: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dragInteractionEnabled = true
        collectionView.dropDelegate = self
        
        colors = generateColorHues(of: UIColor.green, numberOfColors: 12)
    }
    
    // MARK: - Private
    private func generateColorHues(of color: UIColor, numberOfColors: Int) -> [UIColor] {
        var newColors: [UIColor] = []
        for _ in 0..<numberOfColors {
            let newColor = UIColor.randomHueFor(color)
            newColors.append(newColor)
        }
        
        return newColors
    }
}

// MARK: - UICollectionViewDataSource
extension DropViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CollectionViewCell
        cell.contentView.backgroundColor = colors[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDropDelegate
extension DropViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let canHandle = session.hasItemsConforming(toTypeIdentifiers: UIColor.readableTypeIdentifiersForItemProvider)
        return canHandle
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        var destinationIndex = destinationIndexPath.item
        
        for item in coordinator.items {
            guard let newColor = item.dragItem.localObject as? UIColor else { continue }
            
            let insertionIndexPath = IndexPath(item: destinationIndex, section: 0)
            collectionView.performBatchUpdates({
                self.addColor(newColor, at: insertionIndexPath)
                collectionView.insertItems(at: [insertionIndexPath])
            })
            coordinator.drop(item.dragItem, toItemAt: insertionIndexPath)
            destinationIndex += 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let proposal = UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        return proposal
    }
    
    // MARK: Private
    private func addColor(_ color: UIColor, at indexPath: IndexPath) {
        colors.insert(color, at: indexPath.item)
    }
}
