import UIKit
import TinyConstraints
import AVFoundation

class ScanViewController: EduIDBaseViewController {
    
    //MARK: - audio visual components
    let previewLayer = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    let output = AVCaptureMetadataOutput()
    
    //MARK: - middel qr frame view
    let middelSpaceView = UIImageView(image: .qrFrame)
    
    let frameSize: CGFloat = 275

    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        setupScanningFrameUI()
        setupCaptureSession()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        previewLayer.frame = view.bounds
    }
    
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
                
                previewLayer.session = session
                
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
    
    func setupScanningFrameUI() {
        //MARK: - create the dark frame with image
        let upperDarkView = UIView()
        upperDarkView.backgroundColor = .black.withAlphaComponent(0.5)
        let flashButton = UIButton()
        flashButton.setImage(.flashLight, for: .normal)
        flashButton.size(CGSize(width: 50, height: 50))
        upperDarkView.addSubview(flashButton)
        flashButton.trailing(to: upperDarkView, offset: -36)
        flashButton.top(to: upperDarkView, offset: 100)
        let middelLeftDarkView = UIView()
        middelLeftDarkView.backgroundColor = .black.withAlphaComponent(0.5)
        
        //MARK: - the imageview containing the frame lines
        let middelRightDarkView = UIView()
        middelRightDarkView.backgroundColor = .black.withAlphaComponent(0.5)
        let middelStack = UIStackView(arrangedSubviews: [middelLeftDarkView, middelSpaceView, middelRightDarkView])
        let lowerDarkView = UIView()
        lowerDarkView.backgroundColor = .black.withAlphaComponent(0.5)
        
        //MARK: - explanationText
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        paragraph.alignment = .center
        let attributedText = NSMutableAttributedString(string: """
Don’t see a QR code?
Go to eduid.nl/security
Create your personal QR code
Scan it here
""", attributes: [.foregroundColor: UIColor.white, .font: UIFont.sourceSansProRegular(size: 18), .paragraphStyle: paragraph])
        
        attributedText.setAttributeTo(part: "Don’t see a QR code?", attributes: [.font: UIFont.sourceSansProBold(size: 24)])
        attributedText.setAttributeTo(part: "eduid.nl/security", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.white])
        label.attributedText = attributedText
        label.sizeToFit()
        lowerDarkView.addSubview(label)
        label.center(in: lowerDarkView)
        
        //MARK: - the stack view holding the entire frame
        let vStack = UIStackView(arrangedSubviews: [upperDarkView, middelStack, lowerDarkView])
        vStack.axis = .vertical
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.distribution = .fill
        view.addSubview(vStack)
        
        //MARK: - constraints
        vStack.edgesToSuperview()
        middelSpaceView.size(CGSize(width: 275, height: 275))
        middelRightDarkView.height(to: middelSpaceView)
        middelLeftDarkView.height(to: middelSpaceView)
        upperDarkView.size(to: lowerDarkView)
        middelLeftDarkView.size(to: middelRightDarkView)
    }
}

//MARK: - preview layer delegate
extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print(metadataObjects)
    }
}
