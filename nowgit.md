# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | ReceiptVault |
| **Git URL** | git@github.com:asunnyboy861/ReceiptVault.git |
| **Repo URL** | https://github.com/asunnyboy861/ReceiptVault |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/ReceiptVault/ | ✅ Active |
| Support | https://asunnyboy861.github.io/ReceiptVault/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/ReceiptVault/privacy.html | ✅ Active |

## Repository Structure

```
ReceiptVault/
├── ReceiptVault/                    # iOS App Source Code
│   ├── ReceiptVault.xcodeproj/      # Xcode Project
│   ├── ReceiptVault/                # Swift Source Files
│   │   ├── Views/
│   │   ├── Models/
│   │   ├── ViewModels/
│   │   ├── Services/
│   │   ├── Utilities/
│   │   └── ...
│   └── project.yml                  # XcodeGen config
├── docs/                          # Policy Pages (GitHub Pages source)
│   ├── index.html
│   ├── support.html
│   └── privacy.html
├── .github/workflows/
│   └── deploy.yml
├── us.md
├── keytext.md
├── capabilities.md
├── icon.md
├── price.md
└── nowgit.md
```
