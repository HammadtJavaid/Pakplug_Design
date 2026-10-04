# 00 · System: one design language for the PakPlug driver flows

Unifying spec for the Figma build of Flows 1–9 on **Driver Flows (946:8)**. Research only: no Figma calls were made.
Sources: `brief/BRIEF.md`, `brief/NEW-COMPONENTS.md`, and every flow spec `01-onboarding.md` … `09-messages.md` (all reviewed on 2026-10-04).

**Precedence.** This file is the single answer for navigation, sheets, motion, haptics, shared components, section names, formats, tones, materials and icons. Every flow spec now opens with a "00-system alignment" block that lists what changed in it. If a line in a flow spec still disagrees with this file, **this file wins**. Flow specs stay the source for their own frames, real copy, Mobbin references, proposals and logic checks.

Contents: 1 Navigation · 2 Motion and haptics · 3 Shared components · 4 Section plan · 5 Consistency rules · 6 Conflicts resolved.

---

## 1. Navigation patterns

### 1.1 Nav Bar (one spec for every screen)

Component: `Nav Bar` [1087:643], placed at **(0,54)** on every screen that has one. Never drawn inside a sheet (sheets use `Sheet Header`, §1.2).

| Part | Inline (pushed screens, full-screen covers) | Large (root tabs: Charge, Bookings, Messages, Profile) |
|---|---|---|
| Variant | Style=Inline 1087:607, 402×52 | Style=Large 1087:624, 402×103 |
| Leading | `Leading#1087:3` on/off. Glyph on the exposed "Leading button" (`Icon#979:0`): **Back** chevron.left 1025:481 (pushed) · **Close** xmark 958:72 (full-screen cover, step 1 of a modal task) · **Minimize** chevron.down 1025:483 (Live only) · **None** (root tabs, Choose role, Connecting) | off |
| Title | `Title#1087:0`, Headline 17 Medium, `text/primary`, centred, 1 line, tail truncation, never under a button | Large Title 34 Medium, `text/primary`, x 16, in the lower 51pt of the bar; the top 52pt row holds the buttons |
| Trailing | Up to 2 icon actions (`Trailing 1#1087:6` outermost at the right edge, `Trailing 2#1087:9` 8pt to its left), **or** 1 text action (new `Trailing text`, below) | same |
| Buttons | 44×44 `Icon Button` M, 16pt from the screen edges, vertically centred in the 52pt row | same |

**New properties (build before screens, §3 C1):**
- `Material` (variant): **Glass** (default: `Icon Button` Glass M; over the map, Mesh Quiet, canvas) · **Frost** (button fill `bg/frostStrong` 948:44, icons `icon/primary` 948:61; over Mesh Hero and Mesh Celebrate: Charge tab, planner, Live, Complete) · **Camera** (Glass M with the `Symbol` recoloured `icon/onPrimary` 948:65 and the title `text/onMesh` 1067:505; scanner 05.05–05.12 only).
- `Scroll edge` (BOOL): a `bg/frostStrong` band behind the bar from y 0 to 106 (it also covers the status bar) + 1px `stroke/hairline` 948:88 at its bottom. Off at rest; on as soon as content scrolls under the bar (`fade.quick`). On Mesh Hero the band stays off (the Frost buttons are enough).
- `Trailing text` (BOOL) + `Trailing label` (TEXT): replaces Trailing 1/2 with a glass capsule, h 44, padding 0/14, Glass/Regular + `bg/frostStrong`, Subheadline Emph `text/brand`; disabled label `text/tertiary`. Used for "Mark all read" (08.53).

**In one line:** glass over the map and the meshes (Glass buttons on the map and Mesh Quiet, Frost buttons on Hero/Celebrate, transparent bar), solid on canvas and lists once content scrolls under it (`Scroll edge` band). Leading is Back, Close, Minimize or None; trailing is up to two icon actions or one text action.

**Title modes on pushed screens (pick one per screen; the flow spec names it):**
1. **Bar title** (default: lists, settings, utility screens: Saved chargers, Price Trends, Enter charger ID, My vehicles, Add/Edit vehicle, Edit profile, Account & settings, Notifications, Identity): the title shows in the bar from the start; the first content element sits at **y 122**.
2. **Content Large Title** (a statement or an entity name leads the screen: onboarding steps, Station details pushed 04.12): `Title#1087:0` = "" at rest; a Large Title (34 Medium) sits in the content at **y 122** (or y 146 under an eyebrow at y 122). When it scrolls under the bar the bar title fades in (`fade.quick`) together with `Scroll edge`.

**Large → Inline collapse (root tabs):** scroll-driven, not a tween; it completes after **51pt** of scroll (103 − 52). The collapsed bar is Inline with `Scroll edge` on. Content under a Large bar starts at **y 165**.

**On meshes and camera:** the bar background is always transparent; the Large/Inline title sits on the top glow, so it stays `text/primary` (brief's measured rule). Only `Material` changes the buttons.

**Home (map) has no Nav Bar.** Its chrome is the floating heart/bell (Glass M at (16,60), (68,60)), `Map Controls` at (339,60) and the bottom search capsule (02 §2.0).

### 1.2 Sheet anatomy

| Part | Rule |
|---|---|
| Surface | `bg/surface` 948:41, opaque on every background (also over meshes), top corners `radius/sheet` 38, bottom 0, effect Frost/Elevated, clip content |
| Grabber | 36×5, `bg/fillStrong` 948:47, radius pill, centred at **top + 5** (x 183). Hidden while a sheet is not dismissable (submitting, Summary) |
| Detents | **large**: top **y 62**, 402×812 (Book a slot, Reviews, pass detail, search, review with keyboard) · **medium**: the place sheet only, top **y 404** (≈ 54%) · **fit**: hugs its content, top = 874 − H (every other sheet). The last button in any sheet ends at **y ≤ 824** (16 above the home indicator at 840) |
| Header | `Sheet Header` [1008:422] at **top + 16**: **Place** 1008:401 for entity sheets (station, charger found: Title 2 up to 2 lines + Subheadline subtitle, trailing Share + Close) · **Form** 1008:413 for task sheets (Book a slot, Reviews, How we estimate, Update battery %, Booking details, review, inquiry, conversation options, cancel reason: Title + optional Subtitle, optional leading Back, trailing Close). Icon-led sheets use `Sheet / Action` (§3 C3) instead of a header |
| Header buttons | `Icon Button` **Fill S** 979:286 (34pt visual, 44pt hit area): Close xmark, Back chevron.left, Share square.and.arrow.up. Never Glass on an opaque sheet. Exception: the search sheet's ✕ is Fill M 979:283 because it sits beside the 44pt search field (03) |
| Behind | `bg/scrim` 948:48 full-frame, bound as is (the alpha lives in the variable; never change its opacity). The place sheet at medium has **no** scrim (the map stays live) |
| Sheet on sheet | The parent sheet recedes: scale **0.96** around its top centre + a second `bg/scrim` (Directions/Call over the place sheet or the pass detail, Choose vehicle/Confirm over Book a slot, Filter & sort over Search, Custom duration over the planner panel). At most two levels |
| Sheet over a full screen | Scrim only; the screen behind does **not** scale |
| In-sheet push | Reviews and Book a slot push inside the place sheet: content slides horizontally with 30% parallax (`smooth`), Header gets Back; detent forced to large |
| Dismiss | swipe down (follows the finger; past 30% of the height or > 800 pt/s down dismisses), Close, scrim tap. Detent change: velocity > 500 pt/s goes to the next detent, otherwise the nearest wins (`detent`). Grabber tap toggles medium ↔ large where both exist (place sheet). Not dismissable while submitting (grabber hidden, Close 40%) and for Kind=Summary |
| Keyboard | A sheet with a focused field moves to large; its primary button rides 8 above the keyboard at **y 478** |
| Status bar | Dark 996:398 unless the scrimmed top band renders darker than mid-grey, then Light 996:411 |

### 1.3 Modal vs push (presentation rules)

| Presentation | When | Motion | Examples |
|---|---|---|---|
| **Push** | Drill-down to a full screen in the same context; back is always safe | `M-push` (system ≈ 350 ms) + edge-swipe back | Saved chargers, Price Trends, Station details from Saved (04.12), Enter charger ID, Scanner (zoom transition from the Scan card), onboarding steps, chat thread (root push), My vehicles → Add/Edit vehicle, Edit profile, Account & settings, Notifications, Identity |
| **Sheet** | A task or detail that keeps its context visible underneath | `smooth` rise, scrim `fade.std` | Place sheet, search, Filter & sort, Directions, Call, Choose vehicle, Confirm booking, pass detail, How we estimate, Update battery %, End charging session, review, inquiry, conversation options, permission pre-prompt, Info / Coming soon |
| **Full-screen cover** | A focused moment that replaces the context: no tab bar, no edge-swipe back | slide up (`smooth`) or matched geometry | Charge planner (✕ leading, swipe-down disabled), Connecting, Live (chevron.down = minimize), Charging complete, You're booked (04.43) |
| **Native alert** (`Alert` 1014:577) | A short yes/no: ≤ 2 sentences, 2 buttons, no data rows | `alert` (§2.1) | Cancel booking, Logout, Delete account, Delete vehicle, Cannot start session, Location access off, Active charging session |
| **Rich confirm** (`Sheet / Action` Kind=Destructive) | A destructive decision that needs data rows | sheet | End charging session? (06.14) |
| **Route replace** | Leaving a flow for good | `M-replace` (250 ms; 400 ms when the mesh changes) | Splash → Story, All set → Home, auth loss → Sign in, Complete → Charge tab |
| **Toast** | The result of an action, transient | §2.1 Toast | every logic snackbar |

Alert buttons: side by side → safe action left, preferred/destructive right; stacked (labels > ~130pt) → destructive on top, safe below. Weights are the component's own (no Bold/Semibold).

### 1.4 Tab bar and accessory visibility

| Screen type | Tab bar (20,788) 362×64 | Live accessory (20,728) 362×52 |
|---|---|---|
| The 5 root tabs (Home, Charge, Bookings, Messages, Profile) | visible, `Selected` = that tab, Messages badge "2" (cap "9+", hidden at 0) | visible while a session is active (all states: Charging, Ending, No window, Stopping) |
| Root tab while a list scrolls down | `Tab Bar / Minimized` 967:169; the accessory moves inline to its right (iOS 26) | inline |
| Pushed screens (every push, including the logic's pushed `/my-bookings`, 07.40) | hidden | hidden |
| Full-screen covers (planner, Connecting, Live, Complete, You're booked) | hidden | hidden |
| Any bottom sheet open (including Filter & sort, search, place sheet) | covered by the sheet: do not draw it in sheet frames | covered |
| Alerts over a root tab | visible under the scrim | visible under the scrim |
| On Mesh Hero (Charge tab) | fill `bg/frostStrong` (floating chrome rule) | as built |

When the accessory shows on Home, the bottom stack (attribution, chips, search capsule) rises 60pt (02 §2.0).

### 1.5 Bottom-zone stacking and Toast placement

Toasts (`Toast` 1088:631, x 16, 370 wide) are always placed by their **bottom edge, 12pt above the top-most bottom element**, and grow upward. Read the instance height after setting the message (≈ 52 for one line, ≈ 72 for two) and set y = bottom − h. Fixed y values in flow specs are indicative; this table wins.

| Context | Toast bottom edge |
|---|---|
| Above the tab bar | 776 |
| Above the accessory (session active, root tab) | 716 |
| Home map, above the chips (no session / session) | 672 / 612 |
| Above a floating station card | card top − 12 |
| Above one pinned button at 772, or the Floating Action Pill | 760 |
| Above Slide to Start (top 760) | 748 |
| Above a two-button stack (primary at 712) | 700 |
| Above the Cost Footer (762) | 750 |
| Above a button riding on the keyboard (478) | 466 |
| Above the keyboard, no button (538) | 526 |
| Above the thread composer (780) | 768 |
| Above the scanner's manual pill (736) | 724 |
| Pushed screen with nothing pinned | 828 |

Bottom margins: a pinned button ends at y ≤ 824; floating chrome (Floating Action Pill) ends at 828. Keyboard: `iOS / Keyboard` at (0,538), 402×336.

---

## 2. Motion and haptics

### 2.1 Motion system (one table)

Easing names: **easeOut** = cubic-bezier(0, 0, 0.58, 1) (iOS `.easeOut`, Flutter `Curves.easeOut`) · **easeOutEmph** = cubic-bezier(0.22, 1, 0.36, 1) (Flutter `Cubic(0.22,1,0.36,1)`) · **easeInOut** = cubic-bezier(0.42, 0, 0.58, 1) · **easeIn** = cubic-bezier(0.42, 0, 1, 1) · **linear**. A millisecond value written next to a spring is its settle time, never a different curve.

| Token | Kind | Value | iOS (SwiftUI) | Flutter | Used for | Reduce Motion |
|---|---|---|---|---|---|---|
| `scrub` | step feedback | visual change instant; digits `numericText` 120 ms; **selection** haptic per step, max one per 60 ms | `.contentTransition(.numericText())` | `AnimatedSwitcher` 120 ms | % sliders (step 5% for haptics), start-time grid, availability bar, stars drag | haptics stay, no digit motion |
| `fade.quick` | tween | 150 ms easeOut | `.easeOut(duration: 0.15)` | 150 ms `Curves.easeOut` | content swaps, dismissals, toast out, the universal RM fallback | — |
| `fade.std` | tween | 220 ms easeOut | `.easeOut(duration: 0.22)` | 220 ms | scrims, State View swaps, banners, overline swaps | — |
| `roll` | numeric | 220 ms; only changed digits move, up for increases, down for countdowns; "≈", "Rs" and units never move | `.contentTransition(.numericText(countsDown:))` inside `.snappy(duration: 0.22)` | per-digit `AnimatedSwitcher`, 220 ms easeOutEmph | every number that changes | `fade.quick` cross-fade of the whole number |
| `alert` | tween | in: scale 1.08 → 1 + opacity 0 → 1, 250 ms easeOut; out: `fade.quick` | system alert | `showAdaptiveDialog` | native alerts | opacity only |
| `snappy` | spring | response 0.30, damping 0.85; settles ≈ 300 ms | `.snappy` | mass 1, stiffness 440, damping 36 | press release, chips, pills, segmented thumb, selection, pin select | `fade.quick` |
| `M-rise` | tween | y +12 → 0, opacity 0 → 1, 320 ms easeOutEmph, stagger 40 ms (60 ms on Celebrate) | `.easeOut` custom | `Cubic(0.22,1,0.36,1)` | screen entrances, card arrivals | one `fade.std` |
| `M-push` | system | ≈ 350 ms + interactive edge swipe | `NavigationStack` | `CupertinoPageRoute` | pushes and pops | system cross-fade |
| `M-grow` | spring | height 0 → auto `smooth`, content `fade.std`; removal `fade.quick` then collapse `smooth` | — | `AnimatedSize` | Inline Notices, helper lines, tip lines appearing in a layout | fade only |
| `bouncy` | spring | response 0.40, damping 0.70; ≈ 400 ms, one ≈ 4% overshoot | `.bouncy` | stiffness 250, damping 22 | heart save, pin pop-in, star fill, badge pop, check badge, thumbnail pop | no overshoot, `fade.quick` |
| `smooth` | spring | response 0.45, damping 1.0; ≈ 450 ms | `.smooth` | stiffness 195, damping 28 | sheets, cards, stack moves, matched geometry, toasts in | `fade.std` |
| `detent` | spring | `smooth`; 1:1 drag; > 500 pt/s jumps a detent; rubber band 0.3 above large | sheet detents | `DraggableScrollableSheet` | sheet drags | snap, no overshoot |
| `camera` | tween | 350–500 ms easeInOut by distance | MapKit/GMS animate | `animateCamera` | map moves | instant move |
| `M-replace` | tween | cross-dissolve 250 ms easeOut (400 ms when the mesh changes) | `.transition(.opacity)` | `FadeTransition` | route replacement | same |
| `M-shake` | keyframes | 3 × ±6pt, 320 ms | `.keyframeAnimator` | `TweenSequence` | validation errors, 0-star submit, taken slot chip | colour + message only |
| `count` | tween | count-up 700 ms easeOut, `roll` on the last digits | `.numericText` + timer | `TweenAnimationBuilder` | Complete Total, Profile stats (first appearance per launch only) | final value |
| `sweep` | spring | gauge arc A → B with `smooth`: entry 500 ms (start segment) + 400 ms (so far) ≈ 900 ms; re-base 600 ms; final 300 ms | `Circle().trim` | `CustomPainter` | Charging Gauge, Charge Plan Bar | arcs jump |
| `send` | spring | text flies from the composer to its bubble slot, `smooth` 320–400 ms by distance, radius 22 → 20 | `matchedGeometryEffect` | `Hero` | chat send | bubble fades in |
| **Loops** | | | | | | |
| `tick` | clock | UI clock every 1.0 s; continuous values (arcs, bars) interpolate **linearly** over the second | `TimelineView(.periodic)` | `Ticker` | Live countdown, arcs, progress | arcs step per integer % |
| `breathe` | loop | glow ring scale 0.96 ↔ 1.04, opacity 0.55 ↔ 0.85, sine easeInOut, 4.0 s (3.0 s when ending soon) | `.repeatForever` | `AnimationController` | Live glow | static at 0.7 |
| `pulse` | loop | ring around a dot: scale 1 → 2.2, opacity 0.5 → 0, easeOut, **1.33 s** (three per breath) | — | — | every live / ready dot: Live and Ready status-pill dots, Live overline dot, Session Progress now node | static dot |
| `radiate` | loop | Connecting rings: scale 1 → 1.35, opacity 0.35 → 0, easeOut, 1.8 s, rings 600 ms apart | — | — | Connecting Pulse (05.34–05.35) | static rings |
| `comet` | loop | 24° white 0 → 60% → 0 highlight along the energy arc, linear 2.4 s + 600 ms pause | — | — | Live gauge | off |
| `sheen` | loop | white → energy band 120pt at 20°, **≤ 8%** opacity (text-safe on emerald); Ready: one 900 ms sweep every 8 s · Live: 3.2 s linear loop · Confirming: 1.2 s linear loop | — | — | Charging Pass faces | static 6% glow |
| `shimmer` | loop | skeleton gradient white 0 → 40% → 0, 1.2 s linear | — | `Shimmer` | Skeleton Block, card Loading variants | static at 100% |
| `typing` | loop | three 7pt dots, opacity 0.35 → 1 → 0.35 and y 0 → −2 → 0, 1.2 s easeInOut, 160 ms stagger | — | — | Typing bubble | static dots at 60% |
| `dots` | loop | three 8pt dots, opacity 30 → 100 → 30%, 900 ms, 150 ms stagger | — | — | Connecting | static "…" |

**Press feedback (every tappable thing; flow specs only restate exceptions).** Touch-down: Pressed variant (if any) + scale in 100 ms easeOut; release: back with `snappy`. A drag of more than 10pt cancels the press. Disabled controls: no press, no haptic. Reduce Motion: no scale; the element dims to 85% for the touch.

| Element | Press |
|---|---|
| `Button / Large`, `Button / Medium`, Slide to Start thumb (1.05) | Pressed variant + 0.97 |
| `Icon Button` (Glass, Fill, Tinted, Frost) | 0.92 + fill brightens 6% (Glass/Frost) or darkens 6% (Fill/Tinted) |
| Cards (Station Card, Charging Pass + shadow lift, Vehicle Card, Choice Card, Next Booking Card, Booking Banner, System Event Card, Profile Header Card, the Live gauge) | 0.98 |
| Chips, Status/Map pills, Quick Action Tiles, Date Pills, Time Chips, Connector Tiles, Chat Title capsule | 0.96 |
| List rows (List Row, Search Result Row, Inbox Row, Vehicle Card Layout=Row) | `bg/fill` 948:46 highlight at 0 ms, off with `fade.quick`; **no scale** |
| Text links and text buttons ("Clear", "See all", "Change", "Back to the map") | label to 50% on touch-down, `fade.quick` back |

**Toast motion.** Enters from **12pt** below its rest position with opacity 0 → 1 (`smooth`); leaves in reverse (`fade.quick`). Stays **4 s** (one line, no action) or **6 s** (two lines or any action). Exceptions: the stop-failure toast with Retry (06.16) stays until Retry, swipe or 8 s; the auto-stop status toast (06.07) stays until the stop resolves. One at a time (a new one replaces the old with `fade.quick`). Swipe down dismisses. Haptic follows the tone (Success → success, Warning → warning, Error → error, Neutral → none). VoiceOver: polite announcement, focus does not move, the action is in the Actions rotor, the timer pauses while VoiceOver focus is inside; with VoiceOver on, action toasts stay up to 10 s.

**Loading timing.** Spinners and skeletons appear only after a **150 ms** grace and then stay **≥ 600 ms** (all loaders, including the Loading HUD). Exception: the map's "Loading…" pill waits 300 ms (camera moves refetch often).

### 2.2 Haptic map (one map for the app)

| Haptic | API (iOS · Flutter) | Where |
|---|---|---|
| **selection** | `UISelectionFeedbackGenerator` · `HapticFeedback.selectionClick` | chips and filter pills, segmented controls, presets, switches, Connector Tiles, Choice Cards, stars, date pills and time chips, pin / cluster select, `scrub` steps (5% on sliders, one chip on the time grid), inquiry template choice, Estimate Row tap |
| **light** | `UIImpactFeedbackGenerator(.light)` · `lightImpact` | opening a sheet from a button, card or tile; card taps that navigate; Book now and View Details; Next / Continue / Skip in onboarding; Done / Close buttons; Live minimize and expand; pull-to-refresh threshold; Retry taps; slider ends (0% and 100%); milestones M2, M3, M5b (+10% est., halfway, plan time done); back online |
| **medium** | `UIImpactFeedbackGenerator(.medium)` · `mediumImpact` | **commits** that create, change or stop something: Create account, Log in, Send reset link, Continue as driver, Save vehicle, Save changes, Show results, Confirm booking, Slide to start (at the 90% commit), Stop charging (opening the confirm) and End session, the auto-stop at 0:00, Logout / Delete commits, Send inquiry / follow-up, Submit review, vehicle long-press lift |
| **success** | `UINotificationFeedbackGenerator .success` · iOS notification haptic via a platform channel or haptics plugin (Android: short double `vibrate`) | real completions only: Verified, Reset link sent, Vehicle added / updated, All set, Profile updated, saved charger (heart), booking confirmed (04.43), booking found after a scan / charger found, **Charging started (06 M1, the single success of the start)**, ≈80% and plan reached (M4, M5), Complete check draw, review submitted, receipt saved, battery updated |
| **warning** | `UINotificationFeedbackGenerator .warning` · same plugin route | fixable "not yet / can't": Not verified yet, a dimmed chip or preset tapped, slot ends first (once per crossing), already there, 5 min left (M6, Live in the foreground), connection lost, stopped at the charger, booking cancelled by the host (live update), Expiring soon banner, review over 500 characters, 140-character cap, conversation becomes blocked, alerts with a heavy consequence as they appear (Active Charging Session, Delete Account) |
| **error** | `UINotificationFeedbackGenerator .error` · same plugin route (Android: `vibrate` pattern) | any failure: Toast Error, field errors on submit, failed stop / save / send / load / cancel, 0-star submit |
| **none** | — | list-row navigation, back and edge swipe, text links, scrim taps, keyboard, system alerts (except the two above), Neutral toasts, passive updates (countdowns, live values, status changes the user didn't cause, except the warnings above), free-text chat send, tab-bar accessory changes on another tab |

Rules: haptics fire on **release** or on the result, never on touch-down; never two within 300 ms (the first wins); at most one milestone haptic per 60 s (M6 always plays); only while the relevant screen or its sheet is in the foreground; Android maps selection → `selectionClick`, light/medium → `lightImpact`/`mediumImpact`, success/warning/error → `vibrate` patterns.

### 2.3 Numbers and the gauge

1. Every changing number uses `roll` with **tabular figures** (`monospacedDigit` / `FontFeature.tabularFigures()`), in a Display style (SF Pro Light) or the number slot of a component.
2. Rates: Live screen values tick with `tick` (1 s); kWh and Rs roll when their shown digit changes; ≈% rolls when the integer changes, with a 300 ms `energy` tint flash on the number. Lists and passes throttle visual updates (≈% and Rs at most every 10 s, "min left" every minute). Countdowns on lists update per minute (`TimelineView(.everyMinute)`).
3. Values never go down on screen. Server values above the local estimate ease up over 600 ms; values below hold until the estimate catches up.
4. Count-ups (`count`, 700 ms) only for the Complete Total and the Profile stats on first appearance per launch. Everything else rolls.
5. Gauge (`Charging Gauge` 987:414): entry `sweep` ≈ 900 ms (start segment 500 + estimated-so-far 400, planned dotted arc `fade.std`); re-base after "Update battery %" 600 ms; final sweep at stop 300 ms; between ticks the arc creeps linearly. On Complete the 240pt gauge shrinks to the 88pt Success Mark (matched geometry, `smooth`).
6. Slider ↔ number: dragging a Level Slider updates the hero number live with `scrub` (120 ms digits); tapping a preset animates the fill (`smooth`, 300 ms) and the number counts through the values (max 12 roll steps) with one selection haptic.
7. The "≈" prefix is ~55% of the number size, top-aligned to the cap height, and never rolls; "est." sits after the unit where there is room.
8. Rounding: kWh 1 decimal; Rs whole rupees with thousands separators; % whole with "≈". Live floors kWh and Rs; Complete rounds; the billed amount always wins.

### 2.4 Accessibility fallbacks (one table)

| Setting | What changes |
|---|---|
| **Reduce Motion** | every translate, scale, morph, parallax, flight and camera move → `fade.quick` cross-fade (route and page changes `fade.std`); no `roll` (numbers cross-fade), no `count`, no `M-shake` (colour + message only), no confetti, no check-draw (static mark), loops off (`breathe` static 0.7, `pulse`/`radiate`/`comet`/`sheen`/`typing`/`dots` static, `shimmer` static); press = 85% dim; haptics still play |
| **Reduce Transparency** | Glass, Frost and Frost Strong → `bg/surface` + 1px `stroke/hairline`; scanner mask → solid black 80%; the scrim stays `bg/scrim` |
| **Low Power Mode** | loops stop (breathe, pulse, radiate, comet, sheen, shimmer, typing, mesh drift); `tick` and `roll` keep running |
| **VoiceOver** | titles and sheet titles carry the heading trait; status is read after the name; "≈" reads "about"; prices read "42 rupees per kilowatt-hour"; ticking values use `.updatesFrequently` and update silently; announcements are polite and at most one per 10 s (errors exempt); every VoiceOver string is new accessibility copy and is flagged in its flow |
| **Dynamic Type (AX)** | content scrolls above pinned actions; tiles and stat rows stack; chips scroll or wrap; pins cap at XL |

---

## 3. Shared components to build before screens

Build on **Components (946:7)**, each in its own section after C14 (C15, C16, …), with `descriptionMarkdown`, every fill and stroke bound to a variable, and component properties for every visible text. Reuse the inventory first; the items below are the only shared additions. "Exists" = already built tonight (inventory IDs in the brief).

### C1 · Nav Bar · extensions (exists 1087:643)
- **Anatomy:** §1.1. Inline 402×52, Large 402×103; three exposed `Icon Button` M instances "Leading button", "Trailing button 1", "Trailing button 2"; title text node.
- **Add variants:** `Material` = Glass · Frost · Camera (on both Styles; 6 variants total).
- **Add properties:** `Scroll edge` (BOOL), `Trailing text` (BOOL), `Trailing label` (TEXT). Keep `Title#1087:0`, `Leading#1087:3`, `Trailing 1#1087:6`, `Trailing 2#1087:9`.
- **Tokens:** Frost buttons `bg/frostStrong` 948:44 + `icon/primary` 948:61; scroll-edge band `bg/frostStrong` + `stroke/hairline` 948:88; trailing text Subheadline Emph `text/brand` 948:53.
- **Used by:** every flow (1–9). Frost: 05 (Charge tab, planner, Connecting), 06 (Live, Complete). Camera: 05 scanner. Trailing text: 08.53.

### C2 · Toast (exists 1088:631) + Inline Notice (new)
Legacy names: 01's "Inline Message" and "Inline Notice · extension" = this Inline Notice; every "snackbar" in the logic map = Toast.
- **Toast:** no change. Tone = Neutral 1088:611 · Success 1088:616 · Warning 1088:621 · Error 1088:626; `Message#1088:0`, `Action#1088:5`, `Action label#1088:10`; 370 wide, hug height. Placement §1.5, motion §2.1. It has no icon slot; the tone carries meaning. Every logic snackbar in Flows 1–9 is this Toast.
- **Inline Notice (new set):** in-content notice that never floats or times out.
  - Variants: `Tone` = Info · Neutral · Success · Warning · Error × `Style` = Card · Plain × `Action` = No · Yes (20).
  - Card: 370 × hug (min 44), padding 12/14, gap 10, radius `radius/md` 16. Fill: Info `bg/tint` 948:45 · Neutral `bg/fill` 948:46 · Success `status/availableTint` 948:77 · Warning `status/warningTint` 948:81 · Error `status/errorTint` 948:82. Icon 20 (INSTANCE_SWAP `Icon`): Info info.circle 1025:472 `icon/brand` · Neutral info.circle or clock 958:88 `icon/secondary` · Success checkmark.circle.fill 1025:506 `status/available` · Warning exclamationmark.triangle.fill 1025:474 `status/warning` · Error exclamationmark.triangle.fill `icon/error` 1070:506. `Message` Subheadline `text/primary` (wraps). `Action label` Subheadline Emph `text/brand`, trailing, 44pt hit area.
  - Plain: no fill, icon 16 + Footnote in the tone colour (`text/available` / `text/warning` / `text/error` / `text/secondary`), centred.
  - Motion: `M-grow`.
  - **Used by:** 01 (verify, sign-in, API errors), 04 (paused, offline, closed day, times error), 05 (How we estimate note), 06 (ending soon, remote stop, How we estimate), 07 (paused pass, offline cache), 09 (composer Waiting/Blocked, send-error strip).

### C3 · Sheet / Action (new composite)
One icon-led sheet for every short task or decision that is more than a native alert. It replaces 02's Permission Sheet, 09's Manual Call Sheet, 08's Sheet / Action and the anatomy of 06.14. Legacy names in the flow specs: "Permission Sheet" = Kind=Permission; "Manual Call Sheet" = Kind=Call; "End charging session sheet" = Kind=Destructive.
- **Anatomy (leading-aligned, x 16, w 370):** 402 × hug, `bg/surface`, top radius 38, Frost/Elevated, grabber at top + 5 (`Show grabber`), optional Close `Icon Button` Fill S xmark at **(352, top + 16)** (`Show close`) · icon well 56×56 radius 16 at **(16, top + 24)**, icon 28 · Title (Title 2 22 Medium, `text/primary`) at **top + 96** · Message (Body 17, `text/secondary`) 8 below, w 370 · optional Slot (`Show slot`, 370 wide `bg/grouped` 948:42, radius 16, padding 12–16) 16 below · buttons: one at (16,772), two at (16,712) + (16,772); the last ends at 824. Height H = content; top = 874 − H.
- **Variants:** `Kind` = Info · Permission · Call · Destructive · Summary. `Well tone` = Brand (`bg/tint` + `icon/brand`) · Success (`status/availableTint` + `status/available`) · Warning (`status/warningTint` + `status/warning`) · Error (`status/errorTint` + `icon/error`). Call adds `State` = Number · No number · Opening.
  - Info: Primary "Got it" (or Primary + Tertiary), Close on.
  - Permission: Primary "Allow …" + Tertiary "Not now", well Brand + location.fill 1024:472.
  - Call: Primary "Call" with leading phone.fill 1024:476 (No number → Disabled 978:291; Opening → Loading 978:298) + Tertiary "Cancel"; well Brand + phone.fill.
  - Destructive: `Button / Large` Destructive 978:367 + Tertiary; well Error + stop.fill / trash; Slot = decision row (06.14).
  - Summary: one Primary, no grabber, no close, not dismissable (08.13).
- **Properties:** `Title`, `Message`, `Primary label`, `Secondary label`, `Show secondary`, `Show close`, `Show grabber`, `Show slot`, `Icon` (INSTANCE_SWAP).
- **Used by:** 02.02 (Permission), 04.17 + 07.30 + 09.30–09.31 (Call), 04.43 success sheet (Info, Well Success), 06.14 / 06.14b (Destructive), 08.07, 08.08, 08.19 (Info), 08.13 (Summary).

### C4 · Charge planner kit (new): Level Slider, Estimate Card, Estimate Row, Charge Plan Bar
The "Battery % picker" and the estimate the brief asks for. The **Time / Target %** switch uses the existing `Segmented Control` 2 segs (970:187 / 970:192); no new control.
- **Level Slider** — `Mode` = Battery · Target × `State` = Unset (Battery only) · Default · Dragging · Disabled. 370×56 (the whole 56 is the hit area); track `bg/fill` radius pill; fill `brand/primary` 947:3 (Battery) or an `energy` 948:83 → `brand/primary` gradient (Target); 1pt ticks every 10% in `stroke/separator` 948:87. Props: `Placeholder` (TEXT "Drag to set", Unset), `Show start marker` (BOOL: 2×24 white tick at the start % + hatched "already there" region), `Show 80% tick` (BOOL), `Show min/max` (BOOL: "0%" / "100%" Caption 1 `text/tertiary` under the ends). Dragging = scale 1.03 + Shadow/Button. Value = fill width (documented 0–100). VoiceOver: adjustable, **±1% per swipe**. Used by 05.19–05.21, 05.25–05.29, 06.05, 06.08 chip target.
- **Estimate Card** — `State` = Default · Updating · Capped · Unavailable. 370 wide, `bg/grouped` 948:42, radius 16, padding 14, gap 8. Header: `Title` "Estimate" (Footnote Emph `text/secondary`) + trailing info.circle 16 (44 hit; `Show info`); Updating swaps the icon for a 12pt spinner + "· Updating…". Body: 3 nested `Stat Tile` 986:446 (Energy · Cost · Finishes), values Display/S, units Footnote. Capped adds a warning line (exclamationmark.triangle.fill 12 + Footnote `text/warning`). Unavailable replaces the tiles with `Message` (Subheadline `text/secondary`). Props: `Energy`, `Cost`, `Cost unit`, `Finishes`, `Finishes unit`, `Message`, `Show info`. Used by 05.23–05.30.
- **Estimate Row** — `Kind` = Default · Highlighted. 370×64, padding 12/0, gap 12: well 40 `bg/tint` radius 12 + `Icon` 20 `icon/brand`; `Title` (Subheadline `text/primary`), `Formula` (Footnote `text/secondary`, 1–2 lines); trailing `Value` Display/S (tabular, "≈" allowed). Highlighted = `bg/fill` row. Separator inset 52. Used by 05 "How we estimate" (CH14) and 06.03.
- **Charge Plan Bar** — `State` = Plan · Capped · Already there. 370×30 on Mesh Hero: 10pt track white 25% radius pill; start fill white; added fill `energy`; Capped adds a dashed 2pt white target marker 18 tall; labels row Caption 1 Emph `text/onMesh` (`Left label` "20% now", `Right label` "+11% est." / "Target 80%"). Used by 05.23–05.29.

### C5 · Vehicle Card (new; one set for every vehicle display)
Legacy name: 04's "Vehicle Select Row" = Layout=Row.
- **Variants:** `Layout` = Card · Row. Card × `Primary` = Yes · No × `State` = Default · Pressed · Lifted · Swiped · Deleting · Inserted · Loading. Row × `State` = Selected · Choose · None · Error-None · Error-Mismatch · Loading.
- **Card (My vehicles):** 370×104, `bg/frostStrong` + Frost/Card, radius `radius/lg` 22, padding 16, gap 14. Well 56 `bg/tint` radius 16 + car.fill 1024:474 28 `icon/brand`. Column: `Name` (Headline, 1 line) + nested `Status Pill` Neutral S 980:332 "Primary" (Primary=Yes, never truncated); `Specs` (Footnote `text/secondary`, "Type 2, CCS 2 · 60.5 kWh"); **Plate Chip** (hug × 20, padding 2/6, radius `radius/xs` 8, `bg/fill`, Caption 1 Emph `text/primary`, tabular, +2% tracking). Trailing chevron.right 958:55 16 `icon/tertiary`. Lifted = scale 1.02 + Shadow/Button. Swiped = content −96 + revealed 88×104 `action/destructive` 948:69 radius 22 action (trash 1025:496 white 22 + Caption 1 Emph white "Delete"). Deleting = content 40% + small spinner after 1 s. Inserted = `bg/tint` wash 60%. Loading = `bg/fill` well + Skeleton Blocks.
- **Row (booking VEHICLE row, planner vehicle row):** 370×64 (+22 with an error line), `bg/grouped` 948:42, radius 16, padding 12/16, gap 12. Well 40 `bg/tint` radius 12 + car.fill 20 `icon/brand` (None: `icon/tertiary`). `Title` (Headline, "BYD Atto 3 · Type 2 (AC)"), `Subtitle` (Footnote `text/secondary`, "Primary" or specs), trailing `Action label` (Footnote Emph `text/brand`: "Change" / "Add"). Error states: 1.5pt `stroke/error` 1070:505 + `Error message` (Footnote `text/error`) below. Loading: system spinner in the well + Skeleton Block title, no action.
- **Properties:** `Name` / `Title`, `Specs` / `Subtitle`, `Plate`, `Show plate`, `Action label`, `Error message`, `Show error`.
- **Used by:** 04.27, 04.38, 04.39, 04.51 (Row) · 05.19–05.22 (Row, Selected, action "Change") · 08.30–08.52 (Card).

### C6 · Connector Tile · extensions (exists 1088:745)
- Existing: `Selected` = No 1088:729 · Yes 1088:737, 177×112; props `Title#1088:15`, `Subtitle#1088:18`, `Plug#1088:21`. Grid 2×2, gap 16.
- **Add:** `Selected` = Error (No + 1.5pt `stroke/error` 1070:505) and `State` = Pressed (scale 0.96 + `bg/fill`) · Disabled (content 40%).
- Plug glyphs: Type 2 ev.plug.ac.type.2 981:294 · CCS 2 ev.plug.dc.ccs2 1024:482 · Type 1 (wanted `ev.plug.ac.type.1`, stand-in 981:294) · CHAdeMO (wanted `ev.plug.dc.chademo`, stand-in ev.plug.dc.gb.t 1024:484).
- **Used by:** 01.33–01.36, 08.39–08.48.

### C7 · Rating Stars · extension (exists 1088:728)
- Existing `Value` = 0…5 (1088:632 … 1088:712), Input size with 5 × 44pt targets.
- **Add** `Size` = Input · Display (Display: 12pt stars, gap 2, no targets; star.fill 958:52 `icon/brand`, empty star 1025:492 `icon/tertiary`).
- **Used by:** 04 (Rating Summary, Review Row: Display), 06 (Rate Prompt Empty: Input; Rated: Display; review sheet: Input).

### C8 · Avatar (new)
- **Variants:** `Size` = S 32 · M 40 · L 56 · XL 72 × `Style` = Tint · Mesh × `Kind` = Initials · Glyph.
- **Anatomy:** circle. Tint = `bg/tint` + initials `text/brand`. Mesh = radial `mesh/deep` (bottom centre) → `mesh/mid`, `mesh/glow` highlight top-left at 30% that never sits under the letters, initials `text/onMesh`, 1pt `stroke/highlight` inside. Glyph = `bg/fill` + person.crop.circle 1023:483 `icon/secondary` (anonymous "Driver" reviewers). Initials: S Subheadline Emph · M Headline · L Title 3 · XL Title 1 (all Medium).
- **Properties:** `Initials` (TEXT), `Show presence` (BOOL: 10pt `status/available` dot + 2pt `bg/surface` ring, bottom-right), `Show badge` (BOOL: 22pt `bg/tint` circle with a 12pt `icon/brand` glyph + 2pt `bg/surface` ring, `Badge icon` INSTANCE_SWAP).
- Rule: the driver's own avatar is Mesh; everyone else is Tint.
- **Used by:** 04 (host row M, reviews M), 07 (pass detail host M), 08 (Profile XL Mesh, Account L Mesh), 09 (Inbox Row L, bubbles S, Chat Title S, Thread Hero L + badge).

### C9 · Inbox Row (new; notifications and conversations share one row)
Legacy names: 08's "Notification Row" = Kind=Notification; 09's "Thread Row" = Kind=Thread.
- **Variants:** `Kind` = Notification · Thread × `Read` = Unread · Read × `State` = Default · Pressed; Thread adds `Live` = No · Yes and `Meta` = On · Off; Notification adds `Type` = Booking · Expiring · Cancelled · Completed · Chat · Call.
- **Shared anatomy:** 370 wide, padding 14/16, gap 12. **Unread dot** 10pt `action/primary` 948:66 in the leading gutter (x 4, centred on the title line). **Time** trailing on the first line: Footnote `text/secondary` (Unread: Footnote Emph `text/brand`), tabular. Pressed = `bg/fill` row. `Separator` (BOOL, 0.5pt `stroke/separator`, inset to the text column).
- **Notification:** Tile 40 radius 12 by Type (Booking `bg/tint` + calendar 958:39 `icon/brand` · Expiring `status/warningTint` + clock `status/warning` · Cancelled `status/errorTint` + xmark 958:72 `icon/error` · Completed `status/availableTint` + checkmark 958:91 `status/available` · Chat `bg/tint` + message.fill 966:7 `icon/brand` · Call `bg/tint` + phone.fill `icon/brand`). `Title` Subheadline Emph (Unread) / Subheadline (Read), `text/primary`. `Body` Footnote `text/secondary`, 2 lines. Min height 76, separator inset 68.
- **Thread:** Avatar L 56 (C8). `Name` Headline `text/primary`. `Preview` Subheadline (Unread `text/primary`, Read `text/secondary`; 1 line with Meta, 2 without; empty preview "No messages yet" in `text/secondary`). Meta row: nested `Status Pill` S (Info date chip · Neutral "New inquiry" · Live "Charging now") + `Station` Footnote `text/secondary`. Live = 3pt `energy` bar at x 0, inset 12 top/bottom, radius pill. Height 100 (Meta On) / 76. Separator inset 84.
- **Used by:** 08.53–08.55 (Notification), 09.01–09.04, 09.09 (Thread).

### C10 · Message Bubble (new; includes the typing bubble)
- **Variants:** `Sender` = Me · Them × `State` = Sent · Sending · Failed (Me only) × `Tail` = Yes · No × `Avatar` = Yes · No (Them only); plus `Kind` = Typing (Them style).
- **Anatomy:** `Text` Body 17, max width 268, padding 10/14, radius 20; the tail corner (bottom-right Me, bottom-left Them) radius 6 when Tail = Yes. Me: `brand/primary` 947:3 fill + `text/onPrimary` 948:52 (5.4:1). Them: `bg/surface` + 1px `stroke/hairline`, `text/primary`; Avatar S 32 (C8) at the bottom-left, 8 gap, on the last bubble of a run only. `Time` line under the bubble (Caption 2 `text/secondary`, aligned to the bubble side). Sending: bubble 60% + 10pt spinner + "Sending…" (Caption 2 `text/secondary`). Failed: exclamationmark.triangle.fill 18 `icon/error` 8 to the left + "Not sent · Tap to retry" (Caption 2 Emph `text/error`). Typing: 64×40, three 7pt `icon/tertiary` dots gap 5, motion `typing`.
- **Properties:** `Text`, `Time`, `Show time`.
- **Used by:** 09B, 09C.

### C11 · Page Control and Step Progress (new; onboarding indicators)
- **Page Control:** `Pages` = 4 × `Current` = 1…4. Dots 8×8 `bg/fillStrong` 948:47, gap 8; active capsule 24×8 `action/primary` 948:66. Motion: the capsule width morphs with `snappy`; selection haptic on settle. Accessibility: "Page n of 4", adjustable.
- **Step Progress:** `Step` = 1 · 2 · 3a (third segment half) · 3b. 258×4, 3 segments, gap 6, radius pill; filled `action/primary`, empty `bg/fillStrong`. Placed as a sibling layer over the Nav Bar at (72,78). Accessibility: "Step n of 3".
- **Used by:** 01.03–01.06 (Page Control), 01.28–01.40 (Step Progress).

### C12 · Success Mark and Confetti (new; completion moments)
- **Success Mark:** `Size` = L 88 · M 56 × `Style` = On mesh (`bg/surface` disc, `brand/primary` check) · On light (`brand/primary` disc, white check). Check vector separate (`Check`) for the 300 ms easeOut draw-on; effect Shadow/Button on mesh.
- **Confetti:** `Density` = Burst (36 pieces, All set) · Light (24, Complete). 402×560 group, pieces bound to `brand/primary`, `energy`, `mesh/glow`, `mesh/accent`, white; 1.2 s once; hidden from VoiceOver; none on relaunch/resume.
- Rule: Success Mark is for full-screen completion moments; a success inside a sheet uses `Sheet / Action` with Well tone Success.
- **Used by:** 01.41 (L On mesh + Burst), 06.29–06.30 (L On mesh + Light), 06.36 receipt (M On light), 08.59–08.61 (M On light).

### C13 · OS and live surfaces (mocks; Live Activity / Dynamic Island are proposals)
All are labelled "System UI · OS-owned · not built in Flutter" (except Notification Preview · In-app banner, which PakPlug draws).
- **iOS / Keyboard** — 402×336 at (0,538) incl. its own home indicator, light system material. `Layout` = Default · Email · Phone pad · Decimal pad; `Return label` = return · search · go; `Return enabled` = Yes · No; `Shift` = Off · On; `Suggestions bar` = On · Off. One set app-wide. Used by 01, 03, 05, 06, 08, 09.
- **iOS / Permission Alert** — iOS 27 Liquid Glass alert, radius 34, capsule buttons. `Kind` = Location (adds the precise-location map + "Precise: On", 3 stacked buttons) · Notifications · Camera · Photos (2 buttons side by side). Used by 01.38, 01.40, 02.03, 05.05, 06.38.
- **Notification Preview** — `Style` = Lock screen · In-app banner. 370 (or 338) × hug, radius 22, `bg/frostStrong` + Frost/Card, padding 14. App icon 38 (`Brand / App Icon` 992:82); `Title` Subheadline Emph `text/primary` + `Time` Footnote `text/secondary` right; `Body` Subheadline `text/secondary`, 2 lines. In-app banner adds the header "PAKPLUG" (Caption 1 Emph `text/secondary`) · "now", sits at (32,58), stays 6 s (logic), swipe up dismisses. Used by 01.39, 06.27–06.28b, 07.05, 07.09, 09.10.
- **iOS / Lock Screen** — 402×874 template: Mesh Hero wallpaper + `bg/scrim`, Status Bar Light, date (SF Pro Semibold 20 white, OS chrome, the only Semibold allowed), clock (SF Pro Medium 104 white), slot y 460–720, two 50pt glass circles, Home Indicator Light. Used by 06.22–06.24, 06.27–06.28b.
- **Live Activity / Charging** [06-P16, proposal] — `State` = Charging · Ending · Unknown battery · Stale · Complete · Stopped at charger. 370×160 (Complete 132), radius 24, `mesh/deep` 1062:3 + 1pt `stroke/highlight`, padding 16. Row 1 P mark Solid 20 + `Station` Footnote Emph `text/onMesh` + `Window`; Row 2 `Battery` Display/L `text/onMesh` ("≈26%" + "est. battery") and `Time` Display/L `energy` ("28:00" + "left"); Row 3 progress 338×6 (track white 20%, fill `energy`; Ending `status/warning`); Row 4 `Meta` Footnote `text/onMesh`. No buttons. Native ActivityKit (Swift).
- **Dynamic Island / Charging** [06-P16, proposal] — `Presentation` = Compact (250×37) · Minimal (37×37) · Expanded (378×176, radius 44) × `State` = Charging · Ending · Complete. Fill #000 (OS). Compact: 20pt slot-progress ring + bolt.fill 10 leading, `Time` Display/S `energy` trailing. Expanded: P mark 24 + `Battery` Display/M + "est." · `Time` Display/M `energy` + "left" · `Station` Footnote · progress 330×6 + `Start`/`End` Caption 2 + `Meta` Footnote. Used by 06.25–06.26.

### C14 · Core extensions and utilities (small additions to existing sets)
| Item | Change | Used by |
|---|---|---|
| `Button / Large` [978:427] · new Types | **On Mesh** (`bg/surface` fill, `text/brand` label, Shadow/Button; Pressed `bg/frostStrong`), **On Mesh Plain** (no fill, `text/onMesh` label; Pressed `bg/glass`), **On Mesh Destructive** (`bg/frostStrong` + Glass/Regular, label `text/destructive`, leading stop.fill `action/destructive`; Pressed `bg/surface`) × Default · Pressed · Disabled (40%) · Loading | 01.41–01.42, 06.02–06.16 (Stop), 06.30–06.39 |
| `Chip` [970:186] · Fill/Disabled | Fill/No with content at 40%, no stroke, no press | 04 duration chips and windows, 05 planner chips and presets |
| `Status Pill` [980:347] · Spinner | BOOL `Spinner` (10pt activity indicator replaces the dot) | 07.03 "Confirming..." |
| `List Row` [983:388] · trailing + selectable | `Trailing` = Chevron · Value · Value + Chevron · Pill (nested Status Pill S) · Badge (Caption 1 Emph white on `status/error`, min 20×20, "9+") · Switch · None; `Selected` = No · Yes (radio: 22pt 1.5pt `stroke/separator` ring / checkmark.circle.fill `icon/brand`); title up to 2 lines | 08 (Profile, Account), 09.23–09.24 (templates) |
| `List Group Header` [983:389] · trailing | `Trailing` = None · Text (Footnote `text/secondary`, optional 6pt dot e.g. `status/warning` for "Peak 5 PM–9 PM") · Action (Footnote Emph `text/brand`, 44 hit; disabled `text/tertiary`) · Status (Footnote `text/tertiary`, "Loading…") | 03 ("Recent · Clear"), 04 ("WHEN" + Peak, "Reviews · See all", "Connectors · 1") |
| `Map Status Pill` [975:257] · action, error, surface | add Notice + Action, Error + Action (trailing `Action` Footnote Emph `text/brand` after a 1×14 separator; Error icon exclamationmark.triangle.fill `icon/error`); `Surface` = Glass (map) · Frost Strong (Hero/Celebrate mesh, camera; text `text/primary`) | 02.10–02.11, 03.22, 05.08, 06 milestone pills |
| `Text Field` [1070:590] · suffix, lock, code, multiline | `Suffix` (TEXT, Body `text/secondary`, 12 from the trailing edge) + `Show suffix`; `Show lock` (16pt lock, wanted `lock.fill`); `Value style` = Body · Code (Display/S with +8% tracking, "GV7-K42"); `Multiline` = Yes (Text Area: 120 tall, grows to 200, top-aligned) + `Counter` (Caption 1 `text/secondary`, right) + `Counter error` (BOOL → `text/error`) | 05.13–05.17 (Code), 06.40–06.46 (Multiline), 08.39–08.49 (Suffix), 08.26 (Lock), 09.23–09.24 (Counter) |
| `Alert` [1014:577] · stacked + lead | `Layout` = Side by side · Stacked (full-width capsules, destructive on top, 8 gap); `Message lead` (TEXT, Footnote Emph, first line naming the object) | 07.32, 08.10, 08.20, 08.32 |
| `Quick Action Tile` [1008:431] · badge | BOOL `Badge` (8pt `status/error` dot with 2pt `bg/surface` ring, top-right of the icon); BOOL `Loading` (16pt spinner replaces the icon) | 07.21–07.28 |
| `Station Card` Map preview [982:287] | confirm (inspect first) that it holds the actions row `Button / Medium` Secondary "View Details" + Primary "Book now" (equal widths, gap 8) and a distance slot in the meta line; if not, add `Show actions` (BOOL) + `Distance` (TEXT). Floating fill override `bg/frostStrong` + Frost/Card. No new map card component | 02.08, 02.14, 02.30–02.31, 03.13 |
| **Skeleton Block** (utility) | `Width` = S · M · L (or free), `bg/fill`, radius `radius/xs` 8, `shimmer` | 04.04, 04.51, 05.36, 07.29, 08.04, 08.17, 08.36, 08.47, 09 banner |
| **Scroll Edge Fade** (utility) | `Edge` = Top (`bg/frostStrong` 100% → 0% under the status bar and floating chrome) · Bottom (`bg/canvas` 0 → 92% behind pinned actions; `mesh/deep` 0 → 100% on Celebrate) | 02.15–02.19, 03.21, 06.31, 08.01, 09B |
| **Perforation** (utility) | 370×16: 1pt dashed `stroke/separator` (4/4) + two 16pt semicircle notches in the backdrop colour (white 35% dashes and 12pt notches on emerald pass faces) | 06.36 receipt, 07 passes, 07.10 Ghost Pass |
| **Touch marker** (doc utility, not shipped) | 44pt circle `bg/fillStrong` + 1.5pt `stroke/focus`, named `Touch` | 04.26, 04.30, 05.20, 05.31 |

### 3.1 Decisions on the requested items that need no new component
- **Plan segmented (Time / Target %):** existing `Segmented Control` 2 segs (sel1 970:187, sel2 970:192).
- **OTP / code entry:** not needed. Email verification is link-based (01); the charger code is a `Text Field` with `Value style` = Code (C14). If phone OTP ships later, design it then.
- **Map station preview card:** `Station Card` Map preview 982:287 is enough (C14 check).
- **Permission primer card:** `Sheet / Action` Kind=Permission on Home (02.02); onboarding's full-screen primers (01.37, 01.39) keep their illustration cards; the camera-denied state is the Scanner Overlay's Permission state (05.06).
- **Empty / skeleton list row:** `State View` [1072:599] covers empty and error; loading uses the existing Loading variants (Station Card, etc.), the new Loading states (Vehicle Card, Next Booking Card, Profile Header Card) and Skeleton Block. No separate skeleton row.

### 3.2 Flow-local components (build at the start of that flow, on Components)
| Flow | Components (spec section) |
|---|---|
| 1 Onboarding | Auth Button, Choice Card, Requirement Row, Illustration / Map Card, Illustration / Inbox, Illustration / Lock Screen, iOS / Apple ID Sheet (01 §7) |
| 2 Discover | Trend Chart Card, Region Price Card, Price Range Bar (02 §6) |
| 3 Search | Search Result Row new variants (Recent, Filter, resolving, Pressed), Sheet / Search, Attribution / Google, Map Marker / Place (03 §6) |
| 4 Station & Book | Time Chip, Time Window · State + Size, Rating Summary, Review Row, Scrub Loupe, Photo Placeholder, Cost Footer · Show info (04 §6) |
| 5 Charge | Next Booking Card, Scanner Overlay, Connecting Pulse (05 §6) |
| 6 Live & Complete | Session Progress, Charging Gauge · plan arcs + Stale/Frozen, Session Summary Card, Rate Prompt, Receipt (06 §6) |
| 7 Bookings | Charging Pass · Confirming/Ready/Live/Paused/Expired (+ `Edge`), Pass Progress, Review Link, Ghost Pass, Wallet Badge, iOS / Refresh Control, iOS / PassKit Add Sheet (07 §6) |
| 8 Profile | Profile Header Card, Loading HUD, Verification Banner, Condition Card (08 §7) |
| 9 Messages | Chat Title, Booking Banner, Date Separator, System Event Card, Thread Hero, Composer, Sheet / Inquiry, Sheet / Conversation options (09 §6) |

Build order: C1–C14 → Flow 1 locals → Flow 1 sections → Flow 2 locals → … The Motion & haptics table (§2) goes on **Foundations (946:5)** as a "Motion" board, not on Driver Flows.

---

## 4. Section plan for Driver Flows (946:8)

**Naming.** Sections: `Flow <n><Part> · <Flow> · <Part name>` (e.g. `Flow 5B · Charge · Code & battery`). Frames: `nn.nn · Screen · State` (two-digit flow number, as in the specs; "b" frames keep their suffix). Frame names never carry proposal tags or stars; a frame that is wholly a proposal ends with `· proposal`; state demos keep `(state demo)`; OS mocks keep "(OS)" / "(system)". Every section has ≤ 14 phone frames; boards (02.31, 04.53, 06.36) count as frames; link cards and doc cards do not.

**Placement.** Sections go in journey order, each at x 0, **160 below** the current page bottom (read the page first). Copy the fills of section 1076:2. The existing section **1076:2** (holding 1076:5 = 02.06) becomes **Flow 2A**: when its turn comes (after 1D), rename it and move it to x 0, y = page bottom + 160; keep its children; its existing Refs and Logic cards are updated, not duplicated.

**Anatomy (every section, brief format).** Title (Title 1) at (80,80): the section name. Status line (Footnote `text/secondary`) at (80,124): "<what it covers> · n frames · spec <file>". Per row: a Refs · Mobbin card (560 wide) on the left, phones (gap 80, labels above in Footnote Emph `text/secondary`), a Micro-interactions card on the right. One Logic check card at the end with **FLAG — PROPOSALS** (title `text/brand`) listing only that section's proposals plus the dummy-data note.

| # | Section | Spec | Frames (in order) |
|---|---|---|---|
| 1 | Flow 1A · Onboarding · Welcome & sign in | 01-onboarding.md | 01.01 · Splash · Launch · 01.02 · Splash · Loading · 01.03 · Story · 1 PakPlug · 01.04 · Story · 2 Charge anywhere · 01.05 · Story · 3 Plug in. Watch it live. · 01.06 · Story · 4 Earn from your charger · 01.07 · Sign in · Default · 01.08 · Sign in · Apple loading · 01.09 · Sign in · Error · 01.10 · Sign in · Apple sheet (system) (10) |
| 2 | Flow 1B · Onboarding · Create account, verify & log in | 01-onboarding.md | 01.11 · Create account · Empty · 01.12 · Create account · Typing · 01.13 · Create account · Errors · 01.14 · Create account · Creating · 01.15 · Create account · API error · 01.16 · Verify email · Default · 01.17 · Verify email · Checking · 01.18 · Verify email · Not verified yet · 01.47 · Verify email · Resending · 01.19 · Verify email · Resent · 01.20 · Verify email · Resend failed · 01.21 · Log in · Default · 01.22 · Log in · Logging in · 01.23 · Log in · Error (14) |
| 3 | Flow 1C · Onboarding · Reset, role & vehicle prompt | 01-onboarding.md | 01.24 · Reset password · Default · 01.25 · Reset password · Sending · 01.26 · Reset password · Sent (on Log in) · 01.27 · Reset password · Error · 01.28 · Choose role · Driver · 01.29 · Choose role · Host selected · 01.48 · Choose role · Saving · 01.30 · Choose role · Error · 01.31 · Add your vehicle? · Add it now · 01.32 · Add your vehicle? · Set up later (10) |
| 4 | Flow 1D · Onboarding · Add vehicle, permissions & all set | 01-onboarding.md | 01.33 · Add vehicle · Empty · 01.34 · Add vehicle · Filled (scrolled) · 01.35 · Add vehicle · Required errors · 01.36 · Add vehicle · Saving · 01.37 · Location · Default · 01.38 · Location · iOS prompt · 01.39 · Notifications · Default · 01.40 · Notifications · iOS prompt · 01.41 · All set · With vehicle · 01.42 · All set · No vehicle · 01.43 · Role switch · Become a driver · 01.44 · Role switch · Add your vehicle? (12) + link card 01.45/01.46 → 02.02, 02.04 |
| 5 | Flow 2A · Discover · Map & station cards (section 1076:2) | 02-discover.md | 02.06 · Home · Map (1076:5) · 02.07 · Home · Map · Loading stations · 02.08 · Home · Map · Station selected · 02.09 · Home · Map · Cluster opened · 02.10 · Home · Map · No stations · 02.11 · Home · Map · Couldn't load · 02.12 · Home · Filter & sort · 02.13 · Home · Map · Charging · 02.14 · Home · Map · Charging · Station selected · 02.30 · Home · Map · Offline station selected · 02.31 · Station cards · Every station & status (11) |
| 6 | Flow 2B · Discover · Location & list | 02-discover.md | 02.01 · Home · Finding your area · 02.02 · Home · Allow location · 02.03 · Home · iOS location prompt · 02.04 · Home · Location access off · 02.05 · Home · Location services off · 02.32 · Home · Map · Showing Lahore · 02.15 · Home · List · 02.16 · Home · List · Loading · 02.17 · Home · List · Empty · 02.18 · Home · List · Error · 02.19 · Home · List · Charging · Scrolled (11) |
| 7 | Flow 2C · Discover · Saved & price trends | 02-discover.md | 02.20 · Saved chargers · 02.21 · Saved chargers · Removed · 02.22 · Saved chargers · Loading · 02.23 · Saved chargers · Empty · 02.24 · Saved chargers · Couldn't update · 02.25 · Price Trends · 02.26 · Price Trends · Full scroll · 02.27 · Price Trends · Loading · 02.28 · Price Trends · Couldn't load · 02.29 · Price Trends · No data (10) |
| 8 | Flow 3A · Search · Sheet, typing & errors | 03-search.md | 03.01 · Search · Opening (motion still) · 03.02 · Search · Focused · Recents · 03.03 · Search · Focused · First time · 03.04 · Search · Typing · Loading · 03.05 · Search · Typing · Places loading · 03.06 · Search · Typing · Results · 03.07 · Search · Results · Keyboard down · 03.08 · Search · Plug-type query · 03.09 · Search · Availability query · 03.10 · Search · No results · 03.24 · Search · No results · Filters on · 03.11 · Search · Places failed · 03.23 · Search · Couldn't open place · 03.12 · Search · Stations couldn't load (14) |
| 9 | Flow 3B · Search · Results on the map & filters | 03-search.md | 03.13 · Search → Station on map · 03.14 · Search → Place · Loading · 03.15 · Search → Place · Stations nearby · 03.16 · Search · Reopened with query · 03.22 · Search → Place · No stations nearby · 03.17 · Filter & sort · Default · 03.18 · Filter & sort · Edited · 03.19 · Search · Filters applied · 03.20 · Home · Map · Filters applied · 03.21 · Home · List · Filters applied (10) |
| 10 | Flow 4A · Station · Place sheet | 04-station-book.md | 04.01 · Station · Sheet · Medium · 04.02 · Station · Sheet · Large · 04.03 · Station · Sheet · Large · Scrolled · 04.04 · Station · Sheet · Large · Loading details · 04.05 · Station · Sheet · Couldn't load · 04.06 · Station · Sheet · In use (DC) · 04.07 · Station · Sheet · Paused (state demo) · 04.08 · Station · Sheet · Offline · 04.09 · Station · Sheet · No reviews, no location (state demo) · 04.10 · Station · Sheet · Saved · 04.11 · Station · Sheet · Couldn't save · 04.49 · Station · Sheet · Maintenance (state demo) · 04.50 · Station · Sheet · Hourly price (state demo) (13) |
| 11 | Flow 4B · Station · Details, directions & reviews | 04-station-book.md | 04.12 · Station details · Pushed (from Saved) · 04.13 · Station details · Pushed · Loading · 04.14 · Directions · 04.15 · Directions · No coordinates · 04.16 · Directions · Couldn't open Maps · 04.17 · Call host · proposal · 04.18 · Reviews · 04.19 · Reviews · Loading · 04.20 · Reviews · Empty (state demo) · 04.21 · Reviews · Couldn't load (10) |
| 12 | Flow 4C · Book · Book a slot | 04-station-book.md | 04.22 · Book a slot · Loading station · 04.23 · Book a slot · Couldn't load station · 04.24 · Book a slot · Start · 04.25 · Book a slot · Window + duration · 04.26 · Book a slot · Scrubbing start time · 04.27 · Book a slot · Ready · 04.28 · Book a slot · Full scroll · 04.29 · Book a slot · Start first, longer durations dimmed · 04.30 · Book a slot · Availability scrub · proposal · 04.31 · Book a slot · No free windows · 04.32 · Book a slot · Closed this day · 04.33 · Book a slot · Times loading · 04.34 · Book a slot · Times error (13) |
| 13 | Flow 4D · Book · Vehicle | 04-station-book.md | 04.35 · Choose vehicle · 04.36 · Choose vehicle · Empty · 04.37 · Choose vehicle · Couldn't load · 04.52 · Choose vehicle · Loading · 04.38 · Book a slot · No vehicle · 04.39 · Book a slot · No matching vehicle · 04.40 · Book a slot · Pricing unavailable · 04.51 · Book a slot · Vehicle loading (8) |
| 14 | Flow 4E · Book · Confirm, booked & errors | 04-station-book.md | 04.41 · Confirm booking · 04.42 · Confirm · Booking · 04.43 · Booked · Pass appears · proposal · 04.44 · Error · Slot already booked · 04.45 · Error · Station paused · 04.46 · Error · Connection interrupted · 04.47 · Error · Network · 04.48 · Error · Couldn't calculate cost · 04.53 · Errors · Other submit messages (9) |
| 15 | Flow 5A · Charge · Tab & scanner | 05-charge-start.md | 05.01 · Charge · Ready to start · 05.02 · Charge · Booking later today · 05.03 · Charge · No upcoming booking · 05.04 · Charge · Charging in progress · 05.36 · Charge · Loading · 05.05 · Scanner · Camera prompt (OS) · 05.06 · Scanner · Permission denied · 05.07 · Scanner · Scanning · 05.08 · Scanner · Code found · Checking · 05.09 · Scanner · Invalid QR · 05.10 · Scanner · Too early · 05.11 · Scanner · No booking here · 05.12 · Scanner · Booking ended (13) |
| 16 | Flow 5B · Charge · Code & battery | 05-charge-start.md | 05.13 · Charger code · Empty · 05.14 · Charger code · Valid · 05.15 · Charger code · Looking up · 05.16 · Charger code · Not recognised · 05.17 · Charger code · Lookup failed · 05.18 · Charger found · Confirm · 05.19 · Planner · Battery now · Not set · 05.20 · Planner · Battery now · Dragging · 05.21 · Planner · Battery now · 20% · 05.22 · Planner · Choose vehicle (10) |
| 17 | Flow 5C · Charge · Plan, start & connect | 05-charge-start.md | 05.23 · Planner · By time · Until 7:00 PM · 05.24 · Planner · By time · Recalculating · 05.28 · Planner · Battery skipped · 05.30 · Planner · Per-hour station · 05.25 · Planner · By target · Slot ends first · 05.26 · Planner · By target · 30% · 05.27 · Planner · By target · Already there · 05.29 · Planner · DC fast · Target 80% · 05.31 · Planner · Sliding · 05.32 · Planner · Starting · 05.33 · Planner · Start failed · 05.34 · Connecting · Establishing · 05.35 · Connecting · Station known (13) |
| 18 | Flow 6A · Live · Charging | 06-live-complete.md | 06.01 · Live · Starting (6:00 PM) · 06.02 · Live · Charging (6:32 PM) · 06.03 · Live · How we estimate · 06.04 · Live · Halfway (6:30 PM) · 06.05 · Live · Update battery % · 06.06 · Live · Ending soon (6:55 PM) · 06.07 · Live · Slot ended (7:00 PM) · 06.08 · Live · Battery unknown · 06.09 · Live · Connection lost · 06.10 · Live · Stopped at the charger (6:44 PM) · 06.11 · Live · No slot end · 06.12 · Live · ≈80% reached (DC, state demo) · 06.13 · Live · Loading session (13) |
| 19 | Flow 6B · Live · Stop & accessory | 06-live-complete.md | 06.14 · Stop · End charging session? · 06.14b · Stop · Battery unknown · 06.15 · Stop · Stopping · 06.16 · Stop · Couldn't stop · 06.17 · Accessory · Ending (6:55 PM) · 06.17b · Accessory · Slot ended (7:00 PM) · 06.18 · Accessory · Stopping · 06.19 · Accessory · No window · 06.20 · Accessory · Couldn't stop (9) + link card 06.21 → 05.04 |
| 20 | Flow 6C · Live · Lock Screen & Dynamic Island | 06-live-complete.md | 06.22 · Lock Screen · Live Activity · Charging · proposal · 06.23 · Lock Screen · Live Activity · Ending soon · proposal · 06.24 · Lock Screen · Live Activity · Complete · proposal · 06.25 · Dynamic Island · Compact + Minimal · proposal · 06.26 · Dynamic Island · Expanded · proposal · 06.27 · Notifications · Lock Screen (Live Activities off) · proposal · 06.28 · Notification · ≈80% (DC, state demo) · proposal · 06.28b · Notification · Plan done (30 min plan) · proposal (8) |
| 21 | Flow 6D · Complete · Summary & receipt | 06-live-complete.md | 06.29 · Complete · Entrance (t = 450 ms) · 06.30 · Complete · Summary (7:00 PM) · 06.31 · Complete · Scrolled · 06.32 · Complete · Stopped at the charger (6:44 PM) · 06.33 · Complete · Stopped early (6:32 PM) · 06.34 · Complete · Battery unknown · 06.35 · Complete · Rated · 06.35b · Complete · Review unavailable · 06.36 · Receipt · Saved image (artefact) · 06.37 · Receipt · Saved · 06.38 · Receipt · Photos permission (OS) · 06.39 · Receipt · Permission denied · 06.39b · Receipt · Couldn't save (13) |
| 22 | Flow 6E · Complete · Rate & exit | 06-live-complete.md | 06.40 · Review · New · 06.41 · Review · 4 stars + note (typing) · 06.42 · Review · No rating · 06.43 · Review · Too long · 06.44 · Review · Submitting · 06.45 · Review · Couldn't submit · 06.46 · Review · Edit · 06.47 · Review · Read-only · 06.48 · Review · Period ended, no review · 06.49 · Review · Loading / Couldn't load · 06.50 · Charge tab · After session (11) |
| 23 | Flow 7A · Bookings · Charging Passes | 07-bookings.md | 07.01 · Bookings · Upcoming · Ready to start · 07.02 · Bookings · Upcoming · Later today · 07.03 · Bookings · Upcoming · Confirming · 07.04 · Bookings · Upcoming · Charging now · 07.05 · Bookings · Upcoming · Expiring soon · 07.06 · Bookings · Upcoming · Paused (fix) · 07.07 · Bookings · Completed · 07.08 · Bookings · Cancelled · 07.09 · Bookings · Host cancelled (live update) · 07.40 · Bookings · Opened from a push (logic) (10) |
| 24 | Flow 7B · Bookings · Empty, loading & errors | 07-bookings.md | 07.10 · Bookings · Upcoming · Empty · 07.11 · Bookings · Completed · Empty · 07.12 · Bookings · Cancelled · Empty · 07.13 · Bookings · Loading · 07.14 · Bookings · Refreshing · 07.15 · Bookings · Offline (cached) · 07.16 · Bookings · Error · 07.17 · Bookings · Signed out · 07.18 · Bookings · Station failed on a pass · 07.19 · Bookings · Booking failed (legacy) · 07.20 · Bookings · Review period ended (11) |
| 25 | Flow 7C · Bookings · Pass detail | 07-bookings.md | 07.21 · Pass · Upcoming · 07.22 · Pass · Upcoming · Scrolled · 07.23 · Pass · Ready to start · 07.24 · Pass · Charging now · 07.25 · Pass · Completed · 07.26 · Pass · Cancelled by host · 07.27 · Pass · Expired (fix) · 07.28 · Pass · Paused · 07.29 · Pass · Read-only (from chat) · 07.30 · Pass · Call host · 07.31 · Pass · Directions (11) |
| 26 | Flow 7D · Bookings · Cancel & Wallet | 07-bookings.md | 07.32 · Cancel · Confirm · 07.33 · Cancel · Cancelling · 07.34 · Cancel · Done · 07.35 · Cancel · Failed · 07.36 · Cancel · Too late · 07.37 · Cancel · Reason (optional) · 07.38 · Wallet · Add pass (OS) · 07.39 · Wallet · Added (8) |
| 27 | Flow 8A · Profile · Tab & identity | 08-profile-vehicles.md | 08.01 · Profile · Default · 08.02 · Profile · Scrolled · 08.03 · Profile · While charging · 08.04 · Profile · Loading · 08.05 · Profile · Couldn't load · 08.05b · Profile · No user data · 08.06 · Profile · Switching to Host · 08.07 · Profile · Wallet is coming soon · 08.08 · Profile · Help & support · 08.59 · Identity · Verified · 08.60 · Identity · Not verified · 08.61 · Identity · Just verified (12) + link card Saved chargers → 02.20–02.24 |
| 28 | Flow 8B · Profile · My vehicles | 08-profile-vehicles.md | 08.30 · My vehicles · Default · 08.31 · My vehicles · Swipe to delete · 08.32 · Delete vehicle · Confirm · 08.33 · Delete vehicle · Deleted · 08.34 · Delete vehicle · Couldn't delete · 08.35 · My vehicles · Empty · 08.36 · My vehicles · Loading · 08.37 · My vehicles · Couldn't load · 08.38 · My vehicles · Refreshing (9) |
| 29 | Flow 8C · Profile · Add & edit vehicle | 08-profile-vehicles.md | 08.39 · Add vehicle · Empty · 08.40 · Add vehicle · Typing · 08.41 · Add vehicle · Filled · 08.42 · Add vehicle · Required errors · 08.43 · Add vehicle · Battery out of range · 08.44 · Add vehicle · Saving · 08.45 · Add vehicle · Added · 08.46 · Add vehicle · Couldn't save · 08.47 · Edit vehicle · Loading · 08.48 · Edit vehicle · Default (scrolled) · 08.49 · Edit vehicle · Add battery size · 08.50 · Edit vehicle · Updated · 08.51 · Edit vehicle · Couldn't load · 08.52 · My vehicles · Primary changed (14) |
| 30 | Flow 8D · Profile · Edit profile & notifications | 08-profile-vehicles.md | 08.23 · Edit profile · Default · 08.24 · Edit profile · Editing · 08.25 · Edit profile · Errors · 08.26 · Edit profile · Apple private relay · 08.27 · Edit profile · Saving · 08.28 · Edit profile · Saved · 08.29 · Edit profile · Couldn't save · 08.53 · Notifications · Default · 08.54 · Notifications · All read · 08.55 · Notifications · Couldn't mark read · 08.56 · Notifications · Loading · 08.57 · Notifications · Empty · 08.58 · Notifications · Couldn't load (13) |
| 31 | Flow 8E · Profile · Account & settings | 08-profile-vehicles.md | 08.16 · Account & settings · Default · 08.16b · Account & settings · No phone, no vehicle · 08.17 · Account & settings · Loading · 08.18 · Account & settings · Couldn't load · 08.19 · Account & settings · Coming soon · 08.20 · Delete account · Confirm · 08.21 · Delete account · Deleting · 08.22 · Delete account · Couldn't delete (8) |
| 32 | Flow 8F · Profile · Sign out | 08-profile-vehicles.md | 08.09 · Sign out · Confirm · 08.10 · Sign out · Active session · 08.11 · Sign out · Ending session · 08.12 · Sign out · Couldn't end session · 08.13 · Sign out · Charging summary · 08.14 · Sign out · Logging out · 08.14b · Sign out · Logout failed · 08.15 · Sign out · Signed out notice (8) |
| 33 | Flow 9A · Messages · Inbox | 09-messages.md | 09.01 · Inbox · All · 09.02 · Inbox · Unread · 09.03 · Inbox · Upcoming · 09.04 · Inbox · Charging now · 09.05 · Inbox · Empty · 09.06 · Inbox · Filter empty · 09.07 · Inbox · Loading · 09.08 · Inbox · Error · 09.09 · Inbox · Refreshing · 09.10 · Push · New message (other tab) (10) |
| 34 | Flow 9B · Messages · Chat thread | 09-messages.md | 09.11 · Thread · Upcoming booking · 09.12 · Thread · Typing · 09.13 · Thread · Sending · 09.13b · Thread · Sending (logic) · 09.14 · Thread · Failed to send · 09.15 · Thread · Charging now · 09.15b · Thread · Booking details failed · 09.16 · Thread · History & booking events · 09.17 · Thread · Empty · Booked · 09.18 · Thread · Opening (from booking or push) · 09.19 · Thread · Couldn't open · 09.19b · Thread · Loading messages · 09.20 · Thread · Couldn't load messages · 09.21 · Thread · Blocked (14) |
| 35 | Flow 9C · Messages · Inquiries | 09-messages.md | 09.22 · Thread · Ask a question (cold) · 09.23 · Inquiry sheet · Choose · 09.24 · Inquiry sheet · Own message · 09.25 · Thread · Waiting for host · 09.26 · Thread · Follow-up available · 09.27 · Inquiry sheet · Failed (6) + unlock state diagram card |
| 36 | Flow 9D · Messages · Options & call | 09-messages.md | 09.28 · Conversation options · 09.29 · Conversation options · After a session · 09.30 · Call · With number · 09.31 · Call · No number · 09.32 · Call · Dialer failed (5) |

Totals: 36 sections, 384 frames (01: 46 · 02: 32 · 03: 24 · 04: 53 · 05: 36 · 06: 54 · 07: 40 · 08: 64 · 09: 35).

---

## 5. Consistency rules

### 5.1 Copy tone
- **Real copy is verbatim** (logic map), including its punctuation ("Loading session...", "Confirming...", "Logout"). New copy is flagged in its flow and follows the rules below.
- Plain, calm, short; second person; sentence case for new labels and titles ("Leave a review" is the target; real "Leave a Review" stays until Rayan changes it, BK29).
- Buttons start with a verb and say the outcome: "Book now", "Scan to start", "Slide to start charging", "Update estimate", "Book again".
- Errors say what happened, then what to do: "Couldn't load stations" / "Check your connection and try again." + "Retry". New copy uses "Couldn't"; never show a raw exception (use the logic's pattern with a sample, e.g. "Error: Couldn't reach PakPlug.").
- Honest estimates: every planned or live amount carries the brief line **"Estimate. The charger's meter decides the final amount."** once per screen (stats card, planner, footer info, booking details); battery % is always "≈… est."; never claim refunds, billing outcomes or host behaviour the app can't know.
- No blame ("Stopped at the charger", not "The host stopped…"); no exclamation marks in new copy; emoji only where the real copy has it ("Charged to ≈80% ⚡").
- New copy uses the typographic ellipsis "…"; " · " (middle dot with spaces) separates facts; "→" is the time-first arrow on readouts and passes; "–" (spaced en dash) for ranges in rows.

### 5.2 Number and data formats
| Thing | Format | Examples |
|---|---|---|
| Money | "Rs" + space + whole rupees, thousands separators | Rs 42 · Rs 286 · Rs 1,250 · Rs 2,468 (real "Rs 152.00" stays only where the logic prints it, 08.13) |
| Rate | no spaces around the slash | Rs 42/kWh · Rs 300/hr (real StartSessionDialog row keeps "Rs 42 / kWh") |
| Energy, power | 1 decimal + space + unit | 6.8 kWh · 3.6 kWh · 7.4 kW · 60 kW |
| Battery | "≈" + whole % (no space), "est." where there is room | ≈31% · ≈26% est. · start % entered by the driver has no "≈": 20% |
| Time of day | 12-hour, no leading zero | 6:00 PM · 6:32 PM |
| Time range | readouts and passes: "6:00 → 7:00 PM"; rows, summaries, details: "6:00 – 7:00 PM" | |
| Duration | "1 h" · "1 h 10 min" · "30 min" · "1 hour" (real Confirm row) · chips "1.5 h" (real) · "Longest here: 3h / 45m / 2h 30m" (real pattern) | |
| Countdown | mm:ss under 1 h, h:mm:ss above (logic) | 28:00 · 5:00 · 1:28:00 |
| Relative | | Starts in 10 min · 28 min left · 14 min left to start · Tomorrow |
| Dates | story "Today, Sat 4 Oct"; eyebrow caps "TODAY · SAT 4 OCT"; details "Oct 4, 2026"; reviews "September 28, 2026"; chat separators d/m/y (logic) | |
| Distance | 1 decimal + space | 1.2 km · 7.8 km (hidden without GPS) |
| Rating, counts | 4.8 + one star · "36 reviews" · "1 review" · "No reviews yet" / "N/A" | |
| Phone, plate, code | 0301 2345678 · LEB-2481 · GV7-K42 | |
| Unknown | "—" (never "N/A" for new fields; real "N/A" stays where the logic prints it) | |
| Numbers that matter | Display styles (SF Pro Light) or a component's number slot, tabular figures | |

### 5.3 Status → tone (one map; `Status Pill` S unless stated)
| Domain | Status | Tone (pill) | Pin / text / other |
|---|---|---|---|
| Station | Available | Success 980:314 | Map Pin Available; `text/available` |
| | In use | Info 980:326 | In use pin; `text/inUse` |
| | Maintenance · Paused | Warning 980:320 | Unavailable pin; `text/warning` (Paused also disables Book now) |
| | Offline | Neutral 980:332 | Unavailable pin; `text/offline` |
| Booking (pass, list, detail, Next Booking Card, chat chip) | Confirming... | Neutral + Spinner | not tappable |
| | Upcoming | Info | (05.02's "Today" is the When line, not the pill) |
| | Ready to start | Success, dot `pulse` | 3pt `energy` top edge |
| | Expiring soon | Warning, dot | 3pt `status/warning` top edge |
| | Charging now | Live 980:344, dot `pulse` | live row + Pass Progress |
| | Paused | Warning | 4pt warning leading bar |
| | Completed | Success, no dot | |
| | Cancelled by you · Cancelled | Neutral | |
| | Cancelled by host | Error 980:338 | |
| | Expired | Warning | Cancelled face |
| Session | Charging | Live | accessory State=Charging |
| | Ending soon (≤ 5 min) | Warning | now node `status/warning`, accessory State=Ending |
| | Stopping | — (overline "STOPPING…") | accessory State=Stopping |
| | Connection lost | Map Status Pill (Frost Strong) + warning icon | values keep estimating |
| | Stopped at the charger | Map Status Pill + checkmark | |
| | Complete | Success (Live Activity) | Success Mark |
| Planner | Slot ends first | Warning | capped line `text/warning` |
| Account | Verified | Success | |
| | Not verified · Primary · New inquiry · trust "No completed bookings together yet" | Neutral | |
| | "N completed bookings together" | Success | |
| Price trend | Below / Average / Above | Success / Neutral / Warning | |

### 5.4 Empty, error and loading
| Situation | Pattern |
|---|---|
| A whole content area has nothing | `State View` Empty 1072:573: icon, real title, message, at most one action; centred in the content area. Upcoming bookings use the Ghost Pass instead of the icon |
| A whole content area failed | `State View` Error 1072:588: title = what failed, message "Check your connection and try again.", action "Retry" |
| Loading with a known layout (cards, lists, rows) | skeletons: the component's Loading variant or Skeleton Block (150 ms grace, ≥ 600 ms) |
| Loading with an unknown layout or the whole screen | `State View` Loading 1072:584 (spinner; real "Loading…" copy where the logic has it) |
| Loading caused by a button | the button's Loading variant; nothing else moves |
| A blocking logic step (logout, delete account, host switch) | Loading HUD over `bg/scrim` (08) |
| Map-level states | `Map Status Pill`: Loading "Loading…", Notice ("No stations found" + "Clear" when filters are on), Error + "Retry" |
| Search | `Search Result Row` Loading / Empty (+ helper line, "Clear filters") |
| One section or card failed, the rest is fine | Inline Notice Error in that section (or the card's own error line, 07.18) |
| The result of an action | Toast (Success / Error with Retry if repeatable) |
| A decision that blocks | native Alert (§1.3) |
| Field validation | `Text Field` Error with its message under the field, shown after the first submit |
| Offline with cached data | Inline Notice Neutral ("Showing cached bookings (offline)"); Live keeps estimating with the "Reconnecting…" pill |
| Pull to refresh | `iOS / Refresh Control`; old content stays |

### 5.5 Icons per concept (SF names, inventory IDs)
| Concept | Icon |
|---|---|
| Station / charger (wells, rows) | ev.charger.fill 1024:480 · placeholder or empty: ev.charger 1024:478 |
| Charging now, energy, start | bolt.fill 958:35 (reserved for "charging"; not used as a station glyph) |
| Plugs | ev.plug.ac.type.2 981:294 · ev.plug.dc.ccs2 1024:482 · ev.plug.dc.gb.t 1024:484 |
| Book / booking | calendar 958:39 · pass: wallet.pass 1024:486 / wallet.pass.fill 1024:488 |
| Time, window, waiting | clock 958:88 · plan chip / timer: timer 1025:502 |
| Directions | arrow.triangle.turn.up.right.diamond.fill 1024:496 |
| Call · Message | phone.fill 1024:476 (tiles, sheets) / phone 984:451 (nav) · message.fill 966:7 (tiles) / message 958:42 (nav) |
| Save | heart 958:49 / heart.fill 981:289 |
| Share · Download receipt | square.and.arrow.up 1024:503 (wanted square.and.arrow.down) |
| Close · Back · Minimize · More | xmark 958:72 · chevron.left 1025:481 · chevron.down 1025:483 · ellipsis 1024:510 |
| Disclosure | chevron.right 958:55 (`icon/tertiary`) |
| Info · Warning / error · Success | info.circle 1025:472 · exclamationmark.triangle.fill 1025:474 · checkmark.circle.fill 1025:506 |
| Vehicle · Battery | car.fill 1024:474 · battery.75percent 1023:481 |
| Scan · Code entry | qrcode.viewfinder 958:61 · circle.grid.3x3 966:15 (wanted keyboard) |
| Search · Filters · Location | magnifyingglass 958:6 · slider.horizontal.3 1025:513 · location.fill 1024:472 (tracking) / location 958:19 |
| Place | mappin 1025:485 |
| Notifications · Settings · Profile | bell 958:10 · gearshape 1025:498 · person.crop.circle 1023:483 |
| Payment · Delete | creditcard 1025:494 · trash 1025:496 |
| Rating | star.fill 958:52 / star 1025:492 |
| Price trends · List · Map | chart.bar 958:23 · list.bullet 958:81 · map 958:84 |
| Stop | stop.fill 958:64 |
| Empty bookings · inbox | calendar · bolt.car 1025:500 · bubble.left 1023:485 |
Missing symbols keep the nearest listed icon and are named in each section's FLAG card (e.g. `envelope`, `eye`, `lock.fill`, `wifi.slash`, `arrow.up`, `flashlight.off.fill`, `pencil`, `questionmark.circle`, `checkmark.seal`, `ev.plug.ac.type.1`, `ev.plug.dc.chademo`).

### 5.6 Backgrounds: Hero vs Quiet vs Celebrate vs Map
| Background | Where | Text rule |
|---|---|---|
| **Mesh Hero** 951:7416 | Charge tab (05.01–05.04, 05.36, 06.50), Charge planner (05.19–05.33), Connecting (05.34–05.35), Live (06.01–06.16), Lock Screen wallpaper (OS mock), Story 3 illustration window | measured rule: `text/primary` over the top glow (status bar, large title, top ≈ 140pt); `text/onMesh` below; never `text/secondary` on the mesh; cards with grey text Frost Strong or Surface; floating chrome Frost Strong |
| **Mesh Quiet** 951:7417 | every list and pushed screen: onboarding, Discover list, Saved chargers, Price Trends, Station details pushed, Code entry, Bookings, Profile and its pushes, Messages | normal text colours |
| **Mesh Celebrate** 951:7418 | All set (01.41–01.42), You're booked (04.43), Charging complete (06.29–06.39) | `text/primary` inside the glow down to y ≈ 275; nothing sits directly on the mesh from y 290 to 700 (cards are Surface / Frost Strong); white only on the deep base below y 700 (On Mesh buttons); measure on the built frame |
| **Map** (fills of 996:430) | Home map, search outcomes, place sheet, accessory frames, Dynamic Island backdrop | normal text colours; chrome is Glass |
| **Camera feed** (placeholder gradient) | Scanner | white text; Nav Bar Material=Camera; pills Frost Strong |
| **Emerald faces** (passes, Me bubbles, receipt band, Wallet pass) | — | solid white text only (5.4:1); never translucent white; `sheen` ≤ 8% |

### 5.7 Materials: Surface vs Frost Strong vs Frost vs Glass
| Material | Token | Use |
|---|---|---|
| **Surface** | `bg/surface` 948:41 | every sheet; data cards (Price Trends charts); cards on the Celebrate mesh (summary, rate); receipts; Them bubbles |
| **Frost Strong** | `bg/frostStrong` 948:44 + Frost/Card | any card over a mesh or the map that carries grey text (station cards, list groups, stats and progress cards on Hero, Next Booking Card, Vehicle Card, Inbox groups, banners); all floating chrome on Hero/Celebrate (nav buttons, tab bar, pills, Stop); Toast; Notification Preview; Scroll edge band |
| **Frost (68%)** | `bg/frost` 948:43 | decorative only, never under `text/secondary` (Ghost Pass fill) |
| **Glass** | `bg/glass` 953:4, Glass/Regular | floating chrome over the map and on Mesh Quiet (Icon Button Glass, chips, search capsule, Map Controls, map pills); title capsule and composer add Frost Strong underneath |
| **Grouped / Fill** | `bg/grouped` 948:42 · `bg/fill` 948:46 | inner containers on Surface (rows groups in sheets, estimate cards, decision rows) · wells, tracks, skeletons, row press |

### 5.8 Type
SF Pro only. Titles and every "Emph" style are **Medium**, body **Regular**, numbers **Light** (Display styles); no Bold or Semibold anywhere in PakPlug UI (OS chrome is the only exception: the Lock Screen date). Screen titles = Large Title (34); sheet titles = Title 2 (22) in Sheet / Action, the Sheet Header's own style elsewhere; section headers = `List Group Header` or Title 3 / Headline; meta = Footnote / Caption. Match highlights are a weight change (Regular → Medium), never colour. The SF Pro wordmark (`Brand / Wordmark` 994:132) appears on Splash, Story, Sign in, the receipt band and the Wallet pass; Home shows the mesh P in the search capsule (02-P27).

---

## 6. Conflicts resolved between specs

1. **Section names and size.** Specs used `Flow 01 · …`, `Flow 05A · …`, one section of 24–64 frames (01, 02, 03, 04, 08) and a 17-frame 06A → 36 sections named `Flow nX · Flow · Part`, all ≤ 14 frames (§4); 1076:2 becomes Flow 2A and moves into journey order.
2. **Start-of-charging success haptic.** 05 played success on the start request and called 06's arrival "light"; 06 played success at M1 → one success at 06 M1 ("Charging started"); 05's Slide commit is medium and the request success has no haptic.
3. **`tick` name collision.** 05 `tick` (5% haptic) vs 06 `tick` (1 s clock) → `tick` = the 1 s clock; step haptics are `scrub` (05 and 04 merged).
4. **`scrub` rate limit.** 40 ms (04) vs 60 ms (05) → one per 60 ms.
5. **`pulse` collision.** 05 Connecting rings 1.8 s, 06 dot ring 1.33 s, 07 dot opacity 1.6 s → `pulse` = 06's ring on every live/ready dot; Connecting rings renamed `radiate`.
6. **`roll` duration.** 220 ms (01, 06, 08) vs 250 ms (05, 09) → 220 ms.
7. **Toast entrance.** From 16pt below (01, 08) vs 12pt (02–07, 09) → 12pt.
8. **Toast timing.** 06 allowed 8 s for action errors and 3 s for "Battery updated" → 4 s / 6 s everywhere; only the stop-failure toast (8 s) and the auto-stop status toast (until resolved) differ.
9. **Toast position.** Fixed y values assumed 52 or 56pt heights and 08 used 16pt gaps → the bottom-edge table (§1.5) with 12pt gaps.
10. **Sheet recede.** 05 and 06 scaled full screens behind medium sheets, 07 didn't, 03 used 0.94 → recede 0.96 only for sheet-on-sheet; sheets over full screens get the scrim only.
11. **Large detent top.** y 60 (03), 62 (04, 06), 64 (07, 09.24) → 62. **Grabber** at top + 6 (03, 07, 09) vs + 5 → top + 5.
12. **Icon buttons in sheets.** Glass S (04, 06), Glass M (08), Fill M (03) → Fill S on opaque sheets (Fill M beside the search field only).
13. **Nav Bar inside a sheet.** 07's pass detail used `Nav Bar` Inline in the sheet → `Sheet Header` Form; Nav Bar never in sheets.
14. **Icon-led sheets.** Permission Sheet (02, padding 24), Manual Call Sheet (09, centred), Sheet / Action (08, leading), End-session sheet (06) → one `Sheet / Action`, leading-aligned with 16pt margins.
15. **Success inside a sheet.** 04.43 used a bare 32pt checkmark → `Sheet / Action` Success well; Success Mark only for full-screen completions.
16. **Pushed content start.** y 118 (02), y 114 (04.12), y 122 (01, 05, 08) → y 122.
17. **Large-title collapse.** 44pt (04) / 50pt (08) → 51pt, scroll-driven.
18. **Row press.** 04 scaled rows 0.98 while 03/08/09 highlighted → list rows highlight (`bg/fill`, no scale); cards 0.98.
19. **Tile press.** Connector Tile 0.97 (08) vs tiles 0.96 → 0.96.
20. **Book now / View Details haptic.** medium (02, 04) → light; medium is for commits only.
21. **List-row navigation haptic.** light (02 card taps) vs none (08) → rows that push: none; cards and tiles: light.
22. **Disabled chips.** 05 faked them with Fill/No at 40%, 04 added Chip Fill/Disabled → build Fill/Disabled; 05 uses it.
23. **Next Booking Card status.** 05.02 showed Neutral "Today" while the same booking is Info "Upcoming" on the pass (07 S2) → Info "Upcoming"; "Today" lives in the When line.
24. **Battery slider VoiceOver step.** ±5% (05) vs ±1% (06) → ±1%.
25. **Live Stop button.** Destructive Secondary with a Frost Strong override (06) vs the planned On Mesh Destructive type → build `Button / Large` Type=On Mesh Destructive and use it.
26. **Alert dismissal.** 200 ms ease-in + scale 0.96 (08) vs `fade.quick` (05) → `fade.quick`, opacity only.
27. **Loader minimum.** HUD ≥ 500 ms (08) vs spinners ≥ 600 ms (02, 04) → 600 ms everywhere after a 150 ms grace.
28. **Unread rows.** Notification Row dot leading at x 4 with Caption 1 tertiary time (08) vs Thread Row dot trailing with Footnote time (09) → one `Inbox Row`: dot in the leading gutter, time Footnote `text/secondary` (Unread: Footnote Emph `text/brand`).
29. **Vehicle displays.** Vehicle Select Row (04), List Row Value in the planner (05) and Vehicle Card (08) → one `Vehicle Card` set, Layout = Card · Row; the planner uses Row.
30. **Proposal tags in frame names.** "04.17 · Call host [P3]", "04.30 … [P16]", "04.43 … [P20]", "★" on 06.02/06.30 → tags stripped; whole-proposal frames end with "· proposal" (also 06.22–06.28b).
31. **Real-copy ellipsis.** 07 rendered "Confirming..." as "Confirming…" → real copy is verbatim; new copy uses "…".
32. **Shake.** 300 ms (06 stars) vs 320 ms (`M-shake`) → 320 ms.
33. **Pills and nav chrome on meshes/camera.** Per-frame fill overrides (05, 06) → explicit properties: `Map Status Pill` Surface = Glass · Frost Strong; `Nav Bar` Material = Glass · Frost · Camera.
34. **List Group Header trailing.** 03's "· action" variant, 04's "· trailing" extension and the Peak Note utility → one extension: Trailing = None · Text · Action · Status.
35. **"Ending soon" vs "Expiring soon".** 06 uses "Ending soon" for a live session at 5 min left; a booking window closing without a session is "Expiring soon" (07 S4). Kept apart everywhere.
36. **Inline Notice ownership.** 01 defined "Inline Message" and 04 "Inline Notice" → one `Inline Notice` set with 01's Success tone and Plain style added.
37. **Avatar sizes.** 09 drew 28pt bubble avatars → Avatar S 32 is the smallest size; 08 adds XL 72 and the Mesh style.
