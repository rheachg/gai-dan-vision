//
//  ViewController.swift
//  Gaidan
//
//  Created by Rhea Chugh on 24/7/2018.
//  Copyright © 2018 Rhea Chugh. All rights reserved.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    private let cameraViewController = CameraViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraViewController.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: CameraViewControllerDelegate {
    func cameraViewController(_ controller: CameraViewController, didCapture buffer: CMSampleBuffer) {
        
    }
}
