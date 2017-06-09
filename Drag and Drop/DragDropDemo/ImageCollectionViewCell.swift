//
//  ImageCollectionViewCell.swift
//  DragDropDemo
//
//  Created by Eric Miller on 6/9/17.
//  Copyright © 2017 Handsome. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}
