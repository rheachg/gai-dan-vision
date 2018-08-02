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
        guard let ciImage = getImageFromBuffer(sampleBuffer: buffer) else { return }
        
        let handler = VNImageRequestHandler(
            ciImage: ciImage,
            orientation: CGImagePropertyOrientation(rawValue: 6)!,
            options: [VNImageOption: Any]()
        )
        
        let request = VNDetectTextRectanglesRequest(completionHandler: { [weak self] request, error in
            DispatchQueue.main.async {
                self?.handle(ciImage: ciImage, request: request, error: error)
            }
        })
        
        request.reportCharacterBoxes = true
        
        do { try handler.perform([request]) }
        catch { print(error as Any) }
    }
    
    private func handle(ciImage: CIImage, request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNTextObservation] else { return }
        delegate?.visionService(self, didDetect: ciImage, results: results)
    }
    
}

extension VisionService {
    
    // CVImageBuffer -> CIImage -> CGImage -> UIImage in order to prevent pile up in memory
    func getImageFromBuffer(sampleBuffer: CMSampleBuffer) -> CIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        return ciImage
//        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return nil }
//        return UIImage(cgImage: cgImage)
    }
}
