import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()

    private let healthStore = HKHealthStore()
    @Published var isAuthorized = false
    @Published var currentHeartRate: Double = 0

    private init() {}

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device")
            return
        }

        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let typesToRead: Set<HKObjectType> = [heartRateType]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isAuthorized = success
                if let error = error {
                    print("HealthKit authorization error: \(error.localizedDescription)")
                }
            }
        }
    }

    func startHeartRateQuery(completion: @escaping (Double) -> Void) -> HKQuery? {
        guard isAuthorized else {
            print("HealthKit not authorized")
            return nil
        }

        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

        let query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] query, samples, deletedObjects, anchor, error in
            self?.processHeartRateSamples(samples, completion: completion)
        }

        query.updateHandler = { [weak self] query, samples, deletedObjects, anchor, error in
            self?.processHeartRateSamples(samples, completion: completion)
        }

        healthStore.execute(query)
        return query
    }

    private func processHeartRateSamples(_ samples: [HKSample]?, completion: @escaping (Double) -> Void) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }

        for sample in heartRateSamples {
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            let heartRate = sample.quantity.doubleValue(for: heartRateUnit)

            DispatchQueue.main.async { [weak self] in
                self?.currentHeartRate = heartRate
                completion(heartRate)
            }
        }
    }

    func stopQuery(_ query: HKQuery?) {
        guard let query = query else { return }
        healthStore.stop(query)
    }
}
