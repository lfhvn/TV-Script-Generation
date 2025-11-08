import SwiftUI

@main
struct StayAwakeApp: App {
    @StateObject private var healthKitManager = HealthKitManager.shared
    @StateObject private var connectivityManager = WatchConnectivityManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager)
                .environmentObject(connectivityManager)
                .onAppear {
                    // Request necessary permissions
                    healthKitManager.requestAuthorization()
                    connectivityManager.activateSession()
                }
        }
    }
}
