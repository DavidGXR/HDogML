//
//  ViewController.swift
//  HDogML
//
//  Created by David Im on 11/11/20.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate        = self
        imagePicker.sourceType      = .camera
        imagePicker.allowsEditing   = false
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        /// create a model object from the CoreML model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
             fatalError("Unable to find CoreML's model")
        }
        /// An image analysis request that uses a Core ML model to process images.
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            print(results)
        }
        /// tell the CoreML that we want to use this image
        let handler = VNImageRequestHandler(ciImage: image)
        
        /// perform request
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
    }

} /// End of class

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // What to do with image that user has picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            /// convert UIImage to CIImage which can be understood by CoreML engine
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Unable to convert UIImage to CIImage")
            }
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

