# 🚀 Install Flutter on Windows

Follow these steps to install Flutter and run the CredibleEdutech app.

---

## Step 1: Check System Requirements

Before installing, ensure you have:
- **Windows 10 or later** (Windows 11 recommended)
- **Disk space**: 2.5 GB minimum (4 GB recommended)
- **RAM**: 8 GB minimum

---

## Step 2: Download Flutter

### Option A: Automatic (Recommended)
1. Go to [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Click **"Windows"** → Download latest stable release
3. Extract to: `C:\src\flutter` (or your preferred location)

### Option B: Manual Download
```
Direct link: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.x.x-stable.zip
```

---

## Step 3: Extract Flutter

1. Extract the downloaded ZIP file
2. Note the path where you extracted it (e.g., `C:\src\flutter`)

---

## Step 4: Add Flutter to PATH

### Windows 10/11:

**Method 1: Using Environment Variables GUI**
1. Press `Win + X` → Select **System**
2. Click **Advanced system settings** (left panel)
3. Click **Environment Variables** button
4. Under "User variables", click **New**
   - Variable name: `PATH`
   - Variable value: `C:\src\flutter\bin` (replace with your path)
5. Click **OK** → **OK** → **OK**
6. **Restart PowerShell/Command Prompt**

**Method 2: Using PowerShell (faster)**
```powershell
# Run as Administrator
$env:Path += ";C:\src\flutter\bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::User)
```

---

## Step 5: Install Dependencies

### Windows Subsystem for Android (if targeting Android)
```powershell
flutter config --enable-windows
flutter precache
```

### Or use Android Studio (optional but recommended):
1. Download [Android Studio](https://developer.android.com/studio)
2. Install it
3. Run:
```powershell
flutter doctor --android-licenses
# Accept all licenses by typing 'y'
```

---

## Step 6: Verify Installation

Open **PowerShell** or **Command Prompt** and run:

```powershell
flutter --version
flutter doctor
```

### Expected Output:
```
Flutter 3.x.x • channel stable
Dart 3.x.x
```

---

## Step 7: Install Git (if not already installed)

```powershell
# Check if Git is installed
git --version

# If not, download from https://git-scm.com/download/win
# Or use chocolatey:
choco install git
```

---

## Step 8: Run CredibleEdutech App

### Option A: Android Emulator

**Start Android Emulator:**
```powershell
# List available emulators
flutter emulators

# Start one
flutter emulators --launch Pixel_4_API_30

# Wait for emulator to load (2-3 minutes)
```

**Then run the app:**
```powershell
cd f:\EconomicqsMaster\credible_edutech\flutter_app
flutter pub get
flutter run
```

### Option B: iOS Simulator (Mac only)

```bash
cd f:\EconomicqsMaster\credible_edutech\flutter_app
flutter pub get
flutter run
```

### Option C: Physical Device

**Enable Developer Mode:**
1. Connect Android phone via USB
2. Go to Settings → Developer Options → Enable USB Debugging
3. Allow USB connection on phone

**Then run:**
```powershell
flutter devices  # Verify device appears
flutter run
```

---

## Troubleshooting

### "flutter command not found" after PATH update
**Solution:**
```powershell
# Restart PowerShell completely
# Or use full path:
C:\src\flutter\bin\flutter --version
```

### "Android SDK not found"
```powershell
flutter doctor -v
# Follow the suggestions shown
```

### "Java not found"
```powershell
# Download Java 11+
# Or use Android Studio's bundled JDK:
flutter config --jdk-dir="C:\Program Files\Android\Android Studio\jre"
```

### "Emulator won't start"
```powershell
# Reset emulator
flutter emulators --delete Pixel_4_API_30

# Download emulator system image
sdkmanager "system-images;android-31;google_apis;arm64-v8a"

# Create new emulator
flutter emulators --create --name Pixel_4_API_30
```

---

## ✅ Verify Setup Complete

When you see this, you're ready:
```powershell
✓ Flutter is properly installed
✓ flutter command works
✓ Emulator/device connected
```

---

## Next: Run the App

```powershell
cd f:\EconomicqsMaster\credible_edutech\flutter_app
flutter pub get
flutter run
```

The app will launch on your emulator/device! 🎉

---

## Quick Commands Reference

```powershell
flutter --version              # Check Flutter version
flutter doctor                 # Diagnose issues
flutter pub get                # Install dependencies
flutter run                    # Run on default device
flutter run -d emulator        # Run on Android emulator
flutter run -d windows         # Run on Windows
flutter clean                  # Clear build artifacts
flutter pub run build_runner build  # Generate code
```

---

## 🎯 You're All Set!

Once Flutter is installed and PATH is updated:

```bash
cd f:\EconomicqsMaster\credible_edutech\flutter_app
flutter run
```

Your CredibleEdutech app will launch! 🚀

---

**Need help?** Check [flutter.dev/docs](https://flutter.dev/docs) or run `flutter doctor -v`
