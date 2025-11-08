import SwiftUI

@main
struct StayAwakeWatchApp: App {
    @StateObject private var monitoringManager = MonitoringManager()

    var body: some Scene {
        WindowGroup {
            WatchContentView()
                .environmentObject(monitoringManager)
        }
    }
}
