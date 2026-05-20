import SwiftUI
import SwiftData
import PhotosUI

@Observable
final class ReceiptViewModel {
    var receipts: [ReceiptModel] = []
    var searchText = ""
    var sortOption: SortOption = .dateDescending
    var filterCategory: String?
    var filterStartDate: Date?
    var filterEndDate: Date?
    var isShowingScanner = false
    var isShowingEditSheet = false
    var editingReceipt: ReceiptModel?
    var scannedImages: [UIImage] = []
    var ocrResult: OCRService.OCRResult?
    var isProcessing = false
    var duplicateWarning: ReceiptModel?
    var exportFormat: ExportFormat?

    enum SortOption: String, CaseIterable {
        case dateDescending = "Newest First"
        case dateAscending = "Oldest First"
        case amountDescending = "Highest Amount"
        case amountAscending = "Lowest Amount"
        case merchantAZ = "Merchant A-Z"
    }

    enum ExportFormat: String, CaseIterable {
        case csv = "CSV"
        case pdf = "PDF"
    }

    private let ocrService = OCRService()
    private let exportService = ExportService()

    var filteredReceipts: [ReceiptModel] {
        var result = receipts
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                $0.merchantName.lowercased().contains(query) ||
                $0.category.lowercased().contains(query) ||
                $0.notes.lowercased().contains(query) ||
                String(format: "%.2f", $0.amount).contains(query)
            }
        }
        if let category = filterCategory {
            result = result.filter { $0.category == category }
        }
        if let start = filterStartDate {
            result = result.filter { $0.date >= start }
        }
        if let end = filterEndDate {
            result = result.filter { $0.date <= end }
        }
        switch sortOption {
        case .dateDescending: result.sort { $0.date > $1.date }
        case .dateAscending: result.sort { $0.date < $1.date }
        case .amountDescending: result.sort { $0.amount > $1.amount }
        case .amountAscending: result.sort { $0.amount < $1.amount }
        case .merchantAZ: result.sort { $0.merchantName.lowercased() < $1.merchantName.lowercased() }
        }
        return result
    }

    var categories: [String] {
        Array(Set(receipts.map { $0.category })).sorted()
    }

    func processScannedImages(_ images: [UIImage], context: ModelContext) async {
        isProcessing = true
        scannedImages = images
        ocrResult = await ocrService.processImages(images)
        if let ocr = ocrResult {
            checkDuplicate(ocr: ocr, context: context)
        }
        isProcessing = false
        isShowingEditSheet = true
    }

    func checkDuplicate(ocr: OCRService.OCRResult, context: ModelContext) {
        guard let amount = ocr.amount, !ocr.merchantName.isEmpty else { return }
        let merchant = ocr.merchantName
        let descriptor = FetchDescriptor<ReceiptModel>(
            predicate: #Predicate<ReceiptModel> { $0.merchantName == merchant && $0.amount == amount }
        )
        if let existing = try? context.fetch(descriptor), let first = existing.first {
            duplicateWarning = first
        }
    }

    func saveReceipt(
        merchantName: String,
        amount: Double,
        currencyCode: String,
        date: Date,
        category: String,
        notes: String,
        address: String,
        phoneNumber: String,
        lineItems: [String],
        imageData: Data?,
        context: ModelContext
    ) {
        let receipt = ReceiptModel(
            merchantName: merchantName,
            amount: amount,
            currencyCode: currencyCode,
            date: date,
            category: category,
            notes: notes,
            address: address,
            phoneNumber: phoneNumber,
            lineItems: lineItems,
            imageData: imageData
        )
        context.insert(receipt)
        try? context.save()
        duplicateWarning = nil
        isShowingEditSheet = false
        scannedImages = []
        ocrResult = nil
    }

    func updateReceipt(_ receipt: ReceiptModel, context: ModelContext) {
        receipt.updatedAt = Date()
        try? context.save()
    }

    func deleteReceipt(_ receipt: ReceiptModel, context: ModelContext) {
        context.delete(receipt)
        try? context.save()
    }

    func exportReceipts(format: ExportFormat, receipts: [ReceiptModel]) -> Data? {
        switch format {
        case .csv: return exportService.exportCSV(receipts: receipts)
        case .pdf: return exportService.exportPDF(receipts: receipts)
        }
    }

    func clearFilters() {
        filterCategory = nil
        filterStartDate = nil
        filterEndDate = nil
        searchText = ""
    }
}
