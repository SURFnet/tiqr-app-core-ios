import UIKit
import TiqrCoreObjC
import AVFoundation

protocol ScanViewModelDelegate: AnyObject {
    func scanViewModelAddPoints(_for object: AVMetadataMachineReadableCodeObject, viewModel: ScanViewModel)
    func scanViewModelShowVerifyAuthAttempt(viewModel: ScanViewModel)
    func scanViewModelShowErrorAlert(error: Any, viewModel: ScanViewModel)
}
