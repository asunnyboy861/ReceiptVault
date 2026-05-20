import Foundation
import SwiftData

@Model
final class CategoryModel {
    var name: String
    var colorHex: String
    var iconName: String
    var isCustom: Bool
    var receipts: [ReceiptModel] = []

    init(name: String, colorHex: String, iconName: String, isCustom: Bool = false) {
        self.name = name
        self.colorHex = colorHex
        self.iconName = iconName
        self.isCustom = isCustom
    }

    static let presets: [(name: String, colorHex: String, iconName: String)] = [
        ("Groceries", "4CAF50", "cart.fill"),
        ("Dining", "FF9800", "fork.knife"),
        ("Transportation", "2196F3", "car.fill"),
        ("Shopping", "E91E63", "bag.fill"),
        ("Entertainment", "9C27B0", "ticket.fill"),
        ("Healthcare", "F44336", "heart.fill"),
        ("Utilities", "607D8B", "bolt.fill"),
        ("Travel", "00BCD4", "airplane"),
        ("Business", "795548", "briefcase.fill"),
        ("Other", "9E9E9E", "doc.fill")
    ]
}
