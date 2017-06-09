# CoreML-Demo

A simple project showing how to implement image classifier using CoreML and the `Resnet50` model

![sample](coreml-demo.gif)

### Usage

To test the demo, implement a photo library picker for your app.  In the delegate callback after selecting an image, create a `CVPixelBuffer` to pass into the `Resnet50` model:
```swift
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
```
(Our sample project uses a `UIImage+PixelBuffer` extension to encapsulate the `CVPixelBuffer` logic found [here](https://github.com/handsomecode/ios11-Demos/blob/master/CoreML/CoreMLDemo/UIImage%2BPixelBuffer.swift))

After the image is selected, the `Resnet50` model will process the `CVPixelBuffer` and return a `Resnet50Output` object.  This object contains a `classLabel` string describing the most likely image category and a dictionary, `classLabelProbs`, containing the probability of each category.

### Related Documentation

Introduction to CoreML [WWDC Video](https://developer.apple.com/videos/play/wwdc2017/703/)

[CoreML Documentation](https://developer.apple.com/documentation/coreml)

[Converting trained models to CoreML](https://developer.apple.com/documentation/coreml/converting_trained_models_to_core_ml)
