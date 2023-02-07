import UIKit
import AVFoundation

final class ScanViewModel: NSObject {
    
    //MARK: av componenets
    let session = AVCaptureSession()
    let output = AVCaptureMetadataOutput()
    
    let frameSize: CGFloat = 275
    
    //MARK: - setup the av camera session
    func setupCaptureSession() {
        let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            if let device = device {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                                
                output.metadataObjectTypes = [.qr]
                output.setMetadataObjectsDelegate(self, queue: .main)
                
                //MARK: - set rect of interest
                let screenBounds = UIScreen.main.bounds
                let interestOrigin = CGPoint(x: (screenBounds.width - frameSize) / 2 / screenBounds.width, y: (screenBounds.height - frameSize) / 2 / screenBounds.height)
                let interestSize = CGSize(width: frameSize / screenBounds.width, height: frameSize / screenBounds.height)
                output.rectOfInterest = CGRect(origin: interestOrigin, size: interestSize)
                
                DispatchQueue.global(qos: .background).async { [weak self] in
                    self?.session.startRunning()
                }
            }
        } catch {
            print(error)
        }
    }
    
    deinit {
        session.stopRunning()
        session.removeOutput(output)
    }
}

//MARK: - preview layer delegate
extension ScanViewModel: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print(metadataObjects)
    }
}