//
//  VisionService.swift
//  Gaidan
//
//  Created by Rhea Chugh on 26/7/2018.
//  Copyright © 2018 Rhea Chugh. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

protocol VisionServiceDelegate: class {
    func visionService(_ version: VisionService, didDetect image: UIImage, results: [VNTextObservation])
}

class VisionService {
    
    weak var delegate: VisionServiceDelegate?
    
    func performVision(buffer: CMSampleBuffer) {
        guard let image = getImageFromBuffer(sampleBuffer: buffer) else { return }
        let orientation = inferOrientation(image: image)
        
    }
    
    private func handle(image: UIImage, request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNTextObservation] else { return }
        delegate?.visionService(self, didDetect: image, results: results)
    }
    
}

extension VisionService {
    func getImageFromBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    func inferOrientation(image: UIImage) -> CGImagePropertyOrientation {
        
    }
}
