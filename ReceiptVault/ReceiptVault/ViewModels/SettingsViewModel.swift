import SwiftUI
import SwiftData
import LocalAuthentication

@Observable
final class SettingsViewModel {
    var defaultCurrency: String = UserDefaults.standard.string(forKey: "defaultCurrency") ?? "USD" {
        didSet { UserDefaults.standard.set(defaultCurrency, forKey: "defaultCurrency") }
    }
    var defaultCategory: String = UserDefaults.standard.string(forKey: "defaultCategory") ?? "Other" {
        didSet { UserDefaults.standard.set(defaultCategory, forKey: "defaultCategory") }
    }
    var isBiometricEnabled: Bool = UserDefaults.standard.bool(forKey: "isBiometricEnabled") {
        didSet { UserDefaults.standard.set(isBiometricEnabled, forKey: "isBiometricEnabled") }
    }
    var isLocked = false
    var isAuthenticating = false

    private let biometricService = BiometricService()
    let backupService = BackupService()

    var biometricType: LABiometryType {
        biometricService.biometricType
    }

    var isBiometricAvailable: Bool {
        biometricService.isBiometricAvailable
    }

    func lockApp() {
        if isBiometricEnabled {
            isLocked = true
        }
    }

    func unlockApp() async {
        isAuthenticating = true
        let success = await biometricService.authenticate()
        if success {
            isLocked = false
        }
        isAuthenticating = false
    }

    func createBackup(receipts: [ReceiptModel]) -> Data? {
        backupService.createBackup(receipts: receipts)
    }

    func restoreBackup(from data: Data, context: ModelContext) -> Bool {
        guard let backup = backupService.parseBackup(from: data) else { return false }
        backupService.restoreBackup(backup, context: context)
        return true
    }
}
