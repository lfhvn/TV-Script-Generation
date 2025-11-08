# StayAwake - Architecture Documentation

This document explains the technical architecture and design decisions for the StayAwake sleep detection app.

## System Architecture

### Overview

```
┌─────────────────────────────────────────────────────────────┐
│                         iPhone App                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  ContentView                                        │   │
│  │  - Display monitoring status                        │   │
│  │  - Show heart rate and motion data                  │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│                          ▼                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  WatchConnectivityManager                           │   │
│  │  - Receive data from Watch                          │   │
│  │  - Send commands to Watch                           │   │
│  └─────────────────────────────────────────────────────┘   │
└──────────────────────────┬──────────────────────────────────┘
                           │ WatchConnectivity
                           │ (Bluetooth)
┌──────────────────────────▼──────────────────────────────────┐
│                      Apple Watch App                        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  WatchContentView                                   │   │
│  │  - Start/Stop monitoring                            │   │
│  │  - Display real-time heart rate                     │   │
│  │  - Show alerts                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│                          ▼                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  MonitoringManager                                  │   │
│  │  - Coordinate monitoring lifecycle                  │   │
│  │  - Trigger alerts                                   │   │
│  │  - Manage haptics and sounds                        │   │
│  └─────────────────────────────────────────────────────┘   │
│           │                    │                            │
│           ▼                    ▼                            │
│  ┌─────────────────┐  ┌──────────────────────────────┐    │
│  │  HealthKit      │  │  CoreMotion                  │    │
│  │  Manager        │  │  Manager                     │    │
│  │  - Heart rate   │  │  - Accelerometer data        │    │
│  └─────────────────┘  └──────────────────────────────┘    │
│           │                    │                            │
│           └────────┬───────────┘                            │
│                    ▼                                        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  SleepDetector                                      │   │
│  │  - Analyze heart rate patterns                      │   │
│  │  - Analyze motion patterns                          │   │
│  │  - Calculate sleep confidence                       │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Core Components

### 1. HealthKitManager (Shared)

**Purpose**: Interface with Apple's HealthKit framework to access heart rate data.

**Key Features**:
- Request HealthKit authorization
- Create continuous heart rate queries
- Process heart rate samples in real-time
- Thread-safe data updates

**Implementation Details**:
```swift
// Uses HKAnchoredObjectQuery for real-time heart rate streaming
// Updates every time a new heart rate sample is available (typically every 5 seconds)
// Converts HKQuantitySample to BPM (beats per minute)
```

**Why this approach**:
- `HKAnchoredObjectQuery` provides continuous updates without polling
- Efficient battery usage compared to repeated queries
- Receives data as soon as watch generates it

### 2. WatchConnectivityManager (Shared)

**Purpose**: Handle communication between iPhone and Apple Watch.

**Key Features**:
- Bi-directional message passing
- Application context updates (background data sync)
- Session lifecycle management
- Platform-specific delegate methods

**Communication Patterns**:
- **sendMessage()**: For urgent, immediate messages (requires both devices reachable)
- **updateApplicationContext()**: For non-urgent state sync (works even when not reachable)

**Data Synchronized**:
- Heart rate values
- Monitoring status (on/off)
- Alert notifications

### 3. SleepDetector (Shared)

**Purpose**: Analyze physiological data to detect sleep onset.

**Algorithm**:

#### Heart Rate Analysis (50% weight):
```swift
// Collects last 20 heart rate readings
// Analyzes recent 5 readings for:
1. Average heart rate < 55 BPM (configurable)
2. Low heart rate variability < 5 BPM (consistent rhythm)
3. Sustained low heart rate over time
```

#### Motion Analysis (50% weight):
```swift
// Collects last 20 motion samples at 10 Hz
// Analyzes recent 5 samples for:
1. Motion magnitude < 0.05 (very little movement)
2. Sustained low motion over time
```

#### Sleep Confidence Calculation:
```swift
confidence = heartRateScore (0-0.5) + motionScore (0-0.5)

if confidence >= 0.7:  // 70% threshold
    trigger_alert()
```

**Why this algorithm**:
- **Heart Rate**: Drops 10-30% during sleep onset
- **Motion**: Minimal during sleep, increases when awake
- **Combined**: More reliable than either metric alone
- **History-based**: Reduces false positives from momentary stillness
- **Lightweight**: Simple calculations, minimal CPU/battery impact

### 4. MonitoringManager (Watch App)

**Purpose**: Orchestrate the monitoring process on Apple Watch.

**Responsibilities**:

1. **Lifecycle Management**:
   - Start/stop monitoring sessions
   - Initialize sensors
   - Clean up resources

2. **Data Collection**:
   - Query heart rate from HealthKit
   - Poll accelerometer from CoreMotion
   - Feed data to SleepDetector

3. **Alert System**:
   - Detect sleep based on SleepDetector confidence
   - Trigger multi-modal alerts:
     - Haptic feedback (5 strong vibrations)
     - System sound (alarm tone)
     - Visual alert (full-screen dialog)
   - Implement alert cooldown (30 seconds)

4. **Background Execution**:
   - Keep app active during monitoring
   - Prevent auto-sleep of watch display

**Alert Cooldown**:
```swift
// Prevents alert fatigue
// If sleep persists, alerts every 30 seconds
// User must acknowledge to reset
```

### 5. WatchContentView (Watch App)

**Purpose**: User interface for Apple Watch.

**Features**:
- Large, glanceable status indicator
- Real-time heart rate display
- Single-tap start/stop control
- Full-screen sleep alert

**Design Principles**:
- **Glanceable**: Status visible at a glance
- **Simple**: One primary action (start/stop)
- **Accessible**: Large touch targets
- **Informative**: Shows heart rate when monitoring

### 6. ContentView (iOS App)

**Purpose**: Companion interface on iPhone.

**Features**:
- Monitoring status display
- Real-time heart rate from Watch
- Motion activity indicator
- Information about the app

**Role**:
- Monitoring happens on Watch
- iPhone app is for status and backup alerts
- Can receive alert notifications from Watch

## Data Flow

### Monitoring Session Flow

```
1. User taps "Start" on Watch
   ↓
2. MonitoringManager.startMonitoring()
   ↓
3. Request HealthKit & CoreMotion data
   ↓
4. [Every 5s] New heart rate sample received
   ↓
5. [Every 0.1s] New motion sample received
   ↓
6. Feed samples to SleepDetector
   ↓
7. SleepDetector calculates confidence
   ↓
8. If confidence >= 70%: trigger alert
   ↓
9. Alert: Haptics + Sound + Visual
   ↓
10. User acknowledges → reset detector
```

### iPhone-Watch Communication

```
Watch                          iPhone
  │                              │
  ├──[start monitoring]──────────>│
  │                              │
  ├──[heart rate: 65]────────────>│
  │                              │
  ├──[heart rate: 58]────────────>│
  │                              │
  ├──[sleep detected!]───────────>│
  │                              │
  │<───────[acknowledged]─────────┤
  │                              │
```

## Sleep Detection Algorithm

### Scientific Basis

The algorithm is based on known physiological changes during sleep onset:

1. **Heart Rate Decrease**:
   - Awake resting: 60-100 BPM
   - Sleep onset: 10-30% decrease
   - Deep sleep: 40-50 BPM possible

2. **Reduced Heart Rate Variability**:
   - Awake: Variable heart rate (breathing, thoughts)
   - Sleep: More consistent rhythm

3. **Minimal Movement**:
   - Awake: Constant micro-movements
   - Sleep onset: Stillness
   - Sleep: Only occasional position changes

### Parameters (Tunable)

```swift
// In SleepDetector.swift
lowHeartRateThreshold: 55      // BPM threshold for "low" heart rate
lowMotionThreshold: 0.05       // Magnitude threshold for "low" motion
sleepDetectionThreshold: 0.7   // Confidence threshold (0-1)
maxHistorySize: 20             // Samples to keep in history
```

### Sensitivity Tuning

**More Sensitive** (detect earlier):
- Increase `lowHeartRateThreshold` to 60-65 BPM
- Increase `lowMotionThreshold` to 0.1
- Decrease `sleepDetectionThreshold` to 0.5-0.6

**Less Sensitive** (fewer false positives):
- Decrease `lowHeartRateThreshold` to 50 BPM
- Decrease `lowMotionThreshold` to 0.03
- Increase `sleepDetectionThreshold` to 0.8-0.9

## Performance Considerations

### Battery Life

**Estimated Impact**:
- Heart rate monitoring: ~2-3% per hour (leverages existing Watch monitoring)
- Motion monitoring: ~2-3% per hour (low 10 Hz sample rate)
- Background processing: ~1-2% per hour
- Workout session overhead: ~1-2% per hour
- **Total**: ~5-10% battery per hour of monitoring

**With these estimates, you can monitor for 10-20 hours on a full charge.**

**Optimization Strategies**:
- Use HKAnchoredObjectQuery (no polling, event-driven)
- Low motion sample rate (10 Hz, not 50-100 Hz)
- Use workout session for efficient background execution
- Process data in batches
- No data storage or logging
- Screen can sleep normally (doesn't need to stay on)

### CPU Usage

- Minimal: Only simple calculations
- No machine learning models
- No complex signal processing
- Real-time processing (no buffering delays)

### Memory Usage

- Small footprint (~20 samples × 2 metrics)
- No persistent storage
- Automatic cleanup when monitoring stops

## Privacy & Security

### Data Handling

**What's Collected**:
- Heart rate (BPM values only)
- Motion magnitude (not raw accelerometer)

**What's NOT Collected**:
- No data stored to disk
- No cloud uploads
- No analytics or telemetry
- No user identification

**Data Lifecycle**:
1. Sensor → In-memory processing
2. Sleep detection analysis
3. Data discarded immediately
4. History cleared on stop

### Permissions

**Required**:
- HealthKit (heart rate read-only)
- Motion & Fitness (accelerometer read-only)
- Notifications (alert delivery)

**Not Required**:
- Location
- Contacts
- Camera/Microphone
- Network access

## Future Enhancements

### Potential Improvements

1. **Machine Learning**:
   - Train on user's personal sleep patterns
   - Improve accuracy over time
   - Personalized thresholds

2. **Additional Sensors**:
   - Blood oxygen (SpO2)
   - Respiratory rate
   - Wrist temperature

3. **Alert Customization**:
   - Custom alarm sounds
   - Vibration patterns
   - Alert escalation

4. **Analytics** (privacy-preserving):
   - Daily sleep attempt tracking
   - Most vulnerable times
   - Effectiveness metrics

5. **Integration**:
   - Health app export
   - Complication support
   - Shortcuts integration

## Testing Recommendations

### Unit Tests

- SleepDetector confidence calculations
- Data processing edge cases
- Alert cooldown logic

### Integration Tests

- HealthKit query lifecycle
- WatchConnectivity message passing
- Alert trigger conditions

### Manual Testing Scenarios

1. **Normal monitoring**: Wear watch, start monitoring, remain awake
2. **Sleep simulation**: Remain still, slow breathing, lower heart rate
3. **False positive check**: Sit still reading or watching
4. **Battery test**: Monitor for 2-4 hours continuously
5. **Alert response**: Verify haptics, sound, and visual alerts work

## Troubleshooting Guide

### Common Issues

**No heart rate data**:
- Check HealthKit permissions
- Ensure watch is worn snugly
- Verify watch is unlocked
- Check Health app for recent data

**Sleep not detected**:
- Need 30-60 seconds of data collection
- Heart rate must drop below threshold
- Motion must be minimal
- Check sensitivity settings

**False alerts**:
- Increase sleep detection threshold
- Lower heart rate threshold
- Increase motion threshold
- Verify watch fit (loose = false readings)

**Battery drains quickly**:
- Expected: ~20-30% per hour
- Close other active apps
- Reduce screen wake time
- Check for background processes

## Code Style & Conventions

- **SwiftUI** for all UI components
- **Combine** for reactive data flow (`@Published` properties)
- **Async/await** not used (simple callback-based APIs)
- **No external dependencies** (only Apple frameworks)
- **Comments** for complex algorithms only
- **Error handling** with guard statements and optional binding

## Build Configuration

**Minimum Requirements**:
- iOS 17.0+
- watchOS 10.0+
- Xcode 15.0+

**Capabilities**:
- HealthKit (both targets)
- Background Modes (both targets)

**Frameworks**:
- HealthKit
- CoreMotion
- WatchConnectivity
- AVFoundation
- SwiftUI

---

**Note**: This architecture prioritizes simplicity, privacy, and battery efficiency while maintaining reliable sleep detection for safety-critical use cases.
