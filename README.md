# Silver Suite

Big buttons. Clear text. Real help.
A senior-friendly utility suite that collapses the six tools older
users actually open every day into one calm, high-contrast app.

## Why this exists

Senior-focused apps either patronize (oversized clip-art) or hide
utilities inside bloated "senior phone" ROMs. Silver Suite is the
opposite bet: the same crisp design language as a premium iOS app,
tuned for 60+ eyes and shaky taps — WCAG-leaning contrast,
large type scale presets, and tap targets that start at 56dp and
never shrink.

## What's in the MVP

- **Big clock** on the home screen.
- **Pill reminders.** Simple schedule (name + dose + times), mark
  taken for today in one tap, color-coded per medication.
- **Contacts with one-tap call.** Favorite family as "Emergency"
  to surface them in red at the top + on the SOS screen.
- **SOS screen.** Pulsing 911 button (with confirm), plus emergency
  contact shortcuts right below.
- **Flashlight.** Camera torch via `torch_light`, plus screen-light
  fallback for devices without a flash.
- **Magnifier.** Camera-free text magnifier with adjustable scale
  (24-120pt), high-contrast mode, and bold toggle.
- **Notes.** Large-text notes that never shrink.
- **Big calculator.** Four-function only, keys sized for confidence.
- **Accessibility settings.** Dark mode + 3 text-size presets
  (Standard / Large / Extra Large) applied app-wide.

## Run

```bash
flutter pub get
flutter run
```

## Architecture (Color Chaos pipeline pattern)

- `core/constants/theme.dart` — light + dark themes, scalable text
  factory driven by user preference.
- `core/models/` — `ContactEntry`, `PillSchedule`, `PillLog`, `Note`,
  `AppSettings` (Equatable + JSON).
- `core/services/storage_service.dart` — local JSON over SharedPreferences.
- `providers/` — Riverpod notifiers for contacts, pills, pill logs,
  notes, settings, navigation.
- `screens/` — home, pills, contacts, SOS, flashlight, magnifier,
  notes, calculator, more.
- `widgets/big_action_card.dart` — the 96-150dp tap targets that
  drive the entire home grid.

## Permissions

- Android: `CAMERA` + `FLASHLIGHT` (torch), `tel:` dial intent query.
- iOS: set `NSCameraUsageDescription` when shipping (flashlight on
  some devices requires camera permission to toggle the torch).

## Tests

```bash
flutter test
```
