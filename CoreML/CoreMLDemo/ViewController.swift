//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Alexey Solovyov on 08.06.17.
//  Copyright © 2017 Handsome LLC. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    enum Variant {
        case coreML, vision
    }

    var currentVariant: Variant = .coreML

    @IBOutlet fileprivate weak var imageView: UIImageView!

    fileprivate let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.contentMode = .scaleAspectFit
        imagePicker.delegate = self
    }

    @IBAction func chooseImage(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    // Using pure CoreML
    fileprivate lazy var classifier: Resnet50 = {
        return Resnet50()
    }()

    fileprivate func predictionViaPureCoreML(for image: UIImage) {
        self.title = nil
        DispatchQueue.global(qos: .userInitiated).async {
            // Resnet50 expects an image 224 x 224, so we should resize and crop the source image
            let inputImageSize: CGFloat = 224.0
            let minLen = min(image.size.width, image.size.height)
            let resizedImage = image.resize(to: CGSize(width: inputImageSize * image.size.width / minLen, height: inputImageSize * image.size.height / minLen))
            let cropedToSquareImage = resizedImage.cropToSquare()

            guard let pixelBuffer = cropedToSquareImage?.pixelBuffer() else {
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

    // Using Vision framework
    fileprivate lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: Resnet50().model)
            return VNCoreMLRequest(model: model, completionHandler: self.handleClassification)
        } catch {
            fatalError(error.localizedDescription)
        }
    }()

    fileprivate func predictionViaVision(for image: UIImage) {
        self.title = nil
        do {
            guard let cgImage = image.cgImage else {
                fatalError()
            }
            let handler = VNImageRequestHandler(cgImage: cgImage)
            try handler.perform([classificationRequest])
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    fileprivate func handleClassification(request: VNRequest, error: Error?) {
        if let bestResult = request.results?.first as? VNClassificationObservation {
            DispatchQueue.main.async {
                self.title = bestResult.identifier
            }
        } else {
            fatalError("Can't get best result")
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage

            switch currentVariant {
            case .coreML:
                predictionViaPureCoreML(for: pickedImage)
            case .vision:
                predictionViaVision(for: pickedImage)
            }
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

