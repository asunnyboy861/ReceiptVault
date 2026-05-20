import SwiftUI
import SwiftData

struct ReceiptDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let receipt: ReceiptModel
    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageData = receipt.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 4)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(receipt.merchantName)
                        .font(.title2.bold())

                    Text(CurrencyFormatter.format(receipt.amount, currencyCode: receipt.currencyCode))
                        .font(.title)
                        .foregroundStyle(Color.accentColor)

                    HStack {
                        Label(receipt.date.formatted(.dateTime.month().day().year()), systemImage: "calendar")
                        Spacer()
                        Label(receipt.category, systemImage: categoryIcon)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    if !receipt.address.isEmpty {
                        Label(receipt.address, systemImage: "location")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    if !receipt.phoneNumber.isEmpty {
                        Label(receipt.phoneNumber, systemImage: "phone")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.05), radius: 4)

                if !receipt.lineItems.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Line Items")
                            .font(.headline)
                        ForEach(receipt.lineItems, id: \.self) { item in
                            Text(item)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.05), radius: 4)
                }

                if !receipt.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notes")
                            .font(.headline)
                        Text(receipt.notes)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.05), radius: 4)
                }
            }
            .padding()
        }
        .navigationTitle("Receipt")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var categoryIcon: String {
        CategoryModel.presets.first { $0.name == receipt.category }?.iconName ?? "doc.fill"
    }
}
