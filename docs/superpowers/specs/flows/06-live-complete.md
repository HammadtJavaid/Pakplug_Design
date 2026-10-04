# 06 · Live charging + finishing: live session, stop, live surfaces, complete, receipt, rate the host

> **00-system alignment (2026-10-04, read first).** `00-system.md` is the single answer for navigation, sheets, motion, haptics, shared components, section names, formats, tones and materials; where this spec still differs, 00-system wins. Applied to this spec: (1) Sections are `Flow 6A · Live · Charging` (06.01–06.13), `Flow 6B · Live · Stop & accessory` (06.14–06.20 + the 06.21 link card), `Flow 6C · Live · Lock Screen & Dynamic Island` (06.22–06.28b), `Flow 6D · Complete · Summary & receipt` (06.29–06.39b), `Flow 6E · Complete · Rate & exit` (06.40–06.50) (00-system §4); the draft's 17-frame 06A broke the 14-frame limit. (2) Stop charging is `Button / Large` Type=On Mesh Destructive (C14) in every Live frame, including its Loading and Disabled states. (3) Toasts: 4 s / 6 s; only the stop-failure toast (06.16, 8 s) and the auto-stop toast (06.07, until resolved) differ; "Battery updated" stays 4 s; positions by bottom edge (00-system §1.5). (4) Sheets over Live (06.03, 06.05, 06.14) dim Live under the scrim but do not scale it; sheet-header Close buttons are `Icon Button` Fill S. (5) `tick` stays the 1 s clock; this spec's `pulse` (1.33 s ring) is the app-wide dot pulse; the stars shake is `M-shake` (320 ms). (6) OS frames 06.22–06.28b end with "· proposal". (7) Nav Bar on the meshes = Material=Frost (C1); milestone pills = Map Status Pill Surface=Frost Strong (C14); the End charging session sheet = `Sheet / Action` Kind=Destructive (C3); Estimate Row = C4; Live Activity, Dynamic Island, iOS / Lock Screen and Notification Preview = C13; Success Mark and Confetti = C12; Text Area = Text Field Multiline (C14).

Build spec for Flow 06. Research only: no Figma calls were made.
Sources: `BRIEF.md`, `NEW-COMPONENTS.md`, `driver-logic-map.md` §A (`DriverHomePersistentChargingPanel`), §D (ChargeScreen state 2 only), §E (`ActiveSessionScreen` → `ActiveChargingView`, `EndChargingSessionModal`), §F (`ChargingCompleteScreen` → `ChargingCompleteView`, `ChargingReceiptWidget`, `LeaveReviewModal`), §J (onboarding notification copy), Appendix 1–4; the revamp design spec (§4.1 "Live charging → native tab bar bottom accessory", concept C live surfaces, concept D celebration); specs `01-onboarding.md` (Success Mark, Confetti, Button On Mesh, Notification Preview, motion tokens M-rise / M-push), `02-discover.md` (motion tokens §4.0, haptic map, accessory rules 02.13 / P11), `04-station-book.md` (Inline Notice, Toast usage, Celebrate rule on 04.43), `05-charge-start.md` (Level Slider, Estimate Card, the planner's numbers and reminder lines CH18, Charge tab state 2 = 05.04, the Connecting → Live hand-off). 24 Mobbin searches (22 screen searches, 2 flow searches) whose images were reviewed; 86 references (85 unique screens/flows) are cited in §5. Reviewed and corrected on 2026-10-04 (see "Review notes" at the end).

Notation (same as 02 and 04)
- `[P]` = proposal (not in the logic map). Every `[P]` is listed in §7 and must appear in the FLAG — PROPOSALS block of the logic-check card.
- "Real copy" = quoted verbatim from the logic map. `{…}` = a template value from the code; `…` inside a quote = truncated in the logic map.
- Components: `Name [set id] → Variant id`, props as `Prop#id`. Icons by SF name + component id from the brief.
- Motion tokens and haptics are the shared ones from `02-discover.md` §4.0 (`snappy`, `smooth`, `bouncy`, `fade.quick` 150 ms, `fade.std` 220 ms, `camera`) and `01-onboarding.md` (`M-rise`, `M-push`, `M-replace`). This flow adds `tick`, `roll`, `sweep`, `breathe`, `comet`, `pulse` (§4.0).
- Each micro-interaction is written: **Trigger** → response · timing + easing · haptic · VoiceOver · RM (Reduce Motion fallback).

---

## 1. Overview

**Goal.** While the car charges, the driver can see in one glance how far along they are, what it costs, and how long is left, and they understand which numbers are estimates. The app can't read the car's battery, so the estimated battery % is always marked "≈ … est." and the "How we estimate" sheet shows the arithmetic. They can leave the screen (the tab-bar accessory, Lock Screen Live Activity and Dynamic Island keep the session visible), stop safely (confirm sheet, Stopping state, clear errors), and finish with a calm celebration: a summary, a receipt, and a one-tap rating for the host. Done leads to the Charge tab.

**One story (AC, from the brief).** GreenVolt · DHA Phase 5 · Type 2 (AC) 7.4 kW · Rs 42/kWh · host Bilal. Booking Today, Sat 4 Oct · 6:00 → 7:00 PM · 1 h · BYD Atto 3 (60.5 kWh, LEB-2481). Flow 05's planner gives: start battery **20%**, plan by time until slot end (1 h) → **≈6.8 kWh · +11% · ends ≈31% · Rs 286** (Estimate). Live hero moment: **6:32 PM**, 32 min in, 28:00 left, +3.6 kWh, ≈26%, Rs 152. Ending soon at **6:55**. The slot ends at **7:00** → auto-stop → Complete: **1 h 00 min · 6.8 kWh · Rs 286 · ≈31% est.** · receipt PP-2410-0482.

**Screens in this flow (12):** Live charging · How we estimate sheet [P] · Update battery % sheet [P] · End charging session sheet · Tab-bar accessory (on other tabs) · Charge tab (while charging = 05.04, linked, not rebuilt; after the session = 06.50) · Lock Screen Live Activity [P] · Dynamic Island [P] · Lock Screen notifications [P] · Charging complete · Receipt image · Rate your session (LeaveReviewModal).
**Frames:** 54 (25 × P1, 29 × P2). 06.21 is a link to 05.04, not a frame.

**Entry points**
| From | Action | Lands on | Logic |
|---|---|---|---|
| Flow 05 · Connecting to charger | auto after 2 s | 06.01 → 06.02 Live (slide up) | `ConnectingToChargerScreen` replaces itself with `ActiveSessionScreen` |
| Tab-bar accessory (any tab) | tap the body | 06.02 Live (expands from the accessory) | pill → slideUp `ActiveSessionScreen` |
| Tab-bar accessory | **Stop** | 06.14 confirm sheet over the current tab | pill → `EndChargingSessionModal` (root) |
| Charge tab state 2 (05.04, built by Flow 05) | **View session** | 06.02 | slideUp `ActiveSessionScreen` |
| Lock Screen Live Activity / Dynamic Island / notification [P16, P17] | tap | 06.02 (or 06.30 when finished) | reuses the widget intent `active_session` → tab 1 then `ActiveSessionScreen`, and the "pending charging complete" resume |
| App relaunch after a stop while killed | auto | 06.30 Complete (no confetti) | `DriverMainScreen` pending-complete check |

**Exits**
| From | Action | Goes to | Owner |
|---|---|---|---|
| Live | chevron.down / swipe down | Previous tab, accessory visible | Shell |
| Live / accessory | End session → stop OK | 06.29 → 06.30 Complete | this flow |
| Live | slot ends (remaining ≤ 0) | 06.07 auto-stop → Complete | this flow |
| Live | session closed remotely | 06.10 hold (1.2 s) → Complete (06.32 notice) | this flow |
| Live | **Message host** [P14] | `ChatThreadScreen(bookingId)` on root | 09 Messages |
| Complete | ✕ or **Done** [P20] | Driver shell, **Charge tab** (index 1) | logic: `pushNamedAndRemoveUntil(driverHome, tab 1)` |
| Complete | stars / Leave a review | LeaveReviewModal (06.40) | this flow |
| Complete | Download receipt | Photos (OS) | OS |

**Sections on Driver Flows (946:8).** 54 frames are too many for one readable section, so this flow uses five sections (00-system §4), each 160 below the previous page bottom at x=0 (copy the fills of section 1076:2). Each section has the brief's anatomy: title (Title 1, text/primary) at (80,80), status line (Footnote, text/secondary) at (80,124), then per row a Refs · Mobbin card on the left, the phone frames (gap 80, labels `06.nn · Screen · State` in Footnote Emph text/secondary above each frame), a Micro-interactions card on the right, and one Logic check card at the end of the section with the **FLAG — PROPOSALS** block (title in text/brand) listing that section's [P]s from §7 plus the dummy-data note.

| Section | Rows | Status line |
|---|---|---|
| `Flow 6A · Live · Charging` | 1 Live charging (Hero mesh) 06.01–06.13 (13 frames) | "Live session on the Hero mesh, estimates, every state · 13 frames · built from components" |
| `Flow 6B · Live · Stop & accessory` | 2 Stop 06.14, 06.14b, 06.15, 06.16 · 3 In-app live surfaces 06.17, 06.17b, 06.18–06.20 (06.21 = link card to 05.04) (9 frames) | "Stop confirm, stopping, errors, tab-bar accessory states · 9 frames" |
| `Flow 6C · Live · Lock Screen & Dynamic Island` | 4 OS live surfaces [P] 06.22–06.28, 06.28b (8 frames) | "Live Activity, Dynamic Island, notifications · 8 frames · OS surfaces are proposals" |
| `Flow 6D · Complete · Summary & receipt` | 5 Complete (Celebrate mesh) 06.29–06.35, 06.35b · 6 Receipt 06.36–06.39, 06.39b (13 frames) | "Charging complete, summary, receipt image and saving · 13 frames" |
| `Flow 6E · Complete · Rate & exit` | 7 Rate the host 06.40–06.49 · 8 Exit 06.50 (11 frames) | "LeaveReviewModal in every state, back to the Charge tab · 11 frames" |

Frames with a "b" suffix were added in review; the 06.01–06.50 numbers used by other specs (02, 05, 07) stay stable.

---

## 2. Screens & states

### 2.0 Shared rules, data and geometry

#### 2.0.1 Estimate maths (dummy; Hammad wires the backend later)
Show these formulas in the "How we estimate" sheet (06.03) and in the Logic card. Label every result "Estimate".
- **kWh source.** Logic: the KWH cell shows the session's `energyKwh` (1 decimal) or **"—"** when it is null. Design: (a) `energyKwh` present → show it (the charger's meter); (b) null → show the time estimate `kWh(t) = kW × hours × 0.92` (efficiency 92%, kW = `currentPowerKw`, else the connector's rated kW) **[P37: replaces the logic's "—"]**; (c) neither meter nor any kW known → "—" (real). The dummy story uses (b), the common case for home chargers without a live meter feed.
- `battery%(t) = start% + kWh ÷ battery kWh × 100`, capped at 100. Needs the start % from Flow 05's planner (CH3) and the vehicle's battery size (optional in Add vehicle); without either the battery is Unknown (06.08, P25).
- `cost(t) = kWh × Rs/kWh` (per-kWh stations). Per-hour stations: `elapsed hours × Rs/hr`. Logic: SO FAR = `liveTimeBasedRunningCostPkr` (elapsed time × per-hour rate, falling back to the running estimate); the dummy story is per-kWh, so it uses the running estimate.
- **Rounding while live:** floor kWh to 0.1 and rupees to Rs 1 (a running count never shows what hasn't been delivered yet); the ≈ battery % rounds to the nearest 1% (it is already an approximation, and rounding matches Flow 05's planner, so "≈26% at 6:30" is the same number on the plan and on Live). **Final (Complete):** kWh and Rs round to the nearest value; the billed amount from the backend always wins. Displayed values never go down (§8.5).

Time series for the AC story (7.4 kW, 60.5 kWh, Rs 42/kWh, start 20% at 6:00 PM). Every frame uses these numbers:

| Clock | Elapsed | Left | kWh (live) | ≈ battery | Rs so far | Used in |
|---|---|---|---|---|---|---|
| 6:00:08 PM | 0:08 | 59:52 | 0.0 | ≈20% | Rs 0 | 06.01 |
| 6:30 PM | 30 min | 30:00 | 3.4 | ≈26% | Rs 142 | 06.04 (halfway); 06.28b (30 min plan done; 05.24 planned "3.4 kWh · Rs 143 · ≈26%", the Rs 1 gap is live floor vs plan rounding) |
| **6:32 PM** | 32 min | **28:00** | **3.6** | **≈26%** | **Rs 152** | 06.02, 06.03, 06.05, 06.08, 06.09 (6:33: 3.7 · Rs 157), 06.14, 06.14b, 06.15, 06.16, 06.18–06.20, 06.22, 06.25, 06.26 |
| 6:44 PM | 44 min | 16:00 | 4.9 | ≈28% | Rs 209 live → **5.0 kWh · Rs 210 billed** | 06.10 (live, frozen), 06.32 (final) |
| 6:51 PM | 51 min | 9:00 | 5.7 | ≈30% (M2 milestone, 29.6 rounds to 30) | Rs 243 | haptic + VO only |
| **6:55 PM** | 55 min | **5:00** | **6.2** | **≈30%** | **Rs 262** | 06.06, 06.17, 06.23 |
| 7:00 PM | 60 min | 0:00 | 6.8 | ≈31% | Rs 285 live → **Rs 286 billed** | 06.07, 06.17b, 06.24, 06.27, 06.30 |

Check (7.4 kW × 0.92 = 6.808 kWh per hour; 60.5 kWh battery; Rs 42/kWh): 32 min → 3.631 kWh → floor 3.6 · Rs 152.5 → 152 · 20 + 6.0 = ≈26%. 44 min → 4.993 → 4.9 live / 5.0 final · Rs 209.7 → 209 live / 210 final. 60 min → 6.808 → 6.8 · Rs 285.9 → 285 live / 286 final · 20 + 11.25 = ≈31%.

DC state demo (brief): Gulberg Galleria Charger · CCS2 60 kW · Rs 68/kWh · BYD Atto 3 from 20%, booked 6:00–7:00 PM, plan "by target 80%" → 20% → 80% = 36.3 kWh ≈ 40 min · Rs 2,468. At 6:40 PM: ≈80%, 36.3 kWh, Rs 2,468, power 52 kW (tapering, dummy), 20:00 left. Used in 06.12 and 06.28.

#### 2.0.2 Estimate display rules
1. A battery % is **always** written with the prefix "≈" and, where there is room, the suffix "est." Examples: gauge "≈26%" + caption "est. battery"; accessory "Charging · ≈26%"; confirm sheet "Your car is at ≈26%"; Live Activity "≈26%" + "est.".
2. The "≈" glyph is set at about 55% of the number's size, top-aligned to the cap height (gauge: "≈" at 30pt beside "26%" at Display/XL 56). In Figma use one text node with mixed sizes: character 0 = 30pt, the rest = the Display style.
3. Only the battery % carries "≈". kWh and Rs are written plain in tiles and pills while live, because the stats card carries the one estimate line "Estimate. The charger's meter decides the final amount." (brief copy) right under them. Inside the "How we estimate" sheet (06.03), which explains the maths, the time-estimated kWh is written "≈3.6 kWh"; when the meter value (`energyKwh`) is present that row reads "3.6 kWh" with the formula line "From the charger's meter". On Complete, a billed total is final (no disclaimer). The battery stays "≈31% est.".
3a. When the battery is Unknown (P25), every place that would show "≈X%" shows the energy instead: gauge "+3.6 kWh added", accessory and Charge tab title "Charging · +3.6 kWh", stop sheet body without the "Your car is at" clause (06.14b), Live Activity "+3.6 kWh". A made-up % (the logic's default 40) is never shown.
4. Numbers use tabular figures (`monospacedDigit` / Flutter `FontFeature.tabularFigures()`), so ticking digits never shift the layout.
5. Times show as 12-hour "6:32 PM" (locale). The logic's summary uses "HH:mm" (24 h) [P24].
6. Countdown format: under 1 h "28:00" (mm:ss); 1 h or more "1:28:00" (h:mm:ss), as in the logic.

#### 2.0.3 Contrast on the meshes (measured rule from the brief, applied)
- **Hero mesh (Live):** status bar, nav buttons and the overline sit on the top glow (y < 140), so they use `text/primary` (black). Everything placed straight on the mesh below y 140 (gauge text, time-left Hero Stat, tip line) uses `text/onMesh` (solid white, 4.7–5.7:1 measured). There is never `text/secondary` on the mesh. Cards with grey text (stats card, session progress card) use **Frost Strong** `bg/frostStrong` 948:44 (4.6:1), never Frost 68% (3.7:1).
- **Floating chrome on the Hero mesh = Frost Strong (brief rule), applied to every floating element in this flow:** the Nav Bar's three Icon Buttons (instances are Glass M; override their fill to `bg/frostStrong` and keep the icons `icon/primary`), the `Map Status Pill` Notice (glass by default; override its fill to `bg/frostStrong`, text `text/primary`), the Stop button (On Mesh Destructive, Frost Strong fill), the Battery-unknown chip (06.08) and the ≈80% tip capsule (06.12). The same overrides apply on the Celebrate mesh (✕ close button on 06.30).
- **Glow behind the gauge:** the `Glow · breathe` ellipse is a **radial ring**, not a disc: transparent from the centre to radius 84, `energy` 948:83 at 22% at radius 120, back to 0% at 150. The gauge's centre text ("≈26%", "est. battery") therefore sits on plain mesh, where white measured 4.7–5.7:1. **Builder:** screenshot 06.02 at the breathe peak (opacity 0.85) and measure the white "est. battery" caption (Caption 1, small text, needs 4.5:1); if it fails, lower the ring's peak to 14%.
- **Celebrate mesh (Complete):** the brief says "same rule (deep base)", i.e. black over the top glow and white below. The Celebrate mesh's glow sits lower than Hero's (centre ≈ y 227) with a bright `energy` blob around y ≈ 332 where white measures ≈ 2:1, so a literal "white below 140" would fail. This spec (and 01's All set, which copies it) therefore keeps black inside the glow down to y 275: Success Mark, title and subtitle in `text/primary`. From y 290 to 700 **nothing sits directly on the mesh**: summary and rate content live on `bg/surface` cards (5.3:1 for grey text). The bottom (y > 700) is the deep base, where the "On Mesh" buttons (white fill, and plain white label) pass (4.7–5.7:1, from 01). **Builder (required, same check as 01.41):** export 06.30, measure black against the darkest pixel behind the title (Large Title 34 = large text, needs ≥ 3:1) and the subtitle (Body 17 = normal text, needs ≥ 4.5:1) with `scratchpad/contrast.py`, and write the two ratios in the Logic card. If either fails, move the title and subtitle into the top of the summary card (Title 2 + Body, normal colours) and slide the mark down 40.
- **Lock Screen / Dynamic Island (OS mocks):** the Live Activity background is `mesh/deep` 1062:3 (solid #04432D) with `text/onMesh` text and `energy` 948:83 accents (#3DD68C on #04432D ≈ 6.5:1). The Dynamic Island is system black (#000, OS-owned, not a token).

#### 2.0.4 Live screen master geometry (06.02 · 6:32 PM). Every Live state is a delta of this

| Layer | Position / size | Component · overrides |
|---|---|---|
| Background | (0,0) 402×874 | `Background / Mesh Hero` 951:7416 instance, resized |
| Glow | 300×300 at (51,104), behind the gauge | Radial ring (§2.0.3): `energy` 948:83, 0% to radius 84 → 22% at 120 → 0% at 150, layer blur 24. Name `Glow · breathe` |
| Status bar | (0,0) | `iOS / Status Bar` Dark 996:398 |
| Nav bar | (0,54) 402×52 | `Nav Bar` Inline 1087:607, `Title#1087:0` "" (empty), background none. `Leading#1087:3` on → "Leading button" Icon chevron.down 1025:483 (**Minimize** [P15: top-left]); `Trailing 1#1087:6` on → info.circle 1025:472 (**How we estimate** [P6]); `Trailing 2#1087:9` on → message 958:42 (**Message host** [P14]). All three buttons: fill overridden to `bg/frostStrong` 948:44 (floating chrome on the mesh), icons `icon/primary` 948:61 |
| Overline | centred, y 110, h 16 | Auto-layout row, gap 6: 8pt circle `status/available` 948:71 (live dot) + Caption 1 Emph, caps, `text/primary`: **"CHARGING · GREENVOLT · DHA PHASE 5"** (real `"CHARGING · {STATION NAME}"`; when the name is missing, the real fallback **"CHARGING · CHARGING STATION"**). Max width 300; a long name truncates in the middle of the station part with "…" |
| Gauge | (81,134) 240×240 | `Charging Gauge` Charging 987:392. Centre value **"≈26%"** (Display/XL 56, "≈" at 30pt, rule 2.0.2), caption **"est. battery"** [P1; replaces the ring caption "CHARGING"], both `text/onMesh`. Ring: track white 16%; **start segment** 0→20% white 40%; **estimated-so-far segment** 20→26% `energy`; **planned segment** 26→31% dotted 2pt `energy` 50%; **start tick** at 20% and **plan target** hollow dot at 31% [P5] (needs the gauge extension in §6). |
| Time left | (16,386) 370×64 | `Hero Stat` M Center 986:441: `Caption#986:0` **"Left in your slot"** [P3; real ETA label "to full"], `Value#986:7` **"28:00"**, `Detail#986:14` **"Ends 7:00 PM"** [P4], `Show detail#986:21` on. All three text fills → `text/onMesh` 1067:505 |
| Stats card | (16,466) 370×108 | Auto-layout (vertical, padding 12/12, gap 8), fill `bg/frostStrong` 948:44, radius `radius/lg` 948:117, 1pt `stroke/hairline` 948:88. Row (horizontal, 3 × FILL, 1×40 `stroke/separator` dividers): `Stat Tile` 986:446 ×3: **Energy** `Label#986:28` "Energy" [P41 label; real "KWH"], `Value#986:29` "3.6" (time estimate [P37]; the logic would show "—" until `energyKwh` arrives), `Unit#986:30` "kWh" · **So far** "So far" [P41, real "SO FAR"] / "Rs 152" / "" · **Power** "Power" [P2; replaces hard-coded "KM ADDED +92"] / "7.4" / "kW". Tile values use the Display style the Stat Tile carries (SF Pro Light), tabular figures. Hairline, then Caption 1 `text/secondary` centred: **"Estimate. The charger's meter decides the final amount."** (brief copy) [P8] |
| Session progress | (16,590) 370×104 | **Session Progress** (new, §6), State=Charging, Frost Strong. Header: left Footnote Emph `text/primary` **"Plan · until 7:00 PM"**, right Footnote `text/secondary` **"≈31% · Rs 286 est."** (the plan comes from Flow 05's planner [05-CH3–CH5]; it must be kept with the session, locally or on the backend, so Live can show it [P4]; with no plan saved, the header reads "Slot · until 7:00 PM" and the right side is hidden). Track 338×6, fill 53% (`brand/primary` 947:3). Nodes: start 10pt `brand/primary`; now 16pt `energy` with 3pt white stroke and a pulse ring; end 10pt `bg/surface` with 2pt `stroke/separator`. Labels (Caption 1 secondary over Caption 1 Emph primary): left **"Plugged in" / "6:00 PM"** (real "Plugged in"), centred on the now node **"Now" / "6:32 PM"** (real "Now · X%"; the % lives in the gauge), right-aligned **"Slot ends" / "7:00 PM"** [P4] |
| Tip | (16,710) 370×20 | Auto-layout centred, gap 6: battery.75percent 1023:481 16pt `text/onMesh` + Footnote `text/onMesh` **"Stopping under 80% helps your battery last longer."** (real) |
| Stop | (16,772) 370×52 | `Button / Large` **Type=On Mesh Destructive** Default (00-system C14: `bg/frostStrong` + Glass/Regular fill, label `text/destructive`, icon `action/destructive`), label **"Stop charging"** (real), `Leading icon#978:0` on, `Icon#978:21` → stop.fill 958:64. Its Loading and Disabled states serve 06.07, 06.10 and 06.15. |
| Home indicator | (0,840) | `iOS / Home Indicator` Light 996:427 (deep mesh at the bottom) |

No tab bar (full-screen cover, logic: slideUp on root). No scrolling at default text size. At AX sizes the content scrolls and Stop stays pinned (§8.18).

#### 2.0.5 Complete master geometry (06.30 · 7:00 PM)

| Layer | Position / size | Component · overrides |
|---|---|---|
| Background | (0,0) 402×874 | `Background / Mesh Celebrate` 951:7418 |
| Status bar | (0,0) | Dark 996:398 (glow at the top) |
| Close | (342,54) 44×44 | `Icon Button` Glass M 979:277, `Icon#979:0` xmark 958:72 (real "Close X (top right)"), fill overridden to `bg/frostStrong` (floating chrome on a mesh), icon `icon/primary` |
| Success Mark | (157,100) 88×88 | **Success Mark** (01 dependency) Size=L, Style=On mesh (white disc, brand check); effect Shadow/Button |
| Title | centred, y 204, width 340 | Large Title, `text/primary`: **"Charging complete"** (real) |
| Subtitle | centred, y 248 | Body, `text/primary`: **"Your vehicle is ready to go"** (real) |
| Summary card | (16,292) 370×244 | **Session Summary Card** (new, §6), Context=Complete: `bg/surface`, radius `radius/xl` 948:118, effect Frost/Card, padding 20, gap 16. (1) `Hero Stat` L Leading 986:429: Caption **"Total"** (real), Value **"Rs 286"**, Detail **"6.8 kWh × Rs 42/kWh"** [P21]. (2) Hairline. (3) Row of 3 `Stat Tile`: **"Battery" "≈31%" "est."** · **"Energy" "6.8" "kWh"** · **"Time" "1 h 00" "min"** [P41: the real stat cards are Battery / kWh / Total; Total moves up to the Hero Stat, "kWh" becomes the label "Energy" with the unit, and Time comes from the real summary "Duration"]. If kWh is null the logic prints "N/A"; we print "—" with the accessibility label "not available" [P41], the same unknown mark as Live. (4) Row: mappin 1025:485 16pt `icon/secondary` + Footnote `text/secondary` **"GreenVolt · DHA Phase 5 · 6:00 – 7:00 PM"** |
| Rate card | (16,552) 370×128 | **Rate Prompt** (new, §6), State=Empty: `bg/surface`, radius xl, padding 16/16, gap 6. Headline **"How was your session?"** (real modal title) + Footnote `text/secondary` **"Your rating helps the next driver."** [P19] + `Rating Stars` Value=0 1088:632 (5 × 44pt, left at x 8 inside the card). Accessible name "Leave a review" (real CTA) |
| Done | (16,712) 370×52 | `Button / Large` **Type=On Mesh** (01 dependency): **"Done"** [P20] |
| Download receipt | (16,772) 370×52 | `Button / Large` **Type=On Mesh Plain** (01 dependency): **"Download receipt"** (real), leading icon square.and.arrow.up 1024:503 (wanted: square.and.arrow.down) |
| Home indicator | (0,840) | Light 996:427 |

#### 2.0.6 OS mock geometry (Lock Screen, Dynamic Island) [P16]
- **Lock Screen frame:** `Background / Mesh Hero` 951:7416 as wallpaper (same as 01's Illustration / Lock Screen) + full-bleed rect `bg/scrim` 948:48 named `Lock dim`. Status bar Light 996:411. Date "Saturday 4 October" (SF Pro Semibold 20, white, centred, y 72). Clock (SF Pro Medium 104, white, centred, y 96), not bound: label the group "OS-owned". The Semibold date is iOS system chrome (like the status bar's 9:41), the only allowed exception to the brief's "no Bold/Semibold in UI"; nothing PakPlug draws on these frames uses Semibold. Two 50×50 glass circles at (46,770) and (306,770) for flashlight/camera (plain, no icons). Home indicator Light.
- **Live Activity (Lock Screen):** (16,560) 370×160, radius 24, fill `mesh/deep` 1062:3, 1pt `stroke/highlight` 948:89. Built as the new **Live Activity / Charging** component (§6).
- **Dynamic Island:** compact capsule 250×37 at (76,11); minimal 37×37 circle at (352,11); expanded 378×176 at (12,11), radius 44. Fill #000 (OS-owned). New **Dynamic Island / Charging** component (§6). Background behind the island in DI frames: the Map image (copy the fills of 996:430) at full size: the driver is in another app, such as Maps.

#### 2.0.7 Floating feedback positions (Toast 1088:631, 370 wide, x 16; 00-system §1.5 bottom edges win, the y values below assume h 56)
- Live (Stop at 772): Toast y **704** (bottom 760).
- Complete (buttons from 712): Toast y **644**.
- Home with accessory: Toast y **556** (bottom 612, 12pt above the chips, which sit at y 624 when the stack is raised 60pt for the accessory). This is 02's rule 22: a toast never covers the tab bar, the accessory, the chips or the search capsule.
- Review sheet (Submit at 772): Toast y 704; with the keyboard up (06.41–06.43) y 416 (12pt above Submit riding on the keyboard at 478).
- Top status pill on Live (milestones, offline, stopped): `Map Status Pill` Notice 975:253, centred at y **106** in place of the overline, fill overridden to `bg/frostStrong` (floating chrome on the mesh), text `text/primary`, icon 16pt.

### 2.1 Frame table

Priority: **P1** = build tonight; **P2** = if time allows. "Live master" = §2.0.4; only the differences are listed.

#### Row 1 · Live charging (Mesh Hero)

| # | Frame | Pri | Background | Layout (delta from the Live master) | New |
|---|---|---|---|---|---|
| 06.01 | `06.01 · Live · Starting (6:00 PM)` | P2 | Mesh Hero | Overline hidden; `Map Status Pill` Notice 975:253 (fill `bg/frostStrong`) at y 106: bolt.fill 958:35 + "Charging started" [P9]. Gauge mid-sweep: start segment only (0→20%), value "≈20%", caption "est. battery". Hero Stat "59:52" / "Ends 7:00 PM". Tiles: Energy "0.0" kWh · So far "Rs 0" · Power "—" (unit ""), with Caption 2 `text/secondary` "Ramping up" under the tile [P35]. Session progress fill 0%, now node on the start node, label "Now / 6:00 PM". | — |
| 06.02 | `06.02 · Live · Charging (6:32 PM)` ★ | P1 | Mesh Hero | Exactly §2.0.4. | Session Progress, Gauge plan arcs |
| 06.03 | `06.03 · Live · How we estimate` | P1 | 06.02 behind, dimmed with `bg/scrim` (not scaled: 00-system sheet rule); status bar Dark | Sheet (0,316) 402×558, `bg/surface`, top radius `radius/sheet` 38, grabber 36×5 `bg/fillStrong` at (183,321). `Sheet Header` Form 1008:413 at (0,332): `Title#1008:0` **"How we estimate"** [P6], `Subtitle#1008:3` **"PakPlug can't read your car's battery, so we work it out from what we know."** [P6], trailing Fill S xmark. 4 × **Estimate Row** (new) from y 410, gap 4, each 370×64: ① battery.75percent · "You started at" · **"20%"** · "You entered this before charging." ② bolt.fill · "Energy so far" · **"≈3.6 kWh"** · "7.4 kW × 32 min × 92% efficiency" (meter variant, documented beside the frame: "3.6 kWh" · "From the charger's meter") ③ car.fill 1024:474 · "Battery now" · **"≈26%"** · "20% + 3.6 kWh of 60.5 kWh (BYD Atto 3)" ④ creditcard 1025:494 · "Cost so far" · **"Rs 152"** · "3.6 kWh × Rs 42/kWh". Values in Display/S (SF Pro Light, tabular; same as 05's Estimate Card). **Inline Notice** (04 dependency) Tone=Neutral at (16,682) 370×48: info.circle + **"Estimate. The charger's meter decides the final amount."** `Button / Large` Secondary Default 978:307 at (16,772): **"Update battery %"** [P7]. Home indicator Dark. | Estimate Row |
| 06.04 | `06.04 · Live · Halfway (6:30 PM)` | P2 | Mesh Hero | Status pill at y 106 (Frost Strong): bolt.fill + **"Halfway through your slot"** [P9]. Values: "≈26%", "30:00", 3.4 kWh, Rs 142, 7.4 kW. Progress fill 50%, "Now / 6:30 PM". | — |
| 06.05 | `06.05 · Live · Update battery %` [P7] | P2 | 06.02 dimmed with `bg/scrim` (not scaled); status bar Dark | Sheet (0,292) 402×582 `bg/surface`, top radius 38, grabber (183,297). `Sheet Header` Form 1008:413 at (0,308): **"What does your car show now?"** / **"We'll re-base the estimate from this moment."** [P7], trailing Fill S xmark. Value **"28%"** Display/XL `text/primary` centred at y 396 (h 64) + Footnote `text/secondary` centred at y 466: **"Our estimate now: ≈26%"** [P7]. **Level Slider** (05 dependency) Mode=Battery State=Default 370×56 at (16,496), fill at 28%, `Show min/max` on ("0%" / "100%" Caption 1 `text/tertiary` at y 558). Presets row at y 586: `Chip` Fill/No 970:164 × 5, 66 wide, gap 10: "10%" "20%" "30%" "50%" "80%" (05's presets; none selected because 28 isn't a preset). Footnote `text/secondary` at (16,640): **"Your car's screen is the most accurate source."** `Button / Large` Primary Default 978:277 **"Update estimate"** at (16,712) (Disabled 978:291 until the value differs from the estimate), Tertiary Default 978:337 **"Cancel"** at (16,772). Home indicator Dark. | uses 05's Level Slider |
| 06.06 | `06.06 · Live · Ending soon (6:55 PM)` | P1 | Mesh Hero | Gauge "≈30%" (planned segment 30→31%). Hero Stat **"5:00"** / "Ends 7:00 PM". Tiles 6.2 kWh · Rs 262 · 7.4 kW. Session Progress **State=Ending**: fill 92%, now node `status/warning` 948:75, header right replaced by `Status Pill` Warning S 980:320 **"Ending soon"** [P10]. The tip row is replaced by **Inline Notice** Tone=Warning at (16,702) 370×48 (`status/warningTint` fill, so it is a card, not text on the mesh): exclamationmark.triangle.fill + **"Charging stops automatically at 7:00 PM."** [P10]. | — |
| 06.07 | `06.07 · Live · Slot ended (7:00 PM)` | P1 | Mesh Hero | Overline **"STOPPING…"** [P33]. Gauge frozen at "≈31%", the glow is static (no breathe/comet). Hero Stat **"0:00"**, Detail "Ended 7:00 PM" [P4]. Tiles 6.8 kWh · Rs 285 · 7.4 kW. Progress fill 100%, the end node filled `brand/primary`. Stop → `Button / Large` On Mesh Destructive **Loading** (00-system C14). `Toast` Neutral 1088:611 at (16,704): `Message#1088:0` **"Session time reached. Stopping charging automatically..."** (real), `Action#1088:5` off. | — |
| 06.08 | `06.08 · Live · Battery unknown` | P1 | Mesh Hero | Driver skipped the start % in 05 (or the vehicle has no battery size). `Charging Gauge` **Unknown** 987:409: centre **"+3.6"** Display/XL + Caption 1 **"kWh added"**; the ring shows slot time (53%), not battery [P25]. Tiles: **"So far" "Rs 152"** · **"Power" "7.4" "kW"** · **"Battery" "—"**. Session progress header right **"6.8 kWh · Rs 286 est."**. Accessory/Charge-tab title in this state: "Charging · +3.6 kWh" (rule 2.0.2-3a). Tip row → `Chip` Fill/No 970:164 centred at y 706, fill → `bg/frostStrong`, `Leading icon#970:5` on → battery.75percent, `Label#970:0` **"Add your battery now"** (the same label as 05.28's chip, so the action reads the same before and during charging) [P7], `Chevron#970:15` on. Tap → the 06.05 sheet. | — |
| 06.09 | `06.09 · Live · Connection lost` [P11] | P1 | Mesh Hero | Clock 6:33. Status pill at y 106 (Frost Strong): exclamationmark.triangle.fill `status/warning` (wanted: wifi.slash) + **"Reconnecting… · Last update 6:32 PM"** [P11; the time is the app's last successful poll, kept locally]. Glow → desaturated (`bg/fillStrong` at 30%), no comet. Gauge "≈26%" (energy segment at 60% opacity). Values keep ticking from time (they were estimates already): Hero Stat "27:00"; tiles 3.7 kWh · Rs 157 · Power **"—"**. Session Progress **State=Stale**: now node `icon/tertiary`, header right "Last update 6:32 PM". Stop stays enabled. | — |
| 06.10 | `06.10 · Live · Stopped at the charger (6:44 PM)` | P2 | Mesh Hero | The 1.2 s hold before the automatic jump to Complete (logic: "Session closed remotely: auto-navigates to Complete"). Overline **"CHARGING STOPPED"** [P12, P33]. Status pill (Frost Strong): checkmark.circle.fill + **"Stopped at the charger"** [P12]. Gauge frozen "≈28%", static glow. Hero Stat "16:00" / Detail "Stopped 6:44 PM". Tiles 4.9 kWh · Rs 209 (live floor; Complete 06.32 shows the final 5.0 kWh · Rs 210) · "0" kW. Stop → On Mesh Destructive **Disabled**. | — |
| 06.11 | `06.11 · Live · No slot end` | P2 | Mesh Hero | Booking time missing (logic: "shows '—' when there's no booking"). Hero Stat Value **"—"** (real), Detail **"Slot time unavailable"** [P39]. Session progress header "Slot · time unavailable", right side hidden. Accessory in this state = 06.19 (No window, real "— · Rs 152"). No auto-stop (nothing counts down). Session Progress **State=No window**: no end node, the track right of "now" is striped `bg/fill`, right label "Slot ends / —". | — |
| 06.12 | `06.12 · Live · ≈80% reached (DC, state demo)` | P2 | Mesh Hero | Overline **"CHARGING · GULBERG GALLERIA CHARGER"**. Status pill (Frost Strong): checkmark.circle.fill `status/available` + **"≈80% · a good place to stop"** [P9]. Gauge "≈80%", plan target dot filled (reached). Hero Stat "20:00" / "Ends 7:00 PM". Tiles **36.3 kWh · Rs 2,468 · 52 kW**. Progress header **"Plan · until ≈80%"** / **"Reached · Rs 2,468 est."**, fill 67%, "Now / 6:40 PM". The tip row becomes a Frost Strong capsule (padding 8/14, `text/primary`, icon `icon/brand`) to highlight it: "Stopping under 80% helps your battery last longer." (real; the capsule is P9). Power 52 kW is dummy tapering data from `currentPowerKw`. | — |
| 06.13 | `06.13 · Live · Loading session` | P2 | Mesh Hero | Nav Bar with Minimize only (Frost Strong button). `State View` Loading 1072:584 centred at y 380, title **"Loading session..."** (real), fill → `text/onMesh` (below the glow, so white per the measured rule); spinner white; message hidden. Nothing else. After data arrives with no station name, the overline uses the real fallback "CHARGING · CHARGING STATION" (documented beside the frame). | — |

#### Row 2 · Stop

| # | Frame | Pri | Background | Layout | New |
|---|---|---|---|---|---|
| 06.14 | `06.14 · Stop · End charging session?` | P1 | 06.02 dimmed with `bg/scrim` | Sheet (0,452) 402×422, `bg/surface`, top radius 38, grabber (183,457). `Sheet / Action` Kind=Destructive (00-system C3): icon well 56, radius 16, `status/errorTint` 948:82 at (16,476) holding stop.fill 28 `icon/error` 1070:506. Title 2 **"End charging session?"** (real) at (16,548). Body `text/secondary`, 2 lines, at (16,584): **"Your car is at ≈26% — ending now bills this session at Rs 152."** (real template; "≈" [P1]). Decision row at (16,640) 370×44, `bg/grouped` 948:42, radius `radius/md`, padding 12: clock 958:88 16pt `icon/secondary` + Footnote `text/secondary` **"Keep charging until 7:00 PM: ≈31% · Rs 286 est."** [P13]. `Button / Large` Destructive Default 978:367 **"End session"** (real) at (16,712). `Button / Large` Tertiary Default 978:337 **"Keep charging"** (real) at (16,772). Home indicator Dark. Built on `DestructiveConfirmSheet` (logic) = the same sheet anatomy as every destructive confirm in the app. With no slot end (06.11) the decision row is hidden and the sheet shrinks by 56 (starts at y 508). The same sheet opens over any tab from the accessory's Stop (root navigator). | — |
| 06.14b | `06.14b · Stop · Battery unknown` | P1 | 06.08 dimmed with `bg/scrim` | As 06.14, body **"Ending now bills this session at Rs 152."** (real template without the "Your car is at {X}% —" clause, because the % is unknown; the logic would print the default 40% [P25]). Decision row: **"Keep charging until 7:00 PM: ≈6.8 kWh · Rs 286 est."** [P13]. | — |
| 06.15 | `06.15 · Stop · Stopping` | P1 | Mesh Hero | 06.02 after the sheet is gone. Overline **"STOPPING…"** [P33]; live dot `icon/tertiary`, no pulse. Gauge, glow and values frozen at 6:32. Stop → On Mesh Destructive **Loading**. Nav buttons disabled (40%). | — |
| 06.16 | `06.16 · Stop · Couldn't stop` | P1 | Mesh Hero | 06.02 at 6:33 (ticking again). Stop back to Default. `Toast` Error 1088:626 at (16,704): `Message#1088:0` **"Error stopping session: Network error"** (real template `"Error stopping session: $e"`), `Action#1088:5` on, `Action label#1088:10` **"Retry"** (real). Nav buttons enabled again; loops resume. | — |

#### Row 3 · In-app live surfaces

Base for 06.17–06.20: the Home · Map frame with the session active. Clone **02.13 · Home · Map · Charging** if it exists; otherwise clone `Home · Map` 1076:5 and apply the 02 rule (accessory at (20,728); bottom stack raised 60pt). Tab bar Selected=Home 966:79 at (20,788).

| # | Frame | Pri | Background | Layout | New |
|---|---|---|---|---|---|
| 06.17 | `06.17 · Accessory · Ending (6:55 PM)` | P1 | Map | `Tab Bar Accessory / Live Charging` **Ending** 967:135: `Title#967:0` **"Charging · ≈30%"**, subtitle text node **"5:00 left · Rs 262"** [P3, P27]. No in-app banner and no haptic (the driver is on another tab, §4.0 rule; 02 rule 21). | — |
| 06.17b | `06.17b · Accessory · Slot ended (7:00 PM)` | P2 | Map | Accessory **Ending** 967:135: Title **"Charging · ≈31%"**, subtitle **"Ending · Rs 285"** (real ≤ 0 string "Ending · Rs X"). Stop is still visible but ignored while the auto-stop runs (logic stop-in-flight guard). A second later the shell listener pushes Complete. | — |
| 06.18 | `06.18 · Accessory · Stopping` | P1 | Map | Accessory **Stopping** 967:157: Title **"Stopping…"** [P33], subtitle **"Rs 152"**. The EndChargingSessionModal has just dismissed. Map and tabs stay interactive. | — |
| 06.19 | `06.19 · Accessory · No window` | P2 | Map | Accessory **No window** 967:146: **"Charging · ≈26%"** / **"— · Rs 152"** (real "— · Rs X"). | — |
| 06.20 | `06.20 · Accessory · Couldn't stop` | P2 | Map | Accessory **Charging** 967:124 ("Charging · ≈26%" / "28:00 left · Rs 152"). `Toast` Error 1088:626 at (16,556) (bottom 612, above the raised chips, §2.0.7): **"Could not stop session: Network error"** (real template `"Could not stop session: $e"`), `Action#1088:5` off (the logic snackbar has none). | — |
| 06.21 | Link, not a frame | — | — | **Charge tab · Charging in progress is 05.04** (Flow 05 builds it: "Charging in progress" / "You're already charging — finish or stop that session before starting another." / session card / **View session**, accessory Charging, tab bar Charge). Place a Footnote link card in this row: "Charge tab while charging → 05.04 (Flow 05A)". Battery unknown variant (described for 05): card title "Charging · +3.6 kWh" (rule 2.0.2-3a). | — |

#### Row 4 · OS live surfaces [P16, P17] (all OS mocks; frame label suffix "· proposal")

| # | Frame | Pri | Background | Layout | New |
|---|---|---|---|---|---|
| 06.22 | `06.22 · Lock Screen · Live Activity · Charging` | P1 | Lock Screen (2.0.6), clock "6:32" | **Live Activity / Charging** State=Charging at (16,560) 370×160, padding 16. Row 1 (h 20): `Brand / Mark / PakPlug P` Solid 991:69 rescaled to 20 + Footnote Emph `text/onMesh` **"GreenVolt · DHA Phase 5"**; right Footnote `text/onMesh` **"6:00 – 7:00 PM"**. Row 2 (y 44, h 52): left **"≈26%"** Display/L 40 `text/onMesh` + Caption 1 `text/onMesh` "est. battery"; right **"28:00"** Display/L 40 `energy` (6.5:1 on `mesh/deep`) + Caption 1 `text/onMesh` "left". Numbers tabular. Row 3 (y 110): progress 338×6 (track white 20%, fill `energy` 53%). Row 4 (y 128): Footnote `text/onMesh` **"Rs 152 so far · 3.6 kWh"**; right Footnote "Stop in app" omitted (no buttons on OS surfaces [P18]). | Live Activity / Charging |
| 06.23 | `06.23 · Lock Screen · Live Activity · Ending soon` | P2 | Lock Screen, clock "6:55" | State=Ending: Row 1 right → `Status Pill` Warning S **"Ending soon"**; Row 2 **"≈30%"** / **"5:00"** (white, not green); progress fill 92% `status/warning`; Row 4 **"Rs 262 so far · 6.2 kWh"**. | — |
| 06.24 | `06.24 · Lock Screen · Live Activity · Complete` | P1 | Lock Screen, clock "7:01" | State=Complete: Row 1 unchanged; Row 2: checkmark.circle.fill 28 `energy` + Title 3 `text/onMesh` **"Charging complete"** (real); right **"Rs 286"** Display/M `text/onMesh`. Row 3 (no progress bar): Footnote **"6.8 kWh · ≈31% est. · 1 h 00 min"**. Row 4: Caption 1 "Tap for your receipt". Height 132. | — |
| 06.25 | `06.25 · Dynamic Island · Compact + Minimal` | P1 | Map image, status bar Dark | **Compact** at (76,11) 250×37: leading 20pt mini ring (slot progress 53%, `energy` on white 25%) with bolt.fill 10 inside; trailing **"28:00"** Display/S 22 (SF Pro Light, the brief's number rule) `energy`, tabular, baseline-centred in the 37pt capsule. Below, a white doc card (16,140) 370×120 radius lg with Footnote Emph "Minimal · when another Live Activity is active" and the **Minimal** 37×37 (the same ring + bolt), shown at 2× (74×74). | Dynamic Island / Charging |
| 06.26 | `06.26 · Dynamic Island · Expanded` | P1 | Map image dimmed by `bg/scrim` | **Expanded** at (12,11) 378×176: leading region: P mark Solid 24 + **"≈26%"** Display/M white + Caption 1 white "est."; trailing region: **"28:00"** Display/M `energy` + Caption 1 white "left"; centre: Footnote white **"GreenVolt · DHA Phase 5"**; bottom region: progress 330×6 with Caption 2 white labels **"6:00 PM"** (left) and **"7:00 PM"** (right), then Footnote white **"Rs 152 so far · 3.6 kWh · 7.4 kW"**. No buttons [P18]. | — |
| 06.27 | `06.27 · Notifications · Lock Screen (Live Activities off)` | P1 | Lock Screen, clock "7:01" | 3 × **Notification Preview** (01 dependency) Style=Lock screen, 370 wide, gap 8, from y 460 (newest on top): ① now · **"Charging complete"** / **"6.8 kWh · Rs 286 · ≈31% est. Tap for your receipt."** ② 6:55 PM · **"5 minutes left"** / **"Your slot at GreenVolt · DHA Phase 5 ends at 7:00 PM. Charging stops automatically."** ③ 6:00 PM · **"Charging started"** / **"GreenVolt · DHA Phase 5 · ≈31% by 7:00 PM (est.)"**. Bodies stay within the preview's 2 lines at 370 wide. Footnote doc label above them: "Sent only when Live Activities are off (§4.11)". All copy [P17]. | — |
| 06.28 | `06.28 · Notification · ≈80% (DC, state demo)` | P2 | Lock Screen, clock "6:40" | 1 × Notification Preview: **"Charged to ≈80% ⚡"** / **"Rs 2,468 · 36.3 kWh — you're good to go."** (onboarding's real preview "Charged to 80% ⚡" / "Rs 385 · 14.2 kWh — you're good to go", with "≈" added [P1]). Only sent when the plan crosses 80% and the battery is known. | — |
| 06.28b | `06.28b · Notification · Plan done (30 min plan)` | P2 | Lock Screen, clock "6:30" | Variant story from 05.24 (plan by time, 30 min, "We'll remind you at 6:30 PM" [05-CH18], which 05 hands to this flow). 1 × Notification Preview: **"Your 30 min plan is done"** / **"≈26% est. · Rs 142 so far. Charging continues until you stop it or your slot ends at 7:00 PM."** [P17, P40]. With Live Activities on, the same moment is an alert update on 06.22's activity instead (§4.10-4). | — |

#### Row 5 · Complete (Mesh Celebrate)

| # | Frame | Pri | Background | Layout (delta from the Complete master §2.0.5) | New |
|---|---|---|---|---|---|
| 06.29 | `06.29 · Complete · Entrance (t = 450 ms)` | P2 | Mesh Celebrate | A motion keyframe. **Confetti** (01 dependency) Density=Light, 24 pieces mid-burst around the mark. Success Mark at scale 0.8 with the check half drawn. Title and subtitle at 40% opacity, +8pt. Cards and buttons not visible yet (opacity 0, +12pt). | — |
| 06.30 | `06.30 · Complete · Summary (7:00 PM)` ★ | P1 | Mesh Celebrate | Exactly §2.0.5. | Session Summary Card, Rate Prompt |
| 06.31 | `06.31 · Complete · Scrolled` | P1 | Mesh Celebrate | Content scrolled 380pt; Done + Download receipt stay pinned with a 48pt scroll-edge fade (`mesh/deep` 0 → 100%) behind them from y 664. Visible: the bottom of the summary card; the rate card; **"Session summary"** card (real header; Surface, radius xl) at y ≈ 316: `List Group Header` 983:389 "Session summary", then `List Row` Value 983:352 ×6 (icons off): **"Station" · "GreenVolt · DHA Phase 5"** (Subtitle "Street 12, Block CCA, DHA Phase 5, Lahore") · **"Date" · "Oct 4, 2026"** · **"Time" · "6:00 – 7:00 PM"** [P24] · **"Duration" · "1 hour"** · **"Vehicle" · "BYD Atto 3 · LEB-2481"** [P21] · **"Transaction ID" · "PP-2410-0482"** [P21; the shipped code prints "#" + the first 8 characters of the session id, e.g. "#3f9a1c2e"; the brief's dummy receipt number needs a backend field]. Then a Surface **"Timeline"** card [P31]: `Session Timeline Item` Done 987:415 ×3: "Plugged in · 6:00 PM", "Charging started · 6:00 PM" (real labels), "Slot ended · 7:00 PM" [P31; "Stopped by you · 6:32 PM" on 06.33, "Stopped at the charger · 6:44 PM" on 06.32], last `Line#987:0` off. Caption 1 `text/secondary` inside the summary card footer: **"Battery % is estimated from your 20% start."** [P1] | — |
| 06.32 | `06.32 · Complete · Stopped at the charger (6:44 PM)` | P1 | Mesh Celebrate | Summary card values: Total **"Rs 210"** / Detail **"5.0 kWh × Rs 42/kWh"**; tiles **"≈28%"** est. · **"5.0"** kWh · Time **"44" "min"**; row "GreenVolt · DHA Phase 5 · 6:00 – 6:44 PM". **Inline Notice** Tone=Info at the top of the summary card (inside, full width): info.circle + **"Charging stopped at the charger at 6:44 PM, before your slot ended."** [P12] (states only what the app knows; no billing claim, the backend's billed amount is the Total). The card grows to 300; the rate card moves to y 608 (Done stays at 712; the rate card overlaps the fold, so it scrolls). | — |
| 06.33 | `06.33 · Complete · Stopped early (6:32 PM)` | P2 | Mesh Celebrate | Driver ended at 6:32 (06.14 → End session). Total **"Rs 152"** / "3.6 kWh × Rs 42/kWh"; tiles "≈26%" est. · "3.6" kWh · "32" "min"; row "… · 6:00 – 6:32 PM". No notice. | — |
| 06.34 | `06.34 · Complete · Battery unknown` | P2 | Mesh Celebrate | Battery tile Value **"—"**, Unit "" [P25] (the logic defaults to 40%; we never show a made-up %), accessibility label "Battery, not known". Summary footer Caption 1 `text/secondary`: **"Add your battery % next time for a % estimate."** [P42]. Same frame documents the kWh-null case beside it: Energy tile "—" (logic "N/A") [P41]. | — |
| 06.35 | `06.35 · Complete · Rated` | P1 | Mesh Celebrate | After 06.41 → Submit. Rate Prompt **State=Rated**: Headline **"You rated 4 stars"** [P30] + `Rating Stars` Value=4 1088:696 (display, not interactive) + trailing Footnote Emph `text/brand` **"Edit"** [P30; logic label "Edit Review"]. `Toast` Success 1088:616 at (16,644): **"Review submitted successfully"** (real). | — |
| 06.35b | `06.35b · Complete · Review unavailable` | P2 | Mesh Celebrate | 06.30 after tapping a star when the session has no booking id (rare: every start needs a booking). Stars stay empty. `Toast` Error 1088:626 at (16,644): **"Booking not found — cannot open review"** (real), `Action#1088:5` off. If the missing id is known when Complete loads, the Rate Prompt uses State=Hidden instead and the summary card moves up (§8.23). | — |

#### Row 6 · Receipt

| # | Frame | Pri | Background | Layout | New |
|---|---|---|---|---|---|
| 06.36 | `06.36 · Receipt · Saved image (artefact)` | P1 | canvas `bg/canvas` 948:40 (an image, not a screen; label "PNG saved to Photos · 1080 px wide") | **Receipt** (new, §6) 370×640 centred at (16,117), `bg/surface`, radius xl, effect Frost/Card. ① Brand band 370×72 `brand/primary`: `Brand / Mark / PakPlug P` Solid 991:69 at 32 + `Brand / Wordmark` White 994:127 rescaled to 112 wide (logic: "bolt plus PakPlug"). ② The real hero, as in the app: **Success Mark** (01 dependency) Size=M 56 Style=On light, centred, then Title 2 **"Charging complete"** + Subheadline `text/secondary` **"Your vehicle is ready to go"** (real) + Footnote `text/secondary` **"Oct 4, 2026 · 6:00 – 7:00 PM"**. The card is 370×700 at (16,87). ③ 3 Stat Tiles: Battery "≈31%" est. · Energy "6.8" kWh · Total "Rs 286". ④ Key-value rows (Footnote; key `text/secondary`, value `text/primary`, right-aligned): Station "GreenVolt · DHA Phase 5" · Address "Street 12, Block CCA, DHA Phase 5, Lahore" · Date "Oct 4, 2026" · Time "6:00 – 7:00 PM" · Duration "1 hour" · Connector "Type 2 (AC) · 7.4 kW" [P21] · Rate "Rs 42/kWh" [P21] · Vehicle "BYD Atto 3 · LEB-2481" [P21] · Transaction ID "PP-2410-0482" [P21]. Numbers in tiles use Display styles (Light), tabular. ⑤ **Perforation** (dashed 1pt `stroke/separator` + two 16pt semicircle notches in `bg/canvas` at the card edges; the same language as Charging Pass). ⑥ Footer centred: Footnote Emph **"Thank you for charging with PakPlug"** + Footnote `text/brand` **"pakplug.com"** (real) + Caption 2 `text/tertiary` "Battery % is an estimate." [P21]. | Receipt, Perforation |
| 06.37 | `06.37 · Receipt · Saved` | P1 | Mesh Celebrate | 06.30 + "Download receipt" back to its default + `Toast` Success at (16,644): **"Receipt saved to your gallery"** (real) [P23 suggests "Receipt saved to Photos"]. Receipt thumbnail [P22] 56×96 (the 06.36 receipt scaled) at (16,540), radius sm, Shadow/Button, sliding down-left out of view; label it "thumbnail, 2.5 s, tap to share". | — |
| 06.38 | `06.38 · Receipt · Photos permission (OS)` | P2 | 06.30 + system dim | **iOS / Permission Alert** (01 dependency) new Kind=Photos (add-only): "“PakPlug” Would Like to Add to your Photos" / "Save your charging receipts as images." [P43 usage string] / "Don't Allow" · "Allow". "Download receipt" in **Loading** behind it. | Permission Alert Kind=Photos |
| 06.39 | `06.39 · Receipt · Permission denied` | P2 | Mesh Celebrate | 06.30 + `Toast` Error at (16,644): **"Permission required to save receipt"** (real), `Action#1088:5` on, `Action label#1088:10` **"Settings"** [P28]. | — |
| 06.39b | `06.39b · Receipt · Couldn't save` | P2 | Mesh Celebrate | 06.30, "Download receipt" back to default + `Toast` Error 1088:626 at (16,644): **"Could not save receipt. Please try again."** (real), `Action#1088:5` off. Beside the frame, a doc note lists the other two real failure strings with their likely triggers (confirm with Rayan (?)): **"Could not generate receipt. Please try again."** (the PNG render failed) and **"Could not save receipt"** (the gallery save returned false). | — |

#### Row 7 · Rate the host (`LeaveReviewModal`, a root bottom sheet)

Base for 06.40–06.49: 06.30 behind, dimmed with `bg/scrim`. The sheet is `bg/surface`, top radius 38, grabber. `Sheet Header` Form 1008:413: `Title#1008:0` per state, `Subtitle#1008:3` **"GreenVolt · DHA Phase 5 · Oct 4, 2026, 6:00 PM"** (real format `"{station} · {date, time}"` with "MMM d, yyyy, HH:mm", which prints "18:00"; 12-hour time per P24 so it matches the summary and Bookings), trailing Fill S xmark. Status bar Dark (the sheet's dimmed Celebrate top behind it); home indicator Dark. Only one Toast at a time, at y 704 (keyboard down) or y 416 (keyboard up).

| # | Frame | Pri | Layout | New |
|---|---|---|---|---|
| 06.40 | `06.40 · Review · New` | P1 | Sheet (0,314) 402×560, grabber (183,319). Header at (0,330): **"How was your session?"** (real). `Rating Stars` Value=0 1088:632 centred at (91,410). Footnote `text/secondary` centred at y 462: **"Tap a star to rate"** [P19]. **Text Area** (new) at (16,494) 370×120: placeholder **"Anything the next driver should know? (optional)"** (real). Caption 1 `text/secondary`, right-aligned, at y 622: **"0/500 characters"** (real). Footnote `text/secondary` at (16,736): **"You have 7 days to edit your review after submitting."** (real). `Button / Large` Primary Default 978:277 **"Submit Review"** (real) at (16,772). | Text Area |
| 06.41 | `06.41 · Review · 4 stars + note (typing)` | P1 | Sheet at the large detent (0,62) 402×812. Stars **Value=4** 1088:696; word **"Good"** [P19]. Text Area **Focused**: **"Easy to find inside the block, and Bilal had the cable ready."** + caret; counter **"61/500 characters"**. `iOS / Keyboard` (01/03 dependency) at (0,538). Submit rides on the keyboard at (16,478). The 7-day footnote is hidden while the keyboard is up. | — |
| 06.42 | `06.42 · Review · No rating` | P2 | 06.40 after Submit with 0 stars: stars outlined `stroke/error`, Footnote `text/error` under the stars: **"Please select a star rating"** (real). | — |
| 06.43 | `06.43 · Review · Too long` | P2 | 06.41 with 500 characters (text filled, scrolled to the end): counter **"500/500 characters"** in `text/error` (real: red at or over the limit). Submit **Disabled** 978:291. `Toast` Warning 1088:621 at (16,416) (above the keyboard): **"Shorten your review before submitting."** (real; shown on tap of the disabled button, §8.29). | — |
| 06.44 | `06.44 · Review · Submitting` | P2 | 06.41 with the keyboard dismissed; Submit **Loading** 978:298; stars and field disabled (60%). | — |
| 06.45 | `06.45 · Review · Couldn't submit` | P2 | 06.44 back to its default + `Toast` Error at (16,704): **"Failed to submit review (HTTP 500)"** (real template; the server message wins when present). | — |
| 06.46 | `06.46 · Review · Edit` | P2 | Title **"Edit your review"** (real); stars Value=4; Text Area Filled with the note; counter "61/500 characters"; CTA **"Update Review"** (real). Success toast (described in notes): **"Review updated successfully"** (real). | — |
| 06.47 | `06.47 · Review · Read-only` | P2 | Title **"Your review"** (real); Rating Stars display 4; Body text/primary with the note; Footnote secondary **"Submitted reviews are visible to the station host."** (real); `Button / Large` Secondary **"Done"** (real). | — |
| 06.48 | `06.48 · Review · Period ended, no review` | P2 | Title **"Your review"**; Headline **"The review period has ended."**; Subheadline secondary **"You did not submit a review for this booking."** (real); **"Done"**. Sheet height 360. | — |
| 06.49 | `06.49 · Review · Loading / Couldn't load` | P2 | Two sheets side by side in one frame (top half: loading, `State View` Loading 1072:584 with title hidden, spinner only (logic "Loading: spinner"); bottom: `State View` Error 1072:588, title **"Failed to load review"** (real), message = the error text as the logic shows it (dummy **"Network error"**), action `Button / Medium` Primary **"Retry"** (real)). If two in one frame is awkward, split into 06.49a / 06.49b. Reached from Bookings (07) more than from Complete. | — |

#### Row 8 · Exit

| # | Frame | Pri | Background | Layout | New |
|---|---|---|---|---|---|
| 06.50 | `06.50 · Charge tab · After session` | P2 | Mesh Hero | Clone Flow 05's Charge tab idle frame (state 1: "Start charging" / "Scan a charger's QR code to begin a session.", Scan card, shortcuts). No accessory (session over), tab bar at its normal height. Add the **Last session** Frost Strong card [P29] above the shortcuts: 370 wide, radius lg, padding 16, gap 4: Footnote Emph `text/secondary` "Last session" + Subheadline `text/primary` "GreenVolt · DHA Phase 5" + Footnote `text/secondary` "Rs 286 · 6.8 kWh · ≈31% est." + trailing Footnote Emph `text/brand` "Receipt" (44pt hit area). Text on the bare mesh keeps 05.01's colours (black on the top glow, white below). | — |

---

## 3. Real copy (quoted from the logic map) per screen

### 3.1 Live (06.01–06.13) · `ActiveChargingView`
- Entered from Connecting (auto), the shell pill, Charge tab "View session", or the widget intent; slides up from the bottom (4.1, 4.9-2, 4.15).
- Overline: "CHARGING · {STATION NAME}" (06.02), fallback "Charging Station" → "CHARGING · CHARGING STATION" (noted on 06.13).
- Ring: "{battery}%" + "CHARGING". If battery is null it defaults to 40 (?). We show "≈X%" + "est. battery" [P1] and the Unknown state instead of 40 [P25] (06.08).
- ETA: "{mm:ss | h:mm:ss}" "to full" (really booking time left) → "Left in your slot" [P3] (06.02); "—" when there's no booking (06.11, real).
- Stat cells: "KM ADDED" (hard-coded "+92") → Power [P2]; "KWH" (`energyKwh`, 1 decimal, or "—") → Energy, time estimate when null [P37, P41]; "SO FAR" ("Rs {liveTimeBasedRunningCostPkr}", elapsed time × per-hour rate, falling back to the running estimate) → "So far" [P41].
- Timeline: "Plugged in" (start time), "Charging started" (same start time), "Now · X%" (current clock, active dot) → Session Progress "Plugged in · Now · Slot ends" [P4] (06.02) and the Complete timeline (06.31).
- Tip: "Stopping under 80% helps your battery last longer." (06.02, 06.12).
- Minimize chevron (real: top right; pops back to the shell, the session keeps running and the pill shows) → top-left [P15].
- Button: "Stop charging" → `EndChargingSessionModal`; on confirm `stopSession` → replace with `ChargingCompleteScreen`.
- States: session null "Loading session..." (06.13) · stop loading = button spinner, disabled (06.15) · "Error stopping session: $e" + **Retry** (06.16) · booking window ended (remaining ≤ 0) → auto-stop with "Session time reached. Stopping charging automatically...", then Complete (06.07) · session closed remotely → auto-navigates to Complete (06.10 → 06.32) · UI re-renders every 1 s (4.2).
- `currentPowerKw` exists but isn't shown (we show it [P2]).

### 3.2 Stop (06.14, 06.14b) · `EndChargingSessionModal` (wraps `DestructiveConfirmSheet`)
- "End charging session?" / "Your car is at {X}% — ending now bills this session at Rs {Y}." / **End session** / **Keep charging**. Returns a bool (true = End session).

### 3.3 Accessory (06.17–06.20, 06.17b) · `DriverHomePersistentChargingPanel`
- Shown above the bottom nav on every tab while a session is active; hidden when there is no session or it isn't active. Bolt icon well. Ticks every 1 s.
- Title "Charging · {battery}%" → "Charging · ≈26%" [P1] (or "Charging · +3.6 kWh" when unknown [P25]).
- Subtitle by remaining booking seconds: null "— · Rs X" (06.19) · ≤ 0 "Ending · Rs X" (06.17b) · otherwise "{mm:ss | h:mm:ss} to full · Rs X" → "28:00 left · Rs 152" [P3] (02.13, 06.20). Cost = `liveTimeBasedRunningCostPkr`.
- Tap the text area → slideUp `ActiveSessionScreen`. **Stop** → `EndChargingSessionModal` (root) → `stopSession` → push `ChargingCompleteScreen`; error snackbar "Could not stop session: $e" (06.20). Stop-in-flight guard ignores repeat taps.

### 3.4 Charge tab while charging (05.04, linked) · `ChargeScreen` state 2
- "Charging in progress" / "You're already charging — finish or stop that session before starting another." / card station name (or "Charging session") + "Charging · X%" / **View session**. Built by Flow 05 (05.04); 06 does not rebuild it.

### 3.5 OS surfaces (06.22–06.28b)
- No logic copy (all [P]). Reused: "Charging complete" (Complete title); onboarding preview "Charged to 80% ⚡" / "Rs 385 · 14.2 kWh — you're good to go" and the promise "a ping when your car hits 80%". Logic precedent: Android already has a foreground-service notification and a home-screen widget with a "stop_session" action that stops and then pushes Charging Complete (Appendix 2).

### 3.6 Complete (06.29–06.35b) · `ChargingCompleteView`
- Entered from: Live stop, auto-stop or remote close; pill Stop; shell listener; app-relaunch resume; home-widget stop intent. Clears the pending id.
- Close **X** (top right) → `pushNamedAndRemoveUntil(driverHome, tab 1 = Charge)` (06.50).
- Check icon. "Charging complete" / "Your vehicle is ready to go" (06.30).
- Stat cards: Battery "{X}%" (defaults to 40 if null → "—" [P25], 06.34) · kWh (1 decimal or "N/A" → "—" [P41]) · Total "Rs {billedAmount ?? runningCostEstimate}".
- "Session summary": station name and address; Date "MMM d, yyyy"; Time "HH:mm – HH:mm" (→ 12-hour [P24]); Duration ("1 hour 5 minutes" format); Transaction ID "#{first 8 characters of the session id}" (→ "PP-2410-0482" [P21]) (06.31).
- **Leave a review** → `showLeaveReviewModal(bookingId, stationName, "MMM d, yyyy, HH:mm")` (06.40); no booking id → "Booking not found — cannot open review" (06.35b) · **Download receipt** (secondary, shows loading) (06.37–06.39b).
- States: a staggered entrance animation with a safety timer (4.12).

### 3.7 Receipt (06.36–06.39b)
- Widget: brand header (bolt plus "PakPlug" → P mark + SF Pro wordmark), the same hero, stats and summary card, dashed divider, "Thank you for charging with PakPlug" / "pakplug.com". No buttons.
- Save: asks for gallery permission → denied "Permission required to save receipt" (06.39) · renders off-screen to PNG `PakPlug_Receipt_{id}` · "Receipt saved to your gallery" (06.37) · "Could not save receipt" · "Could not generate receipt. Please try again." · "Could not save receipt. Please try again." (06.39b).

### 3.8 Review (06.40–06.49) · `LeaveReviewModal`
- Root bottom sheet, **never auto-shown**; opens from Complete, the Bookings card links (07) and the `/write-review` route.
- States: Loading spinner · Error "Failed to load review" + error text + **Retry** (06.49) · Read-only, no review: "Your review" / "The review period has ended." / "You did not submit a review for this booking." + **Done** (06.48) · New "How was your session?" (06.40) · Edit "Edit your review", prefilled (06.46) · Read-only "Your review" + **Done** + "Submitted reviews are visible to the station host." (06.47).
- Subtitle "{station} · {date, time}". 5 tappable stars; tapping the current star clears it. Required hint "Please select a star rating" (06.42). Field "Anything the next driver should know? (optional)". Counter "N/500 characters", red at or over the limit; Submit disabled at ≥ 500 with snackbar "Shorten your review before submitting." (06.43).
- **Submit Review** / **Update Review** · "You have 7 days to edit your review after submitting."
- "Review submitted successfully" (06.35) / "Review updated successfully" (06.46) · errors: the server message, or "Failed to submit review (HTTP n)" (06.45).

---

## 4. Micro-interactions

Every row below is written **Trigger → response · timing + easing · haptic · VoiceOver (VO) · Reduce Motion (RM)**. "none" means deliberately none.

### 4.0 Motion tokens, press rules and haptics

**Shared tokens (defined in 02 §4.0 and 01; restated here so this spec stands alone):**
| Token | Spec | Settles |
|---|---|---|
| `snappy` | spring response 0.30, damping 0.85 (Flutter stiffness 440, damping 36) | ≈ 300 ms |
| `smooth` | spring response 0.45, damping 1.0 (stiffness 195, damping 28) | ≈ 450 ms |
| `bouncy` | spring response 0.40, damping 0.70 (stiffness 250, damping 22) | ≈ 400 ms, one ≈ 4% overshoot |
| `fade.quick` | 150 ms ease-out | 150 ms |
| `fade.std` | 220 ms ease-out | 220 ms |
| `M-rise` | y +12 → 0 and opacity 0 → 1, 320 ms ease-out (cubic-bezier .22,1,.36,1), stagger 40 ms (60 ms on Celebrate) | 320 ms |
| `M-push` | native push / pop | ≈ 350 ms |
| `M-replace` | cross-dissolve 250 ms ease-out (400 ms when the mesh changes) | 250 / 400 ms |

**Tokens added by this flow (add to the Foundations "Motion" board with 02's):**
| Token | Spec | Use |
|---|---|---|
| `tick` | UI clock every 1.0 s (logic re-renders every 1 s). Between ticks, continuous values (arcs, bars) interpolate **linearly** over 1 s, so motion never stops and starts. | countdown, arcs, progress |
| `roll` | SwiftUI `.contentTransition(.numericText(countsDown:))`, Flutter `AnimatedSwitcher` per digit: only the digits that change roll, 220 ms `snappy`, upward for increases and downward for the countdown. Tabular figures. | every number |
| `sweep` | Gauge arc from A to B: `smooth` spring. Entry sweep ≈ 900 ms (500 + 400). | gauge entry, re-base, final sweep |
| `breathe` | Glow ring scale 0.96 ↔ 1.04 and opacity 0.55 ↔ 0.85, sine ease-in-out, 4.0 s loop (15 breaths/min, calm); 3.0 s when ending soon. | live glow |
| `comet` | A 24° highlight (white 0 → 60% → 0 gradient) travels along the energy segment from the start tick to the now point, linear, 2.4 s, then a 600 ms pause (3.0 s cycle). | "energy is flowing" |
| `pulse` | Ring around a dot: scale 1 → 2.2, opacity 0.5 → 0, ease-out, **1.33 s** loop, so exactly three pulses fit one 4.0 s breath and the two stay in phase. | live dot, now node |

**Press rules (02 §4.0, unchanged):** `Button / Large` and `/ Medium` swap to Pressed on touch-down and scale 0.97 (`snappy`); Icon Buttons (Glass or Frost Strong) scale 0.92 and brighten 6%; cards and the gauge scale 0.98; chips 0.96. A drag of more than 10pt cancels a press. Disabled controls have no press and no haptic.

**Toasts (00-system §2.1):** enter from 12pt below + fade (`smooth`), leave with `fade.quick`; one at a time (a new one replaces the old with `fade.quick`); 4 s for one line without an action, 6 s for two lines or any action; exceptions: the stop-failure toast with Retry (06.16) stays until Retry, a swipe or 8 s, and the auto-stop toast (06.07) stays until the stop resolves; positions = 00-system §1.5 bottom edges (§2.0.7's y values assume h 56).

**Haptic schedule (one map; additions to 02's):** selection (`UISelectionFeedbackGenerator`) = stars, chips, slider ticks, estimate rows; light (`UIImpactFeedbackGenerator .light`) = navigation, minimize/expand, milestones M2/M3/M5b, back online; medium (`.medium`) = opening the stop confirm, End session, the auto-stop at 0:00; **warning** (`UINotificationFeedbackGenerator .warning`) = 5 min left, connection lost, remote stop; success = Charging started (arrival, handed over by 05), ≈80% / plan reached, Complete check, review saved, receipt saved, battery updated; error = a failed stop, submit or save, review with no stars. Haptics fire only while the Live screen, a sheet over it, Complete or the review sheet is in the foreground (never from the accessory on another tab), and never more than one milestone haptic per 60 s; the M6 warning always plays.

**Global fallbacks.** Reduce Motion: no breathe, comet, pulse, roll, shake or confetti; numbers swap with `fade.quick`; arcs jump to their value; slides and scales become `fade.std` cross-fades; haptics still play. Low Power Mode: same as Reduce Motion for the loops (breathe, comet, pulse), but ticks and rolls stay. Reduce Transparency: Frost Strong and glass become Surface with a hairline. VoiceOver: ticking values carry `.updatesFrequently` and update silently (read when focused); only milestones, state changes and toasts are announced, politely (`UIAccessibility.post(.announcement)` / Flutter `SemanticsService.announce`), never more than one every 10 s except errors.

### 4.1 Arriving on Live (06.01 → 06.02)
1. **Connecting (05) finishes** → `ActiveSessionScreen` replaces it (logic, 2 s). The Hero mesh stays; 05's 112pt Connecting circle expands into the 240pt gauge ring (matched geometry, `smooth` ≈ 450 ms) while the Connecting copy fades out (`fade.quick`). Then `sweep`: start segment 0 → 20% (500 ms), estimated-so-far segment to its value (400 ms), planned dotted segment fades in (`fade.std`). · ≈ 1.1 s total · **success** haptic when the "Charging started" pill lands (05 plays its own success for the start request and hands this one to 06) · VO: screen-changed notification, focus on the gauge "Estimated battery, about 20 percent. Started at 20 percent. Plan: about 31 percent by 7 PM." · RM: gauge at its final state; everything cross-fades in (`fade.std`).
2. **"Charging started" pill** (M1) → replaces the overline at y 106: overline out (`fade.quick`), pill drops from −12pt + fades in (`smooth`), holds 2.5 s, then cross-fades back (`fade.std`). · the success above · VO polite announcement "Charging started" · RM: fades only, same hold.
3. **Content rises** → Hero Stat, stats card, session progress, tip and Stop: `M-rise`, stagger 40 ms, starting at 300 ms (all settled by ≈ 820 ms). · none · VO order as §8.20 · RM: one `fade.std` for all.
4. **First `currentPowerKw` arrives** → Power "—" → "7.4" with `roll`; the "Ramping up" caption fades out (`fade.quick`). No power in 60 s → the connector's rated "7.4" + Caption 2 "rated" [P35]. · none · VO silent update "Power, 7.4 kilowatts" · RM: swap.
5. **Opened later** (accessory, Charge tab, widget, relaunch) → no pill, no success haptic; the gauge sweeps from 0 to the current values in 600 ms (`sweep`) and content uses `M-rise`. · light (navigation) · VO focus on the gauge · RM: final state, `fade.std`.

### 4.2 Per-second tick and number rolls (06.02 and every Live state)
1. **Every second** → "Left in your slot" counts down with `roll` (countsDown: true); only changed digits move ("28:00 → 27:59" rolls 3 digits). · `tick` 1.0 s, roll 220 ms `snappy` · none · VO: the Hero Stat is one element "Left in your slot, 27 minutes 59 seconds, ends 7 PM", silent update · RM: digits swap with no movement.
2. **kWh tenth changes** (about every 53 s at 7.4 kW × 92%) → `roll` up 220 ms. · none · VO silent "Energy, 3.7 kilowatt hours" · RM swap.
3. **Rupee changes** (about every 12.6 s: Rs 286/h) → `roll` up 220 ms; the "Rs" prefix never moves. · none · VO silent "So far, 153 rupees" · RM swap.
4. **≈ battery % integer changes** (about every 5.3 min) → `roll` up 220 ms + a 300 ms `energy` tint flash on the number (white → energy → white, ease-in-out). · light haptic only when it is a milestone (M2, §4.4) · VO silent "Estimated battery, about 27 percent" · RM: swap, no flash.
5. **Gauge arc** → each `tick` animates the energy segment linearly over 1.0 s to the new sub-percent value, so it creeps rather than jumps. · none · VO: the gauge's value is its text · RM: the arc steps only when the integer % changes.
6. **Session progress** → the fill and now node move linearly each `tick`; the "Now" time label rolls once a minute. · none · VO: silent value update "Now 6:33 PM, 55 percent of your slot" · RM: per-minute steps.
7. **Server reconciliation** (each poll; interval set in code) → if the meter's kWh / cost is **higher** than the local estimate, the number eases up to it over 600 ms (ease-out + `roll` on changed digits); if **lower**, the display holds until the estimate catches up (values never go down, §8.5). When `energyKwh` first arrives, the How-we-estimate row ② swaps to "From the charger's meter" (`fade.quick`) [P37]. · none · VO silent · RM: values swap at once.

### 4.3 Gauge, glow and comet: the live ambience (06.02)
1. **While charging** → the glow `breathe`s (4.0 s); the `comet` runs along the energy segment (3.0 s cycle); the live dot and the now node `pulse` (1.33 s, three per breath, in phase with the breathe). · loops · none · decorative layers hidden from VO (`accessibilityHidden`) · RM / Low Power: static glow at 0.7, no comet, no pulse.
2. **Ending soon (≤ 5 min)** → breathe slows to 3.0 s, switching at the next breath trough so it never jumps; the now node cross-fades to `status/warning` (300 ms ease-in-out); the comet keeps the energy colour (still charging). · haptic in 4.5-1 · VO n/a · RM: colour change only, instant.
3. **Stopping / stopped / slot ended** → every loop eases to its rest frame over 400 ms (ease-out); the glow fades to 0.4 (400 ms). · none · VO n/a · RM: instant.
4. **Connection lost** → the glow desaturates over 600 ms ease-in-out (energy → `bg/fillStrong` 30%), the comet finishes its pass and stops, the energy arc drops to 60% opacity (600 ms). Reconnect reverses it over 600 ms. · haptic in 4.6-1 · VO n/a · RM: instant colour swap.
5. **Tap the gauge** → press scale 0.98 (`snappy`); release opens "How we estimate" (4.7-1). · light · VO: the gauge is a button "Estimated battery, about 26 percent. Double-tap to see how we estimate." · RM: no scale.

### 4.4 Milestones (06.01, 06.04, 06.12; foreground only)
| # | When | In-app response | Haptic | VO (polite) |
|---|---|---|---|---|
| M1 | Live opens after start | "Charging started" pill 2.5 s (4.1-2) | success | "Charging started" |
| M2 | Every +10% est. crossed (≈30% at 6:51) | % flash (4.2-4), no pill | light | "About 30 percent, estimated" |
| M3 | Half the slot gone (6:30) | "Halfway through your slot" pill 2.5 s (06.04) | light | "Halfway through your slot" |
| M4 | ≈80% est. (DC demo 6:40) | "≈80% · a good place to stop" pill 4 s; the tip row becomes the Frost Strong capsule (06.12) for the rest of the session (`fade.std`) | success | "About 80 percent, estimated. A good place to stop." |
| M5 | Plan target reached (plan by target %) | "Plan reached · ≈{target}%" pill 4 s; the target dot fills (`bouncy`, scale 0.6 → 1) | success | "Plan reached" |
| M5b | Plan time done, when the plan is shorter than the slot (05.24: 30 min → 6:30) | "Your 30 min plan is done" pill 4 s; the plan header right side cross-fades to "Done · ≈26%" [P40] | light | "Your 30 minute plan is done. Charging continues until 7 PM." |
| M6 | 5:00 left (6:55) | Ending soon state (4.5-1) | warning | "5 minutes left. Charging stops at 7 PM." |
| M7 | 1:00 left | Hero Stat value scales 1 → 1.04 → 1 once (`bouncy` ≈ 400 ms) | none | "1 minute left" |
| M8 | 0:00 | Auto-stop (4.5-3) | medium | "Session time reached. Stopping charging." |
- **Pill mechanics (all):** `Map Status Pill` Notice (Frost Strong) replaces the overline: overline out (`fade.quick`), pill drops in from −12pt (`smooth`), holds (2.5 s, or 4 s for M4/M5/M5b), then pill out (`fade.quick`) and overline back (`fade.std`). One pill at a time; a new one replaces the current with a `fade.quick` cross-fade. RM: fades only.
- **Coinciding milestones:** M5 within 60 s of M4 → one pill (M4's copy), the target dot still fills, one success haptic. M5b at the same minute as M3 → M5b wins and M3 is skipped.
- **Backgrounded:** M4, M5, M5b, M6 and complete go to the Live Activity alert or a notification (4.10, 4.11); the others are skipped.

### 4.5 Ending soon and slot ended (06.06, 06.07, 06.17b)
1. **5:00 left** → Session Progress switches to State=Ending: the now node turns warning (300 ms), the header's right side cross-fades to the "Ending soon" pill (`fade.std`); the tip fades out (`fade.quick`) and the Inline Notice rises 8pt + fades in while the stack height animates (`smooth`). · ≈ 450 ms · **warning** · VO announcement (M6) · RM: cross-fade, no rise.
2. **The accessory** (minimized, on another tab) → State=Ending with a 300 ms tint cross-fade; the subtitle keeps counting "4:59 left · Rs 262" [P27]; at ≤ 0 it reads the logic's "Ending · Rs X" (06.17b). · **none** (another tab: 02 rule 21 and §4.0; the Live Activity or notification carries the alert) · VO silent value change · RM: instant.
3. **0:00** (remaining ≤ 0, logic auto-stop) → the overline cross-fades to "STOPPING…" (`fade.std`); ambience freezes (4.3-3); Stop morphs to Loading (label out 150 ms, spinner in 150 ms); the Toast Neutral "Session time reached. Stopping charging automatically..." rises (`smooth`) and stays until the stop resolves. · **medium** · VO announces the toast text · RM: fades.
4. **Stop OK** → Complete (4.12). **Stop fails** → error toast with Retry (4.8-6); Live stays at 0:00 in State=Ending; automatic retry every 10 s [P34] besides the manual Retry; VO announces the first failure only, not each retry.

### 4.6 Connection lost, stopped remotely, loading (06.09–06.11, 06.13)
1. **Polling fails for 15 s** [P11] → the "Reconnecting… · Last update 6:32 PM" pill drops in (`smooth`) and stays; ambience desaturates (4.3-4); Power → "—" (`fade.quick`). Time left, kWh, Rs and ≈% keep ticking from the clock (they were estimates already). · **warning** once per outage · VO "Connection lost. Showing estimates." · RM: fades.
2. **Back online** → the pill cross-fades (`fade.quick`) to checkmark.circle.fill `status/available` + "Back online", holds 1.5 s, then the overline returns (`fade.std`); values reconcile (4.2-7). · light · VO "Back online" · RM: fades.
3. **Stop while offline** → the request is sent and fails → 06.16 error toast with Retry; the button returns to default. We never fake a successful stop. · error · VO announces the toast.
4. **Session closed remotely** (logic: auto-navigate to Complete) → 06.10: loops freeze (400 ms), overline cross-fades to "CHARGING STOPPED" (`fade.std`), "Stopped at the charger" pill drops in (`smooth`), Stop → Disabled (`fade.quick`); after **1.2 s** Complete plays its resumed entrance (4.12-10) with the 06.32 notice. · **warning** at the freeze; success at the check draw · VO "Charging stopped at the charger." · RM: no movement, the same 1.2 s hold.
5. **Session null** → 06.13: the State View spinner and "Loading session..." fade in (`fade.std`) after a 150 ms grace delay (02's rule, so a fast load never flashes). Data arrives → content cross-fades in (`fade.std`) and the entry plays as 4.1-5. · none · VO announces "Loading session" once, then focus on the gauge · RM: fades.
6. **No slot end** (remaining null) → Hero Stat "—", Session Progress State=No window; the stripes right of "now" drift slowly (8 s linear loop) to show unknown time. · none · VO "Left in your slot, not available" · RM: static stripes.

### 4.7 How we estimate + Update battery % (06.03, 06.05)
1. **Tap info.circle** (press 0.92, `snappy`) or the gauge → the sheet presents at the medium detent (`smooth` ≈ 450 ms); the Live screen dims under the scrim (`fade.std`; no scale, 00-system sheet rule). The numbers inside are live and roll with the same ticks. · light · VO focus on "How we estimate, heading" · RM: fades, no scale.
2. **Tap an Estimate Row** → the row shows its Highlighted variant (`bg/fill`) for 1 s and the matching element behind the sheet gets a 2pt `energy` outline that fades in and out (`fade.std`, e.g. the gauge for "Battery now") [P36]. · selection · VO: rows are buttons, "Battery now, about 26 percent. 20 percent plus 3.6 kilowatt hours of 60.5." · RM: the outline appears and disappears without fading.
3. **Drag** between detents (native, interactive) or down to dismiss; ✕ (press 0.92) dismisses (`smooth`). · none · VO: two-finger scrub (Escape) dismisses, focus returns to the info button · RM: native.
4. **"Update battery %"** [P7] → the sheet's content pushes to "What does your car show now?" (`M-push` inside the sheet) and the sheet grows from y 316 to y 292 (`smooth`). · light · VO focus on the new title · RM: cross-fade.
5. **Drag the Level Slider / tap a preset** → 05's behaviour: the track lifts (scale 1.03 + Shadow/Button) while dragging, the big value rolls (220 ms), selection tick every 5%, light at 0% and 100%; presets select with `snappy` and set the slider (`smooth`). "Update estimate" enables (`fade.quick`) once the value differs from the estimate. · selection · VO: adjustable "Battery now, 28 percent. Swipe up or down to adjust." (±1% per swipe here, so 28 is reachable) · RM: no lift, no roll.
6. **"Update estimate"** → the sheet dismisses (`smooth`); the gauge re-sweeps from ≈26% to 28% (`sweep` 600 ms); the planned segment and the plan header recompute and `roll`; Toast Success "Battery updated · estimates recalculated" [P38] at y 704 for 4 s; pending notifications are rescheduled (4.11-2). · success · VO announces the toast, focus returns to the gauge · RM: fades, values swap.
7. **Battery-unknown chip** (06.08, press 0.96) → the same sheet opens straight at "What does your car show now?" (no "Our estimate now" line; Update disabled until the slider is touched). After saving, the gauge morphs Unknown → Charging: the kWh number slides up 12pt and fades (`fade.quick`) as the % slides in from 12pt below (`smooth`); the chip collapses (`fade.quick`) and the tip returns. · success · VO "Battery set to 28 percent. Estimates updated." · RM: cross-fade.

### 4.8 Stop → confirm → Stopping → Complete / error (06.14–06.16)
1. **Press "Stop charging"** → Pressed state (scale 0.97, `snappy`); on release the confirm sheet presents (`smooth` ≈ 450 ms, scrim `fade.std`); the Live screen dims and its loops keep running behind (it is still charging). · **medium** on release · VO: focus on "End charging session?, heading", then the body, "End session, button", "Keep charging, button" · RM: fades.
2. **The sheet's numbers are live** while open: "≈26%" and "Rs 152" `roll` if they change; the decision row "Keep charging until 7:00 PM: ≈31% · Rs 286 est." shows what stopping gives up [P13]. · none · VO: silent updates (not re-read) · RM: swap.
3. **"Keep charging"**, swipe down or a scrim tap → dismiss (`smooth`). · light · VO focus returns to Stop · RM: fade.
4. **"End session"** → the button shows Loading for ≤ 150 ms, then the sheet dismisses (`smooth`) and Live enters **Stopping** (06.15): overline "STOPPING…" (`fade.std`), loops freeze (400 ms), Stop = Loading, nav buttons to 40% (`fade.quick`). The logic's stop-in-flight guard ignores repeat taps. · **medium** · VO "Stopping charging" · RM: fades.
5. **Stop OK** → Complete (4.12) (logic: `stopSession` → replace with `ChargingCompleteScreen`).
6. **Stop fails** → Stop returns to default (spinner → label, 150 ms); loops resume (400 ms ease-in); nav buttons back to 100%; `Toast` Error "Error stopping session: …" + **Retry** rises (`smooth`) and stays until Retry, a swipe-away or 8 s. **Retry** → step 4 again. · **error** · VO announces the toast; Retry is the next element and is in the Actions rotor · RM: fades.
7. **Timeout:** no answer to a stop in 15 s → treated as failed (step 6) with "Error stopping session: Timed out" [P34].

### 4.9 Tab-bar accessory (06.17–06.20, 06.17b; also 02.13)
1. **Minimize** (chevron.down, press 0.92; or a swipe down > 120pt / a flick > 800 pt/s) → the Live screen shrinks into the accessory (matched geometry: the gauge becomes the accessory's bolt well, the title and numbers fly into its text) while the tab bar fades up (`fade.std`, +150 ms). · `smooth` ≈ 450 ms · light · VO focus on the accessory: "Charging, about 26 percent, estimated. 28 minutes left. Rs 152 so far. Double-tap to open the session." Custom action "Stop charging". · RM: cross-fade.
2. **Tap the accessory body** → press 0.98 (`snappy`), then the reverse of step 1 (`smooth`). · light · VO focus on the Live gauge · RM: cross-fade.
3. **Ticks** → the subtitle ticks every 1 s with `roll`; the title's ≈% rolls on change (02 rule 21). · none · VO silent · RM: swap.
4. **≤ 5 min** → State=Ending (300 ms tint cross-fade), the countdown continues. · **none** (another tab; 02 rule 21, §4.0) · VO silent · RM: instant.
5. **Stop** (press 0.92) → `EndChargingSessionModal` presents over the current tab (root, logic) with 06.14's content (`smooth`). "End session" → accessory State=**Stopping** (title "Stopping…", Stop → spinner, `fade.quick`) → Complete pushes over the shell (slide up, `smooth`). · medium on open and on End session · VO focus on the sheet title, then on "Charging complete" · RM: fades.
6. **Stop fails** → the accessory returns to Charging (`fade.quick`); `Toast` Error "Could not stop session: …" at y 556 (no action, logic), 4 s. · error · VO announces the toast · RM: fade.
7. **Scrolling a list tab** → iOS 26 minimizes the tab bar and the accessory moves inline (system, ≈ 300 ms; 02 P20). · none · RM: system.
8. **Session ends while on another tab** → the accessory slides down behind the tab bar (`smooth`), the bottom stack lowers 60pt in the same spring, and Complete is pushed (logic shell listener). · success at the check draw · VO focus on "Charging complete" · RM: fades.

### 4.10 Lock Screen Live Activity + Dynamic Island [P16] (06.22–06.26)
1. **Session becomes active** → start an ActivityKit Live Activity (Rayan: a native Swift widget extension; Flutter via a Live Activities plugin). Content: station, slot window, start %, plan, rate. · no haptic · the activity appears with the system animation.
2. **Countdown ticks for free:** the time left uses `Text(timerInterval: now...slotEnd, countsDown: true)` and the slot progress uses `ProgressView(timerInterval:)`, so both update every second with no pushes. The ≈% and Rs update via ActivityKit push updates **about every 60 s** (budget-friendly) or when the integer % changes; numbers use `.contentTransition(.numericText())` (the system turns it into a fade under Reduce Motion).
3. **5:00 left** → update with an `AlertConfiguration` (title "5 minutes left", body "Charging stops at 7:00 PM"): the Lock Screen lights up, the island briefly expands, the system plays its sound once. State=Ending (06.23). · system haptic.
4. **≈80% est.** (DC) → alert update "≈80% · a good place to stop". **Plan time done** (M5b) → alert update "Your 30 min plan is done" (06.28b's copy). · system.
5. **Complete** → final update to State=Complete (06.24) with an alert; `end(dismissalPolicy: .after(30 min))` [P32]. Tap → Complete (pending-complete id) or the receipt.
6. **Stale data:** `staleDate` = last update + 5 min; when stale, Row 4 reads "Updating…" and the progress fill drops to 60% opacity.
7. **Tap the Live Activity / compact island** → opens the app straight to Live (logic intent `active_session`). **Long-press the island** → expanded (06.26). · system haptic.
8. **No destructive buttons** on OS surfaces [P18]: Stop happens in the app with the confirm sheet.
9. VO: the Live Activity reads "PakPlug, charging at GreenVolt DHA Phase 5. About 26 percent, estimated. 28 minutes left. Rs 152 so far." The island's compact view reads "PakPlug charging, 28 minutes left."

### 4.11 Notifications [P17] (06.27, 06.28, 06.28b)
1. **Rule:** with Live Activities on, there are no separate banners; the Live Activity alerts do the job (4.10-3/4/5). With Live Activities off (or unsupported), schedule **local** notifications at session start from the plan: "Charging started" (immediately, only if the app is backgrounded within 10 s), "5 minutes left" (slot end − 5 min; only when a slot end exists), "Your {n} min plan is done" (plan end, only when the plan ends before the slot, M5b), "Charged to ≈80% ⚡" (only when the plan crosses 80% and the battery is known), and "Charging complete" (on stop / slot end, sent by the server push or the local auto-stop).
2. **Reschedule** whenever the estimate is re-based (Update battery %) or the stop happens early; cancel all pending on stop.
3. **Foreground:** no banners for charging notifications (the accessory and Live screen already show them), like the chat-suppression rule in Appendix 2 (the foreground `AnimatedNotificationBanner` would otherwise show for 6 s).
4. **Tap** → started / 5 min / plan done / ≈80% open Live (`active_session` intent); complete opens Complete (pending-complete resume) and scrolls to the summary. · system haptic · VO: the system reads title and body.

### 4.12 Complete entrance (06.29 → 06.30)
Sequence (logic: "staggered entrance animation with a safety timer"):
1. **0 ms** · stop OK → the gauge does a final `sweep` to its last value (≈31%) in 300 ms. · none.
2. **300 ms** · route replace: the background cross-fades Hero → Celebrate (`M-replace` 400 ms); the gauge shrinks (240 → 88) and its ring fades as it becomes the Success Mark disc (matched geometry, `smooth` 450 ms). · none.
3. **600 ms** · the check stroke draws (300 ms ease-out) → **success** haptic at 900 ms · VO: screen-changed notification, focus on the heading "Charging complete".
4. **650 ms** · Confetti Density=Light (24 pieces from behind the mark, 1.2 s, once) [P26]. · hidden from VO.
5. **700 ms** · title and subtitle `M-rise` (stagger 60 ms).
6. **820 ms** · summary card `M-rise`; the Total counts up "Rs 0 → Rs 286" (700 ms ease-out, `roll` on the last digits); the 3 tiles stagger 40 ms. · VO reads only the final value: "Total, 286 rupees. 6.8 kilowatt hours at 42 rupees per kilowatt hour."
7. **1000 ms** · rate card `M-rise`; the 5 stars fade in left → right, 30 ms stagger.
8. **1100 ms** · Done + Download receipt `fade.std`.
9. **Safety timer:** anything not finished by 1.6 s snaps to its final state.
10. **Resumed from relaunch / remote close:** no confetti and no count-up; a plain cross-fade (`M-replace` 400 ms), success haptic on the check only for a remote close seen live. The remote-close notice (06.32) rises with the summary card.
- RM: Celebrate background and content cross-fade in 300 ms; static check; no confetti or count-up; the success haptic still plays.
11. **✕ or Done** (press 0.92 / 0.97) → logic `pushNamedAndRemoveUntil(driverHome, tab 1)`: Complete slides down (`smooth`) to reveal the Charge tab (06.50); the tab bar rises (`M-rise`, +150 ms). · light · VO focus on the "Charge" title · RM: fade.
12. **Scroll** → content scrolls under the pinned buttons; the scroll-edge fade appears after 8pt of scroll (`fade.quick`). The title doesn't collapse (no nav bar on this screen). · none · VO: three-finger scroll works; the pinned buttons stay last in the order · RM: same.

### 4.13 Rate the host (06.35, 06.35b, 06.40–06.49)
1. **Tap star n on the Complete rate card** → stars 1…n fill left → right (30 ms stagger, each `bouncy` 1 → 1.2 → 1) · **selection** on the tapped star · then after 250 ms `LeaveReviewModal` presents (`smooth`) with the stars preset to n [P19]. · VO: each star is a button "3 of 5 stars"; the card also offers one "Leave a review" action · RM: no bounce, stars fill at once.
2. **No booking id** → `Toast` Error "Booking not found — cannot open review" (real, 06.35b); the stars empty again (`fade.quick`). · error · VO announces the toast. The card is hidden when the id is known to be missing at load (§8.23).
3. **In the sheet, tap a star** → fill as above; the word under the stars cross-fades (`fade.quick`) (1 "Not good" · 2 "Could be better" · 3 "Okay" · 4 "Good" · 5 "Great") [P19]. **Tap the current star again** → it clears (logic): the stars empty right → left (20 ms stagger), the word returns to "Tap a star to rate". · selection · VO: the stars are one adjustable element "Rating, 4 of 5 stars, Good" (swipe up/down) · RM: instant fill.
4. **Tap the field** → the sheet moves to the large detent with the keyboard (native, ≈ 350 ms); Submit rides on the keyboard; the 7-day footnote fades out (`fade.quick`). · none · VO focus in the field, hint "Optional" · RM: native.
5. **Typing** → the counter updates per character (`roll` on the digits); at 500 it turns `text/error` with one warning haptic when the limit is reached. · warning (once) · VO reads the counter only at 450 and 500 ("50 characters left", "Limit reached") · RM: swap.
6. **Submit with 0 stars** → the stars shake (`M-shake`: ±6pt, 3 cycles, 320 ms) and their outline turns `stroke/error`; the hint "Please select a star rating" fades in (`fade.std`). · **error** · VO announces the hint and focuses the stars · RM: no shake, colour + hint only.
7. **Submit** → Loading (06.44); the keyboard dismisses. **Success** → the sheet dismisses (`smooth`), **success** haptic, Toast "Review submitted successfully"; the Complete rate card morphs to Rated (06.35): stars stay filled, the title cross-fades to "You rated 4 stars" and "Edit" fades in (`fade.std`). **Error** → Toast Error "Failed to submit review (HTTP n)" (or the server message); the inputs stay. · error · VO announces either toast · RM: fades.
8. **Over 500 characters** → Submit looks Disabled but its tap target stays live: a tap shows Toast Warning "Shorten your review before submitting." (06.43, §8.29). · warning · VO: Submit reads "Submit Review, dimmed. Shorten your review first."
9. **Edit** (06.46) → the same sheet prefilled; **Update Review** → "Review updated successfully". **Read-only** (06.47/06.48) → **Done** dismisses (`smooth`). **Loading** (06.49) → spinner after a 150 ms grace; **Error** → **Retry** reloads (spinner again). · light on Done · VO focus on the sheet title · RM: fades.

### 4.14 Receipt (06.36–06.39b)
1. **Tap "Download receipt"** (press 0.97) → the button shows Loading: the icon cross-fades to a spinner (150 ms), the label stays. · light · VO "Saving receipt" · RM: swap.
2. **First time** → the iOS add-to-Photos permission alert (06.38). Allow → continue; Don't Allow → Toast Error "Permission required to save receipt" + **Settings** [P28] (opens the app's Settings page). · error · VO announces the toast; Settings is the next element.
3. **Render + save** (logic: off-screen PNG `PakPlug_Receipt_{id}`) → **success** haptic; Toast Success "Receipt saved to your gallery"; a 56×96 receipt thumbnail pops from the button (`bouncy`, scale 0.6 → 1), holds 2.5 s at the bottom-left, then slides down-left out of view (`smooth`) [P22]. Tap the thumbnail → the iOS share sheet with the PNG [P22]. · VO announces the toast; the thumbnail is a button "Share receipt" for its 2.5 s, and the same action stays in the Download receipt rotor afterwards.
4. **Failures** → Toast Error with the matching real string ("Could not generate receipt. Please try again." / "Could not save receipt. Please try again." / "Could not save receipt", 06.39b); the button returns to default. · error · VO announces the toast.
5. RM: no thumbnail motion (it fades in and out with `fade.std`).

### 4.15 Charge tab while charging and after (05.04, 06.50)
1. **05.04 "View session"** (Flow 05) → slideUp Live (logic, `smooth`). The card's "≈26%" and "28 min left" tick and roll like the accessory. · light · VO as 05.
2. **06.50 after Complete** → the Last session card [P29] rises (`M-rise`) 300 ms after the tab appears and stays until midnight; "Receipt" (press 0.97) re-runs the receipt save (4.14). · light on tap · VO: the card is one element "Last session, GreenVolt DHA Phase 5, 286 rupees, 6.8 kilowatt hours, about 31 percent estimated" with the action "Save receipt" · RM: fade.

---

## 5. Mobbin references (86 citations, 85 unique; all iOS, all images reviewed)

### 5.1 Live charging screen (06.01–06.13)
- **Oura — In Session, time remaining ring, "End early"**: https://mobbin.com/screens/08366dca-8bef-401f-a5d2-2514448fdf7d
  - What we take: an immersive full-bleed background with one ring and one big Light number in the centre, and a single quiet full-width stop action at the bottom. That calm density is our Live screen.
- **Oura — In Session (5:48), the ring's head marker**: https://mobbin.com/screens/73f150ad-8e22-441b-85e3-c92904590de7
  - What we take: the small glowing head on the ring's arc marks "now"; this becomes our comet head and the live point on the energy segment.
- **Tesla — Charging 62%, charge limit 80%, "4 kW · +1 kWh", Charge Tip, Stop Charging**: https://mobbin.com/screens/57361bb3-6bfc-461c-b36a-3d525cad0388
  - What we take: power and energy in one compact metric line, a charge-limit marker on the bar (our plan target dot), and the battery-health tip placed next to the stop action.
- **Shell — Charging…, "Estimated charging cost / Final price may include additional fees", Energy, Charge time, Stop charging**: https://mobbin.com/screens/57d1f042-956b-4c98-83df-999c766c231e
  - What we take: honest estimate wording right next to the cost. It is the precedent for our "Estimate. The charger's meter decides the final amount." line inside the stats card.
- **Rivian — Charging flow (67% bar with a hatched 70% limit; Speed / Time left)**: https://mobbin.com/flows/e71d7b2f-c097-4430-92c8-8ad454cd3c94
  - What we take: the filled-vs-hatched split between the current level and the target. It's our solid "estimated so far" arc versus the dotted "planned" arc.
- **Garmin Connect — Body Battery, solid line vs dotted "Estimated"**: https://mobbin.com/screens/37097198-e497-4580-b375-2eacf1b30d91
  - What we take: the visual grammar for estimates (solid = measured, dotted = estimated), with a legend word. We use dotted for anything projected.
- **Polestar — 33% / 65 mi as a huge number over a level block**: https://mobbin.com/screens/29fb82d2-e9cb-4a54-9425-a6b8a07ab806
  - What we take: the battery number as the single biggest thing on screen, typeset Light. This confirms Display/XL for "≈26%".
- **Strava — live recording, giant numbers, Pause in a bottom sheet**: https://mobbin.com/screens/f8af89b7-6c19-4afd-9a87-2f8c53fe02e4
  - What we take: tabular live numbers that tick without the layout jumping, and the stop action separated from the readouts.
- **Structured — "2:00–2:45 PM (45 min)" with "29:53 REMAINING"**: https://mobbin.com/screens/f724a5db-76fd-4df5-92e6-88ab2a51ebb9
  - What we take: a countdown labelled against its time window ("Left in your slot · Ends 7:00 PM") rather than a bare timer.
- **Polarsteps — "Trip started · Current location NOW · Trip finished" nodes**: https://mobbin.com/screens/c81ad9e1-b02e-4075-94d4-42da16677299
  - What we take: the three-node horizontal timeline (done / now / upcoming, the future node outlined). It is our Session Progress "Plugged in · Now · Slot ends".
- **American Airlines — flight status, 7:10 AM ——✈—— 8:56 AM**: https://mobbin.com/screens/3a12aa56-7f37-41a7-b54f-8c9bce34da9a
  - What we take: start and end times anchored to the ends of a track, with a moving marker between them; times in a bigger weight than their labels.
- **Glovo — "4 minutes left" with a progress bar**: https://mobbin.com/screens/c44f34d1-10c1-4228-98b3-71ebd2ad9645
  - What we take: the human phrasing of time left and a thin progress bar right under it.

- **Polarsteps — "Generating your awesome Trip Reel" over a blurred immersive photo, with a thin progress bar**: https://mobbin.com/screens/82fc6f83-a013-45e5-8a61-5dbb8f966e62
  - What we take: a loading state that keeps the immersive background and puts one white line of text in the middle with nothing else. That's 06.13 "Loading session..." on the Hero mesh.
- **Oura — "Finalizing the reset" / "Just a few more minutes." with "Try again" on a dark immersive sheet**: https://mobbin.com/screens/6f0caea9-ffc6-4c1f-be64-3b2059f232e0
  - What we take: a calm in-progress / retry state on a dark live surface, one short title, one line and one action; the tone of our Stopping and "Couldn't stop" states.
- **American Airlines — "Loading map..." dark pill at the top with a centred spinner and a Cancel button**: https://mobbin.com/screens/2c106f8d-fa66-4859-9f12-e90abc9114ef
  - What we take: a small status pill under the status bar that names what is happening while the screen waits; our STOPPING… overline and status pills follow the same placement.

### 5.2 Milestones, ending soon, connection lost (06.04, 06.06, 06.09, 06.10, 06.12)
- **Tolan — "You reached a milestone" glass pill at the top**: https://mobbin.com/screens/d2547f6d-14a5-4c78-ae50-e9be602c4622
  - What we take: a small, non-modal glass pill under the status bar for milestones that doesn't interrupt. This is exactly our Map Status Pill replacing the overline.
- **Bumble — "Less than one hour left to message" + "Need more time?" card**: https://mobbin.com/screens/3ecc2bc7-04b7-4767-b09c-264055942451
  - What we take: an urgency line in a warning tone paired with a calm in-content card explaining what happens. That's our Ending soon pill + Inline Notice (no Extend, because the logic has none).
- **Polarsteps — "Do not lock your screen or close Polarsteps" warning pill on an immersive screen**: https://mobbin.com/screens/96c074be-30d9-464b-add0-dbd0d164e405
  - What we take: a persistent glass status pill with a warning icon at the top of a dark live screen. That's our "Reconnecting… · Last update 6:32 PM".
- **Flighty — "Landing in 40m" tinted notice row inside the flight card**: https://mobbin.com/screens/d2a15492-9519-4965-826f-649edbfc3521
  - What we take: a tinted notice row that sits inside the content (not a toast) for time-critical states.
- **Shop — "No delivery updates" card when tracking data is stale**: https://mobbin.com/screens/071a0ed0-e3c9-4147-b77c-55068d113f14
  - What we take: say plainly that the data is not updating, keep the last known values visible, and don't blank the screen.
- **pushr — "tracking is paused" banner above a live counter**: https://mobbin.com/screens/be056d0f-13b6-4e06-b8b0-6d2159f3f054
  - What we take: a short status line explaining why the live numbers may be off, while the counter stays.

### 5.3 How we estimate + Update battery % (06.03, 06.05)
- **Glovo — "How do we calculate fees?" sheet**: https://mobbin.com/screens/5e3994a2-3aaa-447c-b5ef-f2051fb04e53
  - What we take: icon + name + value rows, each with a one-line explanation of its formula. That's our Estimate Row anatomy.
- **Brink — "How Transcripts Are Made" (On-Device / Best Effort)**: https://mobbin.com/screens/24cca7db-1dfb-42d6-a538-6780fff3515e
  - What we take: the tone: honest about limits ("Best Effort … treat the text as a reading aid"), with short titled points. Our sheet opens with "PakPlug can't read your car's battery…".
- **Oura — "Where's my route?" explaining missing data**: https://mobbin.com/screens/f6f2d90d-8779-4044-9820-57cd9209722a
  - What we take: on a dark immersive screen, explain why data is missing and what the user can do, in one paragraph and one button. That's our Battery unknown chip and its sheet.
- **Future Pro — workout summary "Est. Calorie Burn"**: https://mobbin.com/screens/dcc4e946-a776-4295-ba32-16cf358e2358
  - What we take: "Est." written right on the metric label; estimates sit next to measured values without apology.

- **Stardust — single-slider "Intensity" sheet with a big label and Save, over a dark immersive screen**: https://mobbin.com/screens/8841ef76-e6a4-453f-bebc-cd838feb5804
  - What we take: one value, one slider, one primary button in a sheet that sits over a dark live screen. That's the 06.05 Update battery % sheet (with 05's Level Slider).
- **MacroFactor — "Scale Weight" sheet logging the current weight and body-fat % with Save**: https://mobbin.com/screens/4d9e4722-5f10-49e6-b9ca-54bdc8cbc29d
  - What we take: the user types in a reading from another device (the scale), with the unit beside the value. Our driver reads the % off the car's screen the same way.
- **Future Pro — "Change Goal" sheet: "Lee will be notified and adapt your training", Update Goal disabled until a change**: https://mobbin.com/screens/9448c7d9-60ea-4d12-8729-6da67ec1af52
  - What we take: say what changes after saving ("We'll re-base the estimate from this moment") and keep the primary action disabled until the value differs.

### 5.4 End charging session sheet + Stopping (06.14, 06.14b, 06.15, 06.16)
- **Opal — "Leave Early?" sheet over a dark timer**: https://mobbin.com/screens/79907546-7636-46f8-be47-1e15ba99cbe4
  - What we take: an icon well, a short question title and a one-line consequence, with two stacked actions of clearly different weight, presented over the live screen.
- **Oura — "End session early?" alert over the session**: https://mobbin.com/screens/f1710168-6e23-4630-a5af-30cca7da067e
  - What we take: the confirm stays on top of the live screen (which keeps running behind), so "Keep charging" returns to it with no reload.
- **Glovo — "Keep on saving 2,80 € on every order" cancel sheet**: https://mobbin.com/screens/9d295f34-a687-4b57-acfa-68c06a4692cc
  - What we take: show what you give up by ending. That's our decision row "Keep charging until 7:00 PM: ≈31% · Rs 286 est."
- **Grab — "Cancel this booking?" red primary + tinted Back**: https://mobbin.com/screens/0fb6d70a-e41d-433b-bab0-5360ce93cce1
  - What we take: button order and weights: destructive filled on top, the safe option below.
- **Agoda — Cancel booking with amount rows**: https://mobbin.com/screens/ccdf194b-a86e-450c-af05-7bbd2805d658
  - What we take: money in the confirm itself, so nobody stops without seeing the bill ("bills this session at Rs 152").
- **Garmin Connect — LiveTrack, "Started 9:44 PM · Connected", red Stop LiveTrack**: https://mobbin.com/screens/f4f1a2c4-ac62-42f1-b857-6d47e03637d7
  - What we take: the session's start time and connection status sit above the stop action. Our overline/status pill + Stop follow the same order.

- **Lyft — "Cancel ride?" with the consequence ("Cancelling may result in a longer wait"), red Cancel ride and "Don't cancel ride"**: https://mobbin.com/screens/f807edc0-ce7c-48e1-9943-73371d417f03
  - What we take: an icon, a one-line consequence and the safe option as its own clear button. That's our "End session" / "Keep charging" with the decision row.

### 5.5 Tab-bar accessory (06.17–06.20, 06.17b)
- **Brink — mini player docked under the glass tab bar with a pause button**: https://mobbin.com/screens/eca83382-f024-4089-81df-9fdcd5ba0ca9
  - What we take: the iOS 26 accessory pattern: a slim glass capsule tied to the tab bar, title + subtitle, one trailing action (our Stop), visible on every tab.
- **Glovo — live order header with time range and progress**: https://mobbin.com/screens/39ef8f73-3ddc-4517-858c-2a86ab9b1e85
  - What we take: the hierarchy for a live status (time big, progress thin, one status line). It sets the accessory Ending state's priority: time first.
- **Jomo — "Session 28:18" live banner with a time range and a progress bar**: https://mobbin.com/screens/ac22e3c9-5974-4d31-b371-4da5b9da5848
  - What we take: label left, big tabular countdown right, a slim progress bar under them. That's our subtitle "28:00 left · Rs 152" logic in compact form.

### 5.6 Lock Screen Live Activity (06.22–06.24)
- **Oura — "Indoor running" Live Activity (dark, metric + time, zone bar, brand bottom-left)**: https://mobbin.com/screens/1e3c0935-bc5d-447e-b230-e25ae8f3c398
  - What we take: the 4-row layout: activity title + time on top, a progress band in the middle, a brand mark and a live metric at the bottom, on a dark brand-tinted background.
- **Starbucks — dark green brand Live Activity with step icons**: https://mobbin.com/screens/17ed493c-ff1a-4cd8-92cc-4339f98b3775
  - What we take: a deep green brand background works on the Lock Screen with white type. It is the precedent for our `mesh/deep` fill.
- **Grab — "Arriving 8:15 – 8:30 PM · On time" with a progress line**: https://mobbin.com/screens/1ac6149a-80a7-4ade-b9dd-1ce7aebdc073
  - What we take: the time window in the header and a status word in the brand colour; our "6:00 – 7:00 PM" + "28:00 left" in `energy`.
- **Jomo — Live Activities flow (session countdown with "11:11 PM – 11:41 PM")**: https://mobbin.com/flows/df108245-35a2-4e3a-a4b1-b5a2e5a566a5
  - What we take: the session window shown top-right and a monospaced countdown as the hero.
- **Forest — Live Activities flow incl. the final "Successfully focused for 25 m · 12:14 – 12:39"**: https://mobbin.com/flows/51398a50-ab88-4cb6-8d7d-08e18e411c49
  - What we take: the Live Activity's last state turns into a short summary (outcome + time range) instead of disappearing. That's our State=Complete.
- **Life Reset — Live Activity with big time, progress and start/end labels**: https://mobbin.com/flows/754ce9f7-9bdd-433a-b0e9-4cb8dfe47464
  - What we take: start and end times under the progress bar ends (our expanded island's "6:00 PM" / "7:00 PM").
- **American Airlines — "Arrived at gate" final Live Activity with a status pill**: https://mobbin.com/screens/1ba8137b-fa15-44d2-aab0-63cdb7260c21
  - What we take: a status pill in the corner for the state change (our "Ending soon" pill on 06.23).
- **Flighty — dark Live Activity "MCO 8:46 AM ··✈·· 11:36 AM SJU", "Arrived 1m Late"**: https://mobbin.com/screens/74651d77-b387-4af4-8f3f-0bd555cf37e3
  - What we take: colour only for the live status word and times, everything else neutral white; a check icon for the finished state.

### 5.7 Dynamic Island (06.25, 06.26)
- **Jomo — compact: bolt + "28:23"**: https://mobbin.com/screens/37fe77cb-8f7e-4762-961d-89e3097459a2
  - What we take: the simplest compact form: a bolt on the left and the countdown on the right.
- **Flighty — compact: progress ring icon + "1h 14m" in green**: https://mobbin.com/screens/a878818a-1f9e-4da1-93d6-5463fe9b0fcf
  - What we take: a tiny progress ring as the leading element and the trailing time in the brand colour (our `energy` "28:00").
- **Future Pro — compact ring + "4:17"**: https://mobbin.com/screens/77547503-ef77-4bad-b72b-727466292254
  - What we take: the ring doubles as the minimal presentation when two activities share the island.
- **Future Pro — expanded: thumbnail, title, "14 MIN LEFT", progress bar, play**: https://mobbin.com/screens/50d44c95-e4c8-4e4a-b65b-1df69344b1e4
  - What we take: expanded layout zones: leading visual, centred title, trailing time label, full-width progress at the bottom.
- **Opal — expanded with a full-width "Block Again" button**: https://mobbin.com/screens/c4b08830-1f6d-4da7-9e69-7d029abc4bb6
  - What we take: the expanded island can hold an action. We deliberately don't put Stop there (destructive + billing) [P18], but this sets the bottom-region height we reserve for the metrics row.
- **Oura — compact "♥ 140 · 2:39" (metric left, time right)**: https://mobbin.com/screens/dbc7d8dc-29cf-419c-9a6d-f2f781e2b6d0
  - What we take: an alternative compact layout "≈26% · 28:00". We chose ring + time because the % changes too slowly to be the glanceable value.
- **Brick — Dynamic Island flow (compact → expanded)**: https://mobbin.com/flows/dd24a23c-3869-4fb9-bc10-812be72c3c87
  - What we take: the long-press transition and how much bigger the time gets when expanded.

### 5.8 Notifications (06.27, 06.28, 06.28b)
- **Chick-fil-A — Lock Screen status with a 3-step progress line**: https://mobbin.com/screens/6faa82e1-4a23-4666-8a8f-11240defc430
  - What we take: one plain sentence per status ("Your order will be in the Pickup area in a moment.") — the tone of "Charging stops automatically."
- **Starbucks — "Got it! We received your order" Live Activity**: https://mobbin.com/screens/b84afc05-3bd3-4306-a1f5-80cac83f4894
  - What we take: very short titles ("Got it!") with a quieter second line. Our titles are 2–3 words ("5 minutes left", "Charging complete").
- **Grab — "8:15 – 8:30 PM · On time · … is preparing your order"**: https://mobbin.com/screens/2b55d63a-6709-419b-b784-384f5cab8646
  - What we take: put the time and the place in the body so the notification stands alone without opening the app.

- **American Airlines — Lock Screen activity "Boards in 17 minutes" with a "DELAYED" status pill**: https://mobbin.com/screens/ac125762-9da7-4dda-b694-8304e323c2bb
  - What we take: time-critical wording ("in 17 minutes") as the headline and a small status pill for the change. That's "5 minutes left" (06.27) and the Ending soon pill on 06.23.
- **Box Box Club — Lock Screen countdown "Starts in 1:13:55" as a big tabular hero**: https://mobbin.com/screens/8c2aaf87-687e-4a95-b1a7-50dbdcd80f97
  - What we take: a long countdown in h:mm:ss stays readable as the single hero number; our "1:28:00" format for slots over an hour (§8.28).

### 5.9 Charging complete (06.29–06.35b)
- **Shell — "Charging a vehicle" flow ending on "Thanks for recharging your vehicle"**: https://mobbin.com/flows/763572d1-653f-406e-926a-93fed7f7a39a
  - What we take: the category's end-to-end shape (station → charging → thanks) and a big check mark as the finish. We add the summary that Shell defers to "Receipts".
- **Breathwrk — celebration on an immersive gradient: ring number, 2-up glass stats, white Continue + Share**: https://mobbin.com/screens/2d2dda84-d138-4fbe-a887-50ab50504879
  - What we take: a white primary button on a deep background with a plain text secondary below. That's our On Mesh "Done" + On Mesh Plain "Download receipt".
- **Brick — "First tap complete." soft gradient, a white card of icon rows, Continue**: https://mobbin.com/screens/eb2562e9-5f2c-4e6a-87da-8ca18fdc29eb
  - What we take: put the facts on one white card over the gradient so text never sits on the mesh. That's our Celebrate contrast rule.
- **Sweatcoin — "Boost completed" with concentric rings, check and 2 stat tiles**: https://mobbin.com/screens/6555c020-1d7d-4d27-bc2b-e05e9a0cf4f0
  - What we take: the ring collapsing into a check is the moment; stats sit in equal tiles under the title.
- **Future Pro — summary card with big Light numbers (Miles / Est. Calorie Burn / Duration)**: https://mobbin.com/screens/dcc4e946-a776-4295-ba32-16cf358e2358
  - What we take: Light display numerals with small labels underneath; "Est." printed as part of the label (our "≈31% est.").
- **Urban Company — "Job complete", rating and booking details "Started at 3:52PM • Ended at 6:03PM"**: https://mobbin.com/screens/fcb24d0b-e63e-41ec-b3b9-0682cefd9b7b
  - What we take: rating sits right under the completion header; the booking details (start/end) come after. That's the order of our rate card and Session summary.
- **Instacart — "Your order was delivered" + inline "Rate your order" card**: https://mobbin.com/screens/85edfc78-3a9d-496b-b94d-f74cb2db22f4
  - What we take: an inline rating card on the completion screen rather than an auto-popup (the logic says the review modal is never auto-shown).
- **Tesla — Charging Session detail (Charging Fees "13.6440 kWh @ $0.60/kWh", Energy Delivered, Session Time, Invoice)**: https://mobbin.com/flows/0f3db973-e8cb-42cf-b969-4aa5bdc3ffa8
  - What we take: the fee written as "kWh × rate" under the total (our Detail "6.8 kWh × Rs 42/kWh").
- **Strava — activity summary metric grid (Elapsed Time, Calories, …)**: https://mobbin.com/screens/d3c861da-4e6a-41db-8f76-4de55dbfc02f
  - What we take: label above, value below, equal columns. That's our 3-tile row.

- **Oura — "Session details" explaining which data is only available for longer sessions, with an info button**: https://mobbin.com/screens/68ad00af-84aa-4315-8e67-a3bef411fea2
  - What we take: when a metric can't be shown, say why in one plain sentence instead of faking it. That's 06.34's "—" battery with "Add your battery % next time for a % estimate."
- **Grab — "How's your ride so far? Rate it or tip your driver." inline stars inside the trip sheet**: https://mobbin.com/screens/a63d720e-e8f0-4767-b1b4-b3327e6494a8
  - What we take: an inline star row with a one-line prompt inside a card, tapped without leaving the screen. That's our Rate Prompt on Complete.

### 5.10 Receipt (06.36–06.39b)
- **Luma — amount + date hero, inset grouped rows (Seller, Card, Event, Total)**: https://mobbin.com/screens/4324a04a-33d5-41fc-8162-e007ed4e9f91
  - What we take: iOS-native inset grouped key–value rows with right-aligned values; the amount as the hero.
- **Shop — Receipt with a share circle, order # + date, totals**: https://mobbin.com/screens/9abcfbfe-666f-4d55-8235-20900f8c4a7b
  - What we take: the receipt number and date directly under the title; share is one round button.
- **Ro — "Paid", Summary, "Download receipt" primary + "Contact us"**: https://mobbin.com/screens/4462e36d-46c0-44aa-a060-b57ab7a4bb24
  - What we take: "Download receipt" as a named action on the completion page (the logic's label), not hidden in a menu.
- **Chick-fil-A — receipt with a brand header band, "Estimated order total"**: https://mobbin.com/screens/470d0cdb-1af6-4155-aa26-a4d1ce515169
  - What we take: a brand band at the top of the saved image, and plain "estimated" wording for anything not final.
- **Cash App — big Light "$1.00" and Transaction details rows with icons**: https://mobbin.com/screens/5f175b2f-cd07-4a43-831d-d8cc97607a2c
  - What we take: Light display numerals for money, matching our Display styles.
- **Public — "Order completed" rows with a hairline before the Total**: https://mobbin.com/screens/b0c39422-9170-4dff-a205-ff5324399b6b
  - What we take: one hairline before the total; the total row in a heavier weight.

- **Tolan — "Saved to Photos" pill over an immersive dark screen, with a Share button under the card**: https://mobbin.com/screens/5369d396-8ca8-43dd-ae76-a63e23c5660a
  - What we take: a short, platform-worded confirmation ("Saved to Photos", our P23) and share offered right after saving.
- **Polarsteps — "Image downloaded" toast at the bottom of a share sheet with Download / iMessage / Other**: https://mobbin.com/screens/141776a8-0fa8-4b2e-aa6c-95045a572e5a
  - What we take: the saved image's success is a bottom toast with a check, and sharing stays one tap away. That's 06.37's toast + thumbnail-to-share.
- **Grok — green "Saved to Photos" pill with a check over a full-screen image**: https://mobbin.com/screens/b127a05d-4e3b-4edc-8809-b6324f2a66dd
  - What we take: a success tint and a check glyph for the saved state, gone after a moment; it confirms our Toast Success tone for "Receipt saved to your gallery".

### 5.11 Rate the host (06.40–06.49)
- **Lyft — "How was your ride to …?", stars, the rating word "Great"**: https://mobbin.com/screens/50230a0f-ad08-4578-b0ce-38907cba1f61
  - What we take: a word under the stars that names the rating (our "Good" / "Great").
- **Sesame — the heading changes with the rating, stars + text box**: https://mobbin.com/screens/e7e08aa7-05ab-4152-92f3-fd1fc6157c80
  - What we take: instant feedback on star tap; the optional text box right under the stars.
- **Recime — "Rate & review" with "Clear rating" and the keyboard up**: https://mobbin.com/screens/3737efcf-82d4-4790-8217-5f1da50fdb65
  - What we take: clearing a rating is a first-class action (our tap-the-current-star-to-clear, from the logic), and the layout with the keyboard up.
- **Mindvalley — "Lesson Complete" with a rating sheet over the completion screen**: https://mobbin.com/screens/5ad65ef9-cdc5-4773-aedf-9900f5dc1fce
  - What we take: the review sheet sits on top of the celebration, which stays visible and dimmed behind it.
- **Instacart — "Rate your experience" sheet with an optional comment**: https://mobbin.com/screens/d0437f6f-2385-486b-bf3b-c4dea58395c5
  - What we take: sheet header with ✕, then stars, then "(optional)" written in the placeholder.
- **Grab — "Ride completed · How was your ride?" stars + compliments**: https://mobbin.com/screens/100791f5-1677-4258-9398-e0ddb3cebe0d
  - What we take: the subtitle names the trip (our "GreenVolt · DHA Phase 5 · Oct 4, 2026, 18:00").
- **Mindtrip — "Add review", "(optional)" and a "0/300" counter, Submit disabled**: https://mobbin.com/screens/795c34db-aae2-4a89-bc54-0680665248cd
  - What we take: the counter right-aligned under the field (our "0/500 characters").
- **Linktree — feedback sheet with the keyboard up and the send button above it**: https://mobbin.com/screens/792fab81-ed18-4263-bbb1-02ec12c63924
  - What we take: the primary button rides on the keyboard while typing (06.41).

---

## 6. New components needed (not in the inventory)

| Component | Purpose | Variants | Props / anatomy |
|---|---|---|---|
| **Session Progress** | Slot timeline on Live (06.01–06.12): "Plugged in · Now · Slot ends" + the plan | State = Charging · Ending · Unknown battery · Stale · No window · Complete | 370×104, `bg/frostStrong`, radius lg, hairline, padding 14/16. `Plan label` (TEXT, Footnote Emph primary), `Plan value` (TEXT, Footnote secondary), `Show pill` (BOOL) + nested `Status Pill` S (Ending soon), track 338×6 `bg/fill` radius pill, fill `brand/primary` (Ending: same, the now node `status/warning`), 3 nodes (start 10 `brand/primary`; now 16 `energy` + 3pt white stroke + pulse ring; end 10 `bg/surface` + 2pt `stroke/separator`), labels `Start label`/`Start time`, `Now time`, `End label`/`End time` (Caption 1 secondary over Caption 1 Emph primary). Stale: now node `icon/tertiary`. No window: no end node, track right of now = 45° stripes `bg/fill`. Progress position = doc note "fill % = elapsed ÷ slot" (move the node and fill in Figma). Accessibility: one element, "Plan until 7 PM. Plugged in 6 PM. Now 6:32 PM, 53 percent of your slot." |
| **Charging Gauge · plan arcs** (extend 987:414) | Show start, estimated-so-far and planned on one ring (06.02) | add `State = Stale · Frozen` to Charging; keep Complete / Unknown | New layers in Charging: `Start segment` (white 40%), `Energy segment` (`energy`), `Planned segment` (2pt dotted `energy` 50%), `Start tick` (2×10 white), `Target dot` (8pt hollow white; filled when reached), `Comet` (gradient arc, hidden in Figma by default). TEXT props `Prefix` ("≈"), `Value` ("26%"), `Caption` ("est. battery"); BOOL `Show plan`. Text fills `text/onMesh`. Unknown: centre `Value` "+3.6", `Caption` "kWh added", ring = slot time. Stale: energy at 60%. Frozen: no comet. |
| **Button / Large · On Mesh Destructive** (add to 978:427) | "Stop charging" on the Hero mesh | State = Default · Pressed · Disabled · Loading | Fill `bg/frostStrong` (+ Glass/Regular effect), label `text/destructive`, leading stop.fill `action/destructive`; Pressed fill `bg/surface`; Disabled 40%; Loading = spinner `action/destructive`. Depends on 01's On Mesh / On Mesh Plain types in the same set. |
| **Estimate Row** | One line of the maths in "How we estimate" (06.03) | Kind = Default · Highlighted (pressed/linked) | 370×64, padding 12/0, gap 12: 40pt tint well (`bg/tint`, radius sm) + `Icon` (INSTANCE_SWAP 20, `icon/brand`), `Title` (Subheadline primary), `Formula` (Footnote secondary, 1–2 lines), trailing `Value` (Display/S 22 SF Pro Light, tabular; "≈" allowed; same number style as 05's Estimate Card). Highlighted: `bg/fill` row background. Separator inset 52. |
| **Session Summary Card** | Total + tiles + place line on Complete (06.30–06.34); reused by the receipt and by Bookings' completed pass detail (07) | Context = Complete · Receipt × Battery = Known · Unknown × Notice = None · Info | Surface, radius xl, Frost/Card, padding 20, gap 16: nested `Hero Stat` L Leading (Caption "Total", Value, Detail), hairline, 3 × `Stat Tile` (Battery / Energy / Time), place row (mappin + Footnote secondary), optional nested **Inline Notice** (04) on top, optional footer Caption 1 secondary ("Battery % is estimated from your 20% start."). |
| **Rate Prompt** | Inline rating on Complete (06.30, 06.35; Hidden when there is no booking id, §8.23) | State = Empty · Rated · Hidden | Surface, radius xl, padding 16, gap 6: `Title` (Headline: "How was your session?" / "You rated 4 stars"), `Message` (Footnote secondary), nested `Rating Stars` (Input size in Empty; Display size in Rated), `Action label` (Footnote Emph `text/brand` "Edit", Rated only). Whole card = one button "Leave a review" for VoiceOver; each star also adjustable. |
| **Text Area** (extend Text Field 1070:590 or new) | Multi-line review note (06.40–06.46) | State = Default · Focused · Filled · Error · Disabled | Same visuals as Text Field, height 120 (grows to 200, then scrolls), top-aligned text, `Counter` (TEXT, Caption 1 secondary, right-aligned below), `Counter error` (BOOL → `text/error`), `Placeholder`, `Value`. |
| **Receipt** | The saved PNG (06.36) | Battery = Known · Unknown | 370×700 (renders at 1080 px wide), Surface, radius xl: brand band (72, `brand/primary`, P mark Solid + SF Pro Wordmark White), the real hero (Success Mark M On light + "Charging complete" + "Your vehicle is ready to go") + date line, 3 tiles, key–value rows (Footnote; keys secondary, values primary right-aligned), **Perforation**, footer (thanks / pakplug.com / estimate note). Props for every text value. |
| **Perforation** (utility; share with Charging Pass) | Ticket-style divider | none | 370×16: 1pt dashed `stroke/separator` (dash 4, gap 4) + two 16pt semicircle notches filled with the backdrop colour at x 0 and x 370. |
| **Live Activity / Charging** [P16] | Lock Screen Live Activity (06.22–06.24) | State = Charging · Ending · Unknown battery · Stale · Complete · Stopped at charger | 370×160 (Complete 132), radius 24, `mesh/deep` fill + 1pt `stroke/highlight`, padding 16. Row 1: P mark Solid 20 + `Station` (Footnote Emph onMesh) + `Window` (Footnote onMesh) or nested Status Pill S. Row 2: `Battery` (Display/L onMesh, "≈26%") + `Battery caption` ("est. battery"), `Time` (Display/L `energy`, "28:00") + "left". Row 3: progress 338×6 (track white 20%, fill `energy`; Ending `status/warning`). Row 4: `Meta` (Footnote onMesh "Rs 152 so far · 3.6 kWh"). Unknown: Row 2 left = "+3.6 kWh". Stale: Row 4 "Updating…", fill 60%. Native: ActivityKit `ActivityConfiguration`, SwiftUI; mark it "native-only, not Flutter". |
| **Dynamic Island / Charging** [P16] | Compact, minimal and expanded island (06.25, 06.26) | Presentation = Compact · Minimal · Expanded × State = Charging · Ending · Complete | Compact 250×37: leading 20pt ring (slot progress) + bolt.fill 10, trailing `Time` (Display/S 22 SF Pro Light `energy`, tabular; Ending `status/warning`, Complete checkmark). Minimal 37×37: ring + bolt. Expanded 378×176 radius 44: leading (P mark 24 + `Battery` Display/M + "est."), trailing (`Time` Display/M `energy` + "left"), centre `Station` (Footnote), bottom (progress 330×6 + `Start`/`End` Caption 2 + `Meta` Footnote). Fill #000 (OS-owned). |
| **iOS / Lock Screen** (OS mock template) | Backdrop for 06.22–06.24, 06.27, 06.28, 06.28b | Clock = any (TEXT) | 402×874: Mesh Hero wallpaper + `bg/scrim` dim, Status Bar Light, `Date` (SF Pro Semibold 20 white), `Clock` (SF Pro Medium 104 white), slot for activities/notifications (y 460–720), flashlight/camera glass circles, home indicator Light. Labelled "OS-owned". |
| **iOS / Permission Alert · Kind=Photos** (extend 01's) | Add-to-Photos prompt (06.38) | — | Same anatomy as 01's alert; title "“PakPlug” Would Like to Add to your Photos", message = usage string, "Don't Allow" / "Allow". |

**Dependencies (not new here, built by others):** Success Mark, Confetti, Button / Large On Mesh + On Mesh Plain, Notification Preview, iOS / Keyboard (01/03); Inline Notice (04); Flow 05's **Level Slider** Mode=Battery (06.05; Update battery %). **Reused as-is:** Map Status Pill Notice 975:253 (milestone, offline, back-online, stopped pills; instance fill overridden to `bg/frostStrong` on the mesh); Toast 1088:631 (every snackbar); Rating Stars 1088:728; Hero Stat, Stat Tile, Session Timeline Item, Tab Bar Accessory / Live Charging (all 4 states), Nav Bar (button fills overridden to Frost Strong on the mesh), Sheet Header, State View, List Row, List Group Header, Status Pill, Chip, Icon Button, Button / Large and / Medium. **Linked, not rebuilt:** Charge tab state 2 = 05.04.

---

## 7. Proposals (not in the logic map), flagged

| # | Proposal | Why | Applied in frames? |
|---|---|---|---|
| P1 | "≈" on every battery % plus "est." where there is room, including the stop sheet body ("Your car is at ≈26%"), the receipt note, the accessory and notifications | The app can't read the car's battery (brief); an unmarked % reads as a measured fact | yes (all) |
| P2 | Replace the hard-coded "KM ADDED +92" with **Power** (`currentPowerKw`, which exists but isn't shown). A range estimate ("≈ +22 km") waits until vehicles have an efficiency value | "+92" is fake data (Appendix 4); power is real and useful | yes |
| P3 | "Left in your slot" instead of "to full" (Live, accessory "28:00 left") | "to full" is really booking time left (Appendix 4); consistent with 02 P11 | yes |
| P4 | Session Progress: a "Slot ends" node, plan header "Plan · until 7:00 PM · ≈31% · Rs 286 est.", Hero Stat detail "Ends 7:00 PM" / "Ended 7:00 PM", and "Charging started" merged into "Plugged in" when the times match. **Data:** the planner's choice (05) must be stored with the session (local or backend); without it the header reads "Slot · until 7:00 PM" | Shows the slot and the planner's promise; the logic shows the same time twice | yes (06.02) |
| P5 | Gauge plan arcs: start tick, estimated-so-far arc, dotted planned arc, target dot | Makes the estimate's origin and destination visible | yes |
| P6 | "How we estimate" sheet (info button, or tap the gauge) with formulas | The brief asks to show how it is computed | yes (06.03) |
| P7 | "Update battery %": the driver enters what the car shows (05's Level Slider), the sheet shows "Our estimate now: ≈26%", and the estimate re-bases from now; also the "Add your battery now" chip (05.28's label) when it is unknown | The car's screen is the truth; this fixes drift without a car API. Backend must accept a mid-session SoC update (or keep it local) | yes (06.05, 06.08) |
| P8 | The brief's estimate line in the Live stats card | Every estimate needs the disclaimer (brief) | yes |
| P9 | Milestone pills + haptic schedule (started, halfway, every 10%, ≈80%, plan reached, 1 min) | Micro-interactions the brief asks for; quiet and foreground-only | yes (06.01, 06.04, 06.12) |
| P10 | Ending-soon state at 5:00 (pill, notice "Charging stops automatically at 7:00 PM.", warning haptic) | The auto-stop at 0 is in the logic; nothing warns first | yes (06.06) |
| P11 | Connection lost after 15 s: "Reconnecting… · Last update 6:32 PM", values keep estimating, Power "—", "Back online" | The logic polls but has no offline state | yes (06.09) |
| P12 | Remote close: a 1.2 s "Stopped at the charger" hold on Live, and the notice "Charging stopped at the charger at 6:44 PM, before your slot ended." on Complete (no billing claim: the Total is the backend's billed amount) | The logic jumps to Complete silently; people need to know it wasn't them. Neutral wording: we can't tell host from charger | yes (06.10, 06.32) |
| P13 | Decision row in the stop sheet: "Keep charging until 7:00 PM: ≈31% · Rs 286 est." | Shows what stopping gives up (Glovo pattern) | yes (06.14) |
| P14 | Message host on the Live nav bar → existing `ChatThreadScreen(bookingId)` | Parking/cable problems happen while charging; the thread already exists per booking | yes |
| P15 | Minimize chevron.down at top-left (iOS convention) instead of top-right | Matches Apple Music/Maps and frees the right side for info + message | yes |
| P16 | Lock Screen Live Activity + Dynamic Island (ActivityKit; native Swift extension) | Concept C; the code already has a home-widget charging surface on Android | yes (06.22–06.26) |
| P17 | Local notifications only when Live Activities are off: started, plan done (P40), ≈80% est., 5 minutes left, complete; bodies fit the preview's 2 lines | Onboarding promises "a ping when your car hits 80%"; no duplicates when the Live Activity is on | yes (06.27, 06.28, 06.28b) |
| P18 | No Stop button on OS surfaces; stopping always goes through the confirm sheet | Stopping is billed and irreversible | yes |
| P19 | Inline stars on Complete open `LeaveReviewModal` preset with the tapped rating; rating word under the stars; "Tap a star to rate" | Higher review completion (Uber/Lyft/Instacart); the logic modal is unchanged and still not auto-shown | yes (06.30, 06.40, 06.41) |
| P20 | A "Done" primary button on Complete (same action as ✕ → Charge tab) | ✕ alone is a small, top-corner exit; Done is in the thumb zone | yes |
| P21 | Receipt and summary additions: "kWh × Rs/kWh" detail, connector, rate, vehicle + plate, battery-estimate note, human-readable "PP-2410-0482" instead of "#{first 8 chars of session id}" | Receipts get shared with employers/families; the 8-char hash is unreadable | yes (06.30, 06.31, 06.36) |
| P22 | Receipt thumbnail after saving + tap to share | iOS screenshot-like confirmation; saves a trip to Photos to share | yes (06.37) |
| P23 | Toast wording "Receipt saved to Photos" (iOS term) instead of "gallery" | Platform language; frames keep the real string | flag only |
| P24 | 12-hour times "6:00 – 7:00 PM" in the summary instead of "HH:mm – HH:mm" | Matches the rest of the app (Bookings, Book a slot) and local habit | yes |
| P25 | Battery unknown state instead of the code's default 40%: Live gauge "+3.6 kWh added", accessory / Charge tab title "Charging · +3.6 kWh", stop sheet body without "Your car is at X%" ("Ending now bills this session at Rs 152."), Complete and receipt "—" | A made-up 40% is wrong data | yes (06.08, 06.14b, 06.34) |
| P26 | Light confetti on Complete (24 pieces), none on relaunch/resume | Celebrate without fatigue for a repeated action | yes (06.29) |
| P27 | Accessory Ending state from 5:00 that keeps the countdown ("4:59 left · Rs 262"); "Ending · Rs X" only at ≤ 0 | Refines 02's rule; people still need the countdown | yes (06.17) |
| P28 | "Settings" action on "Permission required to save receipt" | The logic gives no path to fix it | yes (06.39) |
| P29 | "Last session" card on the Charge tab after Complete | The Complete's ✕ lands on Charge; a quick path back to the receipt | yes (06.50) |
| P30 | Rate card turns into "You rated 4 stars · Edit" after submitting | Confirms the action in place; Edit maps to the existing Edit Review | yes (06.35) |
| P31 | Timeline card on Complete (Plugged in / Charging started / Slot ended) | Uses the existing Session Timeline Item; answers "when exactly did it stop?" | yes (06.31) |
| P32 | Live Activity stays 30 min after the end, then dismisses | Lets people glance at the final cost on the Lock Screen | doc |
| P33 | Overline "STOPPING…" / "CHARGING STOPPED" during stop and remote close; accessory title "Stopping…" (the Stopping variant exists in the component, the copy doesn't exist in the logic) | Status in the same place people already read it | yes (06.07, 06.10, 06.15, 06.18) |
| P34 | Auto-retry the auto-stop every 10 s when it fails at 0:00, plus a 15 s timeout on any stop | The slot is over; stopping must not depend on a tap | interaction only |
| P35 | "Ramping up" caption and the "rated" fallback for Power | The first seconds show 0 kW; tell people why | yes (06.01) |
| P36 | Estimate Row tap highlights the matching element on the Live screen | Helps people map the maths to the screen | interaction only |
| P37 | Time-based kWh estimate (kW × hours × 0.92) when the session's `energyKwh` is null; the logic shows "—" | The brief's charge maths; most home chargers send no live meter value. The meter value always wins when present | yes (06.02 and every Live frame) |
| P38 | Toast "Battery updated · estimates recalculated" after Update battery % | Confirms the re-base | interaction only |
| P39 | "Slot time unavailable" detail and "Slot · time unavailable" header when the booking window is null | The logic shows a bare "—" | yes (06.11) |
| P40 | Plan-done milestone and reminder: pill / notification "Your 30 min plan is done" when a time plan ends before the slot; plan header "Done · ≈26%" | 05 promises "We'll remind you at 6:30 PM" (05-CH18) and hands the reminder to this flow; charging itself continues (the logic only auto-stops at the slot end) | yes (06.28b) |
| P41 | Stat labels in sentence case with units ("Energy" for KWH, "So far" for SO FAR, "Power"); Complete tiles Battery / Energy / Time with Total as the hero; "—" instead of "N/A" for a null kWh | One label language across Live, Complete, receipt and 05's Estimate Card | yes (06.02, 06.30, 06.34) |
| P42 | Battery-unknown Complete footer "Add your battery % next time for a % estimate."; a vehicle without a battery size gets 05's "Add battery size" (→ Edit vehicle, 08) | Explains the "—" and gives a fix | yes (06.34) |
| P43 | Photos usage string "Save your charging receipts as images." | iOS needs a purpose string; none exists in the code | yes (06.38) |
| P44 | "Your car may be full · Check its screen" pill when the meter reports 0 kW for 2 min | The estimate can't see a full battery; only the meter's power can hint at it | doc (§8.2) |

---

## 8. Edge cases & defaults chosen (Hammad asleep: decided)
1. **Battery % unknown** (driver skipped it in 05, or the vehicle has no battery size; battery is optional in Add vehicle) → Live 06.08, stop sheet 06.14b, accessory and Charge tab ("Charging · +3.6 kWh"), Complete 06.34: show kWh and Rs, never a % and never the code's default 40 [P25]. The chip offers "Add your battery now" (05.28's label) → 06.05. If the battery size is missing but the start % exists, the chip says "Add battery size" (05-CH5's label) and links to Edit vehicle (08) [P42].
2. **The estimate passes 100%** → cap at "≈100%"; once power reported by the meter stays at 0 kW for 2 min, show the pill "Your car may be full · Check its screen" [P44]. Never show more than 100. Without a meter, the estimate simply caps at ≈100% and the time keeps counting.
3. **Estimate drift** (the car shows 28%, we say ≈26%) → "Update battery %" (06.05) re-bases from now. History before the update is kept for the receipt (start % stays as entered).
4. **Meter vs time:** when the API's `energyKwh` exists, use it for kWh and cost (the How-we-estimate row reads "From the charger's meter" without "≈"); the battery stays "≈". Without it, kWh and cost are time-based [P37]; with neither a meter nor a kW figure, kWh shows the logic's "—".
5. **Values never go down** on screen. If the server's numbers are below the local estimate, hold until they catch up. If the server is far above (> 10%), ease up over 600 ms.
6. **Per-hour stations:** cost so far = elapsed × Rs/hr (logic `liveTimeBasedRunningCostPkr`); Detail "1 h × Rs 300/hr"; kWh stays an estimate.
7. **Started late inside the ±15-min window** (for example 6:10) → "Plugged in 6:10 PM"; the slot still ends at 7:00; the plan is shorter (05 recomputes). The track starts at plug-in, not at the booking start.
8. **Slot ends** → auto-stop (logic). If the stop fails, auto-retry every 10 s + manual Retry; keep showing 0:00 and Ending.
9. **Remote close** → 06.10 hold, then Complete with the notice (06.32). The wording never blames the host.
10. **App killed after a stop** → relaunch shows Complete without confetti (logic pending-complete id).
11. **Stop tapped twice / during Stopping** → ignored (logic in-flight guard); the button is in Loading.
12. **Stop from the accessory** on another tab → the confirm sheet appears over that tab (root); after success, Complete pushes over the shell.
13. **Minimize while Stopping** → allowed; the accessory shows Stopping.
14. **Logout during a session** → the logic's guard dialog (Profile flow, 08). Not drawn here.
15. **No booking window** (remaining null) → "—", State=No window (06.11), accessory No window. No auto-stop (nothing to count down).
16. **Live Activities permission off** → notifications fallback; both off → only in-app surfaces. The accessory always shows.
17. **Multiple Live Activities** (for example Uber + PakPlug) → our minimal presentation (ring + bolt).
18. **Larger text (AX1–AX5):** Live scrolls; the gauge shrinks to 200; the stats card stacks tiles as rows (label left, value right); Stop stays pinned. Complete: tiles become rows; buttons stay pinned.
19. **Reduce Motion / Low Power / Reduce Transparency** → §4.0 fallbacks.
20. **VoiceOver order on Live:** Minimize · How we estimate · Message host · overline · gauge ("Estimated battery, about 26 percent. Started at 20 percent.") · time left · Energy · So far · Power · estimate line · session progress · tip · Stop charging.
21. **Dark mode:** the Hero and Celebrate meshes are already dark-based; Frost Strong cards and sheets follow the semantic tokens' dark values. Not drawn tonight.
22. **Rounding:** live kWh and Rs floor, the ≈ battery % rounds, final kWh and Rs round (2.0.1). The stop sheet at 6:32 says Rs 152; the early-stop Complete (06.33) shows Rs 152 (dummy). The billed amount from the backend always wins.
23. **Review entry with no booking id** → the logic's toast "Booking not found — cannot open review" (06.35b); the Rate Prompt uses State=Hidden when the id is known to be missing at load.
24. **Review already submitted** (opening Complete again from the pending id) → Rate Prompt shows Rated.
25. **Review window** is 7 days, so it is always open from Complete; read-only states (06.47/06.48) come from Bookings (07).
26. **Receipt offline** → rendering is local, so saving works offline.
27. **Large money** → thousands separators "Rs 2,468"; up to 7 characters fit in the tiles and the Live Activity.
28. **Times over 1 h** → "1:28:00" (logic h:mm:ss) in the Hero Stat; the accessory subtitle stays one line ("1:28:00 left · Rs 152").
29. **Review over 500** → the logic says both "disabled" and "snackbar on submit". Default: the button looks disabled, but a tap still shows "Shorten your review before submitting." (the tap target stays live). Flag for Rayan.
30. **Only one toast at a time**; a new one replaces the old (`fade.quick`). Toasts never cover Stop, the accessory, the tab bar, Home's chips or the search capsule (02 rule 22); positions in §2.0.7.
31. **A milestone and a toast at once** → the toast (bottom) and the pill (top) can coexist; two pills can't.
32. **Message host** with a blocked thread → the chat opens in its blocked mode (09); the button is never hidden.
33. **Station name missing** → overline "CHARGING · CHARGING STATION" (real fallback), Charge tab card "Charging session" (real), Live Activity "PakPlug charger", Complete and receipt show the address only if it exists, else the station row is omitted.
34. **No plan saved** (started before the planner shipped, or the app was reinstalled mid-session) → Session Progress header "Slot · until 7:00 PM", no planned arc or target dot on the gauge, no plan-done reminder; the stop sheet's decision row reads "Keep charging until 7:00 PM: ≈31% · Rs 286 est." computed from the slot.
35. **No session or not active** → the accessory is hidden (logic); a session that ends while the app is backgrounded shows Complete on the next foreground (shell listener / pending id).
36. **VoiceOver on the battery slider** → ±1% per swipe in 06.05 so any reading (28%) is reachable; 05's spec says ±5% for its planner, which makes 28 unreachable: flagged to align 05 to ±1% (Review notes).

---

## 9. Logic-check summary (for the logic card)

**Covered from the logic map**
- §E `ActiveChargingView`: entry routes (4.1, 4.9-2, 4.15) · overline (06.02) and its fallback "Charging Station" (06.13 note, §8.33) · battery ring → ≈ estimate (06.02), null → Unknown instead of 40 (06.08) · ETA (Hero Stat, 06.02), "—" (06.11) · KWH (`energyKwh` or "—"; time estimate P37) and SO FAR stat cells (06.02) · KM ADDED replaced by Power [P2] · timeline Plugged in / Charging started / Now (Session Progress 06.02; Complete timeline 06.31) · tip (06.02, 06.12) · Minimize (06.02, 4.9) · Stop charging (06.02 → 06.14) · "Loading session..." (06.13) · stop loading = spinner + disabled (06.15) · "Error stopping session: $e" + Retry (06.16) · auto-stop "Session time reached. Stopping charging automatically..." (06.07) · remote close → Complete (06.10, 06.32) · 1 s re-render (4.2).
- §E `EndChargingSessionModal` (`DestructiveConfirmSheet`): title, body template, End session / Keep charging (06.14); battery-unknown body (06.14b).
- §A `DriverHomePersistentChargingPanel`: title, the three subtitle cases (null 06.19, ≤ 0 "Ending · Rs X" 06.17b, countdown 02.13 / 06.20), bolt well, 1 s tick, tap → Live, Stop → modal (root) → Complete, stop-in-flight guard, "Could not stop session: $e" (06.20), hidden when no session (§8.35); component states Charging / Ending / No window / Stopping (967:124/135/146/157).
- §D `ChargeScreen` state 2 (05.04, linked) and the ✕ destination Charge tab (06.50).
- §F `ChargingCompleteView`: entry routes (§3.6) · ✕ → Charge tab · check + "Charging complete" / "Your vehicle is ready to go" · Battery (40 default → "—", 06.34) / kWh ("N/A" → "—", P41) / Total `billedAmount ?? runningCostEstimate` · Session summary rows (06.31) · Leave a review (Rate Prompt 06.30 → 06.40) · "Booking not found — cannot open review" (06.35b) · Download receipt with permission (06.38, 06.39), success (06.37) and all three failure strings (06.39b) · staggered entrance with safety timer (4.12) · pending-id clear (4.12-10).
- §F Receipt widget (06.36): brand header, the same hero (check, title, subtitle), stats, summary, dashed divider, footer; no buttons.
- §F `LeaveReviewModal`: not auto-shown; loading, error + error text + Retry (06.49), read-only none (06.48), new (06.40), edit (06.46), read-only (06.47), subtitle, stars with clear-on-retap, required hint (06.42), optional field, counter + red at ≥ 500 + disabled + snackbar (06.43), Submit/Update, 7-day note, success (06.35, 06.46) and error strings (06.45).
- Appendix 1 shell pill · Appendix 2 foreground banner suppression (4.11-3) and the widget stop intent → Complete (reused for Live Activity taps) · Appendix 4 gaps fixed: KM ADDED, "to full", default 40%, kW never shown, ✕ lands on Charge.

**Contrast to record on the card (builder):** the 06.02 white "est. battery" caption at the breathe peak (≥ 4.5:1) and the 06.30 black title (≥ 3:1) and subtitle (≥ 4.5:1) on the Celebrate glow, measured with `scratchpad/contrast.py` (§2.0.3).

**Dummy data used (flag as dummy, not a proposal):** the AC time series (§2.0.1: 20% start, 7.4 kW, 92%, Rs 42/kWh, 6:00–7:00 PM, BYD Atto 3 60.5 kWh), the 30 min plan variant (06.28b, from 05.24), the DC state demo (Gulberg Galleria 60 kW, Rs 68/kWh, 52 kW tapering), "Network error" and "HTTP 500" in error templates, the review note text, receipt no. PP-2410-0482, the host stop at 6:44 PM, host Bilal.

**FLAG — PROPOSALS:** P1–P44 (§7); each section's Logic card lists only its own. **Wanted SF Symbols not in the set:** square.and.arrow.down (Download receipt), wifi.slash (Reconnecting), arrow.clockwise (Retry), photo (Photos permission), flag.checkered (Slot ends node, optional), sparkles (milestone, optional). Nearest listed icons are used in the frames.

**For Rayan (native):** Live Activity + Dynamic Island need an ActivityKit widget extension in Swift (not Flutter UI) and APNs push-to-update; countdowns use `Text(timerInterval:)` so they tick without pushes. The accessory is the iOS 26 `UITabAccessory` (02/C1). Tabular figures everywhere numbers tick. Haptics map to `UIImpactFeedbackGenerator` (light/medium), `UISelectionFeedbackGenerator`, `UINotificationFeedbackGenerator` (success/warning/error); Flutter `HapticFeedback` equivalents.

---

## Review notes (2026-10-04)

Reviewed against `BRIEF.md`, `driver-logic-map.md` §A (`DriverHomePersistentChargingPanel`), §E, §F and Appendices 1–4, and the sibling specs 01, 02 and 05. Changes made in this file:

**Logic-map coverage (missing states, errors, copy)**
1. Added **06.14b · Stop · Battery unknown**: the real modal body would print the code's default 40%, so the body drops the "Your car is at X% —" clause ("Ending now bills this session at Rs 152.") and the decision row shows kWh (P25, P13).
2. Added **06.17b · Accessory · Slot ended**: the real ≤ 0 subtitle "Ending · Rs 285" was described but never drawn.
3. Added **06.35b · Complete · Review unavailable** with the real toast "Booking not found — cannot open review" (it was only mentioned in an interaction).
4. Added **06.39b · Receipt · Couldn't save** with "Could not save receipt. Please try again."; the third real failure string "Could not save receipt" was missing from the interactions and is now listed with the other two (trigger mapping marked (?) for Rayan).
5. **06.21 is now a link to 05.04.** Flow 05 already builds Charge tab state 2 with a different layout; two versions of one screen would break consistency.
6. Added the real overline fallback "CHARGING · CHARGING STATION" (06.13 note, §8.33), the real KWH behaviour (`energyKwh` or "—") and Complete's "N/A", the hidden accessory state, `DestructiveConfirmSheet`, the entry routes of Live and Complete, and the receipt's real hero subtitle "Your vehicle is ready to go" (the logic says the receipt repeats the same hero).
7. 06.49 now shows the real error text under "Failed to load review" (dummy "Network error") instead of invented copy.
8. §3 Real copy now maps every logic string to the frame that shows it.

**Invented data now flagged**
9. The time-based kWh shown while `energyKwh` is null replaced the logic's "—" without a flag → **P37**. The planner's plan shown on Live needs storing with the session → added to **P4**. The receipt number PP-2410-0482 now notes the real "#{8 chars}" format (P21).
10. Unnumbered "[P]" items got numbers and rows in §7: P38 (battery-updated toast), P39 (slot time unavailable), P40 (plan-done reminder), P41 (stat labels, Complete tiles, "—" for N/A), P42 (battery-unknown footer, "Add battery size"), P43 (Photos usage string), P44 ("Your car may be full"). P25 and P33 now list every place they apply. FLAG block = P1–P44.
11. Removed the unverifiable billing claim "You're billed for actual usage." from 06.32's notice; it now says "Charging stopped at the charger at 6:44 PM, before your slot ended."

**Dummy maths**
12. 6:44 PM values broke the spec's own floor rule (4.993 kWh shows as 5.0): live is now 4.9 kWh · Rs 209 (06.10), final 5.0 kWh · Rs 210 (06.32).
13. The 6:53 PM row was inconsistent (6.0 kWh × Rs 42 = Rs 252, not 254; 29.94% would floor to 29%). The ≈ battery % now **rounds** (it is an approximation, and rounding matches 05's planner, so 06.04 reads ≈26% like 05.24); the 10% milestone moves to 6:51 PM (5.7 kWh · ≈30% · Rs 243). A check line with the arithmetic was added under the table.

**Brief consistency (tokens, contrast, type, naming)**
14. Floating chrome on the Hero and Celebrate meshes is now Frost Strong everywhere (Nav Bar buttons, Map Status Pill, ✕ close), per the brief's rule; the inventory components are glass by default, so the overrides are spelled out.
15. The energy glow behind the gauge is now a radial ring that leaves the centre on plain mesh, so the white "est. battery" caption keeps the measured 4.7:1+; a builder measurement was added.
16. Celebrate mesh: the deviation from the brief's literal "white below ~140pt" is documented with the reason (bright glow and energy blob), the thresholds are aligned with 01 (title ≥ 3:1, subtitle ≥ 4.5:1), and the builder must record the measured ratios on the Logic card.
17. Numbers use Display (SF Pro Light): the Dynamic Island compact time and the Estimate Row values moved from Subheadline Emph / Headline to Display/S. The Lock Screen's Semibold date is marked as OS chrome, the only exception to "no Semibold".
18. Sections now follow the split pattern of 05 / 07 / 09 (Flow 06A–06D) with the brief's anatomy restated; frame labels keep `06.nn · Screen · State`.

**Consistency with sibling specs**
19. Button press scale 0.97 (02 §4.0), not 0.98. Toast on Home with the accessory at y 556 (02 rule 22: never over the chips), not y 660. The accessory's Ending state has no haptic (02 rule 21 and this spec's own foreground-only rule; the draft contradicted itself). The arrival haptic is **success**, which 05 hands to 06.
20. 06.05 now uses 05's **Level Slider** Mode=Battery and 05's presets with concrete geometry; the 06.08 chip uses 05.28's label "Add your battery now", and a car without a battery size uses 05-CH5's "Add battery size".
21. 05 promises "We'll remind you at 6:30 PM" for a 30 min plan and hands the reminder to this flow (05-CH18); the draft had no such reminder. Added milestone M5b, the alert update (4.10-4), the local notification (4.11) and frame **06.28b**.

**Micro-interactions**
22. The shared token values (snappy, smooth, bouncy, fades, M-rise, M-push, M-replace), press rules and toast rules are restated in §4.0, and every row in §4 now gives timing + easing, haptic, VoiceOver and Reduce Motion. Added: Live opened later (4.1-5), the VO announcement throttle, milestone merge rules, the slider and estimate-row VO, the review-over-500 tap, receipt VO and the Charge-tab card VO.
23. The `pulse` token was 1.2 s, which can't stay "in phase" with a 4.0 s breathe; it is now 1.33 s (three pulses per breath).

**Mobbin**
24. Five more screen searches (same parameters as the brief) added 14 references: Polarsteps, Oura and American Airlines (loading / in-progress states on Live); Stardust, MacroFactor and Future Pro (Update battery %); Lyft (stop confirm); American Airlines and Box Box Club (time-critical Lock Screen copy); Oura and Grab (Complete: missing-data explanation, inline stars); Tolan, Polarsteps and Grok (receipt saved). Total 86 citations, 85 unique; every major screen now has at least 3 (Live 15, milestones 6, estimate + update 7, stop 7, accessory 3, Live Activity 8, Dynamic Island 7, notifications 5, Complete 11, receipt 9, review 8).

**Frames:** 50 → 54 (25 P1, 29 P2): +06.14b (P1), +06.17b, +06.28b, +06.35b, +06.39b (P2), −06.21 (now a link).

**Open flags for Hammad / Rayan**
- 05 says the battery slider moves ±5% per VoiceOver swipe, which makes readings like 28% unreachable; 06.05 uses ±1%. Align 05.
- Which code path prints each of the three receipt failure strings (?).
- The Celebrate-mesh contrast must be measured on the built 06.30 before the layout is final.
