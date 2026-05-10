# Silver Suite — Store Listing Copy

Targeted at TWO audiences: (1) the adult child gifting/setting up the app for a parent,
and (2) the senior using it daily. Headlines lead with the buyer; body copy speaks to both.

---

## Apple App Store Connect

### App Name (30 char — primary SEO)
```
Silver Suite: Senior Phone Kit
```
**30 chars exactly.** "Senior", "Phone", "Kit" hit the three strongest search clusters.

### Subtitle (30 char)
```
Big buttons. Pills. SOS. Simple.
```
**32 chars** — if Apple rejects, use: `Big Buttons, Pills & SOS` (24 chars).

### Keywords (100 char — comma-separated, no spaces, singular)
```
senior,accessibility,pill,reminder,SOS,contact,magnifier,flashlight,large,text,elderly,caregiver
```
**97 chars.** Omits "Silver Suite", "button", "simple" — those appear in title/subtitle and are auto-indexed.

### Promotional Text (170 chars — updateable without new version)
```
The phone app finally built for Mom and Dad. Big tap targets, pill reminders, one-tap SOS, and a flashlight — all in one calm, high-contrast screen.
```
**149 chars.**

### Description (~3000 chars)

```
Finally, a senior phone app you'd actually want your parent to use.

Silver Suite is the phone app that respects older eyes and steadier intentions. No cluttered menus, no tiny buttons, no "swipe to discover" nonsense. Just the six tools your parent actually needs, sized for confidence.

— For the adult child setting this up —

You know the drill: you hand Mom a smartphone and a week later she's calling you because she can't find the flashlight. Silver Suite fixes that. One install. Five minutes of setup. Nine tools your parent can actually find and use on their own. The first time they call you because they want to — not because they're lost in a menu — you'll know it worked.

— For the senior using it every day —

The text is big because you asked for it. The buttons are big because we built them that way on purpose (not as an afterthought). The clock is on the home screen because that's the first thing you look for. And when something goes wrong, the big red SOS button is two taps from anywhere.

WHAT'S INSIDE

• Big Clock — date, day, and time front and center, always readable.
• Pill Reminders — add a medication, set the times, mark it taken in one tap. Color-coded per pill. No app subscription required for this core feature.
• One-Tap Contacts — favorite family members as "Emergency" contacts; they surface first at the top and on the SOS screen.
• SOS Screen — a pulsing 911 button with one confirmation step (no accidental calls), plus your emergency contacts right below.
• Flashlight — camera torch on phones that support it; full-screen white light fallback on every other device. It just works.
• Magnifier — paste any text and zoom it from 24 to 120-point type. High-contrast and bold toggle included. No camera permission needed.
• Notes — large-text notes that never shrink. Exactly what it says.
• Big Calculator — four functions, keys sized for confidence. No scientific-mode clutter.
• Accessibility Settings — three text-size presets (Standard / Large / Extra Large) apply everywhere, instantly. Dark mode included.

PRIVACY
Silver Suite is local-first. No account. No cloud. No tracking. Your pill schedule, contacts, and notes never leave your device. The privacy banner in Settings says so in plain language.

PREMIUM
Unlock the full suite for less than a coffee a month:
• No ads, ever
• Unlimited pill schedules (free tier: 5)
• Unlimited saved notes (free tier: 10)
• Priority support

Monthly ($3.99), yearly ($29.99 — save 37%), or one-time lifetime ($49.99). Cancel monthly or yearly any time. Restore purchases is always available.

Big buttons. Clear text. Real help.
```

### What's New in This Version (v1.0.0)
```
First release. Big clock, pill reminders, one-tap SOS, flashlight, magnifier, notes, calculator, and contacts — all built for 60+ eyes and steadier taps.
```
**153 chars.**

### Support URL
```
https://github.com/nalhamzy/silver_suite
```

### Privacy Policy URL
```
https://nalhamzy.github.io/silver_suite/privacy.html
```

### Copyright
```
2026 Ideal AI
```

### Category
- Primary: **Utilities**
- Secondary: **Lifestyle**

### Age Rating
- **4+**

### App Review — Review Notes
```
Silver Suite is a local-first senior utility app. No account or login. All data (pill schedules, contacts, notes, settings, premium status) stored on-device via SharedPreferences. IAPs: ss_premium_monthly (auto-renewing subscription), ss_premium_yearly (auto-renewing subscription, same group), ss_premium_lifetime (non-consumable), ss_remove_ads (non-consumable). To test IAP: launch app → tap the "Go Premium" card on the More tab → select any tier → confirm in sandbox. Restore Purchases button is on the paywall screen. Camera permission is used only by the torch_light plugin to toggle the device flashlight; the Magnifier feature is text-paste based and requires no camera permission.
```

---

## Apple In-App Purchases

### Product 1 — Premium Monthly
| Field | Value |
|---|---|
| Product ID | `ss_premium_monthly` |
| Reference Name | `Silver Suite Premium (Monthly)` |
| Type | Auto-Renewable Subscription |
| Subscription Group | `ss_premium` |
| Duration | 1 Month |
| Price | $3.99 |
| Display Name | `Premium Monthly` |
| Description | `No ads, unlimited pill schedules and notes. Renews monthly.` |

### Product 2 — Premium Yearly
| Field | Value |
|---|---|
| Product ID | `ss_premium_yearly` |
| Reference Name | `Silver Suite Premium (Yearly)` |
| Type | Auto-Renewable Subscription |
| Subscription Group | `ss_premium` (same group as monthly) |
| Duration | 1 Year |
| Price | $29.99 (save 37%) |
| Display Name | `Premium Yearly` |
| Description | `Save 37% vs monthly. No ads, unlimited pill schedules and notes.` |

### Product 3 — Premium Lifetime
| Field | Value |
|---|---|
| Product ID | `ss_premium_lifetime` |
| Reference Name | `Silver Suite Premium (Lifetime)` |
| Type | Non-Consumable |
| Price | $49.99 one-time |
| Display Name | `Premium Lifetime` |
| Description | `Pay once. Keep forever. No ads, unlimited everything.` |

### Product 4 — Remove Ads
| Field | Value |
|---|---|
| Product ID | `ss_remove_ads` |
| Reference Name | `Silver Suite — Remove Ads` |
| Type | Non-Consumable |
| Price | $2.99 one-time |
| Display Name | `Remove Ads` |
| Description | `Remove all banner ads from Silver Suite. One-time purchase.` |

**IAP review notes (same for all four):**
```
To reproduce: launch app → More tab → "Go Premium" → select tier → confirm. Sandbox tested. Restore Purchases button is always visible on the paywall screen.
```

---

## Google Play Console

### App Name (30 char)
```
Silver Suite: Senior Phone Kit
```

### Short Description (80 char)
```
Big buttons, pill reminders, SOS & flashlight built for 60+ seniors.
```
**69 chars.**

### Full Description (4000 char)
*Reuse the Apple description above.*

### Tags (pick up to 5)
```
Utilities, Health, Seniors, Accessibility, Family
```

### App Category
**Tools** (primary) — closest Play equivalent to Utilities.

### Content Rating
**Everyone**

### Contact Email
```
nalhamzy@gmail.com
```

### Website
```
https://github.com/nalhamzy/silver_suite
```

### Privacy Policy
```
https://nalhamzy.github.io/silver_suite/privacy.html
```

### Target Audience
**Ages 18+** — primary users are seniors (60+) and adult children (25–55) setting up for a parent.
Do NOT enable Designed for Families (not a children's app).

---

## Google Play In-App Products

### Subscription 1 — Premium Monthly
| Product ID | `ss_premium_monthly` |
|---|---|
| Name | `Premium Monthly` |
| Description | `No ads, unlimited pill schedules and notes. Renews monthly.` |
| Base plan | 1 month auto-renewing, $3.99 USD |
| Free trial | 7 days (optional) |

### Subscription 2 — Premium Yearly
| Product ID | `ss_premium_yearly` |
|---|---|
| Name | `Premium Yearly` |
| Description | `Save 37%. No ads, unlimited everything. Billed yearly.` |
| Base plan | 1 year auto-renewing, $29.99 USD |

### In-App Product — Lifetime
| Product ID | `ss_premium_lifetime` |
|---|---|
| Name | `Premium Lifetime` |
| Description | `Pay once. Keep forever. No ads and unlimited everything.` |
| Price | $49.99 USD |
| State | Active |

### In-App Product — Remove Ads
| Product ID | `ss_remove_ads` |
|---|---|
| Name | `Remove Ads` |
| Description | `Remove all banner ads. One-time purchase.` |
| Price | $2.99 USD |
| State | Active |

---

## Screenshot captions (for overlay text, if used)

| # | Caption |
|---|---|
| 01_home | `Big clock. Nine tools. Right there.` |
| 02_pills | `Pill reminders in one tap.` |
| 03_contacts | `Your people, always a tap away.` |
| 04_sos | `SOS — ready when it matters.` |
| 05_premium | `No ads. Unlimited everything. Go Premium.` |

---

## Content-rating questionnaire answers

| Question | Answer |
|---|---|
| Violence | None |
| Sexual content | None |
| Profanity | None |
| Horror | None |
| Alcohol / tobacco / drugs | None |
| Gambling | None |
| Loot boxes | No |
| User-generated content | No (notes/contacts are local-only) |
| Unrestricted web access | No |
| Shares user location | No |
| Targets children under 13 | No — audience is 60+ seniors and adult children |
| Digital purchases (IAPs) | Yes |
| Includes ads | Yes — banner only |

Expected rating: **4+ / Everyone / PEGI 3**.
