//
//  CameraManager.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import AVFoundation
import UIKit
import Observation

@Observable
final class CameraManager: NSObject {
    var session = AVCaptureSession()
    var isFlashOn = false
    var capturedImage: UIImage?
    var isFrontCamera = false
    
    private let photoOutput = AVCapturePhotoOutput()
    private var videoDeviceInput: AVCaptureDeviceInput?
    
    override init() {
        super.init()
        checkPermissionsAndSetup()
    }
    
    func checkPermissionsAndSetup() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.setupCamera()
                    }
                }
            }
        default:
            break
        }
    }
    
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            session.beginConfiguration()
            
            if session.canAddInput(input) {
                session.addInput(input)
                self.videoDeviceInput = input
            }
            
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            }
            
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.startRunning()
            }
        } catch {
            print("Failed to setup camera: \(error.localizedDescription)")
        }
    }
    
    func stopSession() {
        if session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.stopRunning()
            }
        }
    }
    
    func toggleFlash() {
        isFlashOn.toggle()
    }
    
    func flipCamera() {
        session.beginConfiguration()
        guard let currentInput = videoDeviceInput else {
            session.commitConfiguration()
            return
        }
        
        session.removeInput(currentInput)
        isFrontCamera.toggle()
        
        let newPosition: AVCaptureDevice.Position = isFrontCamera ? .front : .back
        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else {
            session.addInput(currentInput)
            session.commitConfiguration()
            return
        }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: newDevice)
            if session.canAddInput(newInput) {
                session.addInput(newInput)
                videoDeviceInput = newInput
            } else {
                session.addInput(currentInput)
            }
        } catch {
            session.addInput(currentInput)
        }
        
        session.commitConfiguration()
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        if photoOutput.supportedFlashModes.contains(.on) && !isFrontCamera {
            settings.flashMode = isFlashOn ? .on : .off
        } else {
            settings.flashMode = .off
        }
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else { return }
        
        DispatchQueue.main.async {
            // If it's front camera, flip the image horizontally
            if self.isFrontCamera {
                if let cgImage = image.cgImage {
                    self.capturedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .leftMirrored)
                }
            } else {
                self.capturedImage = image
            }
        }
    }
}
