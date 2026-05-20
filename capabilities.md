# ReceiptVault — 配置文档

生成时间：2026-05-20

---

## 一、⚠️ 手动配置（需你操作才能生效）

> ✅ 当前软件功能完整，无需手动配置即可使用。
>
> 💡 提示：App Store Connect 中创建应用后，需将 `keytext.md` 中的元数据填入对应字段，并将 `docs/index.html` 中的 `[APP_STORE_ID]` 替换为 Apple 分配的 App ID。

---

## 二、✅ 自动配置记录（已由系统完成，无需操作）

### Capabilities 自动配置

| Capability | 说明 | 状态 |
|------------|------|------|
| Camera Access | NSCameraUsageDescription 已在 Info.plist 配置 | ✅ 已配置 |
| Photo Library Access | NSPhotoLibraryUsageDescription 已在 Info.plist 配置 | ✅ 已配置 |
| Face ID / Biometric Auth | NSFaceIDUsageDescription 已在 Info.plist 配置 | ✅ 已配置 |

### 后端服务

| 服务 | 说明 | 状态 |
|------|------|------|
| 联系客服后端 | Cloudflare Workers 部署，地址：`https://feedback-board.iocompile67692.workers.dev` | ✅ 已部署 |
| NSAppTransportSecurity | 允许HTTPS出站连接，已在Info.plist配置 | ✅ 已配置 |

### 代码生成

| 模块 | 说明 | 状态 |
|------|------|------|
| 核心功能 | MVVM架构，SwiftData持久化，所有12个功能模块已生成 | ✅ 已完成 |
| ContactSupportView | 7主题选择、API对接、网络权限 | ✅ 已完成 |
| SettingsView | 政策页面链接、客服入口、生物识别开关 | ✅ 已完成 |
| OCRService | Vision Framework OCR 文字提取 | ✅ 已完成 |
| ScanningService | VisionKit 文档扫描 | ✅ 已完成 |
| ExportService | CSV/PDF 导出 | ✅ 已完成 |
| BackupService | JSON 备份与恢复 | ✅ 已完成 |
| BiometricService | Face ID/Touch ID 认证 | ✅ 已完成 |
| ReceiptViewModel | 收据管理、重复检测 | ✅ 已完成 |
| StatsViewModel | 统计数据聚合 | ✅ 已完成 |
| SettingsViewModel | 设置管理、货币配置 | ✅ 已完成 |

### 部署

| 项目 | 说明 | 状态 |
|------|------|------|
| GitHub仓库 | https://github.com/asunnyboy861/ReceiptVault | ✅ 已完成 |
| GitHub Pages | 政策页面已部署 | ✅ 已完成 |
| Landing Page | https://asunnyboy861.github.io/ReceiptVault/ （App Store ID为占位符） | ✅ 已完成 |
| Support Page | https://asunnyboy861.github.io/ReceiptVault/support.html | ✅ 已完成 |
| Privacy Page | https://asunnyboy861.github.io/ReceiptVault/privacy.html | ✅ 已完成 |
| App Store元数据 | keytext.md已生成验证 | ✅ 已完成 |
| 定价配置 | price.md已生成（$4.99 一次性购买） | ✅ 已完成 |

---

## 三、能力检测详情

### Analysis

Based on operation guide analysis, the following capabilities are required:

| Keyword Found | Capability Required |
|---------------|-------------------|
| "相机" / "拍照" / "camera" / "扫描" | Camera Access |
| "照片" / "相册" | Photo Library Access |
| "Face ID" / "Touch ID" / "生物识别" | Face ID / Biometric Authentication |
| "iCloud" / "同步" (optional in guide) | iCloud (optional, not in MVP) |
| "Widget" / "小组件" | Widget Extension (post-MVP) |

### No Configuration Needed

- Push Notifications: Not required (offline-first app)
- HealthKit: Not applicable
- Location Services: Not required
- Apple Watch: Not in MVP
- Background Modes: Not required
- In-App Purchase: Not required (one-time paid app, no IAP)
- Siri: Not required
- iCloud: Optional feature, not in MVP scope
- Widget: Post-MVP feature

### Verification

- Build succeeded on iPhone 16 simulator: ✅
- Build succeeded on iPad Pro 13-inch (M4) simulator: ✅
- Security check passed (no secrets in code): ✅
- All entitlements correct: ✅
