//
//  ViewController.swift
//  Gaidan
//
//  Created by Rhea Chugh on 24/7/2018.
//  Copyright © 2018 Rhea Chugh. All rights reserved.
//

import Anchors
import AVFoundation
import UIKit
import Vision

class ViewController: UIViewController {
    
    private let cameraViewController = CameraViewController()
    private let visionService = VisionService()
    private let ocrService = OCRService()
    private let boxService = BoxService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraViewController.delegate = self
        add(childController: cameraViewController)
        activate(cameraViewController.view.anchor.edges)
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
        boxService.handle(previewLayer: cameraViewController.previewLayer, rects: results, on: cameraViewController.view)
        ocrService.performRecognition(ciImage: ciImage, results: results, on: cameraViewController.view)
    }
}

extension UIViewController {
    func add(childController: UIViewController) {
        childController.willMove(toParentViewController: self)
        view.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }
}
