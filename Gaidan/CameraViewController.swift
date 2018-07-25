//
//  CameraViewController.swift
//  Gaidan
//
//  Created by Rhea Chugh on 24/7/2018.
//  Copyright © 2018 Rhea Chugh. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var videoOutput: AVCaptureVideoDataOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCaptureSession()
        setUpPreviewLayer()
        setUpVideoOutput()
        
        captureSession.startRunning()
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
    
    func setUpPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    func setUpVideoOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
        captureSession.addOutput(videoOutput)
    }
}
