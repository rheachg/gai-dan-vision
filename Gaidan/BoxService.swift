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
    
    func handle(previewLayer: AVCaptureVideoPreviewLayer, rects: [(rect: CGRect, text: String)], on view: UIView) {
        removeLayers(on: view)
        drawBoxes(rects: rects, on: view)
    }
    
}

extension BoxService {
    
    func drawBoxes(rects: [(rect: CGRect, text: String)], on view: UIView) {
        let viewWidth = view.frame.size.width
        let viewHeight = view.frame.size.height
        
        for result in rects {
            let layer = CALayer()
            var rect = result.rect
            
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
        view.layer.sublayers?.forEach {
            if let _ = $0 as? CATextLayer {
                $0.removeFromSuperlayer()
            }
        }
    }
}
