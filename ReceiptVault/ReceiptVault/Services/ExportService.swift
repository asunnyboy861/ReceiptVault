import UIKit
import PDFKit

@Observable
final class ExportService {
    func exportCSV(receipts: [ReceiptModel]) -> Data? {
        var csv = "Date,Merchant,Amount,Currency,Category,Notes,Address,Phone\n"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for receipt in receipts {
            let date = formatter.string(from: receipt.date)
            let merchant = receipt.merchantName.replacingOccurrences(of: "\"", with: "\"\"")
            let notes = receipt.notes.replacingOccurrences(of: "\"", with: "\"\"")
            let address = receipt.address.replacingOccurrences(of: "\"", with: "\"\"")
            let amount = String(format: "%.2f", receipt.amount)
            csv += "\"\(date)\",\"\(merchant)\",\"\(amount)\",\"\(receipt.currencyCode)\",\"\(receipt.category)\",\"\(notes)\",\"\(address)\",\"\(receipt.phoneNumber)\"\n"
        }
        return csv.data(using: .utf8)
    }

    func exportPDF(receipts: [ReceiptModel]) -> Data? {
        let pdfMetaData = [
            kCGPDFContextTitle: "ReceiptVault Export",
            kCGPDFContextCreator: "ReceiptVault"
        ]
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 36
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pdfMetaData)
        var currentY = pageHeight - margin
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.black
        ]
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.black
        ]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"

        for receipt in receipts {
            if currentY < margin + 120 {
                UIGraphicsBeginPDFPage()
                currentY = pageHeight - margin
            }
            let title = "\(receipt.merchantName) - \(CurrencyFormatter.format(receipt.amount, currencyCode: receipt.currencyCode))"
            title.draw(at: CGPoint(x: margin, y: currentY), withAttributes: titleAttributes)
            currentY -= 20
            let details = "Date: \(dateFormatter.string(from: receipt.date)) | Category: \(receipt.category) | Currency: \(receipt.currencyCode)"
            details.draw(at: CGPoint(x: margin, y: currentY), withAttributes: textAttributes)
            currentY -= 16
            if !receipt.notes.isEmpty {
                receipt.notes.draw(at: CGPoint(x: margin, y: currentY), withAttributes: textAttributes)
                currentY -= 16
            }
            if !receipt.address.isEmpty {
                receipt.address.draw(at: CGPoint(x: margin, y: currentY), withAttributes: textAttributes)
                currentY -= 16
            }
            currentY -= 12

            if let imageData = receipt.imageData, let image = UIImage(data: imageData) {
                let maxWidth = pageWidth - margin * 2
                let imageHeight = min(200, image.size.height * (maxWidth / image.size.width))
                if currentY - imageHeight < margin {
                    UIGraphicsBeginPDFPage()
                    currentY = pageHeight - margin
                }
                let rect = CGRect(x: margin, y: currentY - imageHeight, width: maxWidth, height: imageHeight)
                image.draw(in: rect)
                currentY -= imageHeight + 20
            }
        }
        UIGraphicsEndPDFContext()
        return pdfData as Data
    }
}
