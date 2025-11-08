import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    @State private var isMonitoring: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: isMonitoring ? "eye.fill" : "eye.slash.fill")
                        .font(.system(size: 80))
                        .foregroundColor(isMonitoring ? .green : .gray)

                    Text(isMonitoring ? "Monitoring Active" : "Monitoring Inactive")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.top, 40)

                // Status Card
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "applewatch.watchface")
                        Text("Apple Watch")
                            .fontWeight(.medium)
                    }

                    Divider()

                    StatusRow(icon: "heart.fill", label: "Heart Rate", value: connectivityManager.lastHeartRate > 0 ? "\(Int(connectivityManager.lastHeartRate)) BPM" : "N/A")

                    StatusRow(icon: "waveform.path.ecg", label: "Motion", value: connectivityManager.isWatchActive ? "Active" : "Inactive")

                    StatusRow(icon: "bell.fill", label: "Alerts", value: "Enabled")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)

                Spacer()

                // Information
                VStack(alignment: .leading, spacing: 10) {
                    Label("Start monitoring on your Apple Watch", systemImage: "info.circle")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("The app uses heart rate and motion data to detect when you're falling asleep and will alert you immediately.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationTitle("StayAwake")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct StatusRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 25)
            Text(label)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .font(.subheadline)
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthKitManager.shared)
        .environmentObject(WatchConnectivityManager.shared)
}
