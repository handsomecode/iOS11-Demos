//
//  CollectionViewCell.swift
//  DragDropDemo
//
//  Created by Eric Miller on 6/6/17.
//  Copyright © 2017 Handsome. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = nil
    }
}
