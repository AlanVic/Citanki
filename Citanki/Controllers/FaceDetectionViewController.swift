//
//  FaceDetectionViewController.swift
//  Citanki
//
//  Created by Alan Victor Paulino de Oliveira on 03/07/19.
//  Copyright © 2019 Alan Victor Paulino de Oliveira. All rights reserved.
//

import AVFoundation
import UIKit
import Vision
import ImageIO

class FaceDetectionViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView!
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    let dataOutputQueue = DispatchQueue(
        label: "video data queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)
    
    var faceViewHidden = false
    
    var maxX: CGFloat = 0.0
    var midY: CGFloat = 0.0
    var maxY: CGFloat = 0.0
    
    var sequenceHandler = VNSequenceRequestHandler()
    
    var currentImageDetected: UIImage = UIImage(){
        willSet{
//            updateClassifications(for: newValue)
//            if let imageCropped = newValue.cropped(boundingBox: faceRect){
//                updateClassifications(for: imageCropped)
//            }
        }
    }
    
    var faceRect: CGRect = .zero
    
    @IBOutlet weak var predictionText: UILabel!
    
    func classificationFace(withImage image:UIImage, andFaceRect faceRect:CGRect){
        guard let imageCropped = image.cropped(boundingBox: faceRect) else{
            fatalError("dont was possible to crop the image")
        }
        
//        updateClassifications(for: imageCropped)
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: ImageClassifier().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.predictionText.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            print(request)
            
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                self.predictionText.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                self.predictionText.text = "Classification:\n" + descriptions.joined(separator: "\n")
            }
        }
    }
    
    func updateClassifications(pixelBuffer:CVPixelBuffer) {
      
        do {
            try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([classificationRequest])
        } catch{
             print("Failed to perform classification.\n\(error.localizedDescription)")
        }
        
//        let orientation = CGImagePropertyOrientation(image.imageOrientation)
//        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
//        guard let cgImage = image.cgImage else {fatalError("Unable to get \(CGImage.self) from \(image).")}
        
//        DispatchQueue.global(qos: .userInitiated).async {
//
////            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
//            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//            do {
//                try handler.perform([self.classificationRequest])
//            } catch {
//                /*
//                 This handler catches general image processing errors. The `classificationRequest`'s
//                 completion handler `processClassifications(_:error:)` catches errors specific
//                 to processing that request.
//                 */
//                print("Failed to perform classification.\n\(error.localizedDescription)")
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCaptureSession()
        
        maxX = view.bounds.maxX
        midY = view.bounds.midY
        maxY = view.bounds.maxY
        
        session.startRunning()
    }
}


// MARK: - Video Processing methods

extension FaceDetectionViewController {
    func configureCaptureSession() {
        // Define the capture device we want to use
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .front) else {
                                                    fatalError("No front video camera available")
        }
        
        // Connect the camera to the capture session input
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            session.addInput(cameraInput)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // Create the video data output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        
        // Add the video output to the capture session
        session.addOutput(videoOutput)
        
        let videoConnection = videoOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
        
        // Configure the preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate methods

extension FaceDetectionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
//        let detectFaceRequest = VNDetectFaceRectanglesRequest(completionHandler: detectedFace)
//
        guard let pixelBuffer:CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
//
//        let attachments = CMCopyDictionaryOfAttachments(allocator: kCFAllocatorDefault, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
//        let ciImage = CIImage(cvImageBuffer: imageBuffer, options: attachments as! [CIImageOption : Any]?)
        
        
//        self.currentImageDetected = UIImage(ciImage: ciImage)
        
        updateClassifications(pixelBuffer: pixelBuffer)
        
//        do {
//            try self.sequenceHandler.perform(
//                [detectFaceRequest],
//                on: imageBuffer,
//                orientation: .leftMirrored)
//        } catch {
//            print(error.localizedDescription)
//        }
    }
    
    func detectedFace(request: VNRequest, error: Error?) {
        // 1
        guard
            let results = request.results as? [VNFaceObservation],
            let result = results.first
            else {
                // 2
                faceView.clear()
                return
        }
        
        // 3
        let box = result.boundingBox
        faceView.boundingBox = convert(rect: box)
        
        // 4
        DispatchQueue.main.async {
            self.faceView.setNeedsDisplay()
//            self.faceRect = self.convert(rect: box)
        }
    }
    
  
    func convert(rect: CGRect) -> CGRect {
        // 1
        let origin = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.origin)
        
        // 2
        let size = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.size.cgPoint)
        
        // 3
        return CGRect(origin: origin, size: size.cgSize)
    }
}

