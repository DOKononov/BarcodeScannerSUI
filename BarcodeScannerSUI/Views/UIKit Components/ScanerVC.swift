//
//  ScanerVC.swift
//  BarcodeScannerSUI
//
//  Created by Dmitry Kononov on 8.01.24.
//

import UIKit
import AVFoundation

enum CameraError {
    case invalidDeviceInput
    case invalidScaneValue
}

protocol ScanerVCDelegate: AnyObject {
    func didFind(barcode: String)
    func didSurface(error: CameraError)
}

final class ScanerVC: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scanerDelegate: ScanerVCDelegate?
    
    init(scanerDelegate: ScanerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scanerDelegate = scanerDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCaptureSession()
        
        guard let previewLayer else {
            scanerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    private func setupCaptureSession() {
        guard let videoCaptureDivice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDivice)
        } catch {
            scanerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scanerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        } else {
            scanerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        guard let previewLayer else {return}
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}

extension ScanerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard
            let object = metadataObjects.first,
            let metadataObject = object as? AVMetadataMachineReadableCodeObject,
            let barcode = metadataObject.stringValue
        else {
            scanerDelegate?.didSurface(error: .invalidScaneValue)
            return
        }
        scanerDelegate?.didFind(barcode: barcode)
    }
}
