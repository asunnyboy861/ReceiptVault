import SwiftUI
import SwiftData

struct StatsView: View {
    @Query private var receipts: [ReceiptModel]
    @State private var viewModel = StatsViewModel()
    @State private var isShowingExport = false
    @State private var exportData: Data?
    @State private var exportFileName = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker("Period", selection: $viewModel.selectedPeriod) {
                        ForEach(StatsViewModel.Period.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    if !viewModel.currencies.isEmpty {
                        Picker("Currency", selection: $viewModel.selectedCurrency) {
                            Text("All").tag(nil as String?)
                            ForEach(viewModel.currencies, id: \.self) { code in
                                Text(code).tag(code as String?)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal)
                    }

                    summaryCard

                    if !viewModel.monthlyTotals.isEmpty {
                        MonthlyChartView(totals: viewModel.monthlyTotals)
                            .padding(.horizontal)
                    }

                    if !viewModel.categoryTotals.isEmpty {
                        CategoryPieChart(totals: viewModel.categoryTotals)
                            .padding(.horizontal)
                    }

                    if !viewModel.topMerchants.isEmpty {
                        topMerchantsSection
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            exportStats(format: .csv)
                        } label: {
                            Label("Export CSV", systemImage: "doc.text")
                        }
                        Button {
                            exportStats(format: .pdf)
                        } label: {
                            Label("Export PDF", systemImage: "doc.richtext")
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .onChange(of: receipts) { _, newValue in
                viewModel.calculateStats(receipts: newValue)
            }
            .onChange(of: viewModel.selectedPeriod) { _, _ in
                viewModel.calculateStats(receipts: receipts)
            }
            .onChange(of: viewModel.selectedCurrency) { _, _ in
                viewModel.calculateStats(receipts: receipts)
            }
            .onAppear {
                viewModel.calculateStats(receipts: receipts)
            }
            .sheet(isPresented: $isShowingExport) {
                if let data = exportData {
                    ShareSheet(items: [data], fileName: exportFileName)
                }
            }
        }
    }

    private var summaryCard: some View {
        VStack(spacing: 8) {
            Text("Total Spending")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(CurrencyFormatter.format(viewModel.totalSpending, currencyCode: viewModel.selectedCurrency ?? "USD"))
                .font(.title.bold())
                .foregroundStyle(Color.accentColor)
            Text("\(viewModel.receiptCount) receipts")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4)
        .padding(.horizontal)
    }

    private var topMerchantsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Top Merchants")
                .font(.headline)
                .padding(.horizontal)

            ForEach(viewModel.topMerchants.prefix(5)) { merchant in
                HStack {
                    Text(merchant.merchant)
                        .font(.subheadline)
                    Spacer()
                    Text(CurrencyFormatter.format(merchant.total, currencyCode: viewModel.selectedCurrency ?? "USD"))
                        .font(.subheadline.bold())
                    Text("(\(merchant.count)x)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4)
        .padding(.horizontal)
    }

    private func exportStats(format: ReceiptViewModel.ExportFormat) {
        let exportService = ExportService()
        let data: Data?
        switch format {
        case .csv: data = exportService.exportCSV(receipts: receipts)
        case .pdf: data = exportService.exportPDF(receipts: receipts)
        }
        exportData = data
        exportFileName = "ReceiptVault_stats_\(format.rawValue.lowercased())_\(Date().formatted(.dateTime.year().month().day())).\(format.rawValue.lowercased())"
        isShowingExport = true
    }
}
