import Foundation
import SwiftData

@Model
final class ReceiptModel {
    var id: UUID
    var merchantName: String
    var amount: Double
    var currencyCode: String
    var date: Date
    var category: String
    var notes: String
    var address: String
    var phoneNumber: String
    var lineItems: [String]
    var imageData: Data?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        merchantName: String = "",
        amount: Double = 0.0,
        currencyCode: String = "USD",
        date: Date = Date(),
        category: String = "Other",
        notes: String = "",
        address: String = "",
        phoneNumber: String = "",
        lineItems: [String] = [],
        imageData: Data? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.merchantName = merchantName
        self.amount = amount
        self.currencyCode = currencyCode
        self.date = date
        self.category = category
        self.notes = notes
        self.address = address
        self.phoneNumber = phoneNumber
        self.lineItems = lineItems
        self.imageData = imageData
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
