import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "doc.text.viewfinder")
                }
                .tag(0)

            ReceiptListView()
                .tabItem {
                    Label("Receipts", systemImage: "list.bullet.rectangle")
                }
                .tag(1)

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.pie")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(3)
        }
        .tint(Color(hex: "10B981"))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [ReceiptModel.self, CategoryModel.self])
}
