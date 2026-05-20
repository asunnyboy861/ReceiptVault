import SwiftUI
import SwiftData

@Observable
final class StatsViewModel {
    var selectedPeriod: Period = .monthly
    var selectedCurrency: String? = nil

    enum Period: String, CaseIterable {
        case monthly = "Monthly"
        case quarterly = "Quarterly"
        case yearly = "Yearly"
    }

    struct MonthlyTotal: Identifiable {
        let id = UUID()
        let month: String
        let total: Double
        let currencyCode: String
    }

    struct CategoryTotal: Identifiable {
        let id = UUID()
        let category: String
        let total: Double
        let count: Int
        let colorHex: String
    }

    struct MerchantTotal: Identifiable {
        let id = UUID()
        let merchant: String
        let total: Double
        let count: Int
    }

    var monthlyTotals: [MonthlyTotal] = []
    var categoryTotals: [CategoryTotal] = []
    var topMerchants: [MerchantTotal] = []
    var totalSpending: Double = 0
    var receiptCount: Int = 0

    func calculateStats(receipts: [ReceiptModel]) {
        let filtered = selectedCurrency.map { code in
            receipts.filter { $0.currencyCode == code }
        } ?? receipts

        totalSpending = filtered.reduce(0) { $0 + $1.amount }
        receiptCount = filtered.count
        calculateMonthlyTotals(receipts: filtered)
        calculateCategoryTotals(receipts: filtered)
        calculateTopMerchants(receipts: filtered)
    }

    private func calculateMonthlyTotals(receipts: [ReceiptModel]) {
        let formatter = DateFormatter()
        switch selectedPeriod {
        case .monthly: formatter.dateFormat = "MMM yyyy"
        case .quarterly: formatter.dateFormat = "yyyy QQQ"
        case .yearly: formatter.dateFormat = "yyyy"
        }
        let grouped = Dictionary(grouping: receipts) { formatter.string(from: $0.date) }
        monthlyTotals = grouped.map { key, value in
            MonthlyTotal(month: key, total: value.reduce(0) { $0 + $1.amount }, currencyCode: value.first?.currencyCode ?? "USD")
        }.sorted { $0.month > $1.month }
    }

    private func calculateCategoryTotals(receipts: [ReceiptModel]) {
        let grouped = Dictionary(grouping: receipts) { $0.category }
        categoryTotals = grouped.map { key, value in
            let preset = CategoryModel.presets.first { p in p.name == key }
            return CategoryTotal(
                category: key,
                total: value.reduce(0) { $0 + $1.amount },
                count: value.count,
                colorHex: preset?.colorHex ?? "9E9E9E"
            )
        }.sorted { $0.total > $1.total }
    }

    private func calculateTopMerchants(receipts: [ReceiptModel]) {
        let grouped = Dictionary(grouping: receipts) { $0.merchantName }
        topMerchants = grouped.map { key, value in
            MerchantTotal(merchant: key, total: value.reduce(0) { $0 + $1.amount }, count: value.count)
        }.sorted { $0.total > $1.total }
    }

    var currencies: [String] {
        Array(Set(monthlyTotals.map { $0.currencyCode })).sorted()
    }
}
