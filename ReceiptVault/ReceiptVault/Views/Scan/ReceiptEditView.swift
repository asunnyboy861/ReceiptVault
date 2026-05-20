import SwiftUI
import SwiftData

struct ReceiptEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let viewModel: ReceiptViewModel
    let ocrResult: OCRService.OCRResult
    let scannedImages: [UIImage]
    let defaultCurrency: String
    let defaultCategory: String

    @State private var merchantName = ""
    @State private var amountText = ""
    @State private var currencyCode = "USD"
    @State private var date = Date()
    @State private var category = "Other"
    @State private var notes = ""
    @State private var address = ""
    @State private var phoneNumber = ""
    @State private var lineItems: [String] = []

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Merchant", text: $merchantName)
                    HStack {
                        Text(CurrencyInfo.symbol(for: currencyCode))
                            .foregroundStyle(.secondary)
                        TextField("Amount", text: $amountText)
                            .keyboardType(.decimalPad)
                    }
                    Picker("Currency", selection: $currencyCode) {
                        ForEach(CurrencyInfo.supported) { currency in
                            Text("\(currency.code) (\(currency.symbol))").tag(currency.code)
                        }
                    }
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section {
                    Picker("Category", selection: $category) {
                        ForEach(CategoryModel.presets, id: \.name) { preset in
                            Label(preset.name, systemImage: preset.iconName).tag(preset.name)
                        }
                    }
                }

                Section {
                    TextField("Address", text: $address)
                    TextField("Phone", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }

                if !lineItems.isEmpty {
                    Section("Line Items") {
                        ForEach(lineItems.indices, id: \.self) { index in
                            Text(lineItems[index])
                                .font(.subheadline)
                        }
                    }
                }

                Section {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Receipt Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveReceipt() }
                        .disabled(merchantName.isEmpty)
                }
            }
            .onAppear {
                merchantName = ocrResult.merchantName
                if let amount = ocrResult.amount {
                    amountText = String(format: "%.2f", amount)
                }
                currencyCode = defaultCurrency
                date = ocrResult.date ?? Date()
                category = defaultCategory
                address = ocrResult.address ?? ""
                phoneNumber = ocrResult.phoneNumber ?? ""
                lineItems = ocrResult.lineItems
            }
        }
    }

    private func saveReceipt() {
        let amount = Double(amountText.replacingOccurrences(of: ",", with: "")) ?? 0
        var imageData: Data?
        if let firstImage = scannedImages.first {
            imageData = firstImage.jpegData(compressionQuality: 0.7)
        }
        viewModel.saveReceipt(
            merchantName: merchantName,
            amount: amount,
            currencyCode: currencyCode,
            date: date,
            category: category,
            notes: notes,
            address: address,
            phoneNumber: phoneNumber,
            lineItems: lineItems,
            imageData: imageData,
            context: modelContext
        )
    }
}
