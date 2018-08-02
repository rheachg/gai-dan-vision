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
    private var textObservations: [VNTextObservation] = []
    private var detectedRects: [CGRect] = []
    
    init() {
        tesseract.engineMode = .tesseractOnly
        tesseract.pageSegmentationMode = .sparseText
    }
    
    func performRecognition(previewLayer: AVCaptureVideoPreviewLayer, ciImage: CIImage, results: [VNTextObservation], on view: UIView) {
        
        textObservations = results
        let size = ciImage.extent.size
        
        for textObservation in textObservations {
            guard let rects = textObservation.characterBoxes else { continue }
            let (xMin, xMax, yMin, yMax) = getRectDimensions(rects: rects)
            let imageRect = CGRect(x: xMin * size.width, y: yMin * size.height, width: (xMax - xMin) * size.width, height: (yMax - yMin) * size.height)
            
            let image = getImageFromCGRect(rect: imageRect, ciImage: ciImage)
            tesseract.image = image?.g8_blackAndWhite()
            tesseract.recognize()
            
            guard var text = tesseract.recognizedText else { continue }
            
        }
        
    }
    
}

extension OCRService {
    
    func getRectDimensions(rects: [VNRectangleObservation]) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        
        var xMin = CGFloat.greatestFiniteMagnitude
        var xMax: CGFloat = 0
        var yMin = CGFloat.greatestFiniteMagnitude
        var yMax: CGFloat = 0
        
        for rect in rects {
            xMin = min(xMin, rect.bottomLeft.x)
            yMin = min(yMin, rect.bottomRight.y)
            xMax = max(xMax, rect.bottomRight.x)
            yMax = max(yMax, rect.topRight.y)
        }
        return (xMin, xMax, yMin, yMax)
    }
    
    func getImageFromCGRect(rect: CGRect, ciImage: CIImage) -> UIImage? {
        guard let cgImage = CIContext().createCGImage(ciImage, from: rect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
}
