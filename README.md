# StayAwake - Sleep Detection Alert App

An iOS and Apple Watch app that automatically detects when someone has fallen asleep and alerts them to wake up.

## Use Cases

- **Medical**: People with epilepsy who need to avoid falling asleep unexpectedly
- **Occupational**: Doctors, truck drivers, security personnel, and others who must stay alert for extended periods
- **Safety**: Anyone who needs to remain awake during critical tasks

## Features

- **Real-time Sleep Detection**: Uses Apple Watch sensors (heart rate, motion) to detect when you're falling asleep
- **Immediate Alerts**: Haptic, sound, and visual alerts on both Watch and iPhone
- **Lightweight Design**: ~5-10% battery per hour, can monitor for 10-20 hours
- **Simple Interface**: Easy start/stop monitoring with clear status indicators
- **Background Operation**: Runs efficiently in the background, screen can sleep normally

## How It Works

The app monitors:
- **Heart Rate Variability**: Detects characteristic patterns when falling asleep
- **Motion Data**: Identifies reduced movement and specific sleep-related motion patterns
- **Wrist Detection**: Ensures the watch is being worn

When sleep patterns are detected, the app triggers:
- Strong haptic feedback on Apple Watch
- Loud alarm sound
- Screen wake with alert message
- Notification on iPhone as backup

## Technical Stack

- **iOS 17.0+** and **watchOS 10.0+**
- **HealthKit**: For heart rate monitoring
- **CoreMotion**: For accelerometer and gyroscope data
- **WatchConnectivity**: For iPhone-Watch communication
- **UserNotifications**: For alert delivery
- **SwiftUI**: For user interface

## Setup

1. Open the project in Xcode 15.0 or later
2. Configure your development team for code signing
3. Enable HealthKit capability in project settings
4. Build and run on your iPhone and paired Apple Watch

## Privacy & Permissions

The app requires:
- **HealthKit Access**: To read heart rate data
- **Motion & Fitness**: To access motion sensors
- **Notifications**: To deliver alerts

All health data is processed on-device and never stored or transmitted.

## Safety Notice

This app is designed as an assistive tool and should not replace medical advice or professional alertness protocols. Always follow appropriate safety procedures for your specific situation.

## License

MIT License
