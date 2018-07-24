//
//  CameraViewController.swift
//  Gaidan
//
//  Created by Rhea Chugh on 24/7/2018.
//  Copyright © 2018 Rhea Chugh. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    private var captureSession: AVCaptureSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCaptureSession()
    }
    
}

extension CameraViewController {
    func setUpCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        guard
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let captureInputDevice = try? AVCaptureDeviceInput(device: camera)
            else { return }
        captureSession.addInput(captureInputDevice)
    }
}