import Foundation

enum Constants {
    static let bundlePrefix = "com.zzoutuo."
    static let appName = "ReceiptVault"
    static let defaultCurrency = "USD"
    static let defaultCategory = "Other"
    static let feedbackBackendURL = "https://feedback-board.iocompile67692.workers.dev"
    static let githubUser = "asunnyboy861"
    static let contactEmail = "iocompile67692@gmail.com"

    enum Color {
        static let primaryHex = "1A1F36"
        static let accentHex = "10B981"
        static let backgroundHex = "F8FAFC"
        static let cardHex = "FFFFFF"
        static let textPrimaryHex = "1E293B"
        static let textSecondaryHex = "64748B"
        static let dangerHex = "EF4444"
    }

    enum Subject: String, CaseIterable, Identifiable {
        case general = "General"
        case featureSuggestion = "Feature Suggestion"
        case bugReport = "Bug Report"
        case usageQuestion = "Usage Question"
        case performanceIssue = "Performance Issue"
        case uiImprovement = "UI Improvement"
        case other = "Other"

        var id: String { rawValue }
    }
}
