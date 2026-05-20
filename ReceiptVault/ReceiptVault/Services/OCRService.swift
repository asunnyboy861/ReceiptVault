import UIKit
import Vision

@Observable
final class OCRService {
    struct OCRResult {
        var fullText: String = ""
        var merchantName: String = ""
        var amount: Double?
        var date: Date?
        var address: String?
        var phoneNumber: String?
        var lineItems: [String] = []
    }

    func processImages(_ images: [UIImage]) async -> OCRResult {
        var allText = ""
        for image in images {
            if let text = await recognizeText(in: image) {
                allText += text + "\n"
            }
        }
        return extractFields(from: allText)
    }

    private func recognizeText(in image: UIImage) async -> String? {
        guard let cgImage = image.cgImage else { return nil }
        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: nil)
                    return
                }
                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                continuation.resume(returning: text)
            }
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en-US"]
            request.usesLanguageCorrection = true
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(returning: nil)
            }
        }
    }

    private func extractFields(from text: String) -> OCRResult {
        var result = OCRResult()
        result.fullText = text
        let lines = text.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        if let firstLine = lines.first {
            result.merchantName = firstLine.trimmingCharacters(in: .whitespaces)
        }
        result.amount = RegexPatterns.extractAmount(from: text)
        result.date = RegexPatterns.extractDate(from: text)
        result.address = RegexPatterns.extractAddress(from: text)
        result.phoneNumber = RegexPatterns.extractPhone(from: text)
        result.lineItems = extractLineItems(from: lines)
        return result
    }

    private func extractLineItems(from lines: [String]) -> [String] {
        let itemPatterns = ["^[A-Za-z].+\\$?\\d+\\.\\d{2}$", "^[A-Za-z].+\\s+\\d+\\.\\d{2}$"]
        var items: [String] = []
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            for pattern in itemPatterns {
                if let regex = try? NSRegularExpression(pattern: pattern),
                   regex.firstMatch(in: trimmed, range: NSRange(trimmed.startIndex..., in: trimmed)) != nil {
                    items.append(trimmed)
                    break
                }
            }
        }
        return items
    }
}
