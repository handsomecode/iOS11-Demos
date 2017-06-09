//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Alexey Solovyov on 08.06.17.
//  Copyright © 2017 Handsome LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    let imagePicker = UIImagePickerController()
    let classifier = Resnet50()

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.contentMode = .scaleAspectFit
        imagePicker.delegate = self
    }

    @IBAction func chooseImage(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate {

}

extension ViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage

            DispatchQueue.global(qos: .userInitiated).async {
                guard let pixelBuffer = pickedImage.resize(to: CGSize(width: 224, height: 224)).pixelBuffer() else {
                    fatalError()
                }
                guard let classifierOutput = try? self.classifier.prediction(image: pixelBuffer) else {
                    fatalError()
                }

                DispatchQueue.main.async {
                    self.title = classifierOutput.classLabel
                }
            }
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

