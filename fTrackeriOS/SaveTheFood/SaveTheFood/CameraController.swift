//
//  CameraController.swift
//  SaveTheFood
//
//  Created by Philip Tam on 2019-01-26.
//  Copyright © 2019 savethefood. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import ChameleonFramework

class CameraController: UIViewController {
    

    @IBOutlet weak var camView: UIView!
    
    @IBOutlet weak var captureButton: UIButton! {
        didSet {
            captureButton.clipsToBounds = false
        }
    }
    
    var currentFrame: UIView?
    
    var isCreated: Bool = false
    
    var manual: Bool = false

    var captureSession = AVCaptureSession()
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    
    var image: UIImage?
    
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Camera"
        
        setupCaptureSession()
        
        requestCameraPermission()
        
        setupPreviewLayer()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.captureButton.backgroundColor = UIColor(hexString: "EAFABD")
        self.captureButton.layer.cornerRadius = self.captureButton.frame.height / 2
        self.captureButton.layer.borderColor = UIColor(hexString: "CEFA99")?.cgColor
        self.captureButton.layer.borderWidth = 1.2
        
        setupInputOutput()
        
        checkPermission()
        
        startRunningCaptureSession()
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.captureSession.stopRunning()
        
    }
    
    func setupPreviewLayer() {
    
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer.frame = self.view.frame
        camView.layer.insertSublayer(cameraPreviewLayer, at: 0)
        
        captureSession.startRunning()
    }
    
    func setupCaptureSession() {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func startRunningCaptureSession() {
        
        captureSession.startRunning()
    }
    

    func requestCameraPermission() {

        if !checkPermission() {
            // Checks if permission is given
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                 
                } else {
                   
                }
            })
        }
       
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
        currentCamera = deviceDiscoverySession.devices.first
    }
    
    func checkPermission() -> Bool {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            self.captureButton.isEnabled = true
            self.captureButton.alpha = 1
            return true
        }
        return false
    }
    
    func setupInputOutput() {
        do {
            
            if let currentCamera = currentCamera {
                
               
                let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera)
                
               
                if captureSession.inputs.isEmpty {
                    captureSession.addInput(captureDeviceInput)
                }
                
               
                setCameraMode(currentCamera: currentCamera)
                
                // If the photo output is nil
                if photoOutput == nil {
                    // Creates a photo output
                    photoOutput = AVCapturePhotoOutput()
                    if #available(iOS 11.0, *) {
                        // For ios11
                        photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    // If the photo output not nil then add the output to the camera session
                    if let photoOutput = photoOutput{
                        captureSession.addOutput(photoOutput)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    // Sets the camera mode depending on what is allowed
    func setCameraMode(currentCamera: AVCaptureDevice) {
        do {
            // Unlock
            try currentCamera.lockForConfiguration()
            
            // Checks to allow focuscenter
            if currentCamera.isFocusPointOfInterestSupported && currentCamera.isExposurePointOfInterestSupported {
                focusCenter()
            }
            
            // Checks continuous exposure to allow continuous or just autoExpose
            if (currentCamera.isExposureModeSupported(.continuousAutoExposure)) {
                currentCamera.exposureMode = .continuousAutoExposure
            } else if currentCamera.isExposureModeSupported(.autoExpose){
                currentCamera.exposureMode = .autoExpose
            }
            
            // Checks continuous exposure to allow continuous or just autoFocus
            if (currentCamera.isFocusModeSupported(.continuousAutoFocus)) {
                currentCamera.focusMode = .continuousAutoFocus
            } else if currentCamera.isFocusModeSupported(.autoFocus) {
                currentCamera.focusMode = .autoFocus
            } else {
                
            }
            
            // Sets the zoom factor to smallest
            currentCamera.videoZoomFactor = currentCamera.minAvailableVideoZoomFactor
            
            // Lock back
            currentCamera.unlockForConfiguration()
        } catch {
            print("Error while shooting auto focus: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCheck" {
            let destination = segue.destination as? CheckController
            destination?.image = image
        }
    }
    
    @IBAction func capturePhoto() {
        guard let camera = self.currentCamera else {return}
        self.captureButton.isUserInteractionEnabled = false
        let setting = AVCapturePhotoSettings()
        self.photoOutput?.capturePhoto(with: setting, delegate: self)
    }
}

// MARK: AV CAPTURE DELEGATE
extension  CameraController: AVCapturePhotoCaptureDelegate {
    
    // Get the device with the specified position
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        // Get all the cameras with builtinwideanglecamera
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        
        if let error = error {
            print("Error while taking picture: \(error)")
            captureButton.isUserInteractionEnabled = false
            return
        }
        
        
        if let imageData = photo.fileDataRepresentation() {
            
        
            image = UIImage(data: imageData, scale: 1.0)
            
            captureButton.isUserInteractionEnabled = true
            
            performSegue(withIdentifier: "goToCheck", sender: self)
        }
    }
}

extension CameraController {
   
    func focusCenter() {
        guard let device = currentCamera else {
            print("Current camera fails")
            return
        }
        
        let screenSize = camView.bounds.size
        let x = camView.frame.midY / screenSize.height
        let y = 1.0 - camView.frame.midX / screenSize.width
        let focusPoint = CGPoint(x: x, y: y)
        
        focusOnPoint(device: device, focusPoint: focusPoint, midPoint: camView.center)
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let device = currentCamera {
            if device.position != .front && touches.count == 1  {
                self.manual = true
                if let touchPoint = touches.first {
                    
                    let screenSize = camView.bounds.size
                    let x = touchPoint.location(in: camView).y / screenSize.height
                    let y = 1.0 - touchPoint.location(in: camView).x / screenSize.width
                    
                    let focusPoint = CGPoint(x: x, y: y)
                    focusOnPoint(device: device, focusPoint: focusPoint, midPoint: touchPoint.location(in: camView))
                }
            }
        }
    }
    
    func focusOnPoint(device: AVCaptureDevice, focusPoint: CGPoint, midPoint: CGPoint) {
        do {
            // Changes the focus point for the area
            try device.lockForConfiguration()
            print(focusPoint)
            device.focusPointOfInterest = focusPoint
            device.focusMode = .autoFocus
            device.exposurePointOfInterest = focusPoint
            device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
            device.unlockForConfiguration()
        } catch {
            // just ignore
        }
    }
}
