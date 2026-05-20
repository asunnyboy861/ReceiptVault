import SwiftUI

struct ReceiptRowView: View {
    let receipt: ReceiptModel

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: categoryColorHex))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: categoryIcon)
                        .foregroundStyle(.white)
                        .font(.body)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(receipt.merchantName)
                    .font(.headline)
                    .lineLimit(1)
                Text(receipt.date.formatted(.dateTime.month().day().year()))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(CurrencyFormatter.format(receipt.amount, currencyCode: receipt.currencyCode))
                    .font(.subheadline.bold())
                Text(receipt.category)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private var categoryColorHex: String {
        CategoryModel.presets.first { $0.name == receipt.category }?.colorHex ?? "9E9E9E"
    }

    private var categoryIcon: String {
        CategoryModel.presets.first { $0.name == receipt.category }?.iconName ?? "doc.fill"
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
