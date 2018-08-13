//
//  CameraViewController.swift
//  Gaidan
//
//  Created by Rhea Chugh on 24/7/2018.
//  Copyright © 2018 Rhea Chugh. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate: class {
    func cameraViewController(_ controller: CameraViewController, didCapture buffer: CMSampleBuffer)
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    weak var delegate: CameraViewControllerDelegate?
    
    private var captureSession: AVCaptureSession!
    public var previewLayer: AVCaptureVideoPreviewLayer!
    private var videoOutput: AVCaptureVideoDataOutput!
    
    // placeholder for passing captured buffer to touchesBegan
//    var buffer: CMSampleBuffer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCaptureSession()
        setUpPreviewLayer()
        setUpVideoOutput()
        
        captureSession.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    func captureOutput( _ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        buffer = sampleBuffer
        delegate?.cameraViewController(self, didCapture: sampleBuffer)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let sampleBuffer = buffer {
//            delegate?.cameraViewController(self, didCapture: sampleBuffer)
//        }
//    }

}

extension CameraViewController {
    func setUpCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        guard
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let captureInputDevice = try? AVCaptureDeviceInput(device: camera)
        else { return }
        guard captureSession.canAddInput(captureInputDevice) else { return }
        captureSession.addInput(captureInputDevice)
    }
    
    func setUpPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resize
        view.layer.addSublayer(previewLayer)
    }
    
    func setUpVideoOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil))
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
    }
}
