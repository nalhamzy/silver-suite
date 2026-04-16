# Capturing App Store / Play Store screenshots

App Store and Google Play require screenshots at specific pixel
dimensions. The cleanest way to produce them from Flutter is via
`flutter drive` + `integration_test` running on the iOS Simulator or
Android Emulator at the exact target device size.

## Required sizes

### App Store (iPhone)
| Device | Portrait | Where to use |
|---|---|---|
| 6.9" iPhone 16 Pro Max | 1320 × 2868 | Required |
| 6.7" iPhone 15 Pro Max | 1290 × 2796 | Required |
| 6.5" iPhone XS Max | 1242 × 2688 | Optional (covered by 6.7") |
| 5.5" iPhone 8 Plus | 1242 × 2208 | Optional |
| 13" iPad Pro | 2064 × 2752 | Required if iPad listing |

### Google Play
- Phone: min 2, max 8. 16:9 or 9:16. 320 px min, 3840 px max on any side.
- 7" tablet / 10" tablet: optional.
- Feature graphic: 1024 × 500 JPG/PNG.

## Recommended capture flow

1. Open iOS Simulator → Devices → iPhone 15 Pro Max.
2. Launch Silver Suite:
   ```bash
   flutter run -d "iPhone 15 Pro Max"
   ```
3. Navigate to each screen you want to capture.
4. Simulator → File → Screenshot (Cmd-S). Output lands on desktop at
   native resolution (1290 × 2796).
5. Move to `store_assets/phone/` with descriptive filenames:
   - `01_home_big_clock.png`
   - `02_pills.png`
   - `03_contacts.png`
   - `04_sos.png`
   - `05_magnifier.png`

For Android, run an emulator at 1080 × 1920 or 1440 × 3200 and use
`adb exec-out screencap -p > 01_home_big_clock.png`.

## Automated capture (bonus)

If you want reproducible screenshots across version bumps, add
`integration_test` + `flutter drive`:

```bash
flutter pub add --dev integration_test
flutter pub add --dev test
```

Then write `integration_test/screenshots_test.dart` that drives the
app through each screen and calls `binding.takeScreenshot(name)`. Run
with:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/screenshots_test.dart \
  -d "iPhone 15 Pro Max"
```

Screenshots land in `build/` and can be copied to `store_assets/`.

## Feature graphic (Play Store)

Generate the 1024 × 500 feature graphic from the app icon + tagline.
A ready-to-use template lives at `store_assets/feature_template.html`
(open in browser, take a browser screenshot at 1024 × 500).

## Privacy screenshots

Do NOT include real child names/birthdays in screenshots. Use:
- "Mia" · age 18 months
- "Noah" · age 3 yr

## Annotation (optional)

For marketing screenshots (as opposed to raw App Store assets), drop
the pngs into `store_assets/frames/` and use a free tool like
[Screenshots.Pro](https://www.screenshots.pro) or
[Fastlane frameit](https://docs.fastlane.tools/actions/frameit/) to add
device frames + headlines.
