import SwiftUI
import VisionKit

struct ScannerRepresentable: UIViewControllerRepresentable {
    let coordinator: ScannerCoordinator

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
}
