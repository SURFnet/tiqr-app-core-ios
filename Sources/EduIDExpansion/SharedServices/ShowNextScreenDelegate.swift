import Foundation
protocol ShowNextScreenDelegate {
    func nextScreen(for type: NextScreenFlowType)
}

enum NextScreenFlowType {
    case registerWithoutRecovery, none
}
