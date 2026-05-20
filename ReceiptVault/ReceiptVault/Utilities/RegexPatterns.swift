import Foundation

struct RegexPatterns {
    static let amount = try? NSRegularExpression(pattern: #"(?:Total|TOTAL|Amount|AMOUNT|Sum|SUM|Balance|BALANCE|Grand Total|GRAND TOTAL)[:\s]*\$?([\d,]+\.\d{2})"#)
    static let amountFallback = try? NSRegularExpression(pattern: #"\$([\d,]+\.\d{2})"#)
    static let date1 = try? NSRegularExpression(pattern: #"\b(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\b"#)
    static let date2 = try? NSRegularExpression(pattern: #"\b((?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\.?\s+\d{1,2},?\s+\d{2,4})\b"#)
    static let phone = try? NSRegularExpression(pattern: #"\b(?:\+?1[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}\b"#)
    static let address = try? NSRegularExpression(pattern: #"\b\d+\s+[A-Za-z0-9\s]+(?:Street|St|Avenue|Ave|Boulevard|Blvd|Road|Rd|Drive|Dr|Lane|Ln|Way|Court|Ct|Place|Pl|Suite|Ste|Apt)\.?(?:\s*(?:#|Unit|No\.?)\s*\d+)?(?:,?\s*[A-Za-z\s]+,?\s*[A-Z]{2}\s+\d{5}(?:-\d{4})?)?\b"#)

    static func extractAmount(from text: String) -> Double? {
        let range = NSRange(text.startIndex..., in: text)
        if let match = amount?.firstMatch(in: text, range: range),
           let groupRange = Range(match.range(at: 1), in: text) {
            let cleaned = text[groupRange].replacingOccurrences(of: ",", with: "")
            return Double(cleaned)
        }
        if let match = amountFallback?.firstMatch(in: text, range: range),
           let groupRange = Range(match.range(at: 1), in: text) {
            let cleaned = text[groupRange].replacingOccurrences(of: ",", with: "")
            return Double(cleaned)
        }
        return nil
    }

    static func extractDate(from text: String) -> Date? {
        let range = NSRange(text.startIndex..., in: text)
        let formatters: [DateFormatter] = [
            { let f = DateFormatter(); f.dateFormat = "MM/dd/yyyy"; return f }(),
            { let f = DateFormatter(); f.dateFormat = "MM-dd-yyyy"; return f }(),
            { let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"; return f }(),
            { let f = DateFormatter(); f.dateFormat = "MMM dd, yyyy"; return f }(),
            { let f = DateFormatter(); f.dateFormat = "MMMM dd, yyyy"; return f }()
        ]

        for regex in [date1, date2] {
            if let match = regex?.firstMatch(in: text, range: range),
               let groupRange = Range(match.range(at: 1), in: text) {
                let dateStr = String(text[groupRange])
                for formatter in formatters {
                    if let date = formatter.date(from: dateStr) {
                        return date
                    }
                }
            }
        }
        return nil
    }

    static func extractPhone(from text: String) -> String? {
        let range = NSRange(text.startIndex..., in: text)
        if let match = phone?.firstMatch(in: text, range: range),
           let groupRange = Range(match.range(at: 0), in: text) {
            return String(text[groupRange])
        }
        return nil
    }

    static func extractAddress(from text: String) -> String? {
        let range = NSRange(text.startIndex..., in: text)
        if let match = address?.firstMatch(in: text, range: range),
           let groupRange = Range(match.range(at: 0), in: text) {
            return String(text[groupRange])
        }
        return nil
    }
}
