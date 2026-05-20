# ReceiptVault - iOS Development Guide

## Executive Summary

**ReceiptVault** is a privacy-first, offline receipt scanner for iOS that eliminates the three biggest pain points in the receipt scanning market: subscription fatigue, privacy concerns, and feature bloat. Unlike competitors that require cloud uploads, monthly subscriptions, or force account creation, ReceiptVault keeps all data on-device using Apple's native Vision framework for OCR, charges a one-time fee of $4.99, and requires zero setup.

**Target Audience**: Freelancers (35%), small business owners (25%), personal finance users (20%), privacy-conscious users (15%), and travelers (5%).

**Key Differentiators**:
- 100% offline — data never leaves the device
- One-time purchase — no subscription, no hidden fees
- Zero-setup — no account needed, scan in 3 seconds
- Apple-native OCR — Vision Framework for maximum accuracy
- Full export freedom — CSV and PDF export included, no paywall

## Competitive Analysis

| App | Price | Strengths | Weaknesses | Our Advantage |
|-----|-------|-----------|------------|---------------|
| Expensify | $5-10/mo subscription | Enterprise features, report generation | Forced cloud, subscription model, complex setup | One-time purchase + fully offline + simple UX |
| Smart Receipts | Subscription | Open source, decent OCR | Free version limits scans, subscription trap | No scan limits, one-time purchase, all features included |
| Adobe Scan | Free + subscription | Adobe ecosystem, good OCR | Cloud OCR, privacy issues, aggressive upselling | Local Vision OCR, data never leaves device |
| Shoeboxed | $4-9/mo subscription | Mail-in scanning, receipt organization | Expensive subscription, data uploaded to cloud | One-time $4.99, completely local storage |
| ReceiptIQ Pro | Subscription + Lite $2.99 one-time | AI OCR, voice input, iCloud sync | Lite version limited to 30 transactions, subscription for full features | No transaction limits, no subscription |
| Receipty | Subscription / batch purchase | AI OCR, PDF/CSV export | Subscription for unlimited, cloud-based | One-time purchase, offline-first |
| Receipto | Free + IAP | 162+ currencies, Magic Email, tax export | Cloud-dependent, subscription for full features | Fully offline, no subscription, one-time purchase |
| Receipt Elite | $30 one-time | iCloud sync, Apple Intelligence totals, tags | Expensive at $30, limited OCR | $4.99 price point, full Vision OCR extraction |

## Feature Inventory

### Primary Features

| # | Feature | User Operation Flow | Data Input | Processing | Data Output | Persistence | Acceptance Criteria |
|---|---------|--------------------|------------|------------|-------------|-------------|---------------------|
| 1 | Receipt Scanning | 1. User taps Scan button → 2. VisionKit camera launches → 3. Auto edge detection frames receipt → 4. User captures → 5. OCR extracts fields | Camera capture of receipt image | VNDocumentCameraViewController → VNRecognizeTextRequest → Regex extraction of amount/date/merchant/category | Scanned receipt with extracted fields displayed in edit form | SwiftData ReceiptModel (image Data, amount, date, merchant, category, address, phone, items) | User can scan a receipt and see auto-extracted amount, date, merchant within 3 seconds |
| 2 | OCR Field Extraction | 1. After scan → 2. System shows extracted fields → 3. User reviews/edits → 4. User taps Save | Recognized text from Vision OCR | Regex patterns for: total amount, date formats, merchant name, address, phone, line items | Pre-filled edit form with all extracted fields | ReceiptModel fields populated | At least amount, date, and merchant are auto-filled with 80%+ accuracy |
| 3 | Receipt List & Search | 1. User opens app → 2. Sees receipt list sorted by date → 3. Types in search bar → 4. Results filter in real-time | Search text query | Search across merchant, amount, category, notes | Filtered receipt list | Query is transient, list from SwiftData | Search returns results within 500ms for 1000+ receipts |
| 4 | Category System | 1. User taps category on receipt → 2. Chooses from preset categories → 3. Or creates custom category → 4. Category saved | Category selection or custom name | Map to CategoryModel, validate uniqueness | Category tag displayed on receipt | CategoryModel (name, color, icon, isCustom) | User can assign preset or custom categories; categories persist across sessions |
| 5 | Statistics Dashboard | 1. User taps Stats tab → 2. Sees monthly/yearly totals → 3. Breakdown by category → 4. Breakdown by merchant | Date range selection, filter criteria | Aggregate ReceiptModel data by period/category/merchant | Charts (bar/pie) and summary numbers | Aggregation is computed, not stored | Dashboard shows accurate totals matching receipt data; updates in real-time |
| 6 | CSV Export | 1. User taps Export → 2. Selects CSV format → 3. Chooses date range/category filter → 4. File generated → 5. ShareLink presents share sheet | Date range, category filter, export format | Filter receipts → map to CSV rows → generate Data | CSV file with headers: Date, Merchant, Amount, Category, Notes | Export is transient | CSV opens correctly in Numbers/Excel with all fields |
| 7 | PDF Export | 1. User taps Export → 2. Selects PDF format → 3. Chooses date range/category filter → 4. File generated → 5. ShareLink presents share sheet | Date range, category filter | Filter receipts → render receipt images + data to PDF pages | PDF file with receipt images and extracted data | Export is transient | PDF contains receipt images and extracted text data |
| 8 | Face ID / Touch ID Lock | 1. User enables in Settings → 2. App locks on background → 3. On foreground, biometric prompt appears → 4. Authenticated → app unlocked | Biometric authentication | LocalAuthentication framework evaluatePolicy | App access granted/denied | UserDefaults isBiometricEnabled | App requires Face ID/Touch ID when enabled; denies access on failure |
| 9 | Multi-Currency Support | 1. User selects currency on receipt → 2. Amount displayed in selected currency → 3. Stats grouped by currency | Currency code selection | Map amount to CurrencyModel, group stats by currency | Amount with currency symbol, stats per currency | ReceiptModel.currencyCode, CurrencyModel | User can assign different currencies; stats group correctly |
| 10 | Duplicate Receipt Detection | 1. User scans receipt → 2. System checks for duplicates → 3. If duplicate found, shows warning → 4. User confirms or cancels | New receipt data | Compare amount+date+merchant against existing receipts | Duplicate warning dialog | Transient check against SwiftData | System warns when scanning a receipt matching existing amount+date+merchant |
| 11 | Data Backup & Restore | 1. User taps Backup in Settings → 2. JSON file generated → 3. ShareLink to save → 4. Restore: select JSON file → 5. Data imported | JSON backup file | Serialize all SwiftData to JSON / Deserialize and insert | Backup file / restored data | JSON file external, SwiftData on restore | Full data round-trip: backup → delete app → restore = same data |
| 12 | Settings | 1. User taps Settings tab → 2. Configure preferences → 3. Changes saved immediately | Toggle selections, text input | Apply settings to UserDefaults/AppStorage | Updated settings UI | UserDefaults / AppStorage | All settings persist and apply immediately |

### Sub-Features & Detail Interactions

| # | Parent Feature | Sub-Feature | Detail Description | Interaction Pattern |
|---|---------------|-------------|-------------------|--------------------|
| 1.1 | Receipt Scanning | Auto edge detection | VisionKit automatically detects receipt edges and highlights with yellow border | Automatic on camera view |
| 1.2 | Receipt Scanning | Multi-page scan | User can scan multiple pages of a long receipt | Tap "Add Page" in scanner |
| 1.3 | Receipt Scanning | Image enhancement | CoreImage auto-corrects perspective, brightness, contrast after capture | Automatic post-capture |
| 2.1 | OCR Field Extraction | Amount extraction | Regex extracts total amount with currency symbol | Automatic, editable in form |
| 2.2 | OCR Field Extraction | Date extraction | Regex extracts date in multiple formats (MM/DD/YYYY, DD/MM/YYYY, etc.) | Automatic, editable in form |
| 2.3 | OCR Field Extraction | Merchant extraction | First line of OCR text treated as merchant name | Automatic, editable in form |
| 2.4 | OCR Field Extraction | Line items extraction | Individual item lines extracted from receipt body | Automatic, shown in detail view |
| 2.5 | OCR Field Extraction | Address & phone extraction | Regex extracts address patterns and phone numbers | Automatic, editable in form |
| 3.1 | Receipt List & Search | Sort options | Sort by date (newest/oldest), amount (high/low), merchant (A-Z) | Tap sort button, select option |
| 3.2 | Receipt List & Search | Filter by category | Show only receipts in selected category | Tap filter chip |
| 3.3 | Receipt List & Search | Filter by date range | Show receipts within date range | Tap date filter, select range |
| 3.4 | Receipt List & Search | Swipe to delete | Swipe left on receipt to reveal delete action | Swipe gesture |
| 4.1 | Category System | Preset categories | Groceries, Dining, Transportation, Shopping, Entertainment, Healthcare, Utilities, Travel, Business, Other | Tap to select from list |
| 4.2 | Category System | Custom category creation | User creates category with name, color, and icon | Tap "+" button, fill form |
| 5.1 | Statistics Dashboard | Monthly summary | Total spending per month with trend indicator | Auto-calculated |
| 5.2 | Statistics Dashboard | Category breakdown | Pie chart showing spending distribution by category | Auto-calculated |
| 5.3 | Statistics Dashboard | Top merchants | List of top 5 merchants by total spending | Auto-calculated |
| 5.4 | Statistics Dashboard | Date range selector | Switch between monthly, quarterly, yearly views | Tap segment control |
| 9.1 | Multi-Currency Support | Currency selection on scan | Default currency pre-filled, user can change | Tap currency field |
| 9.2 | Multi-Currency Support | Per-currency stats | Statistics dashboard groups by currency | Auto-grouped |
| 12.1 | Settings | Default currency | Set default currency for new receipts | Picker selection |
| 12.2 | Settings | Biometric lock toggle | Enable/disable Face ID/Touch ID | Toggle switch |
| 12.3 | Settings | Default category | Set default category for new receipts | Picker selection |
| 12.4 | Settings | Export all data | One-tap backup of all receipt data | Button tap |
| 12.5 | Settings | Import data | Restore from JSON backup file | Button tap, file picker |
| 12.6 | Settings | About & privacy | App version, privacy policy link, support email | Navigation link |

### Cross-Feature Dependencies

| Dependency | Source Feature | Target Feature | Data Passed | Trigger Condition |
|------------|---------------|----------------|-------------|-------------------|
| Scan → List | Receipt Scanning | Receipt List | New ReceiptModel object | User saves scanned receipt |
| Scan → Stats | Receipt Scanning | Statistics Dashboard | New receipt data for aggregation | User saves scanned receipt |
| Category → Stats | Category System | Statistics Dashboard | Category grouping for charts | Category assigned to receipt |
| Currency → Stats | Multi-Currency Support | Statistics Dashboard | Currency grouping for per-currency totals | Currency assigned to receipt |
| Export → Filter | CSV/PDF Export | Receipt List & Search | Date range and category filters applied to export | User selects filters before export |
| Settings → Scan | Settings | Receipt Scanning | Default currency and category | User opens scanner |
| Backup → Restore | Data Backup | Data Restore | JSON file with all data | User selects restore file |
| Duplicate Check | Receipt Scanning | Receipt List | Comparison against existing receipts | Each new scan |

## Apple Design Guidelines Compliance

- **Human Interface Guidelines - Scanning**: Use VNDocumentCameraViewController for system-native scanning experience with auto edge detection
- **Privacy - Camera Usage**: NSCameraUsageDescription in Info.plist explaining camera use for receipt scanning
- **Privacy - Data Minimization**: All data stored on-device only, no cloud transmission, no analytics collection
- **LocalAuthentication**: Use LAContext for Face ID/Touch ID with proper NSFaceIDUsageDescription
- **SwiftUI Best Practices**: Use @Observable macro for ViewModels, SwiftData for persistence, NavigationStack for navigation
- **Accessibility**: VoiceOver labels on all interactive elements, Dynamic Type support, sufficient color contrast
- **HIG - Navigation**: Tab-based navigation with Scan, Receipts, Stats, Settings tabs
- **HIG - Modals**: Scanner presented as full-screen modal, edit form as sheet
- **HIG - Feedback**: Haptic feedback on scan completion, visual confirmation on save

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), UIKit (VisionKit bridge)
- **Data Persistence**: SwiftData with @Model classes
- **OCR Engine**: Vision Framework (VNRecognizeTextRequest)
- **Scanning**: VisionKit (VNDocumentCameraViewController)
- **Biometric Auth**: LocalAuthentication (LAContext)
- **Image Processing**: CoreImage (auto-enhancement)
- **Export**: CSV (custom formatter), PDF (PDFKit)
- **Architecture**: MVVM + Protocol-Oriented Dependency Injection
- **Minimum iOS**: 17.0

## Module Structure

```
ReceiptVault/
├── ReceiptVaultApp.swift
├── Models/
│   ├── ReceiptModel.swift
│   ├── CategoryModel.swift
│   └── CurrencyModel.swift
├── ViewModels/
│   ├── ReceiptViewModel.swift
│   ├── StatsViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Scan/
│   │   ├── ScanView.swift
│   │   ├── ScannerRepresentable.swift
│   │   └── ReceiptEditView.swift
│   ├── Receipts/
│   │   ├── ReceiptListView.swift
│   │   ├── ReceiptRowView.swift
│   │   └── ReceiptDetailView.swift
│   ├── Stats/
│   │   ├── StatsView.swift
│   │   ├── MonthlyChartView.swift
│   │   └── CategoryPieChart.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   └── BackupRestoreView.swift
│   └── Components/
│       ├── SearchBar.swift
│       ├── FilterChips.swift
│       └── EmptyStateView.swift
├── Services/
│   ├── ScanningService.swift
│   ├── OCRService.swift
│   ├── ExportService.swift
│   ├── BiometricService.swift
│   └── BackupService.swift
└── Utilities/
    ├── RegexPatterns.swift
    ├── CurrencyFormatter.swift
    └── Constants.swift
```

## Data Flow Diagram

### Feature 1: Receipt Scanning
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Tap "Scan" button on ScanView                       │
│       │                                                   │
│  Scanner Presentation                                     │
│  └── ScannerRepresentable presents VNDocumentCameraVC     │
│       │                                                   │
│  Image Capture                                            │
│  └── VNDocumentCameraScan → images[] + title              │
│       │                                                   │
│  OCR Processing                                           │
│  └── OCRService.processImages() → VNRecognizeTextRequest  │
│       │                                                   │
│  Field Extraction                                         │
│  └── RegexPatterns extract: amount, date, merchant, etc.  │
│       │                                                   │
│  Edit Form Display                                        │
│  └── ReceiptEditView with pre-filled fields               │
│       │                                                   │
│  Save to Persistence                                      │
│  └── ReceiptViewModel.saveReceipt() → SwiftData insert    │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── ReceiptListView updates, StatsView recalculates      │
└───────────────────────────────────────────────────────────┘
```

### Feature 2: Receipt List & Search
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Type search query or select filter                   │
│       │                                                   │
│  ViewModel Processing                                     │
│  └── ReceiptViewModel applies predicate to SwiftData      │
│       │                                                   │
│  Model/Persistence                                        │
│  └── @Query with #Predicate for filtering and sorting     │
│       │                                                   │
│  Display Output                                           │
│  └── ReceiptListView renders filtered/sorted list         │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── Tap receipt → ReceiptDetailView, Swipe → delete      │
└───────────────────────────────────────────────────────────┘
```

### Feature 3: Statistics Dashboard
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Select date range (monthly/quarterly/yearly)         │
│       │                                                   │
│  ViewModel Processing                                     │
│  └── StatsViewModel aggregates ReceiptModel data          │
│       │                                                   │
│  Model/Persistence                                        │
│  └── @Query fetches all receipts, ViewModel groups them   │
│       │                                                   │
│  Display Output                                           │
│  └── Charts: bar chart (monthly), pie chart (categories)  │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── Tap category → filtered ReceiptListView              │
└───────────────────────────────────────────────────────────┘
```

### Feature 4: CSV/PDF Export
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Tap Export, select format, set filters               │
│       │                                                   │
│  ViewModel Processing                                     │
│  └── ExportService generates CSV or PDF from filtered data│
│       │                                                   │
│  Model/Persistence                                        │
│  └── Read filtered receipts from SwiftData                │
│       │                                                   │
│  Display Output                                           │
│  └── ShareLink presents system share sheet                │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── File saved to Files, emailed, or AirDropped          │
└───────────────────────────────────────────────────────────┘
```

### Feature 5: Face ID / Touch ID Lock
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── App comes to foreground (if biometric enabled)       │
│       │                                                   │
│  ViewModel Processing                                     │
│  └── BiometricService.authenticate() → LAContext          │
│       │                                                   │
│  Model/Persistence                                        │
│  └── AppStorage("isBiometricEnabled") reads setting       │
│       │                                                   │
│  Display Output                                           │
│  └── Biometric prompt overlay, app content hidden         │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── Success → app visible, Failure → locked state        │
└───────────────────────────────────────────────────────────┘
```

### Feature 6: Data Backup & Restore
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Tap Backup or Restore in Settings                    │
│       │                                                   │
│  ViewModel Processing                                     │
│  └── BackupService.serialize/deserialize SwiftData → JSON │
│       │                                                   │
│  Model/Persistence                                        │
│  └── Read all ReceiptModel + CategoryModel → JSON         │
│       │                                                   │
│  Display Output                                           │
│  └── ShareLink (backup) / FilePicker (restore)            │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── Restore triggers ReceiptListView + StatsView refresh │
└───────────────────────────────────────────────────────────┘
```

## Implementation Flow

1. Create Xcode project (iOS 17.0+, SwiftUI, SwiftData)
2. Define SwiftData models (ReceiptModel, CategoryModel, CurrencyModel)
3. Implement Service layer protocols and concrete implementations
4. Build ScannerRepresentable (VisionKit bridge)
5. Implement OCRService with VNRecognizeTextRequest and regex extraction
6. Build ScanView with camera integration and ReceiptEditView
7. Build ReceiptListView with search, filter, sort
8. Build ReceiptDetailView with full receipt information
9. Implement CategoryModel and category management
10. Build StatsView with charts and aggregations
11. Implement ExportService (CSV + PDF generation)
12. Implement BiometricService with LocalAuthentication
13. Build SettingsView with all configuration options
14. Implement BackupService (JSON serialize/deserialize)
15. Add duplicate receipt detection logic
16. Add multi-currency support
17. Polish UI/UX, animations, haptics
18. Test on physical device (camera required)

## UI/UX Design Specifications

- **Color Scheme**: 
  - Primary: Deep navy (#1A1F36) — trust and security
  - Accent: Emerald green (#10B981) — money/finance association
  - Background: Off-white (#F8FAFC) — clean, paper-like
  - Card: White (#FFFFFF) with subtle shadow
  - Text: Dark gray (#1E293B) primary, medium gray (#64748B) secondary
  - Danger: Red (#EF4444) for delete actions
- **Typography**: 
  - SF Pro Display for headings (Large Title, Title 2)
  - SF Pro Text for body (Body, Callout, Caption)
  - Monospaced for amounts and numbers
- **Layout**: 
  - 4-tab bottom navigation: Scan (camera icon), Receipts (list icon), Stats (chart icon), Settings (gear icon)
  - Card-based receipt list with thumbnail, merchant, amount, date, category chip
  - Floating scan button on Receipts tab for quick access
  - Consistent 16pt horizontal padding, 12pt vertical spacing
- **Animations**: 
  - Scan completion: success checkmark with spring animation
  - List transitions: slide-in for new receipts
  - Tab transitions: cross-dissolve
  - Delete: swipe-to-delete with fade-out
- **Haptics**: 
  - UIImpactFeedbackGenerator on scan capture
  - UINotificationFeedbackGenerator on save success/failure

## Code Generation Rules

- One feature per module, high cohesion, low coupling
- Semantic naming, clear file structure
- Never add comments in code unless asked
- Apple native first: prioritize SwiftUI, SwiftData, Vision, VisionKit
- Protocol-Oriented DI for all services
- @Observable macro for ViewModels (iOS 17+)
- SwiftData @Model for all persistent data
- No third-party dependencies unless absolutely necessary
- All strings localizable (NSLocalizedString ready)
- Accessibility: VoiceOver labels, Dynamic Type support

## Build & Deployment Checklist

1. Verify Xcode project builds without errors
2. Test on iPhone simulator (all layouts)
3. Test on physical device (camera, Face ID)
4. Verify all Info.plist keys (NSCameraUsageDescription, NSFaceIDUsageDescription)
5. Test CSV export opens in Numbers/Excel
6. Test PDF export renders correctly
7. Test backup/restore round-trip
8. Test biometric lock enable/disable
9. Verify SwiftData migration path
10. Test with 1000+ receipts for performance
11. App Store Connect metadata prepared
12. Privacy policy page deployed
