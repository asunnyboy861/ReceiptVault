import SwiftUI
import SwiftData

struct ScanView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ReceiptViewModel()
    @AppStorage("defaultCurrency") private var defaultCurrency = "USD"
    @AppStorage("defaultCategory") private var defaultCategory = "Other"

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if viewModel.isProcessing {
                    ProgressView("Processing receipt...")
                        .font(.headline)
                        .padding()
                } else {
                    Image(systemName: "doc.text.viewfinder")
                        .font(.system(size: 64))
                        .foregroundStyle(Color.accentColor)
                        .padding(.top, 60)

                    Text("Scan Your Receipt")
                        .font(.title2.bold())

                    Text("Point your camera at a receipt. Data stays on your device. Always.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Button {
                        viewModel.isShowingScanner = true
                    } label: {
                        Label("Scan Receipt", systemImage: "camera.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 8)

                    Text("No account needed · No cloud · One-time purchase")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .padding(.top, 4)
                }

                Spacer()
            }
            .navigationTitle("ReceiptVault")
            .fullScreenCover(isPresented: $viewModel.isShowingScanner) {
                ScannerRepresentable(
                    coordinator: ScanningService().createScannerDelegate(
                        onCancel: { viewModel.isShowingScanner = false },
                        onFinish: { images in
                            viewModel.isShowingScanner = false
                            Task {
                                await viewModel.processScannedImages(images, context: modelContext)
                            }
                        },
                        onError: { _ in viewModel.isShowingScanner = false }
                    )
                )
            }
            .sheet(isPresented: $viewModel.isShowingEditSheet) {
                if let ocrResult = viewModel.ocrResult {
                    ReceiptEditView(
                        viewModel: viewModel,
                        ocrResult: ocrResult,
                        scannedImages: viewModel.scannedImages,
                        defaultCurrency: defaultCurrency,
                        defaultCategory: defaultCategory
                    )
                    .environment(\.modelContext, modelContext)
                }
            }
            .alert("Duplicate Receipt?", isPresented: .constant(viewModel.duplicateWarning != nil)) {
                Button("Save Anyway") {
                    viewModel.duplicateWarning = nil
                }
                Button("Cancel", role: .cancel) {
                    viewModel.duplicateWarning = nil
                    viewModel.isShowingEditSheet = false
                }
            } message: {
                if let dup = viewModel.duplicateWarning {
                    Text("A receipt from \(dup.merchantName) for \(CurrencyFormatter.format(dup.amount, currencyCode: dup.currencyCode)) already exists.")
                }
            }
        }
    }
}
