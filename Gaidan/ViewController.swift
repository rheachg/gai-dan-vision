//
//  ViewController.swift
//  Gaidan
//
//  Created by Rhea Chugh on 24/7/2018.
//  Copyright © 2018 Rhea Chugh. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

class ViewController: UIViewController {
    
    private let cameraViewController = CameraViewController()
    private let visionService = VisionService()
    private let ocrService = OCRService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add to child controller
        cameraViewController.delegate = self
        
        visionService.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: CameraViewControllerDelegate {
    func cameraViewController(_ controller: CameraViewController, didCapture buffer: CMSampleBuffer) {
        visionService.performVision(buffer: buffer)
    }
}

extension ViewController: VisionServiceDelegate {
    func visionService(_ version: VisionService, didDetect ciImage: CIImage, results: [VNTextObservation]) {
        ocrService.performRecognition(previewLayer: cameraViewController.previewLayer, ciImage: ciImage, results: results, on: cameraViewController.view)
    }
}

