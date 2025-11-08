# StayAwake - User Guide

A simple guide for using the StayAwake app to stay alert and avoid unintended sleep.

## Quick Start

### First Time Setup

1. **Install the app** on your iPhone (it will automatically install on your paired Apple Watch)
2. **Open StayAwake** on your iPhone first
3. **Grant permissions** when prompted:
   - Allow access to Health data (heart rate)
   - Allow access to Motion & Fitness
   - Allow notifications
4. **Open StayAwake** on your Apple Watch

### Starting Monitoring

**On your Apple Watch:**

1. Raise your wrist or tap the watch screen
2. Find and tap the **StayAwake** app icon
3. You'll see a large eye icon (currently gray)
4. Tap the green **"Start"** button at the bottom
5. The eye icon turns green - you're now being monitored!

### While Monitoring

**What you'll see on your Watch:**
- Green eye icon (monitoring is active)
- Your current heart rate in BPM
- "Monitoring" status text
- Red "Stop" button

**What the app is doing:**
- Continuously checking your heart rate
- Monitoring your wrist movement
- Analyzing for signs of sleep
- Ready to alert you instantly

**On your iPhone:**
- You can see the same heart rate data
- Monitoring status is synced
- Serves as a backup display

### When Sleep is Detected

If the app detects you're falling asleep, it will **immediately**:

1. **Vibrate strongly** - Your watch will vibrate 5 times rapidly
2. **Play an alarm sound** - A loud alert tone
3. **Show an alert** - Full-screen message: "WAKE UP!"
4. **Keep alerting** - If you don't respond, it alerts again every 30 seconds

**To dismiss the alert:**
- Tap "I'm Awake" on the alert screen
- The monitoring continues automatically

### Stopping Monitoring

1. Look at your Apple Watch
2. Tap the red **"Stop"** button
3. The eye icon turns gray
4. Monitoring has stopped

## Understanding the Alerts

### What Triggers an Alert?

The app detects sleep by combining:
- **Low heart rate** (typically under 55 BPM)
- **Minimal movement** (you're very still)
- **Sustained pattern** (30-60 seconds of data)

When both your heart rate drops AND you're not moving, the app assumes you're falling asleep.

### Alert Cooldown

After an alert:
- You have 30 seconds before the next alert can trigger
- This prevents constant alerts if you're just resting
- If you're still showing sleep patterns after 30 seconds, you'll be alerted again

## Best Practices

### For Best Results:

✅ **DO:**
- Wear your Apple Watch snugly (but comfortably)
- Ensure the watch is unlocked when starting
- Keep the watch charged (monitoring uses ~25% per hour)
- Respond to alerts promptly
- Test the app before relying on it in critical situations

❌ **DON'T:**
- Wear the watch too loosely (affects heart rate accuracy)
- Let the watch battery die during monitoring
- Ignore multiple alerts (you're likely falling asleep!)
- Use as a replacement for proper rest

### Optimizing for Your Body

Everyone's physiology is different. You may need to adjust sensitivity:

**If you get too many false alerts:**
- Your resting heart rate might be naturally low
- You might be very still when focused
- See SETUP.md for sensitivity adjustment

**If alerts come too late:**
- Your heart rate might not drop as much
- You might be a restless sleeper
- See SETUP.md for sensitivity adjustment

## Specific Use Cases

### For People with Epilepsy

**Why it helps:**
- Some seizures are triggered by sleep or drowsiness
- Early detection of drowsiness allows you to take action
- Can help you recognize patterns in your sleep attempts

**Important:**
- This is NOT a seizure detection device
- Always follow your doctor's recommendations
- Use as an additional safety tool only

### For Truck Drivers & Long-Haul Operators

**Why it helps:**
- Detects microsleep and drowsiness early
- Immediate alerts can prevent accidents
- Works continuously during long shifts

**Important:**
- Pull over safely if you receive an alert
- This does not replace proper rest breaks
- Follow all legal requirements for rest periods
- Do not rely solely on the app for safety

### For Doctors & Healthcare Workers

**Why it helps:**
- Long shifts can lead to fatigue
- Helps maintain alertness during critical tasks
- Discreet alerts via wrist vibration

**Important:**
- Do not use during sterile procedures (watch contamination)
- Always follow hospital alertness protocols
- Use during breaks or when safe
- Ensure patient safety first

### For Students & Test-Takers

**Why it helps:**
- Stay alert during long study sessions
- Avoid dozing off during lectures or exams
- Maintain focus on important material

**Important:**
- Consider if device policies allow smartwatches
- Better long-term: get adequate sleep
- Use for occasional needs, not chronic sleep deprivation

## Troubleshooting

### "No heart rate data"

**Fix:**
1. Make sure you granted Health permissions
2. Ensure watch is worn snugly on wrist
3. Check that watch is unlocked
4. Open the Health app on iPhone and verify it's recording heart rate
5. Try restarting the watch

### "App not detecting sleep even when I'm drowsy"

**Possible reasons:**
- Heart rate not dropping enough (you're naturally alert)
- Still moving around (fidgeting, typing)
- Not enough data collected yet (wait 60 seconds)

**To test:**
- Sit very still for 60 seconds
- Close your eyes and breathe deeply
- Relax completely
- The app should alert you

### "Battery draining too fast"

**Expected:**
- ~5-10% per hour during active monitoring
- Can monitor for 10-20 hours on a full charge
- This is normal for continuous sensor use

**To conserve:**
- Fully charge before long monitoring sessions
- Close other active apps on watch
- Disable always-on display if your Watch has it
- Lower screen brightness

### "Alert is not loud/strong enough"

**Current limitations:**
- The app uses maximum system haptics
- Sound volume follows watch settings

**Improvements:**
- Increase watch volume in Settings
- Ensure watch is worn snugly for stronger haptics
- Consider using iPhone as backup (also receives alerts)

### "App stops monitoring on its own"

**Check:**
- Watch battery level (may enter low power mode)
- That you didn't accidentally tap "Stop"
- Watch didn't lose connection to iPhone
- App didn't crash (restart if needed)

## Privacy & Your Data

### What data is used:
- ✅ Heart rate (read from Health app)
- ✅ Motion/accelerometer data
- ✅ Only while monitoring is active

### What happens to your data:
- ❌ **NOT stored** - processed in real-time only
- ❌ **NOT uploaded** - stays on your devices
- ❌ **NOT shared** - completely private
- ❌ **NOT tracked** - no analytics or logs

### You can verify:
- Check Settings > Privacy > Health - only "Read" access
- No internet permission needed
- No location access
- Open source code available for review

## Safety Reminders

⚠️ **Important Safety Information**

**This app is a tool, not a medical device:**
- Not FDA approved
- Not a replacement for sleep
- Not a substitute for medical advice
- Not a guarantee against falling asleep

**Always:**
- Get adequate sleep (7-9 hours per night)
- Take regular breaks during long tasks
- Follow your doctor's recommendations
- Use proper safety protocols for your job
- Have backup safety measures

**Never:**
- Rely solely on this app for safety
- Use as an excuse to skip sleep
- Ignore signs of extreme fatigue
- Use while operating vehicles or machinery without other safety measures

## Getting Help

**If you have technical issues:**
1. Check this guide first
2. Review the SETUP.md for configuration
3. Check the GitHub repository for updates
4. Report bugs via GitHub Issues

**If you have medical questions:**
- Consult your doctor or healthcare provider
- This app is not medical advice
- Use only as approved by your medical team

## Tips for Success

1. **Test before you rely on it**
   - Try it at home first
   - Verify it alerts you when drowsy
   - Adjust settings to your needs

2. **Charge strategically**
   - Full charge before long sessions
   - Use charging breaks wisely
   - Consider a spare watch for 24/7 needs

3. **Respond to alerts**
   - Stand up and move around
   - Splash cold water on face
   - Take a short break
   - Consider a brief rest if safe

4. **Know your patterns**
   - Notice when you get drowsy
   - Plan breaks accordingly
   - Address underlying sleep issues

5. **Combine with other strategies**
   - Adequate sleep
   - Caffeine (if appropriate)
   - Bright lights
   - Physical activity
   - Cool environment

## Frequently Asked Questions

**Q: Can I use this while sleeping?**
A: No, it's designed to prevent sleep, not monitor it during sleep.

**Q: Will it work if I close the app?**
A: Yes, it runs in the background on Apple Watch during monitoring.

**Q: Does it work without my iPhone nearby?**
A: Yes, the Apple Watch app works independently.

**Q: Can I customize the alert sound?**
A: Currently, it uses the system alarm sound. Custom sounds may be added in future versions.

**Q: How accurate is the sleep detection?**
A: Generally reliable for typical sleep onset, but individual variation exists. Test it with your own body.

**Q: Will this drain my iPhone battery?**
A: Minimal impact on iPhone. Most battery usage is on the Apple Watch.

**Q: Can multiple people use it?**
A: Each person needs their own Apple Watch and iPhone with the app installed.

**Q: Is it safe to use all day?**
A: The app is safe, but relying on it instead of proper sleep is not healthy.

---

**Remember**: The best way to stay alert is to be well-rested. This app is for situations where you need extra help staying awake, not a replacement for good sleep habits.

Stay safe! 👁️
