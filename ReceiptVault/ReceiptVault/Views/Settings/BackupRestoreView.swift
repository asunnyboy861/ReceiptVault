import SwiftUI
import SwiftData

struct BackupRestoreView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var receipts: [ReceiptModel]
    @State private var settingsVM = SettingsViewModel()
    @State private var isShowingBackupShare = false
    @State private var isShowingRestorePicker = false
    @State private var backupData: Data?
    @State private var showRestoreSuccess = false
    @State private var showRestoreError = false
    @State private var receiptCount = 0

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Data")
                        .font(.headline)
                    Text("\(receipts.count) receipts stored on this device")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Button {
                    backupData = settingsVM.createBackup(receipts: receipts)
                    isShowingBackupShare = true
                } label: {
                    Label("Create Backup", systemImage: "arrow.up.doc.fill")
                }
                .disabled(receipts.isEmpty)
            }

            Section {
                Button {
                    isShowingRestorePicker = true
                } label: {
                    Label("Restore from Backup", systemImage: "arrow.down.doc.fill")
                }
            }
        }
        .navigationTitle("Backup & Restore")
        .sheet(isPresented: $isShowingBackupShare) {
            if let data = backupData {
                ShareSheet(items: [data], fileName: "ReceiptVault_backup.json")
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
        }
        .alert("Restore Failed", isPresented: $showRestoreError) {
            Button("OK") {}
        }
    }
}
