import SwiftUI

struct FilterChips: View {
    let categories: [String]
    @Binding var selectedCategory: String?
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @State private var showDatePicker = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if selectedCategory != nil || startDate != nil {
                    Button {
                        selectedCategory = nil
                        startDate = nil
                        endDate = nil
                    } label: {
                        Label("Clear", systemImage: "xmark")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.red.opacity(0.15))
                            .foregroundStyle(.red)
                            .clipShape(Capsule())
                    }
                }

                ForEach(categories, id: \.self) { category in
                    Button {
                        selectedCategory = selectedCategory == category ? nil : category
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: categoryIcon(for: category))
                                .font(.caption2)
                            Text(category)
                                .font(.caption)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(selectedCategory == category ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                        .foregroundStyle(selectedCategory == category ? Color.accentColor : .primary)
                        .clipShape(Capsule())
                    }
                }

                Button {
                    showDatePicker = true
                } label: {
                    Label("Date", systemImage: "calendar")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(startDate != nil ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                        .foregroundStyle(startDate != nil ? Color.accentColor : .primary)
                        .clipShape(Capsule())
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            NavigationStack {
                VStack {
                    DatePicker("From", selection: Binding(
                        get: { startDate ?? Date() },
                        set: { startDate = $0 }
                    ), displayedComponents: .date)
                    .padding(.horizontal)

                    DatePicker("To", selection: Binding(
                        get: { endDate ?? Date() },
                        set: { endDate = $0 }
                    ), displayedComponents: .date)
                    .padding(.horizontal)

                    Spacer()
                }
                .navigationTitle("Filter by Date")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { showDatePicker = false }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Clear") {
                            startDate = nil
                            endDate = nil
                            showDatePicker = false
                        }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }

    private func categoryIcon(for name: String) -> String {
        CategoryModel.presets.first { $0.name == name }?.iconName ?? "doc.fill"
    }
}
