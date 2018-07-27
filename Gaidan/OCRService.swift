//
//  OCRService.swift
//  Gaidan
//
//  Created by Rhea Chugh on 27/7/2018.
//  Copyright © 2018 Rhea Chugh. All rights reserved.
//

import TesseractOCR

class OCRService {
    private let tesseract = G8Tesseract(language: "chi_tra", engineMode: .tesseractOnly)
    
    func performRecognition() {
        
    }
    
}
