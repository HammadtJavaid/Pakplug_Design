# Driver UI Revamp — Progress Log

Overnight run, 2026-10-03. Spec: [`2026-10-03-driver-ui-revamp-design.md`](2026-10-03-driver-ui-revamp-design.md) ·
Plan: [`../plans/2026-10-03-driver-ui-revamp.md`](../plans/2026-10-03-driver-ui-revamp.md) ·
Logic: [`driver-logic-map.md`](driver-logic-map.md)

Figma file: [PakPlug Design System](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System). Everything new is on the
`v4 · …` pages after the `——— v4 · Driver Revamp ———` divider. Old pages, variables and styles are untouched.

## Waiting on Hammad (morning)

| # | Decision | Where to look | Provisional pick |
|---|----------|---------------|------------------|
| H1 | Palette direction | [Palette directions](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=955-2) | **Decided: Deep Emerald (heritage)** — now the default mode everywhere |
| H2 | Logo mark | [Signature P · refined](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=991-65) | **Decided: heritage signature P, refined** + tucked wordmark + app icon + favicons |
| H3 | **Display face:** Sora / Geist / Bricolage Grotesque | [Typography](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=955-111) | **Sora** |
| H4 | **Add the "iOS and iPadOS 27" library to this file** (Assets → Libraries). The API cannot add it, and native chrome stays as stand-ins until it is added. | — | — |
| H5 | Approve or redirect the **mood test** | [Style frame](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=959-2) | — |

Switching any of H1–H3 is cheap:
- **Palette (H1):** set the `v4 · Brand` mode, or change the collection default. Every component and the mesh shader follow, because the mesh colours are bound to variables.
- **Display face (H3):** change the string variable `font/display` in `v4 · Scale`.
- **Mark (H2):** swap the mark component instance.

## Done

### Foundations

- **4 variable collections, 136+ variables** (`v4 · Brand` ×3 modes, `v4 · Primitives`, `v4 · Semantic`, `v4 · Scale`).
  - 0 `ALL_SCOPES`; Dart code syntax on all of them.
- **20 text styles:** SF Pro iOS ramp, plus Display XL–S with the font set by a variable.
- **6 effect styles:**
  - Frost Card / Frost Elevated
  - Glass Regular / Glass Clear (Figma's native Glass effect)
  - Shadow Button / Shadow Pin
- **Mesh shader "PakPlug Mesh"** (Figma fill shader, id `fdfc1a31-…`):
  - OKLab blending, domain warp, drift animation, grain
  - Colours bound to variables
  - 3 backgrounds: Hero, Quiet, Celebrate
- **Boards:** materials, palette directions, typography, brand marks + app icons.

### Components (`v4 · 🧩 Components` page)

Every component has Mobbin refs, a UX-notes card (purpose, anatomy, states, motion, accessibility, SF→Material icons, native API, logic mapping, flags) and a passed audit: 0 unbound paints and targets ≥ 44pt.

| ID | Component sets | Link |
|----|----------------|------|
| Icons | 31 SF-style icons | [Icons](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=958-2) |
| C1 | Tab Bar / Item (10) · Tab Bar (5) · Tab Bar Accessory / Live Charging (4) · Tab Bar / Minimized | [C1](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=965-2) |
| C2 | Chip (4) · Segmented Control (5) · Search Field (6) · Search Result Row (4) | [C2](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=969-142) |
| C3 | Map Pin (6) · Map Cluster (2, proposal) · User Location · Map Button · Map Controls (2) · Map Status Pill (2) + on-map showcase | [C3](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=973-222) |
| C5 | Button / Large (20) · Button / Medium (20) · Icon Button (6) · Slide to Start (4) | [C5](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=977-277) |
| C7 | Status Pill (12) + status→tone table for every code status | [C7](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=980-287) |
| C4 | Station Card (6: map preview / list / saved × default / loading) | [C4](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=981-295) |

C5 and C7 were built before C4 (atoms before molecules).

## Brand update (Hammad awake, 2026-10-03)

- **Emerald everywhere.** Deep Emerald is the default `v4 · Brand` mode, so every component, both mood tests and the mesh shader switched with no rebuild. Volt Indigo is kept as an alt mode.
- **Signature P refined**, plus a tucked "Pakplug" wordmark (Ink / Emerald / White), layered app icon (Default / Dark / Tinted) and favicons 16–512.
  - [App icon + favicon](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=992-94)
- The old mark is swapped for the P in the Search Field and in the style frame.
- **Flag:** the iOS app ships the default Flutter icon today.

## Fixes to the system made along the way

- **`text/secondary` is 76% grey, not iOS's 60%.** iOS's secondary label is only 3.4:1 on white. Ours is 5.3:1 on white and ≈4.7:1 on Frost over mesh.
- **`action/destructive` uses red/700, not systemRed.** White on systemRed was 3.6:1 and failed AA; now it is 6.0:1.
- **"Abstract spark" mark direction swapped for a rounded bolt.** The four-point sparkle now reads as an AI icon.

## Flags for Rayan

These are code-side and copy-only; none of them changes behaviour.

1. **Native shell spike.** Real iOS 26/27 glass tab bar + bottom accessory (`UITabBarController` + `UITabAccessory`) from Flutter. Check platform views vs. a native shell before flows are built.
2. **Copy:**
   - The charging panel says "{time} to full", but the value is booking-window remaining. Proposed: "{time} left".
3. **Data quirks seen in the code:**
   - KM ADDED is hard-coded "+92".
   - Battery % defaults to 40 when missing.
   - The booking details pill uses the raw status, so it can read "Upcoming" when the list says "Expired".
   - Paused bookings fall into no tab.
   - The empty-inbox "Find a charger" button is a no-op.
4. **Icons in code.**
   - Native iOS chrome (tab bar, nav bar, alerts) gets SF Symbols for free.
   - Icons drawn inside Flutter content need a small bridge on iOS that renders `UIImage(systemName:)`, through a platform view, a texture or a package.
   - Android uses Material Symbols Rounded. The mapping is in each icon component's description.
   - The three EV plug icons have no Material equivalent and need custom SVGs.
   - Don't put the exported SF vectors in the shared Flutter assets: Apple's licence limits them to Apple platforms.
5. **Presentation proposals** (same data, same actions):
   - price on map pins
   - optional pin clustering
   - glass status pill instead of the spinner chip / location snackbar
   - floating station preview card with distance shown
   - quick filter chips on the map that mirror the Filter & sort sheet
   - slide-to-start inside the Start-session sheet


## Icons → real SF Symbols (Hammad: "the icons suck", 2026-10-03)

The first icon set was 31 hand-drawn SF look-alikes, and they looked like it. They are now **Apple's actual SF Symbols**, so no new library was needed.

- **Source:** exported from macOS 26 as vectors with [`tools/sf-symbols`](../tools/sf-symbols/README.md).
- **Format:** Medium weight, 24pt frame, one optical size.
- **Coverage:** 63 icons in the [Icons section](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=958-2), grouped and labelled.
  - The 33 existing icons were swapped **in place**: same components and same vector layer. Every instance in every component, the style frame and the explorations kept its colour.
  - Old stroke colours were moved to fills: 55 instances.
  - 30 symbols are new, including Apple's EV set: `ev.charger`, `ev.plug.ac.type.2`, `ev.plug.dc.ccs2`, `ev.plug.dc.gb.t`, `bolt.car`. Also `wallet.pass` for the Charging Pass, Apple Maps' directions sign, share, info, warning, trash, gear and others.
- **Connector Row** has a new **Plug** swap (Type 2 / CCS2 / GB/T), so each connector shows its real plug shape. Drivers with Chinese EVs need to see GB/T vs CCS2 at a glance.
- **Quick Action Tile:** a usage row shows Book now (calendar) and Directions (Maps directions sign).
- **Naming:** names now match SF exactly (`search` → `magnifyingglass`, `filter` → `line.3.horizontal.decrease`, `qrcode` → `qrcode.viewfinder`, `keypad` → `circle.grid.3x3`, `plug` → `ev.plug.ac.type.2`).
  - SF Symbols has no `calendar.fill`, so the selected Bookings tab uses `calendar` ("Icon / calendar (selected)").
- **Not changed:** 8 small hand-drawn bits remain inside old exploration mock-ups. The A + B flows are rebuilt from components, so they don't carry over.

## C9 · Sheets + dialogs: done

[C9 section](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=1008-398):

- **Sheet parts:** Sheet Header, Quick Action Tile, Stats Row, Connector Row, Floating Action Pill.
- **Sheets:** Filter & sort, Directions, Confirm booking, **Choose vehicle**.
  - In Choose vehicle, incompatible vehicles stay readable, with the reason "Doesn't fit this charger (Type 2 (AC))".
- **Native-style Alert:** Destructive "Cancel booking?" and Default "Cannot start session".
- **C12 (Charging Pass parts):** Charging Pass (stacked/front × upcoming/completed/cancelled), Date Pill, Time Window, Availability Bar, Cost Footer.

## Divergent explorations (Hammad's request, 2026-10-03)

[Explorations page](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System?node-id=995-2) holds four concepts. Each has 3 screens, 4 Mobbin references and the same logic; anything new is flagged as a proposal.

| Concept | Screens | Inspired by | What's new (flag) |
|---|---|---|---|
| A · Maps-native | Discover with bottom search · Station place sheet · Book in sheet | Apple Maps iOS 26, Apple News (search tab + accessory) | "Ask host" pre-booking (no pre-booking chat in code) |
| B · Charging Pass | Bookings as Wallet passes · Pass detail · Pass → live | Apple Wallet, Agoda time window | Add to Apple Wallet (needs the official badge + PassKit) · charger code on pass |
| C · Live Everywhere | Lock Screen Live Activity + Dynamic Island · Aurora live screen · Home widgets | Tinder/FocusFlight Live Activities, Transit widgets | ActivityKit Live Activity (native) · nearest / next-booking widgets (the code already has a charging home widget) |
| D · Editorial Bold | Editorial home · Time-first booking scrubber · Celebration complete | Apple Games editorial, Rivian, Wonder, Instacart | Home becomes a feed with "Open map" (IA change) · drag-to-select time window |

**Recommendation:** combine them rather than pick one.
- **A** for discovery: it keeps Home map-first, as the logic requires.
- **B** for Bookings: the most distinctive and memorable concept.
- **C** for the live session, on and off the app: iOS-native strength.
- **D**'s time-first booking readout and celebration complete.
- Keep D's editorial home as optional content, not a replacement for the map.

### Data honesty

Two invented numbers were removed from C2 ("km per minute", "plugged in at 41%"). Every value shown exists in the logic map, or is marked as a proposal.

## Next

- C10 inputs (default / focused / filled / error / disabled)
- C11 empty / loading / error states
- Then the chosen flows (A · Maps-native discovery + B · Charging Pass bookings), one at a time, each checked against every state in the logic map: Discover → Station → Book → Bookings (passes) → Pass detail
- Later: Charge → Live session → Complete (C's live surfaces, D's celebration) → Messages → Profile → Onboarding
