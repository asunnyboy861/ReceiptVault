import Foundation

struct CurrencyFormatter {
    static func format(_ amount: Double, currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: NSNumber(value: amount)) ?? "\(CurrencyInfo.symbol(for: currencyCode))\(String(format: "%.2f", amount))"
    }

    static func formatCompact(_ amount: Double, currencyCode: String) -> String {
        if abs(amount) >= 1000 {
            let formatted = String(format: "%.1fk", amount / 1000)
            return "\(CurrencyInfo.symbol(for: currencyCode))\(formatted)"
        }
        return format(amount, currencyCode: currencyCode)
    }
}
