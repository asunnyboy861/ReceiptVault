import SwiftUI
import SwiftData

struct ReceiptListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ReceiptModel.date, order: .reverse) private var allReceipts: [ReceiptModel]
    @State private var viewModel = ReceiptViewModel()
    @State private var isShowingExport = false
    @State private var exportData: Data?
    @State private var exportFileName = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)

                FilterChips(
                    categories: viewModel.categories,
                    selectedCategory: $viewModel.filterCategory,
                    startDate: $viewModel.filterStartDate,
                    endDate: $viewModel.filterEndDate
                )
                .padding(.horizontal)
                .padding(.top, 4)

                if viewModel.filteredReceipts.isEmpty {
                    EmptyStateView(
                        title: "No Receipts Yet",
                        subtitle: "Scan your first receipt to get started",
                        systemImage: "doc.text.viewfinder"
                    )
                } else {
                    List {
                        ForEach(viewModel.filteredReceipts) { receipt in
                            NavigationLink {
                                ReceiptDetailView(receipt: receipt)
                                    .environment(\.modelContext, modelContext)
                            } label: {
                                ReceiptRowView(receipt: receipt)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.deleteReceipt(receipt, context: modelContext)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Receipts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $viewModel.sortOption) {
                            ForEach(ReceiptViewModel.SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        Button {
                            exportReceipts(format: .csv)
                        } label: {
                            Label("Export CSV", systemImage: "doc.text")
                        }
                        Button {
                            exportReceipts(format: .pdf)
                        } label: {
                            Label("Export PDF", systemImage: "doc.richtext")
                        }
                        if viewModel.filterCategory != nil || viewModel.filterStartDate != nil {
                            Button {
                                viewModel.clearFilters()
                            } label: {
                                Label("Clear Filters", systemImage: "xmark.circle")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .onChange(of: allReceipts) { _, newValue in
                viewModel.receipts = newValue
            }
            .onAppear {
                viewModel.receipts = allReceipts
            }
            .sheet(isPresented: $isShowingExport) {
                if let data = exportData {
                    ShareSheet(items: [data], fileName: exportFileName)
                }
            }
        }
    }

    private func exportReceipts(format: ReceiptViewModel.ExportFormat) {
        let data = viewModel.exportReceipts(format: format, receipts: viewModel.filteredReceipts)
        exportData = data
        exportFileName = "ReceiptVault_\(format.rawValue.lowercased())_\(Date().formatted(.dateTime.year().month().day())).\(format.rawValue.lowercased())"
        isShowingExport = true
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    let fileName: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
