import Foundation

struct CurrencyInfo: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let symbol: String
    let name: String

    static let supported: [CurrencyInfo] = [
        CurrencyInfo(code: "USD", symbol: "$", name: "US Dollar"),
        CurrencyInfo(code: "EUR", symbol: "€", name: "Euro"),
        CurrencyInfo(code: "GBP", symbol: "£", name: "British Pound"),
        CurrencyInfo(code: "JPY", symbol: "¥", name: "Japanese Yen"),
        CurrencyInfo(code: "CNY", symbol: "¥", name: "Chinese Yuan"),
        CurrencyInfo(code: "CAD", symbol: "C$", name: "Canadian Dollar"),
        CurrencyInfo(code: "AUD", symbol: "A$", name: "Australian Dollar"),
        CurrencyInfo(code: "CHF", symbol: "CHF", name: "Swiss Franc"),
        CurrencyInfo(code: "KRW", symbol: "₩", name: "South Korean Won"),
        CurrencyInfo(code: "INR", symbol: "₹", name: "Indian Rupee"),
        CurrencyInfo(code: "MXN", symbol: "MX$", name: "Mexican Peso"),
        CurrencyInfo(code: "BRL", symbol: "R$", name: "Brazilian Real"),
        CurrencyInfo(code: "SGD", symbol: "S$", name: "Singapore Dollar"),
        CurrencyInfo(code: "HKD", symbol: "HK$", name: "Hong Kong Dollar"),
        CurrencyInfo(code: "SEK", symbol: "kr", name: "Swedish Krona")
    ]

    static func symbol(for code: String) -> String {
        supported.first { $0.code == code }?.symbol ?? code
    }
}
