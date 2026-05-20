import SwiftUI
import SwiftData

@main
struct ReceiptVaultApp: App {
    @State private var settingsVM = SettingsViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if settingsVM.isBiometricEnabled && settingsVM.isLocked {
                    LockView(settingsVM: settingsVM)
                } else {
                    ContentView()
                        .environment(settingsVM)
                        .onAppear {
                            settingsVM.lockApp()
                        }
                }
            }
        }
        .modelContainer(for: [ReceiptModel.self, CategoryModel.self])
    }
}

struct LockView: View {
    let settingsVM: SettingsViewModel

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.accentColor)

            Text("ReceiptVault is Locked")
                .font(.title2.bold())

            Text("Authenticate to access your receipts")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                Task {
                    await settingsVM.unlockApp()
                }
            } label: {
                Label("Unlock", systemImage: settingsVM.biometricType == .faceID ? "faceid" : "touchid")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 48)
            .disabled(settingsVM.isAuthenticating)

            if settingsVM.isAuthenticating {
                ProgressView()
            }
        }
    }
}
