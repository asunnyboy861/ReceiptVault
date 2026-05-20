import UIKit
import VisionKit

@Observable
final class ScanningService {
    var isScannerAvailable: Bool {
        VNDocumentCameraViewController.isSupported
    }

    func createScannerDelegate(
        onCancel: @escaping () -> Void,
        onFinish: @escaping ([UIImage]) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ScannerCoordinator {
        ScannerCoordinator(onCancel: onCancel, onFinish: onFinish, onError: onError)
    }
}

final class ScannerCoordinator: NSObject, VNDocumentCameraViewControllerDelegate {
    private let onCancel: () -> Void
    private let onFinish: ([UIImage]) -> Void
    private let onError: (Error) -> Void

    init(
        onCancel: @escaping () -> Void,
        onFinish: @escaping ([UIImage]) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        self.onCancel = onCancel
        self.onFinish = onFinish
        self.onError = onError
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        onCancel()
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        var images: [UIImage] = []
        for page in 0..<scan.pageCount {
            images.append(scan.imageOfPage(at: page))
        }
        onFinish(images)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: any Error) {
        onError(error)
    }
}
