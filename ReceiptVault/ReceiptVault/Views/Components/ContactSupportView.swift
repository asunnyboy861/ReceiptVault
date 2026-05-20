import SwiftUI

struct ContactSupportView: View {
    @State private var subject: Constants.Subject = .general
    @State private var message = ""
    @State private var isSending = false
    @State private var showSuccess = false
    @State private var showError = false

    var body: some View {
        Form {
            Section {
                Picker("Subject", selection: $subject) {
                    ForEach(Constants.Subject.allCases) { s in
                        Text(s.rawValue).tag(s)
                    }
                }
            }

            Section {
                TextField("Message", text: $message, axis: .vertical)
                    .lineLimit(5...12)
            }

            Section {
                Button {
                    sendFeedback()
                } label: {
                    HStack {
                        Spacer()
                        if isSending {
                            ProgressView()
                        } else {
                            Text("Send Feedback")
                                .bold()
                        }
                        Spacer()
                    }
                }
                .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
            }

            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Or email us directly")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button {
                        if let url = URL(string: "mailto:\(Constants.contactEmail)?subject=ReceiptVault%20Support") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text(Constants.contactEmail)
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .navigationTitle("Contact Support")
        .alert("Feedback Sent", isPresented: $showSuccess) {
            Button("OK") {
                message = ""
            }
        } message: {
            Text("Thank you for your feedback! We will review it as soon as possible.")
        }
        .alert("Send Failed", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text("Could not send feedback. Please try again or email us directly.")
        }
    }

    private func sendFeedback() {
        isSending = true
        let payload: [String: String] = [
            "app": Constants.appName,
            "subject": subject.rawValue,
            "message": message,
            "platform": "iOS \(UIDevice.current.systemVersion)",
            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: payload) else {
            isSending = false
            showError = true
            return
        }
        var request = URLRequest(url: URL(string: Constants.feedbackBackendURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSending = false
                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    showSuccess = true
                } else {
                    showError = true
                }
            }
        }.resume()
    }
}
