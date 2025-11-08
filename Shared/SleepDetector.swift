import Foundation
import CoreMotion

class SleepDetector: ObservableObject {
    @Published var isSleepDetected = false
    @Published var sleepConfidence: Double = 0.0

    private var heartRateHistory: [Double] = []
    private var motionHistory: [Double] = []
    private let maxHistorySize = 20

    // Sleep detection thresholds
    private let lowHeartRateThreshold: Double = 55 // Typical resting/sleep heart rate
    private let lowMotionThreshold: Double = 0.05 // Very low motion
    private let sleepDetectionThreshold: Double = 0.7 // 70% confidence

    func analyzeHeartRate(_ heartRate: Double) {
        heartRateHistory.append(heartRate)
        if heartRateHistory.count > maxHistorySize {
            heartRateHistory.removeFirst()
        }

        updateSleepConfidence()
    }

    func analyzeMotion(_ motionIntensity: Double) {
        motionHistory.append(motionIntensity)
        if motionHistory.count > maxHistorySize {
            motionHistory.removeFirst()
        }

        updateSleepConfidence()
    }

    private func updateSleepConfidence() {
        var confidence: Double = 0.0

        // Heart rate analysis (50% weight)
        if heartRateHistory.count >= 5 {
            let recentHeartRate = Array(heartRateHistory.suffix(5))
            let avgHeartRate = recentHeartRate.reduce(0.0, +) / Double(recentHeartRate.count)
            let heartRateVariability = calculateVariability(recentHeartRate)

            // Low heart rate with low variability suggests sleep
            if avgHeartRate < lowHeartRateThreshold && heartRateVariability < 5.0 {
                confidence += 0.5
            } else if avgHeartRate < lowHeartRateThreshold + 10 {
                confidence += 0.25
            }
        }

        // Motion analysis (50% weight)
        if motionHistory.count >= 5 {
            let recentMotion = Array(motionHistory.suffix(5))
            let avgMotion = recentMotion.reduce(0.0, +) / Double(recentMotion.count)

            // Very low motion suggests sleep
            if avgMotion < lowMotionThreshold {
                confidence += 0.5
            } else if avgMotion < lowMotionThreshold * 2 {
                confidence += 0.25
            }
        }

        sleepConfidence = confidence
        isSleepDetected = confidence >= sleepDetectionThreshold
    }

    private func calculateVariability(_ values: [Double]) -> Double {
        guard values.count > 1 else { return 0.0 }

        let mean = values.reduce(0.0, +) / Double(values.count)
        let squaredDifferences = values.map { pow($0 - mean, 2) }
        let variance = squaredDifferences.reduce(0.0, +) / Double(values.count)

        return sqrt(variance)
    }

    func reset() {
        heartRateHistory.removeAll()
        motionHistory.removeAll()
        sleepConfidence = 0.0
        isSleepDetected = false
    }
}
