import SwiftUI
import WatchKit

struct WatchContentView: View {
    @EnvironmentObject var monitoringManager: MonitoringManager
    @State private var showingAlert = false

    var body: some View {
        VStack(spacing: 15) {
            // Status Icon
            ZStack {
                Circle()
                    .fill(monitoringManager.isMonitoring ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)

                Image(systemName: monitoringManager.isMonitoring ? "eye.fill" : "eye.slash.fill")
                    .font(.system(size: 35))
                    .foregroundColor(monitoringManager.isMonitoring ? .green : .gray)
            }

            // Status Text
            Text(monitoringManager.isMonitoring ? "Monitoring" : "Stopped")
                .font(.headline)
                .foregroundColor(monitoringManager.isMonitoring ? .green : .gray)

            // Heart Rate Display
            if monitoringManager.isMonitoring {
                HStack(spacing: 5) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.caption)

                    Text("\(Int(monitoringManager.currentHeartRate)) BPM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Control Button
            Button(action: {
                if monitoringManager.isMonitoring {
                    monitoringManager.stopMonitoring()
                } else {
                    monitoringManager.startMonitoring()
                }
            }) {
                Text(monitoringManager.isMonitoring ? "Stop" : "Start")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(monitoringManager.isMonitoring ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .alert("WAKE UP!", isPresented: $monitoringManager.showAlert) {
            Button("I'm Awake", role: .cancel) {
                monitoringManager.dismissAlert()
            }
        } message: {
            Text("Sleep detected! Stay alert!")
        }
        .onChange(of: monitoringManager.showAlert) { _, newValue in
            if newValue {
                // Trigger haptic feedback
                WKInterfaceDevice.current().play(.notification)
            }
        }
    }
}

#Preview {
    WatchContentView()
        .environmentObject(MonitoringManager())
}
