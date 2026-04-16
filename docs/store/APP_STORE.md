# App Store Listing — Silver Suite

Paste into App Store Connect → App Information / Version Info.

## Identity

| Field | Value |
|---|---|
| App Name | `Silver Suite` |
| Subtitle (30 chars) | `Big buttons. Clear help.` |
| Bundle ID | `com.nalhamzy.silverSuite` |
| SKU | `silversuite2026` |
| Primary Language | English (U.S.) |
| Primary Category | Utilities |
| Secondary Category | Lifestyle |
| Age Rating | 4+ |

## Promotional text (170 chars)

> Calm, high-contrast utilities for ages 60+. Big clock, pill reminders, one-tap family calling, SOS, flashlight, magnifier, notes, and a simple calculator.

## Description

> **Big buttons. Clear text. Real help.**
>
> Silver Suite is a senior-friendly utility kit — one calm, high-contrast app for the six tools older users actually open every day.
>
> **The tools you get**
>
> · **Big clock** on every screen.
> · **Pill reminders** — color-coded, multiple times per day, one-tap "Taken."
> · **One-tap calling** — your family, your doctor, your neighbor. Mark any contact as Emergency to pin it to the top.
> · **SOS screen** — pulsing 911 button with a confirm step, plus shortcuts to your emergency contacts.
> · **Flashlight** — instant torch, with a screen-light fallback for devices without a flash.
> · **Magnifier** — type or paste text to read it at 24–120pt, with a high-contrast mode and a bold toggle.
> · **Big-text notes** — large, readable, no formatting clutter.
> · **Simple calculator** — four-function, oversized keys.
>
> **Built for 60+ eyes and shaky taps**
>
> · Tap targets that start at 56dp and grow from there.
> · Three text-size presets — Standard, Large, Extra Large — applied app-wide in one switch.
> · Full dark mode for night use.
> · No tiny icons. No buried menus. No "tap twice to scroll."
>
> **Silver+ (optional upgrade)**
> Removes the banner ad and unlocks unlimited medications, contacts, and notes — plus priority access to future tools (widgets, SOS location sharing, bigger keyboard themes).
>
> $3.99/month · $29.99/year (save 37%) · $49.99 lifetime · or just $2.99 to remove ads forever.
>
> **Privacy first, by design.** No account required. Everything stays on your device. No third-party analytics. Ads are served only when you're on the free tier, and even those don't follow you around — AdMob only, no data brokers.

## Keywords

```
senior,elderly,large,accessibility,flashlight,magnifier,pill,medication,SOS,emergency,calculator,notes
```

## Support & Marketing URLs

| Field | URL |
|---|---|
| Support URL | `https://nalhamzy.github.io/silver-suite/#support` |
| Marketing URL | `https://nalhamzy.github.io/silver-suite/` |
| Privacy Policy URL | `https://nalhamzy.github.io/silver-suite/privacy.html` |

## Review info

| Field | Value |
|---|---|
| Contact Name | Nasir Alhamzy |
| Contact Email | nalhamzy@gmail.com |
| Demo Account | Not required — no login. |
| Notes to reviewer | The SOS screen shows a confirm dialog before dialing 911 — it will not call emergency services during automated testing unless the tester taps "Call 911." The torch uses the `torch_light` plugin and falls back gracefully on simulators/devices without flash. |

## Release notes (v1.0.0)

```
Welcome to Silver Suite 1.0.
• Big clock + big buttons.
• Pill reminders, one-tap contact calling, SOS.
• Flashlight, magnifier, notes, calculator.
• Dark mode + three text-size presets.
• Privacy first — everything stays on your device.
```

## App Privacy labels

| Category | Collected? | Linked to you? | Used for tracking? |
|---|---|---|---|
| Contact Info | No (emergency contacts are stored locally by the user) | — | — |
| Location | No | — | — |
| Identifiers (advertising ID) | Yes (AdMob) | No | No (non-personalized ads by default) |
| Usage Data (ad interactions) | Yes (AdMob) | No | No |
| Purchases | Yes (Apple-handled) | Yes | No |
| Health / Medical Info | No | — | — |

## In-App Purchases

| Product | Type | Reference | Price |
|---|---|---|---|
| Remove Ads | Non-Consumable | `ss_remove_ads` | $2.99 |
| Silver+ Monthly | Subscription | `ss_premium_monthly` | $3.99/mo |
| Silver+ Yearly | Subscription | `ss_premium_yearly` | $29.99/yr |
| Silver+ Lifetime | Non-Consumable | `ss_premium_lifetime` | $49.99 |

Subscription group name: `Silver+ Membership`.

## Asset checklist

- [ ] App icon 1024×1024 — `assets/icon/icon.png`
- [ ] Phone + tablet screenshots — see `store_assets/`
- [ ] App Preview (optional, 15–30s)
