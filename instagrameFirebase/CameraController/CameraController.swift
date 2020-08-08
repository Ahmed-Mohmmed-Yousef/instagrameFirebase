//
//  CameraController.swift
//  instagrameFirebase
//
//  Created by Ahmed on 8/7/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    private lazy var dissmisButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrowshape.turn.up.right.fill"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(handelDissmis), for: .touchUpInside)
        return btn
    }()
    
    private lazy var capturePhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "capPhoto"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(handelCaptuer), for: .touchUpInside)
        return btn
    }()
    
    // output
    let output = AVCapturePhotoOutput()
    // animated transition
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismisser = CustomAnimationDismisser()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemPink
        transitioningDelegate = self
//        setupCaptureSression()
        setupCapturePhotoButton()
        setupDissmisButton()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc fileprivate func handelDissmis(){
        self.dismiss(animated: true)
    
    }
    
    @objc fileprivate func handelCaptuer(){
        let settings = AVCapturePhotoSettings()
        guard let previewFromateType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFromateType]
        output.capturePhoto(with: settings, delegate: self)

    }
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        //1. setup inputs
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("Could not setup camera: ", err.localizedDescription)
        }
        
        //2. setup output
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
        // camera.viewfinder
        // arrowshape.turn.up.right.fill
        
    }
    
    fileprivate func setupCapturePhotoButton(){
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  paddingBottom: -44,
                                  width: 60,
                                  height: 60)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
   
    fileprivate func setupDissmisButton(){
        view.addSubview(dissmisButton)
        dissmisButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             trailing: view.trailingAnchor,
                             paddingTop: 12,
                             paddingTrailing: -12,
                             width: 50,
                             height: 50)
    }

}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        let previewContainer = PreviewPhotoContainerView()
        previewContainer.imageView.image = previewImage
        view.addSubview(previewContainer)
        previewContainer.anchor(top: view.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.bottomAnchor,
                                trailing: view.trailingAnchor)
        
        
        print("finish ....")
    }
}

extension CameraController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresentor
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
}


