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

//protocol OCRServiceDelegate: class {
//    func ocrService(_ service: OCRService, didDetect rects: [VNTextObservation])
//}

class OCRService {
    
//    weak var delegate: OCRServiceDelegate?
    private let tesseract = G8Tesseract(language: "eng+chi_tra")!
    private var textObservations: [VNTextObservation] = []
    private var textPositionTuples = [(rect: CGRect, text: String)]()
    private var detectedRects: [VNTextObservation] = []
    
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
            text = text.trimmingCharacters(in: CharacterSet.newlines)
            
            for chr in text {
                if chr == "雞" || chr == "蛋" {
                    
                    print("found gaidan")
                    
//                    detectedRects.append(imageRect)
                    text = text.replacingOccurrences(of: "雞", with: "chicken")
                    text = text.replacingOccurrences(of: "蛋", with: "egg")
                
                    if !text.isEmpty {
                        let x = xMin
                        let y = 1 - yMax
                        let width = xMax - xMin
                        let height = yMax - yMin
                        textPositionTuples.append((rect: CGRect(x: x, y: y, width: width, height: height), text: text))
//                        detectedRects.append(textObservation)
                        addRectLayers(on: view)
                    }
                }
            }
            textObservations.removeAll()
//            DispatchQueue.main.async {
                self.removeLayers(on: view)
                self.addRectLayers(on: view)
//            }
        }
//        self.delegate?.ocrService(self, didDetect: self.detectedRects)
    }
}

extension OCRService {
    
    func adjustFontSize(of text: String, to height: CGFloat, to width: CGFloat, on layer: CATextLayer) -> CGFloat {
        var fontSize = 25
        var font = CTFontCreateWithName("Helvetica" as CFString, CGFloat(fontSize), nil)
        var textHeight = text.heightOfString(usingFont: font)
        
        while textHeight > height {
            fontSize -= 1
            font = CTFontCreateWithName("Helvetica" as CFString, CGFloat(fontSize), nil)
            textHeight = text.heightOfString(usingFont: font)
        }
        
        var textWidth = text.widthOfString(usingFont: font)

        while textWidth > width {
            fontSize -= 1
            font = CTFontCreateWithName("Helvetica" as CFString, CGFloat(fontSize), nil)
            textWidth = text.widthOfString(usingFont: font)
        }
        
        return CGFloat(fontSize)
    }
    
    func addRectLayers(on view: UIView) {
        DispatchQueue.main.async {
            for tuple in self.textPositionTuples {
                let layer = CATextLayer()
                layer.backgroundColor = UIColor.clear.cgColor
                var rect = tuple.rect
                
                rect.origin.x *= view.frame.size.width
                rect.origin.y *= view.frame.size.height
                rect.size.width *= view.frame.size.width
                rect.size.height *= view.frame.size.height
                
                layer.fontSize = self.self.adjustFontSize(of: tuple.text, to: rect.height, to: rect.width, on: layer)
                layer.frame = rect
                layer.string = tuple.text
                layer.foregroundColor = UIColor.white.cgColor
                view.layer.addSublayer(layer)
            }
        }
    }
    
    func getImageFromCGRect(rect: CGRect, ciImage: CIImage) -> UIImage? {
        guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: rect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    func getRectDimensions(rects: [VNRectangleObservation]) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var xMin = CGFloat.greatestFiniteMagnitude
        var xMax: CGFloat = 0
        var yMin = CGFloat.greatestFiniteMagnitude
        var yMax: CGFloat = 0
        
        for rect in rects {
            xMin = min(xMin, rect.bottomLeft.x)
            xMax = max(xMax, rect.bottomRight.x)
            yMin = min(yMin, rect.bottomRight.y)
            yMax = max(yMax, rect.topRight.y)
        }
        
        return (xMin, xMax, yMin, yMax)
    }
    
    func removeLayers(on view: UIView) {
        DispatchQueue.main.async {
            guard let sublayers = view.layer.sublayers else { return }
            for layer in sublayers[1...] {
                if let _ = layer as? CATextLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [kCTFontAttributeName: font]
        let size = self.size(withAttributes: fontAttributes as [NSAttributedStringKey : Any])
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [kCTFontAttributeName: font]
        let size = self.size(withAttributes: fontAttributes as [NSAttributedStringKey : Any])
        return size.height
    }
}
