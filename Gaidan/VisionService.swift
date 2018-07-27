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
        guard let cgImage = image.cgImage else {
            assertionFailure()
            return
        }
        
        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: inferOrientation(image: image),
            options: [VNImageOption: Any]()
        )
        
        let request = VNDetectTextRectanglesRequest(completionHandler: { [weak self] request, error in
            DispatchQueue.main.async {
                self?.handle(image: image, request: request, error: error)
            }
        })
        
        request.reportCharacterBoxes = true
        
        do { try handler.perform([request]) }
        catch { print(error as Any) }
    }
    
    private func handle(image: UIImage, request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNTextObservation] else { return }
        delegate?.visionService(self, didDetect: image, results: results)
    }
    
}

extension VisionService {
    
    // CVImageBuffer -> CIImage -> CGImage -> UIImage in order to prevent pile up in memory
    func getImageFromBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    func inferOrientation(image: UIImage) -> CGImagePropertyOrientation {
        switch image.imageOrientation {
            case .up:
                return CGImagePropertyOrientation.up
            case .upMirrored:
                return CGImagePropertyOrientation.upMirrored
            case .down:
                return CGImagePropertyOrientation.down
            case .downMirrored:
                return CGImagePropertyOrientation.downMirrored
            case .left:
                return CGImagePropertyOrientation.left
            case .leftMirrored:
                return CGImagePropertyOrientation.leftMirrored
            case .right:
                return CGImagePropertyOrientation.right
            case .rightMirrored:
                return CGImagePropertyOrientation.rightMirrored
        }
    }
}
