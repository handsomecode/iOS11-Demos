# CoreML-Demo

A simple project showing how to implement image classifier using CoreML and the `Resnet50` model

![sample](coreml-demo.gif)

### Usage

To test the demo, implement a photo library picker for your app.  In the delegate callback after selecting an image, create a `CVPixelBuffer` to pass into the Resnet50 model:
```swift
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        imageView.image = pickedImage

        DispatchQueue.global(qos: .userInitiated).async {

            // Our sample project uses a `UIImage+PixelBuffer` extension to encapsulate the `CVPixelBuffer` logic.
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

### Related Documentation

Introduction to CoreML [WWDC Video](https://developer.apple.com/videos/play/wwdc2017/703/)
