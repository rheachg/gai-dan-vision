//
//  OCRService.swift
//  Gaidan
//
//  Created by Rhea Chugh on 27/7/2018.
//  Copyright © 2018 Rhea Chugh. All rights reserved.
//

import TesseractOCR
import Vision
import AVFoundation

class OCRService {
    private let tesseract = G8Tesseract(language: "chi_tra")!
    
    init() {
        tesseract.engineMode = .tesseractOnly
        tesseract.pageSegmentationMode = .sparseText
    }
    
    func performRecognition(previewLayer: AVCaptureVideoPreviewLayer, ciImage: CIImage, results: [VNTextObservation], on view: UIView) {
        
        
        
    }
    
}
