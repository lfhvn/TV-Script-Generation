import Foundation
import HealthKit
import CoreMotion
import WatchKit
import AVFoundation

class MonitoringManager: NSObject, ObservableObject {
    @Published var isMonitoring = false
    @Published var currentHeartRate: Double = 0
    @Published var showAlert = false

    private let healthStore = HKHealthStore()
    private let motionManager = CMMotionManager()
    private let sleepDetector = SleepDetector()

    private var heartRateQuery: HKQuery?
    private var alertPlayer: AVAudioPlayer?
    private var lastAlertTime: Date?
    private let alertCooldown: TimeInterval = 30 // Minimum seconds between alerts

    private let connectivityManager = WatchConnectivityManager.shared

    override init() {
        super.init()
        requestHealthKitAuthorization()
        setupAudio()
    }

    private func requestHealthKitAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let typesToRead: Set<HKObjectType> = [heartRateType]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if let error = error {
                print("HealthKit authorization error: \(error.localizedDescription)")
            }
        }
    }

    private func setupAudio() {
        // Configure audio session for alarm playback
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Audio session setup error: \(error.localizedDescription)")
        }
    }

    func startMonitoring() {
        isMonitoring = true
        sleepDetector.reset()
        startHeartRateMonitoring()
        startMotionMonitoring()
        connectivityManager.activateSession()

        // Send status to iPhone
        connectivityManager.updateContext(["isMonitoring": true])

        // Keep the app running in the background
        WKExtension.shared().isAutorotating = false
    }

    func stopMonitoring() {
        isMonitoring = false
        stopHeartRateMonitoring()
        stopMotionMonitoring()

        // Send status to iPhone
        connectivityManager.updateContext(["isMonitoring": false])
    }

    private func startHeartRateMonitoring() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

        let query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] query, samples, deletedObjects, anchor, error in
            self?.processHeartRateSamples(samples)
        }

        query.updateHandler = { [weak self] query, samples, deletedObjects, anchor, error in
            self?.processHeartRateSamples(samples)
        }

        heartRateQuery = query
        healthStore.execute(query)
    }

    private func processHeartRateSamples(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }

        for sample in heartRateSamples {
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            let heartRate = sample.quantity.doubleValue(for: heartRateUnit)

            DispatchQueue.main.async { [weak self] in
                self?.currentHeartRate = heartRate
                self?.sleepDetector.analyzeHeartRate(heartRate)
                self?.checkForSleep()

                // Send to iPhone
                self?.connectivityManager.updateContext(["heartRate": heartRate])
            }
        }
    }

    private func stopHeartRateMonitoring() {
        if let query = heartRateQuery {
            healthStore.stop(query)
            heartRateQuery = nil
        }
    }

    private func startMotionMonitoring() {
        guard motionManager.isAccelerometerAvailable else { return }

        motionManager.accelerometerUpdateInterval = 1.0 / 10.0 // 10 Hz

        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let data = data, error == nil else { return }

            // Calculate motion intensity
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            let magnitude = sqrt(x * x + y * y + z * z)

            self?.sleepDetector.analyzeMotion(magnitude)
            self?.checkForSleep()
        }
    }

    private func stopMotionMonitoring() {
        motionManager.stopAccelerometerUpdates()
    }

    private func checkForSleep() {
        guard isMonitoring else { return }

        if sleepDetector.isSleepDetected {
            triggerAlert()
        }
    }

    private func triggerAlert() {
        // Check cooldown to avoid repeated alerts
        if let lastAlert = lastAlertTime,
           Date().timeIntervalSince(lastAlert) < alertCooldown {
            return
        }

        lastAlertTime = Date()

        DispatchQueue.main.async { [weak self] in
            // Show alert
            self?.showAlert = true

            // Trigger strong haptic feedback multiple times
            for i in 0..<5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                    WKInterfaceDevice.current().play(.notification)
                }
            }

            // Play alarm sound
            self?.playAlarmSound()

            // Keep screen on
            WKExtension.shared().isAutorotating = false

            // Send alert to iPhone
            self?.connectivityManager.sendMessage(["alert": "sleep_detected"])
        }
    }

    private func playAlarmSound() {
        // Create a simple beep using system sounds
        // In a real app, you would include a custom alarm sound file
        AudioServicesPlaySystemSound(1304) // System sound for alarm
    }

    func dismissAlert() {
        showAlert = false
        sleepDetector.reset()
    }
}
