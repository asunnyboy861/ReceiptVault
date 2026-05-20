import SwiftUI

struct CategoryPieChart: View {
    let totals: [StatsViewModel.CategoryTotal]

    private var total: Double {
        totals.reduce(0) { $0 + $1.total }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("By Category")
                .font(.headline)

            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                HStack(spacing: 16) {
                    ZStack {
                        ForEach(Array(sliceData().enumerated()), id: \.offset) { index, slice in
                            Circle()
                                .trim(from: slice.start, to: slice.end)
                                .fill(Color(hex: slice.colorHex))
                                .frame(width: size * 0.45, height: size * 0.45)
                                .rotationEffect(.degrees(-90))
                        }
                    }
                    .frame(width: size * 0.5, height: size * 0.5)

                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(totals.prefix(6)) { item in
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color(hex: item.colorHex))
                                    .frame(width: 10, height: 10)
                                Text(item.category)
                                    .font(.caption)
                                Spacer()
                                Text("\(Int((item.total / total) * 100))%")
                                    .font(.caption.bold())
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 140)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4)
    }

    private struct SliceData {
        let start: CGFloat
        let end: CGFloat
        let colorHex: String
    }

    private func sliceData() -> [SliceData] {
        var slices: [SliceData] = []
        var currentAngle: CGFloat = 0
        for item in totals {
            let fraction = CGFloat(item.total / total)
            let startAngle = currentAngle
            currentAngle += fraction * 2 * .pi
            slices.append(SliceData(start: startAngle / (2 * .pi), end: currentAngle / (2 * .pi), colorHex: item.colorHex))
        }
        return slices
    }
}
