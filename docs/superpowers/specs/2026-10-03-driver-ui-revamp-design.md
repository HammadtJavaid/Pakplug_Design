# PakPlug Driver UI Revamp — Design Spec

**Date:** 2026-10-03
**Owner:** Hammad (design + product). Code changes that follow from this spec belong to Rayan.
**Status:** Approved in conversation (sections 1–2 explicitly; sections 3–5 delegated: "do on your own").
**Figma working file:** [PakPlug Design System](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System) (`x2fPubLkytfeO9btWSoTu6`)

---

## 1. What this is

A full visual revamp of the **driver side** of PakPlug: a new brand identity and a new component
system, rebuilt on Apple's **iOS and iPadOS 27** UI Kit (Liquid Glass). Then the driver flows are
reassembled one at a time from those components.

The visual target is the *component hierarchy* of the "Nessie" reference shown in conversation:
- a quick-action card on top
- a big hero number
- grouped "at a glance" rows
- a floating glass tab bar over a mesh-shaded background

The theme is **light, not black**.

### Fixed decisions

| # | Decision | Chosen |
|---|----------|--------|
| D1 | Brand scope | **Revised 2026-10-03 (Hammad): keep the heritage brand, refresh everything else.** The signature PakPlug **P** (bolt-stem P) is kept and refined, and the **deep emerald** palette is kept. Components, mesh backgrounds, app-icon background, favicon, type and materials are all new. (Was: full rebrand.) |
| D2 | Name | **PakPlug stays.** Mark = refined signature P; wordmark = tucked lockup (P + lowercase "akplug"); new layered app icon + favicon set. |
| D3 | Mood | **Light base + coloured mesh.** Off-white base with soft mesh glows behind content. The map stays light. |
| D4 | Glass delivery | **Native chrome, custom content.** Tab bar, nav bar, search, sheets, toolbars, alerts and segmented controls are real iOS components on iPhone (embedded via platform views). Cards and content are custom. Android gets a matching non-glass version. |
| D5 | Logic | **Unchanged.** Same screens, steps, data, states and navigation. Only presentation changes. |
| D6 | Process | **Approach C.** Logic map → brand → foundations → disposable style frame → components one at a time → flows one at a time. |
| D7 | Old design | The previous Figma flows and components are **not a design input**. They are used only to remember the logic. |
| D8 | Base kit | **iOS and iPadOS 27** community library (updated 2026-09-15), not 26. It is the shipping OS and uses the same Liquid Glass language. |
| D9 | Flow direction (2026-10-03, Hammad) | **A · Maps-native discovery + B · Charging Pass bookings.** Discovery: bottom search, Apple-Maps-style station place sheet, booking inside the sheet. Bookings: Wallet-style passes; the pass detail is the booking detail; the pass turns live while charging. C (Live Activity / widgets) and D (editorial home, time scrubber) are parked; C can return when native iOS work is scheduled. |

### Out of scope

- Host and admin screens
- Dark mode (designed later; tokens are structured so it can be added)
- Any Flutter code change
- Android-specific variants (deferred until the iOS component is approved; see §5.4)
- Renaming the product

---

## 2. Figma file structure

The file currently holds only the `📐 Cover` page (V3 cover plus the archived v2.4 cover). Both are left untouched.

| Page | Contents |
|------|----------|
| 🧭 Logic Map | Grey-box inventory of every driver screen and state, taken from the Flutter code (§4). Not styled. |
| 🌱 Brand | 3 mark directions → chosen mark → wordmark → layered app icon |
| 🎨 Foundations | Colour variables, type, spacing/radius, mesh shader backgrounds, Glass and Frost materials |
| 🖼 Style Frame | One disposable Driver Home composition that tests the mood. Not a deliverable screen. |
| 🧩 Components | One section per component: Mobbin references → anatomy → all states → UX notes |
| 📱 Driver Flows | Screens assembled only from approved components, one flow per section |

**Access note:** the Figma account connected to Claude (`hjavaid@purdue.edu`) can edit `x2fPubLkytfeO9btWSoTu6`
but **not** the older file `v1oVBiIBAJeRBYPqLxH1J1`.

---

## 3. Foundations

### 3.1 Two materials (the core of the hierarchy)

| Material | Where | What it is |
|----------|-------|------------|
| **Glass** | Controls layer only: tab bar, bottom accessory, search capsule, map buttons, nav bar buttons, sheet chrome | Real Liquid Glass on iOS (from the kit). It is never used for content. This follows Apple's rule that glass belongs to the navigation layer. |
| **Frost** | Content cards on the mesh: station card, hero stat, grouped rows, booking card, receipt | Custom: translucent white fill, soft background blur, 1px inner highlight, very soft shadow. Quieter than Glass, so controls always read as the top layer. |

Plain **Surface** (opaque) is used where nothing sits behind it, such as inside sheets and long lists.

### 3.2 Colour

- **Neutrals:** taken from the iOS 27 kit's system colours (labels, fills, grouped backgrounds), so native chrome and custom content match.
- **Brand:** **Deep Emerald (heritage)** is the default `v4 · Brand` mode: primary `#0C7A4A`, pressed `#09653D`, energy `#3DD68C`, mesh mint `#9FE6C4` / aqua `#A9DCEB` / warm sand `#F1E3B8`, canvas `#F7F6F1`, tint `#E5F3EB`. Jade Monsoon, Sunset Ember and Volt Indigo stay as alternate modes for comparison.
- **Status:** Available → system green · In use → system orange · Booked → system blue · Offline → system grey · Error → system red. Users already know these meanings, and dark-mode pairs exist for later.
- **Contrast rule:** text never sits directly on the mesh. It always sits on Frost, Glass or Surface, keeping body text at ≥ 4.5:1 and large text at ≥ 3:1.
- Every component fill and stroke is **bound to a variable**, so the brand palette can be swapped in one place.

### 3.3 Mesh backgrounds

Built as Figma shaders and exported for Rayan as static images or a Flutter fragment shader. Three intensities:

| Intensity | Used on |
|-----------|---------|
| **Hero** | Top ~40% of Charge, Live session |
| **Quiet** | Bookings, Messages, Profile, list screens |
| **Celebrate** | Charge complete / receipt |

The map screen has **no mesh**; the map is the background.

### 3.4 Type

- **UI text:** the platform system font (SF Pro on iOS, so native chrome and custom content are one family; Roboto on Android). Follows iOS text styles (Large Title … Caption 2) so Dynamic Type works.
- **Brand display face:** used only for big numerals (kWh, Rs, %, time) and the wordmark. 2–3 candidates are shown in step 2. It must be bundleable (OFL or similar) so Flutter can ship it on both platforms.

### 3.5 Icons, spacing, shape

- **Icons:** SF Symbols on iOS. Material Symbols Rounded on Android (Apple's licence forbids SF Symbols on Android). Each component's notes include an SF → Material mapping row.
  - In Figma the `Icon / …` components are the **real SF Symbols** at Medium weight, exported as vectors with [`tools/sf-symbols`](../tools/sf-symbols/README.md). They are not redraws. Each icon's description carries its SF name and its Material equivalent.
  - The three EV plug symbols (`ev.plug.ac.type.2`, `ev.plug.dc.ccs2`, `ev.plug.dc.gb.t`) mark connector types. Android needs custom SVGs for them.
- **Spacing:** 4pt grid. Screen side margin 16pt (iOS 27 default for inset content).
- **Corners:** concentric: inner radius = outer radius − padding. Radius tokens follow the kit (sheets and large cards follow the device corner).
- **Touch targets** ≥ 44×44pt.

### 3.6 Brand (revised 2026-10-03)

- **Mark:** the heritage signature **P** (lightning bolt as the P's stem), rebuilt with true arcs, consistent 17°/23° angles and the original's parallel 3pt gap between bowl terminal and bolt. The plug/cable details are dropped from the compact mark (illegible below 48px); the original stays on the Brand page as reference.
- **Wordmark:** tucked lockup in the original's proportions. P is 2.2× the x-height, the bolt tip dips below the baseline, and the "a" of lowercase "akplug" tucks under the bowl so it reads as one word. Variants: Ink (default), Emerald, White.
- **App icon:** layered for Icon Composer (Background = emerald + mesh glow + soft light; Glyph = white P at 62.5%). Appearances: Default, Dark, Tinted.
  - **Flag:** the shipped iOS icon (`ios/Runner/Assets.xcassets/AppIcon.appiconset`) is still the default Flutter logo.
- **Favicon set:** 16, 32, 48, 180 (apple-touch), 192, 512.
- The first three overnight mark directions are archived on the Brand page.

---

## 4. Logic map (driver)

The full screen/state inventory is in [`driver-logic-map.md`](driver-logic-map.md), taken from the code.
In summary:

**Shell:** 5 tabs — Home · Charge · Bookings · Messages · Profile — plus the persistent live-charging panel.

| Flow | Screens |
|------|---------|
| Discover | Driver home (map / list, search, filters sheet, station preview), station detail, reviews, favourites |
| Book | Book a slot (date, time, vehicle, cost footer), confirm booking, schedule |
| Charge | Charge tab, QR scanner, manual charger-ID entry, start-session confirm, connecting |
| Live session | Active session (live telemetry), stop-charging confirm |
| Complete | Charging complete + receipt, review prompt |
| Bookings | Upcoming / Completed / Cancelled tabs, booking details sheet, cancel confirm |
| Messages | Inbox, chat thread, call sheet |
| Profile | Profile, edit profile, account settings, notifications, vehicles, add/edit vehicle, identity verification |
| Onboarding | Splash, story, sign in (Apple / Google / email), create account, verify email, log in, forgot password, choose role, add vehicle, location, notifications, all set |

### 4.1 Presentation-only improvements (logic unchanged)

These change *where* or *how* something is shown, never *what* happens:

1. **Live charging → native tab bar bottom accessory.**
   - Today's persistent charging panel becomes the iOS tab bar's bottom accessory (like Apple Music's mini player), visible from every tab.
   - Same data, same tap target (opens the active session).
2. **Station preview → floating Frost card over the map** (as in Places on Mobbin), expandable into the native sheet. Same content and actions.
3. **Start charging → slide-to-start control** (as in Lime). It prevents an accidental start, and the confirm step still exists.
4. **Bookings tabs → native segmented control** (Upcoming · Completed · Cancelled).
5. **Confirm and destructive dialogs → native alerts / action sheets** where the content is short. Rich confirms (booking cost breakdown) stay as sheets.

---

## 5. Components

### 5.1 Native vs custom

| Component | Native (iOS 27 kit) | Custom (Frost / ours) |
|-----------|:---:|:---:|
| Tab bar (5 tabs) + bottom accessory (live charge) | ● | accessory content is ours |
| Navigation bar (large title, back, trailing glass buttons) | ● | |
| Search capsule (map home) | ● | |
| Map control buttons (locate, layers, filter) | ● glass buttons | |
| Sheets (detents medium / large) | ● | sheet *content* is ours |
| Alerts, action sheets, context menus | ● | |
| Segmented control, toggles, date picker | ● | |
| Filter chips row | | ● |
| Map pins + clusters | | ● |
| Station card (floating) | | ● |
| Buttons: primary, secondary, glass-on-content, icon | primary/secondary follow kit button styles | slide-to-start ● |
| Grouped list rows / settings rows | follows kit inset-grouped anatomy | ● on Frost |
| Status pills | | ● |
| Hero stat (big number + caption) | | ● |
| Charging gauge (live %) | | ● |
| Booking card, receipt card, vehicle card | | ● |
| Date / time slot chips | | ● |
| Text fields | follows kit field anatomy | ● |
| Chat bubbles + composer | | ● |
| Empty / loading / error states | kit spinner | ● layout |

### 5.2 Build order (step 4)

1. Floating tab bar + bottom accessory
2. Search capsule + filter chips
3. Map pins + clusters + map buttons
4. Station card
5. Buttons + slide-to-start
6. Grouped list rows
7. Status pills
8. Hero stat + charging gauge
9. Sheets + dialogs
10. Inputs
11. Empty / loading / error states

The flow-specific cards (booking, receipt, vehicle, chat) are built inside their flow step, from these parts.

### 5.3 Per-component recipe

For every component:

1. **Mobbin:** 2–3 searches; 3–6 references placed in a `Refs` frame beside the component, each with a link.
2. **UX notes:** purpose, anatomy, states, interactions and motion, accessibility (target size, Dynamic Type at the largest size, VoiceOver label, contrast), SF → Material icon mapping, and the native API for Rayan (e.g. `UITabBarController` bottom accessory, `UISheetPresentationController` detents).
3. **Build:** a Figma component set with variants for every state. All fills, strokes, radii and spacing are bound to variables.
4. **Review:** a screenshot is sent to Hammad; the component is marked `Draft` until approved.

### 5.4 Android

Once an iOS component is approved, its Android counterpart is one extra frame:
- same layout
- Frost instead of Glass
- Material ripple and icon mapping

Not part of this first pass.

---

## 6. Flows (step 5)

Assembled in driver-journey order:
Discover → Station → Book → Charge → Live session → Complete → Bookings → Messages → Profile → Onboarding.

Each flow covers every state in the logic map (loading, empty, error, edge cases), not just the happy path.
A flow uses **only approved components**. Anything new it needs goes back through §5.3 first.

---

## 7. Review gates and overnight rule

- Every step ends with a screenshot to Hammad. Nothing is called final without his approval.
- **Overnight run (2026-10-03):** Hammad delegated the steps while asleep. Where a step needs his choice (mark, palette, display face), all options are built. Work continues on the recommended one, labelled **PROVISIONAL** in Figma. Because components are bound to variables, swapping the palette later is one change.

---

## 8. Risks

| Risk | Mitigation |
|------|------------|
| Native platform views (tab bar, glass buttons) layered over the Google Maps platform view may stutter or clip | Flag to Rayan before flow build; keep the custom map overlays (pins, station card) in Flutter |
| Frost blur over a live map is costly on low-end Android | Android Frost falls back to an opaque-translucent fill without blur |
| Mesh behind text hurts contrast | §3.2 contrast rule: text always sits on a material |
| Designs drift from real logic | Flows are checked against `driver-logic-map.md` state by state |
