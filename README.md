# 🤎 CapyDoro
**The Coziest Pomodoro Timer on the Planet!**

CapyDoro is a charming, beautifully designed, and ad-free Pomodoro focus app built in Flutter. Complete with a dynamic Capybara companion who changes moods based on your focus cycle, soft aesthetic themes, and robust background persistence, it's the perfect companion to help you stay productive without feeling stressed!

## 🌟 Features

* **Dynamic Capybara Companion**: The central capybara mascot subtly changes expressions and backgrounds based on your current timer phase (Focus, Short Break, Long Break, or Idle).
* **Fully Customizable Cycles**: Adjust your Focus duration, Short Break, Long Break, and the number of sessions before a Long Break in the Settings.
* **Smart Automation**: Optionally auto-start your breaks and your focus sessions.
* **Background Support**: Go ahead, close the app! CapyDoro utilizes `flutter_foreground_task` to keep your timer running securely and identically in the background. A persistent notification lets you `Pause`, `Skip`, or `Reset` without even opening the app.
* **Haptic & Audio Alerts**: Choose to be notified by pleasant chimes or strong vibrating haptics when a phase finishes.
* **Cozy Light & Dark Themes**: Manually toggle or follow your system settings for a beautifully curated Light (Warm Vanilla) or Dark Mode (Deep Espresso) theme.
* **Optional Tip Jar**: CapyDoro is 100% free and ad-free. If you love it, you can "Support the Capybara" through optional one-time tip purchases safely via the native Google Play / App Store billing APIs. 

## 🛠️ Tech Stack 

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: Highly optimized `ChangeNotifier` / `Provider` architecture 
- **Persistence**: `shared_preferences`
- **Background Processes**: `flutter_foreground_task`
- **Audio & Haptics**: `audioplayers` & `vibration`
- **In-App Billing**: `in_app_purchase`

## 🚀 Getting Started

If you want to clone this repo and contribute or build it yourself locally:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Codymwon/CapyDoro.git
   cd CapyDoro
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   ```bash
   flutter run
   ```

*(Note: For the Tip Jar mock purchases to run visually locally, no further action is required as dummy fallback data is injected if the Android Play Console products are not found for debugging purposes.)*

## 🤝 Contributing
Feel free to open issues or submit pull requests for any bugs you find or features you'd like to see! 

---
*Stay cozy, stay focused.* 🌿
