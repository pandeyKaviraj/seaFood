//
//  ViewController.swift
//  seaFood
//
//  Created by KAVIRAJ PANDEY on 14/08/19.
//  Copyright © 2019 KAVIRAJ PANDEY. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    //MARK- ONCE IMAGE HAS BEEN PICKED PUT IT TO MACINE LEARNING MODEL
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //User picked an image, infro is dict where image will store, our image we downcast to uiimage
       if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
         imageView.image = userPickedImage
        //for imageProcessing in model convert uiimage into ciimage
        guard let ciimage = CIImage(image: userPickedImage) else {
            fatalError("Could not convert UIImage into CIImage ")
        }
        
        detect(image: ciimage)
        
        }
        
        //Dismiss imagePicker  and go back to view controller
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    //Code to use machine learing model in order to classify our image
    func detect(image: CIImage) {
        //using inception model object for ml model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreMl model faild.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
           guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            print(results)
        }
        
        //handler take the requst to perform
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    
    //MARK- WHEN TO LOAD UIIMAGEPICKER, LOGICALLU WHEN CAMERA TAPPED
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        //present camera to user to pick photos
        present(imagePicker, animated: true, completion: nil)
        
    }
}

