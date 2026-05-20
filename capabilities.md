# Capabilities Configuration

## Analysis
Based on operation guide analysis, the following capabilities are required:

| Keyword Found | Capability Required |
|---------------|-------------------|
| "相机" / "拍照" / "camera" / "扫描" | Camera Access |
| "照片" / "相册" | Photo Library Access |
| "Face ID" / "Touch ID" / "生物识别" | Face ID / Biometric Authentication |
| "iCloud" / "同步" (optional in guide) | iCloud (optional, not in MVP) |
| "Widget" / "小组件" | Widget Extension (post-MVP) |

## Auto-Configured Capabilities

| Capability | Status | Method |
|------------|--------|--------|
| Camera Access | ✅ Configured | NSCameraUsageDescription in Info.plist |
| Photo Library Access | ✅ Configured | NSPhotoLibraryUsageDescription in Info.plist |
| Face ID / Biometric Auth | ✅ Configured | NSFaceIDUsageDescription in Info.plist |

## Manual Configuration Required

| Capability | Status | Steps |
|------------|--------|-------|
| None | - | All capabilities auto-configured |

## No Configuration Needed

- Push Notifications: Not required (offline-first app)
- HealthKit: Not applicable
- Location Services: Not required
- Apple Watch: Not in MVP
- Background Modes: Not required
- In-App Purchase: Not required (one-time paid app, no IAP)
- Siri: Not required
- iCloud: Optional feature, not in MVP scope
- Widget: Post-MVP feature

## Info.plist Entries Required

| Key | Value |
|-----|-------|
| NSCameraUsageDescription | "ReceiptVault needs camera access to scan receipts" |
| NSPhotoLibraryUsageDescription | "ReceiptVault needs photo library access to import receipt images" |
| NSFaceIDUsageDescription | "ReceiptVault uses Face ID to protect your receipt data" |

## Verification
- Build succeeded after configuration: Pending
- All entitlements correct: Pending
