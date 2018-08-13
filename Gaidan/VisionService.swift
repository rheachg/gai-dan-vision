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
    func visionService(_ version: VisionService, didDetect ciImage: CIImage, results: [VNTextObservation])
}

class VisionService {
    
    weak var delegate: VisionServiceDelegate?
    
    func performVision(buffer: CMSampleBuffer) {
        guard var ciImage = getImageFromBuffer(sampleBuffer: buffer) else { return }
        let transform = ciImage.orientationTransform(for: CGImagePropertyOrientation(rawValue: 6)!)
        ciImage = ciImage.transformed(by: transform)
        
        let handler = VNImageRequestHandler(
            ciImage: ciImage,
            orientation: .up,
            options: [VNImageOption: Any]()
        )
        
        let request = VNDetectTextRectanglesRequest(completionHandler: { [weak self] request, error in
            self?.handle(ciImage: ciImage, request: request, error: error)
        })
        
        request.reportCharacterBoxes = true
        
        do { try handler.perform([request]) }
        catch { print(error as Any) }
    }
    
    private func handle(ciImage: CIImage, request: VNRequest, error: Error?) {
        guard let textResults = request.results else { return }
        let results = textResults.map() { return $0 as? VNTextObservation }
        if results.isEmpty { return }
        delegate?.visionService(self, didDetect: ciImage, results: results as! [VNTextObservation])
    }
    
}

extension VisionService {
    
    func getImageFromBuffer(sampleBuffer: CMSampleBuffer) -> CIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        return ciImage
    }
}
