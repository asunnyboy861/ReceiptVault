# Pricing Configuration

## Monetization Model: Paid Download

- **Price**: $4.99 (One-time purchase)
- **IAP**: Not required
- **Subscription**: None

## Rationale

The Chinese guide explicitly states:
- "一次性买断" (one-time purchase) — no subscription
- "$4.99" price point — competitive vs Expensify ($5-10/mo), Shoeboxed ($4-9/mo), Receipt Elite ($30)
- "No subscription, no hidden fees" — core differentiator
- All features included — no paywall, no premium tier

## App Store Connect Pricing

- **Price Tier**: Tier 4 = $4.99
- **App Store Name**: ReceiptVault - Private Scanner
- **Subtitle**: Offline OCR · No Cloud · No Sub

## Policy Pages Required

- Support Page: ✅
- Privacy Policy: ✅
- Terms of Use: ❌ (Not needed for paid download apps — Apple EULA applies)

## Policy Pages Count: 2

## No IAP Implementation Needed

Since this is a one-time paid download app:
- No StoreKit 2 integration required
- No PurchaseManager needed
- No Paywall UI needed
- No Restore Purchases button needed
- No subscription management UI needed

## Competitive Pricing Comparison

| App | Price | Model | ReceiptVault Advantage |
|-----|-------|-------|----------------------|
| Expensify | $5-10/mo | Subscription | One-time $4.99 vs monthly fee |
| Smart Receipts | Subscription | Subscription | No scan limits, all features included |
| Adobe Scan | Free + subscription | Freemium | No subscription, full features |
| Shoeboxed | $4-9/mo | Subscription | One-time vs ongoing cost |
| ReceiptIQ Lite | $2.99 one-time | Paid (30 tx limit) | No transaction limits |
| Receipt Elite | $30 one-time | Paid | 6x cheaper, more features |
| Receipto | Free + IAP | Freemium | No hidden costs, full features |
