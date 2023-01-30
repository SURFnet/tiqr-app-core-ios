import UIKit
import TinyConstraints
import AVFoundation

class ScanViewController: EduIDBaseViewController {
    
    init(viewModel: ScanViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: viewmodel
    var viewModel: ScanViewModel
    
    //MARK: flash button
    let flashButton = UIButton()
    
    //MARK: audio visual components
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    //MARK: middel qr frame view
    let middelSpaceView = UIImageView(image: .qrFrame)

    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        setupScanningFrameUI()
        
        previewLayer.session = viewModel.session
        viewModel.setupCaptureSession()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        previewLayer.frame = view.bounds
    }
    
    func setupScanningFrameUI() {
        //MARK: - create the dark frame with image
        let upperDarkView = UIView()
        upperDarkView.backgroundColor = .black.withAlphaComponent(0.5)
        flashButton.setImage(.flashLightOff, for: .normal)
        flashButton.size(CGSize(width: 50, height: 50))
        flashButton.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
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
    
    //MARK: - toggle flash action
    @objc
    func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { print("Torch isn't available"); return }

        do {
            try device.lockForConfiguration()
            let on = flashButton.image(for: .normal) == .flashLightOff
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
            let newImage: UIImage = on ? .flashLight : .flashLightOff
            flashButton.setImage(newImage, for: .normal)
        } catch {
            print("Torch can't be used")
        }
    }
}

