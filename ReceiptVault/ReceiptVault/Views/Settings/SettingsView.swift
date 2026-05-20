import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var receipts: [ReceiptModel]
    @State private var settingsVM = SettingsViewModel()
    @State private var isShowingBackupShare = false
    @State private var isShowingRestorePicker = false
    @State private var backupData: Data?
    @State private var showRestoreSuccess = false
    @State private var showRestoreError = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Defaults") {
                    Picker("Default Currency", selection: $settingsVM.defaultCurrency) {
                        ForEach(CurrencyInfo.supported) { currency in
                            Text("\(currency.code) (\(currency.symbol))").tag(currency.code)
                        }
                    }
                    Picker("Default Category", selection: $settingsVM.defaultCategory) {
                        ForEach(CategoryModel.presets, id: \.name) { preset in
                            Text(preset.name).tag(preset.name)
                        }
                    }
                }

                Section("Security") {
                    if settingsVM.isBiometricAvailable {
                        Toggle(
                            biometricLabel,
                            isOn: $settingsVM.isBiometricEnabled
                        )
                    } else {
                        Text("Biometric authentication not available on this device")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Data") {
                    Button {
                        backupData = settingsVM.createBackup(receipts: receipts)
                        isShowingBackupShare = true
                    } label: {
                        Label("Backup Data", systemImage: "arrow.up.doc")
                    }
                    .disabled(receipts.isEmpty)

                    Button {
                        isShowingRestorePicker = true
                    } label: {
                        Label("Restore from Backup", systemImage: "arrow.down.doc")
                    }
                }

                Section("Export All") {
                    Button {
                        exportAll(format: .csv)
                    } label: {
                        Label("Export as CSV", systemImage: "doc.text")
                    }
                    Button {
                        exportAll(format: .pdf)
                    } label: {
                        Label("Export as PDF", systemImage: "doc.richtext")
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                            .foregroundStyle(.secondary)
                    }
                    Link("Privacy Policy", destination: URL(string: "https://\(Constants.githubUser).github.io/ReceiptVault/privacy")!)
                    Link("Support", destination: URL(string: "https://\(Constants.githubUser).github.io/ReceiptVault/support")!)
                }

                Section {
                    NavigationLink {
                        ContactSupportView()
                    } label: {
                        Label("Contact Support", systemImage: "envelope.fill")
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $isShowingBackupShare) {
                if let data = backupData {
                    ShareSheet(items: [data], fileName: "ReceiptVault_backup_\(Date().formatted(.dateTime.year().month().day())).json")
                }
            }
            .fileImporter(isPresented: $isShowingRestorePicker, allowedContentTypes: [.json]) { result in
                switch result {
                case .success(let url):
                    if let data = try? Data(contentsOf: url) {
                        let success = settingsVM.restoreBackup(from: data, context: modelContext)
                        if success {
                            showRestoreSuccess = true
                        } else {
                            showRestoreError = true
                        }
                    }
                case .failure:
                    showRestoreError = true
                }
            }
            .alert("Restore Successful", isPresented: $showRestoreSuccess) {
                Button("OK") {}
            } message: {
                Text("Your receipts have been restored from the backup.")
            }
            .alert("Restore Failed", isPresented: $showRestoreError) {
                Button("OK") {}
            } message: {
                Text("Could not restore from the selected file. Please make sure it is a valid ReceiptVault backup.")
            }
        }
    }

    private var biometricLabel: String {
        switch settingsVM.biometricType {
        case .faceID: return "Face ID Lock"
        case .touchID: return "Touch ID Lock"
        default: return "Biometric Lock"
        }
    }

    private func exportAll(format: ReceiptViewModel.ExportFormat) {
        let exportService = ExportService()
        let data: Data?
        switch format {
        case .csv: data = exportService.exportCSV(receipts: receipts)
        case .pdf: data = exportService.exportPDF(receipts: receipts)
        }
        if let data = data {
            backupData = data
            isShowingBackupShare = true
        }
    }
}
