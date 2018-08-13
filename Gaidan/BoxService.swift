//
//  BoxService.swift
//  Gaidan
//
//  Created by Rhea Chugh on 8/8/2018.
//  Copyright © 2018 Rhea Chugh. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

class BoxService {
    
    func handle(previewLayer: AVCaptureVideoPreviewLayer, rects: [VNTextObservation], on view: UIView) {
        DispatchQueue.main.async {
            self.removeLayers(on: view)
            self.drawBoxes(rects: rects, on: view)
        }
    }
}

extension BoxService {
    
    func drawBoxes(rects: [VNTextObservation], on view: UIView) {
        let viewWidth =  view.frame.size.width
        let viewHeight = view.frame.size.height
        
        for result in rects {
            let layer = CALayer()
            var rect = result.boundingBox
            
            rect.origin.x *= viewWidth
            rect.size.height *= viewHeight
            rect.origin.y = ((1 - rect.origin.y) * viewHeight) - rect.size.height
            rect.size.width *= viewWidth
            
            layer.frame = rect
            layer.borderWidth = 2
            layer.borderColor = UIColor.white.cgColor
            
            view.layer.addSublayer(layer)
        }
    }
    
    func removeLayers(on view: UIView) {
        guard let sublayers = view.layer.sublayers else { return }
        for layer in sublayers[1...] {
            if (layer as? CATextLayer) == nil {
                layer.removeFromSuperlayer()
            }
        }
     }
}
