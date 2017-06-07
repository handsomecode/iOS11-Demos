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
            dragItem.localObject = cell
            items.append(dragItem)
        }
        
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        var items: [UIDragItem] = []
        if let cell = collectionView.cellForItem(at: indexPath) {
            let dragItem = UIDragItem(itemProvider: NSItemProvider())
            dragItem.localObject = cell
            items.append(dragItem)
        }
        
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        print("DRAG SESSION WILL BEGIN")
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        print("DRAG SESSION ENDED")
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let preview = UIDragPreviewParameters()
        if let cell = collectionView.cellForItem(at: indexPath) {
            let cellCenterPoint = cell.contentView.center
            let path = UIBezierPath(
                arcCenter: cellCenterPoint,
                radius: 50.0,
                startAngle: 0.0,
                endAngle: 360.0,
                clockwise: true
            )
            preview.visiblePath = path
        }
        preview.backgroundColor = UIColor.magenta
        return preview
    }
}

extension ViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath, let destinationIndexPath = coordinator.destinationIndexPath {
                moveColor(from: sourceIndexPath, to: destinationIndexPath)
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                    
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let proposal = UICollectionViewDropProposal(dropOperation: .move, intent: .insertAtDestinationIndexPath)
        return proposal
    }
    
    // MARK: Private
    fileprivate func moveColor(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedColor = colors.remove(at: sourceIndexPath.item)
        colors.insert(movedColor, at: destinationIndexPath.item)
    }
}


