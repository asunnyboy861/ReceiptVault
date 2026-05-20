import SwiftUI

struct MonthlyChartView: View {
    let totals: [StatsViewModel.MonthlyTotal]

    private var maxTotal: Double {
        totals.map(\.total).max() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Spending Trend")
                .font(.headline)

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(totals.prefix(6).reversed()) { item in
                    VStack {
                        Spacer(minLength: 0)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.accentColor)
                            .frame(height: max(4, CGFloat(item.total / maxTotal) * 120))
                        Text(item.month)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 160)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}
