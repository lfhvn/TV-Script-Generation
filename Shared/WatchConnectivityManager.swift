import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()

    @Published var isWatchActive = false
    @Published var lastHeartRate: Double = 0
    @Published var isMonitoring = false

    private override init() {
        super.init()
    }

    func activateSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func sendMessage(_ message: [String: Any]) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }

        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }

    func updateContext(_ context: [String: Any]) {
        do {
            try WCSession.default.updateApplicationContext(context)
        } catch {
            print("Error updating context: \(error.localizedDescription)")
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.isWatchActive = activationState == .activated
        }

        if let error = error {
            print("WCSession activation error: \(error.localizedDescription)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            if let heartRate = message["heartRate"] as? Double {
                self?.lastHeartRate = heartRate
            }
            if let monitoring = message["isMonitoring"] as? Bool {
                self?.isMonitoring = monitoring
            }
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            if let heartRate = applicationContext["heartRate"] as? Double {
                self?.lastHeartRate = heartRate
            }
            if let monitoring = applicationContext["isMonitoring"] as? Bool {
                self?.isMonitoring = monitoring
            }
        }
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("Session deactivated")
        session.activate()
    }
    #endif
}
