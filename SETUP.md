# StayAwake - Setup Guide

This guide will help you set up and build the StayAwake iOS and Apple Watch app in Xcode.

## Prerequisites

- **macOS** 14.0 (Sonoma) or later
- **Xcode** 15.0 or later
- **iOS** 17.0+ device for testing
- **Apple Watch** running watchOS 10.0+ paired with your iPhone
- **Apple Developer Account** (free or paid)

## Project Structure

```
StayAwake/
├── StayAwake/                    # iOS App
│   ├── StayAwakeApp.swift       # iOS App entry point
│   ├── ContentView.swift        # iOS main view
│   └── Info.plist               # iOS permissions and config
├── StayAwake Watch App/          # watchOS App
│   ├── StayAwakeWatchApp.swift  # Watch app entry point
│   ├── WatchContentView.swift   # Watch main view
│   ├── MonitoringManager.swift  # Core monitoring logic
│   └── Info.plist               # Watch permissions and config
└── Shared/                       # Shared code
    ├── HealthKitManager.swift   # HealthKit interface
    ├── WatchConnectivityManager.swift  # iPhone-Watch communication
    └── SleepDetector.swift      # Sleep detection algorithm
```

## Setup Instructions

### 1. Create Xcode Project

1. Open Xcode
2. Select **File > New > Project**
3. Choose **iOS > App** template
4. Configure your project:
   - **Product Name**: StayAwake
   - **Bundle Identifier**: com.stayawake.app (or your own)
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Include Tests**: Optional

### 2. Add Watch App Target

1. In Xcode, select **File > New > Target**
2. Choose **watchOS > Watch App**
3. Configure:
   - **Product Name**: StayAwake Watch App
   - **Bundle Identifier**: com.stayawake.app.watchkitapp
   - Uncheck "Include Notification Scene"

### 3. Add Source Files

1. **Delete** the default ContentView.swift files from both targets
2. **Add** the files from this repository to your project:
   - Drag `StayAwake/` folder files to the iOS app target
   - Drag `StayAwake Watch App/` folder files to the Watch app target
   - Drag `Shared/` folder and select both targets when adding

### 4. Configure Capabilities

#### iOS App Target:
1. Select your project in Xcode
2. Select the **StayAwake** target
3. Go to **Signing & Capabilities**
4. Click **+ Capability** and add:
   - **HealthKit**
   - **Background Modes** (enable "Background processing")

#### Watch App Target:
1. Select the **StayAwake Watch App** target
2. Go to **Signing & Capabilities**
3. Click **+ Capability** and add:
   - **HealthKit**
   - **Background Modes** (enable "Workout Processing" and "Self Care")

### 5. Set Deployment Targets

- iOS App: **iOS 17.0** or later
- Watch App: **watchOS 10.0** or later

### 6. Configure Info.plist Files

The Info.plist files in the repository already include the necessary privacy descriptions:

**iOS App (`StayAwake/Info.plist`):**
- NSHealthShareUsageDescription
- NSMotionUsageDescription

**Watch App (`StayAwake Watch App/Info.plist`):**
- NSHealthShareUsageDescription
- NSMotionUsageDescription
- WKRunsIndependently
- WKBackgroundModes

Make sure these files are properly included in their respective targets.

### 7. Code Signing

1. Select your project in Xcode
2. For each target (iOS and Watch):
   - Go to **Signing & Capabilities**
   - Select your **Team** (Apple Developer Account)
   - Xcode will automatically manage signing

### 8. Build and Run

1. Connect your iPhone (with paired Apple Watch)
2. Select your iPhone as the run destination
3. Click the **Run** button (⌘R)
4. Xcode will install both the iOS and Watch apps
5. Grant permissions when prompted:
   - Health data access
   - Motion & Fitness access
   - Notification permissions

## Testing the App

### On Apple Watch:

1. Open the **StayAwake** app on your Watch
2. Tap **Start** to begin monitoring
3. The app will display:
   - Your current heart rate
   - Monitoring status
4. To test sleep detection:
   - Remain very still for 30-60 seconds
   - Keep your heart rate low (relax)
   - The app should detect potential sleep and trigger an alert

### On iPhone:

1. Open the **StayAwake** app on your iPhone
2. You'll see:
   - Real-time heart rate from your Watch
   - Monitoring status
   - Motion activity status

## Troubleshooting

### App won't build:
- Ensure all files are added to correct targets
- Check that capabilities are enabled
- Verify deployment targets are set correctly

### No heart rate data:
- Grant HealthKit permissions when prompted
- Ensure Apple Watch is worn and unlocked
- Check that Health app has heart rate data

### Watch app not installing:
- Ensure Apple Watch is paired and unlocked
- Check that watch has sufficient storage
- Try unpairing and re-pairing the watch (last resort)

### Sleep not detected:
- Monitoring requires 30-60 seconds of data
- Remain very still and relaxed
- Heart rate should drop below 60 BPM for best results

## Customization

### Adjust Sleep Detection Sensitivity

Edit `Shared/SleepDetector.swift`:

```swift
private let lowHeartRateThreshold: Double = 55 // Lower = more sensitive
private let lowMotionThreshold: Double = 0.05 // Lower = more sensitive
private let sleepDetectionThreshold: Double = 0.7 // Lower = triggers faster
```

### Change Alert Behavior

Edit `StayAwake Watch App/MonitoringManager.swift`:

```swift
private let alertCooldown: TimeInterval = 30 // Seconds between alerts
```

### Modify Haptic Intensity

In `MonitoringManager.swift`, change:

```swift
WKInterfaceDevice.current().play(.notification)
```

Options: `.notification`, `.directionUp`, `.directionDown`, `.success`, `.failure`, `.retry`, `.start`, `.stop`, `.click`

## Privacy & Data

- All health data processing happens **on-device**
- No data is sent to external servers
- Heart rate and motion data is **not stored**
- Only used in real-time for sleep detection

## Support

For issues or questions:
- Check the main [README.md](README.md) for app overview
- Review Xcode console logs for error messages
- Ensure all permissions are granted in Settings app

## Next Steps

After successful setup:
1. Test the app in various scenarios
2. Adjust sensitivity settings for your needs
3. Consider adding custom alarm sounds
4. Implement additional safety features as needed

**Important**: This app is a safety tool but should not replace professional medical devices or protocols. Always follow appropriate safety guidelines for your specific situation.
