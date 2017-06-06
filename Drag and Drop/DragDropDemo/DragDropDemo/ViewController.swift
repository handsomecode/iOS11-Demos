//
//  ViewController.swift
//  DragDropDemo
//
//  Created by Eric Miller on 6/6/17.
//  Copyright © 2017 Handsome. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    fileprivate var currentDragSession: UIDragSession?
    fileprivate var colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple, .cyan, .magenta, .brown, .black]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CollectionViewCell
        cell.contentView.backgroundColor = colors[indexPath.item]
        return cell
    }
}

extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        var items: [UIDragItem] = []
        if let cell = collectionView.cellForItem(at: indexPath) {
            let dragItem = UIDragItem(itemProvider: NSItemProvider())
            
            // Pretty sure this isn't being called.
            dragItem.previewProvider = {
                let previewView = UIView()
                let dragPreview = UIDragPreview(view: previewView)
                dragPreview.parameters.backgroundColor = cell.contentView.backgroundColor
                return dragPreview
            }
            
            dragItem.localObject = cell
            items.append(dragItem)
        }
        
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        self.currentDragSession = session
    }
}

extension ViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath, let destinationIndexPath = coordinator.destinationIndexPath {
                let movedColor = colors.remove(at: sourceIndexPath.item)
                colors.insert(movedColor, at: destinationIndexPath.item)
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                    
                }, completion: { (success) in
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let proposal = UICollectionViewDropProposal(dropOperation: .move, intent: .insertAtDestinationIndexPath)
        return proposal
    }
}

