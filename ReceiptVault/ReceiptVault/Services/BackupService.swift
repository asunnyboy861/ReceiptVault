import Foundation
import SwiftData

@Observable
final class BackupService {
    struct BackupData: Codable {
        let version: Int
        let exportDate: Date
        let receipts: [ReceiptBackup]
    }

    struct ReceiptBackup: Codable {
        let id: UUID
        let merchantName: String
        let amount: Double
        let currencyCode: String
        let date: Date
        let category: String
        let notes: String
        let address: String
        let phoneNumber: String
        let lineItems: [String]
        let createdAt: Date
    }

    func createBackup(receipts: [ReceiptModel]) -> Data? {
        let backupReceipts = receipts.map { receipt in
            ReceiptBackup(
                id: receipt.id,
                merchantName: receipt.merchantName,
                amount: receipt.amount,
                currencyCode: receipt.currencyCode,
                date: receipt.date,
                category: receipt.category,
                notes: receipt.notes,
                address: receipt.address,
                phoneNumber: receipt.phoneNumber,
                lineItems: receipt.lineItems,
                createdAt: receipt.createdAt
            )
        }
        let backup = BackupData(version: 1, exportDate: Date(), receipts: backupReceipts)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(backup)
    }

    func parseBackup(from data: Data) -> BackupData? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(BackupData.self, from: data)
    }

    func restoreBackup(_ backup: BackupData, context: ModelContext) {
        for receiptBackup in backup.receipts {
            let receipt = ReceiptModel(
                id: receiptBackup.id,
                merchantName: receiptBackup.merchantName,
                amount: receiptBackup.amount,
                currencyCode: receiptBackup.currencyCode,
                date: receiptBackup.date,
                category: receiptBackup.category,
                notes: receiptBackup.notes,
                address: receiptBackup.address,
                phoneNumber: receiptBackup.phoneNumber,
                lineItems: receiptBackup.lineItems,
                createdAt: receiptBackup.createdAt
            )
            context.insert(receipt)
        }
        try? context.save()
    }
}
