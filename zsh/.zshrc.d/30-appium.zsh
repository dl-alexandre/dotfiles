apm_extended() {
  APMLOG=~/Documents/Github/Milc/One/Appium/appium_$(date +%Y%m%d_%H%M%S).log
  pgrep -f 'emulator -avd Emulator15' >/dev/null || (emulator -avd Emulator15 >/dev/null 2>&1 &)
  pgrep -f 'emulator -avd Emulator11' >/dev/null || (emulator -avd Emulator11 >/dev/null 2>&1 &)
  xcrun simctl list | grep '03AD2C17-4993-462F-93F1-5B1A38B31FB0 (Booted)' >/dev/null || (xcrun simctl boot '03AD2C17-4993-462F-93F1-5B1A38B31FB0' >/dev/null 2>&1)
  xcrun simctl list | grep '1C29D004-3855-49F5-B0AA-779BB6C029DD (Booted)' >/dev/null || (xcrun simctl boot '1C29D004-3855-49F5-B0AA-779BB6C029DD' >/dev/null 2>&1)
  appium --log-level debug --log "$APMLOG"
}
alias apm_ext='apm_extended'

apm_update() {
  npm update appium &&
    appium driver update xcuitest --unsafe &&
    appium driver update uiautomator2 --unsafe &&
    appium driver update espresso --unsafe &&
    appium driver update chromium --unsafe &&
    appium driver run chromium install-chromedriver
}
alias apmu='apm_update'

alias apm='appium --log-level warn:warn --log ~/Documents/Github/Milc/One/Appium/appium_$(date +%Y%m%d_%H%M%S).log'

kill_emulators() {
  adb -s emulator-5554 emu kill 2>/dev/null || true
  adb -s emulator-5556 emu kill 2>/dev/null || true
  xcrun simctl shutdown "1C29D004-3855-49F5-B0AA-779BB6C029DD" 2>/dev/null || true
  xcrun simctl shutdown "03AD2C17-4993-462F-93F1-5B1A38B31FB0" 2>/dev/null || true
}
alias kl='kill_emulators'
