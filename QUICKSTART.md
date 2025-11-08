# Quick Start Guide - Test on Device in 5 Minutes

Follow these steps to get StayAwake running on your iPhone and Apple Watch ASAP.

## Prerequisites

- Mac with Xcode 15.0+ installed
- iPhone with iOS 17.0+ paired with Apple Watch running watchOS 10.0+
- Lightning/USB-C cable to connect iPhone to Mac
- Apple ID (free account works for testing)

## Steps

### 1. Open the Project (30 seconds)

```bash
cd TV-Script-Generation
open StayAwake.xcodeproj
```

**Or**: Double-click `StayAwake.xcodeproj` in Finder

### 2. Configure Code Signing (2 minutes)

In Xcode:

**For iOS App:**
1. Click on **StayAwake** project in left sidebar
2. Select **StayAwake** target
3. Go to **Signing & Capabilities** tab
4. Under **Team**, select your Apple ID
   - If no team shows up, click "Add Account" and sign in with your Apple ID
5. Click **+ Capability** button
6. Add **HealthKit**
7. Add **Background Modes** → Check "Background processing"

**For Watch App:**
1. Select **StayAwake Watch App** target (same project)
2. Go to **Signing & Capabilities** tab
3. Under **Team**, select the same Apple ID
4. Click **+ Capability** button
5. Add **HealthKit**
6. Add **Background Modes** → Check "Workout Processing" and "Self Care"

### 3. Connect Your Device (1 minute)

1. Connect your iPhone to your Mac with a cable
2. Unlock your iPhone
3. Tap **Trust** when prompted on iPhone
4. Make sure your Apple Watch is:
   - Paired with the iPhone
   - Unlocked
   - On your wrist (or Watch will go to sleep)

### 4. Build & Run (2 minutes)

1. At the top of Xcode, click the device dropdown (currently shows "iPhone Simulator" or similar)
2. Select your actual iPhone from the list (e.g., "John's iPhone")
3. Click the **▶ Play** button (or press ⌘R)

**What happens:**
- Xcode builds the app (~30-60 seconds first time)
- App installs on your iPhone
- Watch app automatically installs on paired Watch
- iPhone app launches automatically

### 5. Grant Permissions (30 seconds)

**On iPhone:**
- When prompted, tap **Allow** for Health access
- Tap **Allow** for Motion & Fitness
- Tap **Allow** for Notifications

**On Apple Watch:**
- Raise your wrist
- Find the **StayAwake** app icon
- Open it
- Tap **Start**
- If prompted, grant Health access

### 6. Test It! (1 minute)

**To verify sleep detection works:**

1. With StayAwake running on your Watch, tap **Start**
2. You'll see your heart rate displayed
3. Sit very still for 30-60 seconds:
   - Don't move your arm
   - Close your eyes
   - Breathe slowly and deeply
   - Relax completely
4. The app should detect potential sleep and alert you with:
   - Strong vibrations (5 buzzes)
   - Alert sound
   - "WAKE UP!" message
5. Tap **I'm Awake** to dismiss

**Success!** Your app is working.

## Troubleshooting

### "Failed to code sign"
- Make sure you selected a Team under Signing & Capabilities
- Try creating a free Apple ID if you don't have one
- Check that bundle identifier is unique (you can change it in project settings)

### "No devices found"
- Make sure iPhone is connected via cable (not just WiFi)
- Unlock iPhone and tap Trust on the trust dialog
- Try unplugging and replugging the cable

### "Watch app not installing"
- Make sure Watch is unlocked and on your wrist
- Check Settings > General > Automatic App Install is ON
- Manually install: Open Watch app on iPhone → My Watch → scroll to StayAwake → Install

### "No heart rate data"
- Make sure you granted HealthKit permission
- Check that Watch is worn snugly (not too loose)
- Open Health app on iPhone, verify heart rate data exists
- Try restarting the Watch app

### "Sleep not detected during test"
- Wait 60 seconds for enough data to collect
- Make sure you're very still (no typing, no moving)
- Your heart rate should drop below 60 BPM
- Try adjusting sensitivity (see SETUP.md)

### Build errors
- Make sure both targets have HealthKit capability enabled
- Verify deployment targets: iOS 17.0, watchOS 10.0
- Clean build folder: Product → Clean Build Folder (⌘⇧K)
- Restart Xcode if needed

## Next Steps

- **Adjust sensitivity**: See SETUP.md for tuning detection parameters
- **Read user guide**: See USER_GUIDE.md for detailed usage
- **Understand architecture**: See ARCHITECTURE.md for technical details
- **Test in real scenarios**: Try it during a long task where you need to stay alert

## Battery Tips for Testing

- Fully charge both iPhone and Watch before long test sessions
- Expected usage: ~5-10% battery per hour on Watch
- Can monitor for 10-20 hours on full charge
- Close other active apps on Watch to conserve battery

## Important Notes

⚠️ **For First-Time Testing:**
- Test at home first, not in critical situations
- Verify alerts are loud/strong enough for you
- Understand your body's response patterns
- Adjust settings as needed

⚠️ **Safety Reminder:**
- This is a safety TOOL, not a replacement for proper rest
- Always follow appropriate safety protocols for your job/situation
- Do not use as only alertness measure in critical scenarios
- Consult doctors for medical use cases

## Support

- Stuck? Check the full SETUP.md guide
- Issues? Review troubleshooting in USER_GUIDE.md
- Technical questions? See ARCHITECTURE.md

---

**Total time from clone to running on device: ~5-7 minutes**

Enjoy staying alert and safe with StayAwake! 👁️
