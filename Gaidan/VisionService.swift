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

class VisionService {
    
    func performVision(buffer: CMSampleBuffer) {
        let image = getImageFromBuffer(buffer: buffer)
        let orientation = inferOrientation(image: image)
        
    }
    
}

extension VisionService {
    func getImageFromBuffer(buffer: CMSampleBuffer) -> UIImage {
        
    }
    
    func inferOrientation(image: UIImage) -> CGImagePropertyOrientation {
        
    }
}
