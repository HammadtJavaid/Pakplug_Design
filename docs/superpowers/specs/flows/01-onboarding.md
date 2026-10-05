# Flow 01 · Onboarding + auth (driver path): build spec

> **00-system alignment (2026-10-04, read first).** `00-system.md` is the single answer for navigation, sheets, motion, haptics, shared components, section names, formats, tones and materials; where this spec still differs, 00-system wins. Applied to this spec: (1) Sections are `Flow 1A`–`Flow 1D` with the frame lists in 00-system §4; each section closes with its own Logic check card. (2) Toasts enter from 12pt below and are placed by their bottom edge (00-system §1.5). (3) Inline Notice (C2), Page Control and Step Progress (C11), Success Mark and Confetti (C12), Notification Preview, iOS / Keyboard and iOS / Permission Alert (C13) and the Button / Large On Mesh types (C14) are shared components built before screens from 00-system §3; §7 here is the per-flow detail. (4) Connector Tile Pressed scale is 0.96 (C6). (5) Haptics follow the 00-system map: Next / Continue light, submits medium, success only for real completions.

Research-only spec for the Figma build. No Figma calls were made. Sources: `BRIEF.md`, `NEW-COMPONENTS.md` (Nav Bar, Toast, Rating Stars and Connector Tile already exist), `driver-logic-map.md` §J (plus §B location sequence, §I `AddEditVehicleScreen`, Appendix 2–4), the revamp spec and progress log, the sibling specs that share screens or parts with this one (`02-discover.md` §4.0 motion tokens and the Home permission frames 02.02/02.04, `03-search.md` §6 iOS / Keyboard, `04-station-book.md` §6 Inline Notice, `06-live-complete.md` Celebrate rule, `08-profile-vehicles.md` Add vehicle 08.39–08.46), and 18 Mobbin searches (screens + flows, iOS) whose images were reviewed. Reviewed and corrected on 2026-10-04 (see "Review notes" at the end).

Sections on Driver Flows (946:8): `Flow 1A · Onboarding · Welcome & sign in` · `Flow 1B · Onboarding · Create account, verify & log in` · `Flow 1C · Onboarding · Reset, role & vehicle prompt` · `Flow 1D · Onboarding · Add vehicle, permissions & all set` (frame lists: 00-system §4). Frame labels are written `01.nn · Screen · State` (Footnote Emph, `text/secondary`, above each frame).

---

## 1. Overview

**Goal.** A new driver opens PakPlug, understands it in four slides, signs in (Apple, Google or email), chooses Driver, optionally saves a car, grants location and notifications, and lands on the Home map. The flow should feel calm, light and native: Quiet mesh throughout, one emerald accent, and a Celebrate-mesh moment at the end.

**Entry points**
1. First launch → Splash → Story (onboarding not seen).
2. Launch while logged out, onboarding already seen → Splash → Sign in (`/login`).
3. Auth loss on any non-public route → Sign in (Appendix 2).
4. Sign out or Delete account from Profile → Sign in (08.15, 08.21).
5. Role switch: an existing Host taps Driver mode for the first time (Profile) → Become a driver → Add your vehicle? → Add vehicle → All set (skips Location and Notifications).

**Exits**
- Home tab (`/driver-home`, index 0) from All set (both buttons), from Log in, and for returning social users straight from Sign in.
- Host flow when Host is chosen (out of scope; the selection state is shown).
- Splash with a valid session → role home directly.
- PrivacyPolicyScreen from the Sign-in legal line (pushed; not drawn, the logic map has no copy for it).

**Order (logic map J, unchanged):** Splash → Story (4) → Sign in → [email: Create account → Verify email] or [Log in → role home] → Choose role (STEP 1) → Add your vehicle? (STEP 2) → [Add vehicle form] → Location (STEP 3) → Notifications (STEP 3) → All set → Home.

**Count.** 17 distinct screens (including 3 system surfaces) shown in **46 phone frames** (states), plus one link card to Flow 02 for the two Home permission surfaces (02 owns them).

---

## 2. Shared layout template (applies to every frame unless a frame says otherwise)

Frame 402×874, named as above. Every fill and stroke is bound to a variable. The only raw colours allowed are brand-mandated third-party ones (Apple button black, Google "G") and OS-owned mocks (keyboard, system alert dim); each is labelled in its component description.

| Zone | Spec |
|---|---|
| Background | `Background / Mesh Quiet` 951:7417 instance, resized 402×874 at (0,0). All set uses Mesh Celebrate 951:7418. |
| Status bar | `iOS / Status Bar` Content=Dark 996:398 at (0,0). This applies on Celebrate too, because the top glow is light and the measured rule says black there. |
| Navigation (pushed screens) | `Nav Bar` Style=Inline 1087:607 at (0,54), 402×52. Leading#1087:3 on (its "Leading button" already shows chevron.left 1025:481), Trailing 1/2 off. Title#1087:0 = "" (empty) while the large title is in view; it shows the screen title once the content scrolls under the bar (scroll-edge = Frost Strong + 1px `stroke/hairline`, fade.quick). Story, Sign in, Splash and All set have no Nav Bar. |
| Step Progress | New **Step Progress** 258×4, placed as a sibling layer **above** the Nav Bar instance at (72,78) (vertically centred in the bar, between the back button and the right edge). Only on Choose role, Add your vehicle?, Location, Notifications. |
| Eyebrow | (16,122), Caption 1 Emph, `text/brand`, all caps, tracking +6%. E.g. "STEP 1 OF 3". |
| Title | Large Title (34 Medium, line height 41), `text/primary`, width 370, wraps. At (16,146) under an eyebrow, or (16,122) without one (matches 08: pushed content starts at y 122). Centred screens centre it instead. |
| Subtitle | Body (17 Regular, lh 22), `text/secondary`, 8 below the title, width 370. |
| Content | Starts 32 below the subtitle. Text Fields are 76 tall with the label on; pitch 88 (gap 12), as in 08. |
| One action | `Button / Large` at (16,772), 370×52. |
| Two actions | Primary at (16,712); secondary, tertiary **or a text-link row** at (16,772). A text-link row is a 370×52 hit area with the line centred in it. |
| Text link line | Subheadline `text/secondary` with the link part in Subheadline Emph `text/brand` (Medium; no Bold). The whole line is one link for VoiceOver. |
| Sticky footer (scrolling forms) | `bg/frostStrong` + Frost/Elevated + 1px `stroke/hairline` top, from y 756 to 874. Only while content scrolls underneath (fade.quick). Same as 08. |
| Toast | Existing `Toast` 1088:631 (Tone=Neutral 1088:611 · Success 1088:616 · Warning 1088:621 · Error 1088:626; props Message#1088:0, Action#1088:5, Action label#1088:10). x 16, width 370, **bottom edge 12 above the top-most bottom button** (brief rule): y 704 (1 line) above a single button at 772; y 644 (1 line) or 628 (2 lines) above a primary at 712. It grows upward. Every Material snackbar in this flow becomes this Toast [P13]. |
| Home indicator | `iOS / Home Indicator` Dark 996:425 at (0,840). Light 996:427 on Celebrate (deep base at the bottom). |
| Keyboard frames | `iOS / Keyboard` (the shared OS mock from 03 §6; this flow adds Layout variants, §7), 402×336 at (0,538). The CTA rides at y 478 (keyboard top − 8 − 52). |

**Text on mesh (measured rule).**
- Quiet mesh (every screen except All set): normal text colours. Any card that carries grey text is Frost Strong or Surface, never Frost 68%.
- Hero mesh used inside illustration cards (Story 3, Lock Screen): the card is a window onto a full 402×874 Hero instance placed at the card's negative offset (so the mesh keeps its proportions; never stretch it). Text straight on it: black (`text/primary`) only over the top glow, `text/onMesh` below it, never `text/secondary`. Cards on it are Frost Strong (4.6:1) or Surface (5.3:1).
- Celebrate mesh (All set): follows 06's measured placement. Its glow sits lower than Hero's (centre ≈ y 227) with a bright `energy` blob around y ≈ 332, where white text fails (≈2:1). So the Success Mark and the title sit inside the glow (y 100–290) in `text/primary`; from y 290 to 700 nothing sits directly on the mesh (body and recap live on a Frost Strong card); the deep base (y > 700) carries the On Mesh buttons (white fill / white label, 4.7–5.7:1). Builder: screenshot 01.41 and measure the title; if black over the glow is < 3:1 for the 34pt title anywhere, move the title into the top of the recap card (06 uses the same fallback).

### 2.1 Motion tokens (shared; nothing new is invented here)

From 02 §4.0 (system-wide): `snappy` (response 0.30, damping 0.85), `smooth` (0.45, 1.0), `bouncy` (0.40, 0.70), `fade.quick` 150 ms ease-out, `fade.std` 220 ms ease-out, `camera` 350–500 ms ease-in-out. From 06 §4.0: `sweep` (gauge arc, `smooth`, ≈900 ms), `roll` (digit roll, 220 ms `snappy`).

Composite tokens defined here (08 and 06 cite them; the values below are the ones they quote):

| Token | Definition |
|---|---|
| **M-press** | Scale 0.97 + Pressed variant, 100 ms ease-out; release with `snappy`. |
| **M-select** | Selection change on cards, tiles and radios: `snappy`; the check badge pops 0.5→1 with `bouncy`. |
| **M-push** | Native UINavigationController push / pop (~350 ms), with the interactive edge-swipe back. |
| **M-replace** | Route replacement: cross-dissolve 250 ms ease-out (400 ms when the background changes mesh, e.g. → All set). |
| **M-rise** | y +12→0 and opacity 0→1, 320 ms ease-out (cubic-bezier .22,1,.36,1), stagger 40 ms (60 ms on All set). |
| **M-count** | Number count-up, 700 ms ease-out (tabular figures, Display style). |
| **M-shake** | 3 oscillations ±6pt, 320 ms. |
| **M-grow** | An Inline Notice appearing in a layout: height 0→auto with `smooth` while its content fades in with `fade.std`; content below slides with the same spring. Removal = `fade.quick` then height collapse (`smooth`). |
| **Toast motion** | As 00-system §2.1: rises from 12pt below with opacity 0→1 (`smooth`); auto-dismisses after 4 s (1 line) or 6 s (2 lines); swipe down dismisses; haptic follows tone (Success → success, Error → error, Warning → warning, Neutral → none); posted as a polite VoiceOver announcement without moving focus; RM fade. |

**Haptics (the app map from 02/08, applied).** *selection* = pager settle, card/tile/switch selection, threshold crossings; *light* = navigation buttons (Next, Skip, Continue to the next step, Allow/Not now, auth buttons); *medium* = submit taps that commit data (Create account, Log in, Send reset link, I've verified — Continue, Continue as driver, Save vehicle); *success* = real completions only (Verified, Vehicle added, Reset link sent, All set check); *warning* = Not verified yet; *error* = any failure. Text links and system alerts have no haptic.

**Reduce Motion (RM).** Every translate, scale, morph, parallax, swipe-spring and matched-geometry move becomes a `fade.quick` cross-fade (page and route changes use `fade.std`). No confetti, pulses, mesh drift, shakes, count-ups or digit rolls; numbers show their final value; the check mark appears static. Haptics still play.
**Reduce Transparency.** Frost, Frost Strong and Glass become Surface + 1px hairline. **Low Power Mode.** Same as RM for loops (mesh drift, pulses).

---

## 3. Screens & states table

Priority: **P1** = happy path (build first), **P2** = states (duplicate and override), **P3** = system-UI mocks (label them "System UI · reference", OS-owned, not built in Flutter).

| # | Frame | BG | Pri | Key instances | New parts |
|---|---|---|---|---|---|
| 01.01 | Splash · Launch | Mesh Quiet | P1 | P Mark Mesh 1082:123 | — |
| 01.02 | Splash · Loading | Mesh Quiet | P1 | Wordmark Emerald 994:122, spinner | — |
| 01.03 | Story · 1 PakPlug | Mesh Quiet | P1 | Wordmark Emerald, Button/Large Primary | Page Control |
| 01.04 | Story · 2 Charge anywhere | Mesh Quiet | P1 | Map Pins, Chip, Station Card, User Location, Button/Medium Tertiary (Skip) | Page Control, Illustration / Map Card |
| 01.05 | Story · 3 Plug in. Watch it live. | Mesh Quiet (card: Mesh Hero window) | P1 | Charging Gauge, Status Pill Live, Stat Tile ×2 | Page Control |
| 01.06 | Story · 4 Earn from your charger | Mesh Quiet | P1 | Hero Stat, Icon Button Tinted | Page Control |
| 01.07 | Sign in · Default | Mesh Quiet | P1 | P Mark Mesh | Auth Button ×3 |
| 01.08 | Sign in · Apple loading | Mesh Quiet | P2 | — | Auth Button Loading/Disabled |
| 01.09 | Sign in · Error | Mesh Quiet | P2 | — | Inline Notice Error · Plain |
| 01.10 | Sign in · Apple sheet (system) | Mesh Quiet + system dim | P3 | App Icon 992:82 | iOS / Apple ID Sheet |
| 01.11 | Create account · Empty | Mesh Quiet | P1 | Nav Bar Inline, Text Field ×4, Button/Large | Requirement Row |
| 01.12 | Create account · Typing | Mesh Quiet | P2 | Text Field Filled/Focused, Nav Bar (scroll edge) | iOS / Keyboard Layout=Default, Requirement Row Met |
| 01.13 | Create account · Errors | Mesh Quiet | P2 | Text Field Error ×3 | Requirement Row Error |
| 01.14 | Create account · Creating | Mesh Quiet | P2 | Text Field Disabled, Button Loading | — |
| 01.15 | Create account · API error | Mesh Quiet | P2 | — | Inline Notice Error · Card |
| 01.16 | Verify email · Default | Mesh Quiet | P1 | Nav Bar Inline, Button/Large Primary + Secondary | Illustration / Inbox |
| 01.17 | Verify email · Checking | Mesh Quiet | P2 | Button Loading | — |
| 01.18 | Verify email · Not verified yet | Mesh Quiet | P2 | — | Inline Notice Warning · Card |
| 01.47 | Verify email · Resending | Mesh Quiet | P2 | — | — (spinner from 978:304) |
| 01.19 | Verify email · Resent | Mesh Quiet | P2 | — | Inline Notice Success · Plain |
| 01.20 | Verify email · Resend failed | Mesh Quiet | P2 | — | Inline Notice Error · Plain |
| 01.21 | Log in · Default | Mesh Quiet | P1 | Nav Bar Inline, Text Field ×2 | — |
| 01.22 | Log in · Logging in | Mesh Quiet | P2 | Button Loading | — |
| 01.23 | Log in · Error | Mesh Quiet | P2 | Text Field Error | Inline Notice Error · Card |
| 01.24 | Reset password · Default | Mesh Quiet | P1 | Text Field Filled, Primary + Tertiary | — |
| 01.25 | Reset password · Sending | Mesh Quiet | P2 | Button Loading | — |
| 01.26 | Reset password · Sent (on Log in) | Mesh Quiet | P2 | 01.21 duplicate, Toast Success 1088:616 | — |
| 01.27 | Reset password · Error | Mesh Quiet | P2 | — | Inline Notice Error · Card |
| 01.28 | Choose role · Driver | Mesh Quiet | P1 | Nav Bar Inline (no leading), Button/Large | Step Progress, Choice Card ×2 |
| 01.29 | Choose role · Host selected | Mesh Quiet | P2 | — | Choice Card Selected |
| 01.48 | Choose role · Saving | Mesh Quiet | P2 | Button Loading | Choice Card Disabled |
| 01.30 | Choose role · Error | Mesh Quiet | P2 | — | Inline Notice Error · Plain |
| 01.31 | Add your vehicle? · Add it now | Mesh Quiet | P1 | Status Pill Neutral S | Choice Card, Inline Notice Info · Card |
| 01.32 | Add your vehicle? · Set up later | Mesh Quiet | P2 | — | — |
| 01.33 | Add vehicle · Empty | Mesh Quiet | P1 | Nav Bar Inline "Add vehicle", Text Field ×4, List Group Header, Connector Tile 1088:729 ×4 | Text Field Suffix (08) |
| 01.34 | Add vehicle · Filled (scrolled) | Mesh Quiet | P1 | Connector Tile 1088:737, List Row Toggle, Switch On | — |
| 01.35 | Add vehicle · Required errors | Mesh Quiet | P2 | Text Field Error, Toast Error 1088:626 | Connector Tile · Error (08) |
| 01.36 | Add vehicle · Saving | Mesh Quiet | P2 | Button Loading | Connector Tile · Disabled (08) |
| 01.37 | Location · Default | Mesh Quiet | P1 | Map Pin ×3, User Location, Chip | Illustration / Map Card (Route) |
| 01.38 | Location · iOS prompt | Mesh Quiet + system dim | P3 | — | iOS / Permission Alert (Location) |
| 01.39 | Notifications · Default | Mesh Quiet | P1 | Brand / App Icon | Notification Preview ×2, Illustration / Lock Screen |
| 01.40 | Notifications · iOS prompt | Mesh Quiet + system dim | P3 | — | iOS / Permission Alert (Notifications) |
| 01.41 | All set · With vehicle | Mesh Celebrate | P1 | Chip Fill/No ×3 | Success Mark, Confetti, Button On Mesh + On Mesh Plain |
| 01.42 | All set · No vehicle | Mesh Celebrate | P2 | Chip ×1 | — |
| 01.43 | Role switch · Become a driver | Mesh Quiet | P2 | Nav Bar Inline, Icon Button Tinted, Button/Large | — |
| 01.44 | Role switch · Add your vehicle? | Mesh Quiet | P2 | — | Choice Card (no progress) |
| 01.45 / 01.46 | Link card · Home permission → 02.02, 02.04 | — (560 card, not a phone) | P2 | — | — |

**Section layout.** Four sections, 1A–1D (00-system §4), each closing with its own Logic check card that lists only its own proposals. Inside them, one row per screen with its states side by side (gap 80), in this order: Splash (01.01–02) · Story (01.03–06) · Sign in (01.07–10) · Create account (01.11–15) · Verify (01.16, 17, 18, 47, 19, 20) · Log in (01.21–23) · Reset (01.24–27) · Choose role (01.28, 29, 48, 30) · Add your vehicle? (01.31–32) · Add vehicle (01.33–36) · Location (01.37–38) · Notifications (01.39–40) · All set (01.41–42) · Role switch (01.43–44) · Link card (01.45/46). Each row: **Refs · Mobbin** card at the row's left (x 80), the phones to its right, the **Micro-interactions** card (§5, that screen's block) to the right of the last phone. One **Logic check** card (§10 + FLAG — PROPOSALS) closes the section. Frame numbers 01.47 and 01.48 were added in review and sit in their screen's row, so the row order above is the reading order, not the numeric order.

---

## 4. Frame-by-frame layout (top → bottom) and real copy

All quoted copy is verbatim from the logic map unless it is marked **[PROPOSAL Pn]** (or **[Pn]**).

### 01.01 · Splash · Launch (P1)
- Mesh Quiet; status bar Dark; home indicator Dark.
- `Brand / Mark / PakPlug P` Style=Mesh 1082:123, **rescale** to 96 (never resize), centred at (153,389).
- Nothing else. This frame equals the iOS static LaunchScreen and must match Flutter's first frame pixel for pixel (no flash).
- Real copy: none. VO label "PakPlug".

### 01.02 · Splash · Loading (P1)
- `Brand / Wordmark` Emerald 994:122 (Mesh P + SF Pro "akplug"), rescaled to 236 wide, centred at y≈395. Its P sits exactly where 01.01's P was; this is the morph target [P14].
- Tagline (Body, `text/secondary`, centred) 16 below: **"Charge Your Journey"**.
- Spinner at (189,752), 24pt: copy the spinner frame inside `Button / Large` Primary Loading (978:304) and recolour it to `icon/secondary`. Annotate "appears only after 1.5 s" [P14] (the code always shows it).
- Canvas note beside the frame (Caption 1, `text/tertiary`): "After 1.5 s → /onboarding (not seen) · auth check (10 s timeout) → /driver-home, host or admin home, or /login · 12 s safety → /login".

### 01.03 · Story · 1 PakPlug (P1)
- Mesh Quiet. There is no Skip on slide 1 (logic). Keep the Skip node at opacity 0 and hidden from hit testing so the layout doesn't jump.
- Wordmark Emerald 994:122, same position as 01.02 (continuity).
- Subtitle (Body `text/secondary`, centred, width 300) 16 below: **"Community charging for Pakistan's EVs"**.
- Page Control (new) Current=1, centred at y 736.
- `Button / Large` Primary Default 978:277 at (16,772), label **"Next"**.
- Real copy: "PakPlug" (rendered as the wordmark; VO reads "PakPlug"), "Community charging for Pakistan's EVs", "Next".

### 01.04 · Story · 2 Charge anywhere (P1)
- Top right: `Button / Medium` Tertiary Default 978:488, label **"Skip"**, hugging, right edge at x 386, y 54.
- **Illustration / Map Card** (variant Prices), 370×400 at (16,108), radius 28 (`radius/xl`), Frost/Elevated, clip content. Inside:
  - Map image fill (fills copied from 996:430).
  - `User Location` 974:264 near the bottom left.
  - `Map Pin` Available selected 974:238, Price "Rs 42", centre (GreenVolt).
  - Map Pin Available 974:223, "Rs 38", top right (Model Town).
  - Map Pin In use 974:228, "Rs 68", lower left (Gulberg Galleria).
  - `Map Cluster` Small 974:259, top left.
  - `Chip` Glass/Yes 970:153, Label **"Rs 42/kWh"** (real chip copy), Leading icon bolt 958:32, floating 8 above the selected pin.
  - `Station Card` Map preview 982:287, **rescaled** 0.86, docked inside the card bottom (inset 12), showing GreenVolt · DHA Phase 5 · 4.8★ · Rs 42/kWh · Available (brief dummy data).
- Title (Large Title, centred, width 338) at y 532: **"Charge anywhere"**.
- Body (Body `text/secondary`, centred, width 338) 8 below (3 lines): **"Private chargers all around you — clear Rs/kWh pricing, rated by drivers like you."**
- Page Control Current=2 at y 736; Button "Next" at (16,772).

### 01.05 · Story · 3 Plug in. Watch it live. (P1)
- Skip as in 01.04.
- Illustration card 370×400 at (16,108), radius 28, clip content, Frost/Elevated. Fill = a `Background / Mesh Hero` 951:7416 instance at 402×874 placed at (−16,−108) inside the card, so the card shows the mesh's deep region below the glow. Inside:
  - `Charging Gauge` Charging 987:392, **rescaled** to 200, centred, top 24. Value **"68%"**.
  - `Status Pill` Live M 980:341, label **"Charging · 22 kW"**, centred, 12 under the gauge.
  - Two `Stat Tile` 986:446 side by side (gap 12), inset 16, bottom inset 16, fill overridden to `bg/frostStrong`: (Value **"Rs 385"**, Label **"so far"**) and (Value **"80%"**, Label **"by 6:40 PM"**). Values in Display/S (SF Pro Light).
  - Contrast: the tiles are Frost Strong (4.6:1 ✓). The gauge sits on the deep region, so its centre value must be `text/onMesh`; override it if the component resolves to `text/primary`. Verify with `node.screenshot`.
- Title (Large Title, centred, 2 lines) at y 532: **"Plug in. Watch it live."**
- Body (Body `text/secondary`, centred): **"Scan the station QR to start — then track battery, speed and cost in real time."**
- Page Control Current=3; Button "Next".
- **[PROPOSAL P4]** in the FLAG card only: show "≈68% est." to match the live-session estimate language. The frame keeps the real copy.

### 01.06 · Story · 4 Earn from your charger (P1)
- No Skip (logic: last slide).
- Illustration card 370×400 Frost Strong, radius 28, at (16,108):
  - `Icon Button` Tinted M 979:289, Icon ev.charger.fill 1024:480, **rescaled** ×1.6, centred at top 72.
  - `Hero Stat` XL Center 986:425: Value **"+ Rs 1,240"** (Display/XL Light), Caption **"this week"**, Show detail = false.
- Title (Large Title, centred) at y 532: **"Earn from your charger"**. Body: **"Share it while you're parked elsewhere. You set the price and the hours."**
- Page Control Current=4; Button label **"Get started"**.

### 01.07 · Sign in · Default (P1)
- No Nav Bar, no back (root of `/login`).
- P Mark Mesh 1082:123 rescaled to 64, centred at y 150.
- Title (Large Title, centred, width 320, 2 lines) at y 238: **"Let's get you charging"**.
- Subtitle (Body `text/secondary`, centred) 8 below: **"Sign in or create your account — it takes a minute."**
- Quiet mesh negative space (no hero art). This is mymind-style calm.
- Footnote `text/secondary`, centred, at y 520: **"New here? Your account is created automatically."** (08.15 positions its Toast relative to this line; keep it at 520.)
- Auth Button stack (new), 370×52, gap 12, from y 548:
  1. Provider=Apple **"Continue with Apple"**
  2. Provider=Google **"Continue with Google"**
  3. Provider=Email **"Continue with email"**
  - **[PROPOSAL P1]** order is Apple → Google → Email. The code lists email first.
- Text link at y 744 (44 hit area): **"Already have an account? Log in"** ("Log in" in brand).
- Legal (Caption 1 `text/secondary`, centred, width 320) at y 792: **"By continuing you agree to our Terms & Privacy Policy"** ("Terms & Privacy Policy" in Caption 1 Emph `text/brand`).
- Canvas note: "Returning social user → straight to Home (no Choose role)".

### 01.08 · Sign in · Apple loading (P2)
- 01.07 duplicate. Apple button = State Loading (white spinner, label hidden); Google and Email = State Disabled. Link and legal lines at 40% opacity (not tappable).

### 01.09 · Sign in · Error (P2)
- 01.07 duplicate. All buttons are back to Default.
- Inline Notice Tone=Error, Style=Plain, centred, width 338, at y 488 (above the "New here?" footnote, so the button stack, link and legal never move). Icon exclamationmark.triangle.fill 1025:474 in `icon/error`, text Footnote `text/error`.
- Copy: **[PROPOSAL P5]** "Couldn't sign in with Google. Try again." (The logic only says "inline error text".)

### 01.10 · Sign in · Apple sheet (P3, system UI)
- 01.07 behind the system dim (black 20%, OS-owned).
- iOS / Apple ID Sheet (system mock): iOS 27 Liquid Glass sheet, radius 38. Title "Sign in with Apple", ✕; app icon `Brand / App Icon` Default 992:82 at 44.
- "Create an account for PakPlug using your Apple Account."
- Rows: Name "Ayesha Khan"; Share My Email "ayesha.khan@email.com"; Hide My Email "Forward to: ayesha.khan@email.com" (selected).
- Button "Continue".
- Label the frame "System UI · reference". This sets up the private-relay note on Edit profile (08).

### 01.11 · Create account · Empty (P1)
- `Nav Bar` Inline at (0,54), Title "" , Leading on.
- Title (16,122): **"Create your account"**. Subtitle (16,171): **"Book and charge at any PakPlug station."**
- Text Fields (Default 1070:510, Show label = on, Show message = off, no leading icons), 370 wide, pitch 88, from y 225:
  1. (16,225) Label **"Full name"**, Placeholder "Your name" (hint reused from Edit profile, §I)
  2. (16,313) Label **"Email"**, Placeholder "you@email.com" (Edit profile hint)
  3. (16,401) Label **"Phone number (optional)"**, Placeholder "03XXXXXXXXX" (Edit profile hint)
  4. (16,489) Label **"Password"**, no placeholder; trailing text button **"Show"** (Subheadline Emph `text/brand`, 44×44 hit area) **[PROPOSAL P16]** (an `eye` glyph is wanted but missing).
- Requirement Row (new) State=Unmet at (16,573): **"At least 6 characters"**.
- `Button / Large` Primary Default at (16,712): **"Create account"**.
- Text-link row at (16,772): **"Already have an account? Log in"**.

### 01.12 · Create account · Typing (P2)
- Content scrolled 124pt. The Nav Bar shows Title#1087:0 **"Create your account"** with the scroll edge (Frost Strong + hairline).
- Full name Filled "Ayesha Khan" at y 101 (its top runs under the bar); Email Filled "ayesha.khan@email.com" (189); Phone Filled "0301 2345678" (277); Password **Focused** 1070:526 at 365, value "••••••••", trailing "Show".
- Requirement Row State=Met at (16,449) (`checkmark.circle.fill` 1025:506 in `status/available`).
- `iOS / Keyboard` Layout=Default at (0,538) with the QuickType bar showing "Use Strong Password" (system). Button "Create account" at (16,478).

### 01.13 · Create account · Errors after first submit (P2)
- 01.11 with: Full name Error 1070:558 at 225, message **[P5]** "Full name is required"; Email Error at 335, Value "ayesha.khan@email", message **[P5]** "Enter a valid email address" (08.25 reuses both strings); Phone Default at 445 (optional); Password Error at 533 with Value empty and **Show message off** (the rule row carries the message, so it isn't printed twice); Requirement Row State=Error at (16,617) **"At least 6 characters"**.
- Fields grow by the message height (22); the CTA stays at 712.

### 01.14 · Create account · Creating (P2)
- 01.12's values with the keyboard down (positions as 01.11); every field Disabled 1070:574; Button Loading 978:298; Nav Bar back at 40%; text link 40%.

### 01.15 · Create account · API error (P2)
- 01.14's values, fields re-enabled (Filled). Inline Notice Tone=Error, Style=Card, 370 wide, at (16,636) (bottom edge 700, 12 above the CTA).
- Copy **[P5]** "An account with this email already exists. Log in instead." (The logic only says "inline error message for API failures".)

### 01.16 · Verify email · Default (P1)
- `Nav Bar` Inline, Title "", Leading on (pops to Create account).
- Illustration / Inbox (new) 160×120, centred, top 176: a Frost Strong envelope with a Mesh-P wax seal (P Mark Mesh 40).
- Title (Large Title, centred) at y 320: **"Check your inbox"**.
- Body (Body `text/secondary`, centred) 8 below: **"We sent a verification link to"**; next line Headline `text/primary`: **"ayesha.khan@email.com"** (the `{email}` token).
- Link row (44 tall) at y 437: **"Didn't get it? Resend"** ("Resend" in brand).
- `Button / Large` Primary at (16,712): **"I've verified — Continue"**.
- `Button / Large` Secondary at (16,772): **[PROPOSAL P2]** "Open Mail".

### 01.17 · Verify email · Checking (P2)
- Primary = Loading 978:298; Secondary Disabled; link row at 40%.

### 01.18 · Verify email · Not verified yet (P2)
- 01.16 + Inline Notice Tone=Warning, Style=Card, 370 wide at (16,497): **"Not verified yet — tap the link in the email we sent you."**

### 01.47 · Verify email · Resending (P2, added in review)
- 01.16 with the link line replaced (same 44 row, centred) by a 12pt spinner (from 978:304, `icon/secondary`) + Subheadline `text/secondary` **"Resending…"** (real). Not tappable. Primary and Secondary stay enabled.

### 01.19 · Verify email · Resent (P2)
- The link row becomes Inline Notice Tone=Success, Style=Plain: **"Verification email resent."**
- **[P3]** Below it (8), Footnote `text/tertiary`: "Resend in 0:30" (cooldown; digits in tabular figures).

### 01.20 · Verify email · Resend failed (P2)
- The link row stays: **"Didn't get it? Resend"**, active. Above it (8), Inline Notice Tone=Error, Style=Plain: **"Couldn't resend — try again in a moment."**

### 01.21 · Log in · Default (P1)
- `Nav Bar` Inline, Title "", Leading on. Title (16,122): **"Welcome back"**. Subtitle (16,171): **"Log in to your PakPlug account."**
- Text Field Email (Label "Email", Placeholder "you@email.com") at (16,225); Password (Label "Password", trailing "Show" [P16]) at (16,313).
- Right-aligned link at y 397 (Subheadline Emph `text/brand`, 44 hit area): **"Forgot password?"**.
- Button Primary at (16,712): **"Log in"**.
- Text-link row at (16,772): **"Don't have an account? Sign up"**.

### 01.22 · Log in · Logging in (P2)
- Email Filled "ayesha.khan@email.com"; Password Filled "••••••••"; both Disabled; Button Loading; links 40%.

### 01.23 · Log in · Error (P2)
- Email Filled; Password **Error**, Value empty (cleared), Show message off, focused-error stroke.
- Inline Notice Error, Style=Card, at (16,636) (bottom edge 700, 12 above the CTA): **[P5]** "That email and password don't match. Try again or reset your password."

### 01.24 · Reset password · Default (P1)
- `Nav Bar` Inline, Title "", Leading on. Title (16,122): **"Reset password"**. Subtitle (16,171, 3 lines): **"Enter the email for your account. If it is registered, we will send reset instructions."**
- Text Field Filled 1070:542 at (16,269), Label "Email", Value "ayesha.khan@email.com" (prefilled from Log in, per the logic).
- Primary at (16,712): **"Send reset link"**. Tertiary 978:337 at (16,772): **"Back to login"**.

### 01.25 · Reset password · Sending (P2)
- Primary Loading; field Disabled; Tertiary Disabled 978:351.

### 01.26 · Reset password · Sent (P2)
- Duplicate of 01.21 with Email Filled (the screen popped back to Log in).
- `Toast` Success 1088:616, 2 lines, at (16,628) (bottom edge 700, 12 above "Log in"), Action off: **"If an account exists for that email, you will receive password reset instructions shortly."**

### 01.27 · Reset password · Error (P2)
- 01.24 + Inline Notice Error, Style=Card, at (16,357) (12 under the field): **[P5]** "Couldn't send the link. Check your connection and try again."
- The logic also fires a snackbar; the design shows only the inline message **[P13]**.

### 01.28 · Choose role · Driver (P1)
- `Nav Bar` Inline with **Leading off** (no back: the account already exists; edge 4), Title "". Step Progress Step=1 at (72,78).
- Eyebrow **"STEP 1 OF 3"**. Title (16,146, 2 lines): **"How will you use PakPlug?"** Subtitle: **"Pick one to start — you can add the other anytime."**
- Choice Card (new) ×2, 370 wide, gap 12, from y 312:
  1. State=Selected, Icon bolt.car 1025:500, Title **"Drive & charge"**, Description **"Find, book and start charging sessions near you"**
  2. State=Default, Icon ev.charger 1024:478, Title **"Host & earn"**, Description **"List your charger, set your price and hours"**
- Button Primary at (16,772): **"Continue as driver"**.

### 01.29 · Choose role · Host selected (P2)
- Card 2 is Selected and card 1 Default. CTA **[PROPOSAL P11]** "Continue as host". Canvas note: "→ host flow (out of scope)".

### 01.48 · Choose role · Saving (P2, added in review)
- 01.28 with both cards State=Disabled (content 60%), Button Loading 978:298 **[P18]** (the logic names only the inline error, which implies a request).

### 01.30 · Choose role · Error (P2)
- Driver selected; Inline Notice Error, Style=Plain, under the cards at y 532: **[P5]** "Couldn't save your choice. Try again." Button back to Default.

### 01.31 · Add your vehicle? · Add it now (P1)
- `Nav Bar` Inline, Leading on (pops to Choose role). Step Progress Step=2. Eyebrow **"STEP 2 OF 3"**.
- Title (16,146): **"Add your vehicle?"** Subtitle: **"Saving your car makes booking faster — you can always add it later from your profile."**
- Choice Cards from y 293:
  1. Selected, Icon car.fill 1024:474, Title **"Add it now"**, Show badge on = `Status Pill` Neutral S 980:332 **"1 min"**, Description **"Brand, model, connector type — under a minute."**
  2. Default, Icon clock 958:88, Title **"Set up later"**, Description **"Add your car from Profile whenever you're ready."**
- Inline Notice Tone=Info, Style=Card (`bg/tint`), icon info.circle 1025:472, 16 under the cards: **"We'll only show you chargers that fit your car's connector type."**
- Button Primary at (16,772): **"Add my vehicle"**.

### 01.32 · Add your vehicle? · Set up later (P2)
- Card 2 Selected. CTA **"Continue"**.

### 01.33 · Add vehicle · Empty (P1)
Same screen and coordinates as 08.39 (this flow owns the onboarding variant, which receives a `VehicleFormDraft`; build once here, 08 duplicates with MG ZS EV values).
- `Nav Bar` Inline, Title#1087:0 **"Add vehicle"**, Leading on (back keeps the draft). No Step Progress (shared screen).
- Text Field Default (16,122) Label "Brand", Placeholder **"e.g., Tesla"**; (16,210) Label "Model", Placeholder **"e.g., Atto 3, Model 3"**.
- `List Group Header` 983:389 Label **"CONNECTOR TYPE"** at (16,306).
- `Connector Tile` Selected=No 1088:729 ×4, 177×112, gap 16:
  - (16,338) **"Type 2"** / **"AC · common"**, Plug ev.plug.ac.type.2 981:294
  - (209,338) **"CCS 2"** / **"DC · fast"**, ev.plug.dc.ccs2 1024:482
  - (16,466) **"Type 1"** / **"AC"** (wanted `ev.plug.ac.type.1`; temporary 981:294, FLAG)
  - (209,466) **"CHAdeMO"** / **"DC"** (wanted `ev.plug.dc.chademo`; temporary ev.plug.dc.gb.t 1024:484, FLAG)
- Text Field (16,602) Label "Battery (optional)", Placeholder **"e.g., 60 kWh"**, Suffix "kWh" (Text Field Suffix prop from 08), Helper **[P8]** "Used to estimate charge % and cost."
- Text Field (16,710) Label "Plate (optional)", Placeholder **"e.g., LES-1234"** (runs under the footer).
- Sticky footer from 756; Button Primary at (16,772): **"Save vehicle"**.

### 01.34 · Add vehicle · Filled, scrolled to bottom (P1)
- Scroll offset 236; the Nav Bar shows its scroll edge (Brand "BYD" and Model "Atto 3" are scrolled under it).
- Tiles at y 122/250: Type 2 **Selected=Yes** 1088:737, CCS 2 **Yes**, Type 1 No, CHAdeMO No.
- Battery Filled "60.5" + suffix "kWh" at (16,386); Plate Filled "LEB-2481" at (16,474).
- Frost Strong group (`bg/frostStrong` + Frost/Card, radius 22) at (16,570) holding `List Row` Toggle 983:364, title **"Set as primary vehicle"**, Icon off, Switch On/Enabled 983:330 (first car → primary).
- Button "Save vehicle" Default at (16,772).

### 01.35 · Add vehicle · Required errors (P2)
- 01.33 after "Save vehicle" with nothing filled: Brand Error **"Car brand is required"**; Model Error **"Car model is required"** (fields grow; header moves to 346, tiles to 378/506); all 4 tiles **Selected=Error** (08's variant, 1.5pt `stroke/error`, captured mid-flash).
- `Toast` Error 1088:626 at (16,704): **"Select at least one connector type"**.
- The battery range error ("Enter a battery size between 1 and 1000 kWh") is framed once in 08.43; not repeated here.

### 01.36 · Add vehicle · Saving (P2)
- 01.34 with every field Disabled, tiles Disabled (content 40%), Switch On/Disabled 983:332, Button Loading 978:298, back 40%.
- Canvas note: "success → Toast Success **'Vehicle added successfully!'** (root overlay, rides over the transition and lands at y 644 on Location) → Location. Failure → Toast Error 'Error: …' (frame 08.46)."

### 01.37 · Location · Default (P1)
- `Nav Bar` Inline, Leading on. Step Progress Step=3a (third segment half filled) [P7]. Eyebrow **"STEP 3 OF 3"**.
- Title (16,146, 2 lines): **"Find chargers near you"**.
- Body (3 lines): **"Your location helps us show stations nearby and guide you there. Prefer not to? Browse any area in Limited Mode."**
- **Illustration / Map Card** (variant Route) 370×292 at (16,324), radius 28. It contains Map, User Location, Map Pin Available selected "Rs 42" with a dashed emerald route line (3pt, `action/primary`, dash 6/6, round caps) from the user to the pin, Map Pin Available "Rs 38", Map Pin In use "Rs 68", and Chip Glass/No 970:142 "1.2 km" beside the route midpoint (dummy story distance to GreenVolt).
  - Presentation change from the coded "dark green screen" **[P15]**.
- Primary at (16,712): **"Allow location"**. Tertiary at (16,772): **"Not now"**.

### 01.38 · Location · iOS prompt (P3, system UI)
- 01.37 behind the system dim (black 20%, OS-owned). iOS / Permission Alert Kind=Location, centred:
  - Title "Allow “PakPlug” to use your location?"
  - Purpose string **[P6]**: "PakPlug uses your location to center the map on you, show how far each charger is, and guide you there."
  - Map preview with "Precise: On".
  - Buttons stacked: "Allow Once" · "Allow While Using App" · "Don't Allow".
- This mock is reused by 02.03 (do not build a second one).

### 01.39 · Notifications · Default (P1)
- `Nav Bar` Inline, Leading on. Step Progress Step=3b (full) [P7]. Eyebrow **"STEP 3 OF 3"**.
- Title (16,146): **"Never miss a charge"**. Body: **"Booking confirmations, session updates, and a ping when your car hits 80%. The stuff that matters — nothing else."**
- **Illustration / Lock Screen** 370×292 at (16,324), radius 28, clip content; fill = a Mesh Hero instance 402×874 at (−16,−324) (deep region; no text sits on it). At the top centre, a black Dynamic Island capsule 126×37. Two **Notification Preview** (new) Style=Lock screen cards, 338 wide, gap 8, from y 72 inside the card:
  1. App icon 992:82 at 38; title **"Booking confirmed 🎉"**; body **"GreenVolt Charger · DHA Phase 5, tomorrow 6:00 PM"**; time "now" [P5].
  2. Title **"Charged to 80% ⚡"**; body **"Rs 385 · 14.2 kWh — you're good to go"**; time "1h ago" [P5].
  - The cards are Frost Strong with `text/primary` titles and `text/secondary` bodies (4.6:1 ✓).
- Primary at (16,712): **"Turn on notifications"**. Tertiary at (16,772): **"Maybe later"**.

### 01.40 · Notifications · iOS prompt (P3, system UI)
- iOS / Permission Alert Kind=Notifications: "“PakPlug” Would Like to Send You Notifications" / "Notifications may include alerts, sounds, and icon badges. These can be configured in Settings." / "Don't Allow" | "Allow".

### 01.41 · All set · With vehicle (P1)
- Mesh Celebrate; status bar Dark; home indicator Light. Layout follows the Celebrate rule in §2 (same grammar as 06's Charge complete).
- Confetti (new) Density=Burst layer 402×560 at (0,0), behind the content.
- Success Mark (new) Size=L, Style=On mesh (88 white disc, brand check), at (157,100) (06.30 uses the same spot).
- Title (Large Title, **`text/primary`**, centred, width 340, 2 lines) at y 208: **"You're all set, Ayesha!"** (`{first name}`). It sits inside the glow.
- **Recap card** at (16,306), 370 wide, hug height (≈132), `bg/frostStrong` + Frost/Card, radius 28, padding 20, gap 16, centred content:
  - Body (Body `text/primary`, centred, width 330): **"Your BYD Atto 3 is ready. Let's find its first charger."** (`{vehicle}` = "BYD Atto 3").
  - Recap pills row, centred, gap 8, wraps: `Chip` Fill/No 970:164 (default `bg/fill`, label `text/primary`): "Driver" (person.fill 966:11) · "BYD Atto 3" (car.fill 1024:474) · "Type 2 · CCS 2" (ev.plug.ac.type.2 981:294).
- Button / Large **Type=On Mesh** (new type) at (16,712): **"Find my first charger"**.
- Button / Large **Type=On Mesh Plain** (new type) at (16,772): **"Explore the app first"**.
- Canvas note: both buttons go to `/driver-home` (identical in the code) **[P10]**. Builder: screenshot and measure the title over the glow (§2).

### 01.42 · All set · No vehicle (P2)
- Recap card body: **"Let's find your first charger."** Recap pills: "Driver" only. Card hugs (≈100).

### 01.43 · Role switch · Become a driver (P2)
- `Nav Bar` Inline, Leading on (back cancels the role switch). No progress.
- `Icon Button` Tinted M 979:289 with bolt.car 1025:500, **rescaled** to 72, at (16,122).
- Title (16,218): **"Become a driver"**.
- Body (Body `text/secondary`): **"This is your first time switching to Driver — add your vehicle first to get verified. Same quick step every driver goes through."**
- Primary at (16,772): **"Continue"**.

### 01.44 · Role switch · Add your vehicle? (P2)
- 01.31 with **no Step Progress and no eyebrow** (hidden in role-switch mode). The title moves to (16,122) and everything below moves up 24. Next = All set.

### 01.45 / 01.46 · Link card · Home permission (P2)
- Not phone frames. Flow 02 owns the canonical Home permission frames (02.02 "Allow location access?" sheet, 02.03 iOS prompt, 02.04 "Location access" alert, 02.05 services off). Here, a 560-wide card in the standard card style: header "CONTINUES IN FLOW 02" (Footnote Emph), two rows "02.02 · Home · Allow location" and "02.04 · Home · Location access off" (Subheadline Emph) each with a Footnote `text/secondary` line "Shown when location was refused here and Home starts (logic §B)" and a hyperlink (Footnote `text/brand`) to the 02 frame once it exists. Copy completions stay shared: [P6] = 02's [P17].

---

## 5. Micro-interactions

Format: trigger → response · timing/easing · haptic · VoiceOver · Reduce Motion (RM). Tokens are §2.1. One Micro-interactions card per screen row carries that screen's block.

### Splash (01.01–01.02)
1. Cold launch → static LaunchScreen (01.01), identical to Flutter's first frame · 0 ms · none · VO "PakPlug" (image) · RM same.
2. First frame +200 ms → the P settles (scale 0.94→1) and the Quiet mesh starts an 8 s drift loop · `smooth` · none · — · RM and Low Power: no scale, static mesh.
3. +400 ms → the P slides left into lockup position while "akplug" reveals left→right with a mask wipe, becoming the Wordmark [P14] · 520 ms ease-out (.22,1,.36,1) · none · VO label stays "PakPlug" · RM `fade.std` cross-fade P → wordmark.
4. +700 ms → "Charge Your Journey" enters · M-rise · none · the splash is one VO group "PakPlug, Charge Your Journey" · RM `fade.quick`.
5. Routing still pending at 1.5 s → spinner fades in [P14] · `fade.std` · none · VO announcement "Loading" only after 3 s (no chatter on fast launches) · RM same.
6. Route = Story → no cut: the wordmark stays; the tagline cross-fades to "Community charging for Pakistan's EVs"; Page Control and Next enter · `fade.std` + M-rise (stagger 40) · none · VO focus moves to slide 1 · RM cross-fade.
7. Route = Sign in → the wordmark shrinks into Sign-in's 64pt P (matched geometry); everything else cross-dissolves · `smooth` (~450 ms) + `fade.std` · none · VO focus on "Let's get you charging" (heading) · RM cross-fade.
8. Route = Home (valid session) → M-replace; the tab bar rises (M-rise, +150 ms) · none · VO focus on the Home search field · RM fade.
9. 10 s auth timeout or 12 s safety timer → Sign in silently (logic) · as 7 · none · as 7 · as 7.

### Story (01.03–01.06)
1. Horizontal swipe → interactive paging that follows the finger; release settles, a flick > 300 pt/s turns the page · `smooth` · selection on each settled page change · VO: three-finger swipe pages; each slide is one container ("Slide 2 of 4. Charge anywhere. …") · RM `fade.quick` page cross-fade, no slide.
2. Parallax → the illustration card moves at 0.7× scroll, text at 1× · tied to scroll · none · — · RM off (both 1×).
3. Page Control → the active capsule stretches 8→24 and travels between dots in step with the scroll · linear to scroll · none · VO adjustable "Page 2 of 4", swipe up/down to change · RM capsule jumps at settle.
4. Tap "Next" → M-press, then a programmatic page to the next slide · `smooth` (~420 ms) · light on tap (no second haptic on settle) · VO "Next, button" · RM cross-fade.
5. Tap "Skip" (slides 2–3 only) → scrolls to slide 4 (logic: jumps to the last slide, not to Sign in) · `smooth` (~450 ms) · light · VO "Skip, button", hint "Goes to the last slide" · RM cross-fade.
6. Skip visibility → opacity follows scroll (1 on slides 2–3, 0 on 1 and 4); hit testing off below 0.5 · tied to scroll · — · hidden from VO at 0 · RM instant at settle.
7. Arrive on slide 4 → the button label cross-fades "Next" → "Get started"; width fixed · `fade.quick` · none · VO label updates, focus stays · RM same.
8. Slide 2 becomes ≥50% visible → pins pop in (y −16→0, scale 0.6→1, 60 ms stagger, the selected Rs 42 pin last); the "Rs 42/kWh" chip pops at +300 ms; the station card rises 24pt. Plays once per visit (replays only after the slide left the screen fully) · `bouncy` (pins, chip) + `smooth` (card) · none · VO one image **[P5]** "Map of private chargers nearby, from Rs 42 per kWh. GreenVolt, DHA Phase 5, rated 4.8" · RM final state with `fade.quick`.
9. Slide 3 enters → the gauge arc sweeps 0→68% while the value counts up; the Live pill dot pulses (opacity 1→0.4, 1.2 s loop); "Rs 385" rolls in once · `sweep` (~900 ms) + M-count + `roll` · none · VO one image "Charging at 22 kilowatts, 68 percent, Rs 385 so far, 80 percent by 6:40 PM" · RM static final values, no pulse.
10. Slide 4 enters → "+ Rs 1,240" counts up; the charger icon scales 0.8→1 · M-count + `bouncy` · none · VO "Plus Rs 1,240 this week" · RM static.
11. Tap "Get started" → marks onboarding seen (logic) → Sign in; its content M-rises · M-replace · light · VO focus on the Sign-in title · RM fade.

### Sign in (01.07–01.10)
1. Appear → P, title, subtitle, footnote and button stack enter in sequence · M-rise (stagger 40) · none · VO focus on "Let's get you charging" (heading) · RM fade.
2. Auth Button press → Pressed variant (Apple #1C1C1E, Google `bg/fill`, Email `action/primaryPressed` tint) · M-press · none on press · — · RM no scale.
3. "Continue with Apple" → native ASAuthorization sheet (01.10); our Apple button → Loading, Google and Email → Disabled, links 40% (01.08) · `fade.quick` · light on tap · VO announcement "Signing in with Apple" · RM same.
4. "Continue with Google" → system web-auth sheet (ASWebAuthenticationSession); loading as 3 on the Google button · `fade.quick` · light · VO "Signing in with Google" · RM same.
5. Apple / Google cancelled by the user → buttons and links restore, no message · `fade.quick` · none · VO focus returns to the tapped button · RM same.
6. Social success, new user → push Choose role · M-push · none · VO focus on "STEP 1 OF 3" progress, then the title · RM fade. Returning user → Home with the tab bar rising (+150 ms) · M-replace + M-rise · none · VO focus on the Home search field · RM fade.
7. Social failure → buttons restore; Inline Notice Error Plain fades in above "New here?" (01.09), nothing else moves · `fade.std` + y +4→0 · error · VO announces the message (assertive) · RM fade. The notice clears on the next auth tap (`fade.quick`).
8. "Continue with email" → push Create account · M-push · light · VO "Continue with email, button" · RM fade.
9. "Already have an account? Log in" → push Log in · M-push · none (text link) · VO one link "Already have an account? Log in" · RM fade.
10. "Terms & Privacy Policy" → push PrivacyPolicyScreen (logic) · M-push · none · VO "Terms and Privacy Policy, link" · RM fade.

### Create account (01.11–01.15)
1. Push lands → Full name auto-focuses and the keyboard rises 250 ms later (not for VoiceOver users: their focus goes to the title) · system keyboard curve · none · VO focus on "Create your account" (heading) · RM same.
2. Field focus → Focused variant (2pt `stroke/focus`); the CTA rides the keyboard (keyboardLayoutGuide) to y 478 · `fade.quick` + keyboard curve · none · VO reads label, value and hint ("Phone number, optional, text field, 03XXXXXXXXX") · RM same (system).
3. Scroll → the large title slides under the bar and the Nav Bar title "Create your account" + scroll edge fade in (01.12) · native, `fade.quick` · none · — · RM native.
4. Return key → next field (Name → Email → Phone → Password); Password return = "Go" (submit) · instant · none · VO "Next" / "Go" · —.
5. Input traits → name `.name`, words autocap; email `.emailAddress` + `.username`, no autocorrect; phone `.phonePad` + `.telephoneNumber`; password `.newPassword` (iOS offers "Use Strong Password"). No live formatting (the logic has none) · — · — · — · —.
6. Password crosses 6 characters → Requirement icon morphs from the empty circle (`icon/tertiary`) to `checkmark.circle.fill` (`status/available`), scale 0.6→1; dropping below reverses · `bouncy` (in) / `snappy` (out) · selection, once per crossing · VO value "At least 6 characters, met" / "not met", announced politely on change · RM colour swap only.
7. "Show" / "Hide" [P16] → secure entry flips, the label cross-fades, caret and value stay · `fade.quick` · selection · VO "Show password, button" ↔ "Hide password, button" · RM same.
8. "Create account" with errors (first submit) → invalid fields switch to Error, each invalid field shakes, the form scrolls to the first invalid field and focuses it (01.13) · M-shake + `smooth` scroll · error · VO announces the first error ("Full name is required") · RM no shake, instant scroll.
9. After the first submit → each field re-validates on change; an error clears the moment the value is valid · `fade.quick` (message) + `smooth` (height) · none · VO announces "Error cleared" on blur only · RM fade.
10. Valid submit → keyboard dismisses; Button Loading; fields Disabled; back and link 40%; repeat taps ignored (01.14) · `fade.quick` · medium on tap · VO announcement "Creating account" · RM same.
11. Success → push Verify email · M-push · none · VO focus on "Check your inbox" · RM fade.
12. API failure → fields re-enable, button restores, Inline Notice Error Card grows in above the CTA (01.15) · M-grow · error · VO announces the message · RM fade.
13. "Already have an account? Log in" → **replace** the route with Log in (logic) · M-replace · none · VO one link · RM fade.

### Verify email (01.16–01.20, 01.47)
1. Appear → the envelope rises, then the Mesh-P seal "stamps" (scale 1.15→1) at +320 ms · M-rise then `bouncy` · light at the stamp · VO image "Email sent" · RM fade, no haptic.
2. "Open Mail" [P2] → opens Mail (`message://`), or an action sheet of the installed mail apps · system · light · VO "Open Mail, button" · RM —.
3. "I've verified — Continue" → Loading (01.17); Open Mail Disabled; Resend 40%; the user record reloads · `fade.quick` · medium on tap · VO announcement "Checking" · RM same.
   - Verified → push Choose role · M-push · **success** · VO focus on the step progress · RM fade.
   - Not verified → button restores; Inline Notice Warning Card grows in (01.18) and stays until the next Continue (then fades while loading) · M-grow · **warning** · VO announces "Not verified yet — tap the link in the email we sent you." · RM fade.
4. "Resend" → the line becomes the spinner + "Resending…" (01.47), not tappable · `fade.quick` · light · VO announcement "Resending" · RM same.
   - Success → Inline Notice Success Plain "Verification email resent." (01.19) + "Resend in 0:30" counting down each second [P3]; at 0:00 the row returns to "Didn't get it? Resend" · `fade.quick`, digits `roll` · success · VO announces once; the countdown is silent (updatesFrequently) · RM digits swap without roll.
   - Failure → Inline Notice Error Plain above the active link (01.20) · M-grow · error · VO announces · RM fade.
5. App returns to the foreground [P3] → automatic check (as 3, without the medium haptic). Verified → success + push; not verified → silent (no warning when the check was automatic) · as 3 · as listed · VO announces only on success ("Email verified") · RM fade.
6. Long-press the email line → iOS edit menu "Copy" · system · none · VO custom action "Copy email" · —.
7. Back / edge swipe → pop to Create account with values kept (edge 5) · M-push (pop) · none · VO focus on the Create account title · RM fade.

### Log in (01.21–01.23)
1. Push lands → Email auto-focuses (not for VO users); the QuickType bar offers saved Passwords (`.username` / `.password`); picking one fills both fields and moves focus to Log in · system · none · VO "Email, text field" · RM same.
2. "Show" / "Hide" [P16] → as Create account 7.
3. "Forgot password?" → push Reset password with the email prefilled (logic) · M-push · none (text link) · VO "Forgot password?, link" · RM fade.
4. "Log in" → keyboard dismisses; Loading (01.22); fields Disabled · `fade.quick` · medium on tap · VO announcement "Logging in" · RM same.
   - Success → role home; the tab bar rises (+150 ms) (no verify gate, logic) · M-replace + M-rise · none · VO focus on the Home search field · RM fade.
   - Failure → Inline Notice Error Card grows in above the CTA; the password field turns Error, shakes, is cleared and refocused (keyboard returns) (01.23) · M-grow + M-shake · error · VO announces the message · RM no shake. The card clears when either field is edited (`fade.quick`).
5. "Don't have an account? Sign up" → replace with Create account (logic) · M-replace · none · VO one link · RM fade.

### Reset password (01.24–01.27)
1. Appear → email prefilled (logic), keyboard not raised, CTA enabled · — · none · VO reads "Email, ayesha.khan@email.com" · —.
2. Tap the field → Focused + system clear button · `fade.quick` · none · VO "Clear text, button" available · RM same.
3. "Send reset link" → Loading (01.25); field and "Back to login" Disabled · `fade.quick` · medium on tap · VO announcement "Sending" · RM same.
   - Success → pop to Log in; 250 ms after the pop lands, Toast Success (01.26) rises and stays 6 s (2 lines) · M-push (pop) + Toast motion · success · VO announces the toast politely; focus stays on Log in · RM fade.
   - Failure → Inline Notice Error Card grows in under the field (01.27); the button restores; no snackbar [P13] · M-grow · error · VO announces · RM fade.
4. "Back to login" → replace the route with Sign in `/login` (logic: not 4b) · M-replace · light · VO "Back to login, button" · RM fade.

### Choose role (01.28–01.30, 01.48)
1. Appear → Step Progress segment 1 fills 0→100%; cards enter · 400 ms ease-out (.22,1,.36,1) + M-rise (stagger 40) · none · VO "Step 1 of 3" (progress element with value), then the heading · RM instant fill, fade.
2. Card press → Pressed (fill `bg/fill`, scale 0.98) · M-press · none · — · RM no scale.
3. Card select → Selected: stroke 1→2pt `action/primary`, fill → `bg/surface`, the radio becomes `checkmark.circle.fill`; the other card deselects at the same time · M-select · selection · VO radio-group semantics "Drive and charge, Find, book and start charging sessions near you, selected, 1 of 2" · RM no scale.
4. CTA label follows the selection ("Continue as driver" ↔ "Continue as host" [P11]); width fixed · `fade.quick` · none · VO label updates · RM same.
5. Continue → Loading (01.48) [P18]; cards Disabled · `fade.quick` · medium on tap · VO announcement "Saving" · RM same.
   - Driver success → push Add your vehicle? · M-push · none · VO focus on "Step 2 of 3" · RM fade. Host → host flow (out of scope).
   - Failure → button restores; Inline Notice Error Plain fades in under the cards (01.30) · M-grow · error · VO announces · RM fade.
6. Edge swipe back → disabled (no back; edge 4) · — · — · — · —.

### Add your vehicle? (01.31–01.32, 01.44)
1. Appear → segment 2 fills · 400 ms ease-out · none · VO "Step 2 of 3" (not present in role switch) · RM instant.
2. Card press / select → as Choose role 2–3 · M-press / M-select · selection · VO "Add it now, 1 min, Brand, model, connector type — under a minute, selected, 1 of 2" · RM no scale.
3. CTA label "Add my vehicle" ↔ "Continue" · `fade.quick` · none · VO label updates · RM same.
4. "Add my vehicle" → push Add vehicle with the draft (the flow advances only after a real save) · M-push · light · VO focus on "Add vehicle" · RM fade.
5. "Continue" (Set up later) → push Location (role switch: All set) · M-push (All set: M-replace 400 ms) · light · VO focus on the next title · RM fade.
6. Back / edge swipe → pop; segment 2 empties in step with the interactive pop · native · none · VO focus on Choose role's selected card · RM fade.
7. The info card is static; VO reads it after the cards ("We'll only show you chargers that fit your car's connector type.").

### Add vehicle form (01.33–01.36)
1. Push lands → Brand auto-focuses (not for VO users) · keyboard curve · none · VO "Add vehicle" heading, then "Brand, text field, e.g., Tesla" · RM same.
2. Brand / Model → words autocap; return → next field; Model's return dismisses the keyboard and scrolls CONNECTOR TYPE into view · `smooth` · none · VO "Next" · RM instant scroll.
3. Connector Tile tap → toggles Selected=Yes: tint fill fades in, stroke 1→2pt `action/primary`, check badge pops; off reverses · M-select (`bouncy` pop, `snappy` off) · selection · VO "Type 2, AC, common. Selected. Toggle button." (header "Connector type, required, select one or more") · RM no pop.
4. Battery focus → decimal pad (iOS / Keyboard Layout=Decimal pad); "kWh" suffix stays visible; [P8] helper visible · keyboard curve · none · VO "Battery, optional, kilowatt hours. Used to estimate charge % and cost." · RM same.
5. Plate → `.allCharacters`, uppercases live as typed · instant · none · VO reads characters · —.
6. "Set as primary vehicle" → native Switch · system spring · selection · VO "Set as primary vehicle, switch button, on" · RM system.
7. Scroll → the sticky footer (Frost Strong + hairline) fades in while content is underneath; the hairline hides at the bottom; the Nav Bar gains its scroll edge · `fade.quick` · none · — · RM same.
8. "Save vehicle" with errors (01.35) → keyboard dismisses; the form scrolls to the first error; Brand/Model turn Error and shake; with no connector, all four tiles flash Selected=Error twice (2 × 160 ms) and Toast Error "Select at least one connector type" rises · `smooth` + M-shake + Toast motion · error · VO announces "Car brand is required" and focuses Brand · RM no shake or flash; the Toast still shows.
9. Battery outside 1–1000 → that field turns Error "Enter a battery size between 1 and 1000 kWh" (frame 08.43) · M-shake · error · VO announces · RM no shake.
10. Valid → Loading (01.36); fields, tiles and switch Disabled; repeat taps ignored · `fade.quick` · medium on tap · VO announcement "Saving vehicle" · RM same.
    - Success → `pop(true)`; the flow pushes Location; Toast Success "Vehicle added successfully!" (root overlay) rides over the transition and settles at y 644 on Location · M-push + Toast motion · success · VO announces the toast politely after focus lands on Location's title · RM fade.
    - Failure → controls re-enable; Toast Error "Error: …" (08.46) · Toast motion · error · VO announces · RM fade.
11. Back / edge swipe → pop keeping the draft (logic); no discard alert · M-push (pop) · none · VO focus on "Add it now" · RM fade.

### Location (01.37–01.38)
1. Appear → segment 3 fills 0→50% [P7]; in the map card the user dot drops (y −8→0) then pulses (2 s loop); the route line draws from the user to the GreenVolt pin (dash offset); the pins pop (60 ms stagger); the "1.2 km" chip fades in last · 400 ms ease-out (segment), `bouncy` (dot, pins), 900 ms ease-in-out (route), `fade.std` (chip) · none · VO one image "Map showing your location and a route to GreenVolt, DHA Phase 5, 1.2 kilometres away" · RM static final state; Low Power: no pulse.
2. "Allow location" → M-press; the system alert (01.38) appears after 150 ms; whatever the answer, push Notifications (logic) · M-push after the alert closes · light on tap; none for the OS alert · VO focus moves into the system alert · RM fade.
3. "Not now" → push Notifications · M-push · light · VO "Not now, button" · RM fade.
4. Back / edge swipe → pop; segment 3 empties · native · none · VO focus on the Add your vehicle? selected card · RM fade.
5. If a vehicle was just saved, the "Vehicle added successfully!" Toast is visible here at y 644 for its 4 s (see Add vehicle 10).

### Notifications (01.39–01.40)
1. Appear → segment 3 fills 50→100% [P7]; the two preview cards slide down from the Dynamic Island one after another (y −40→0 + fade) · 400 ms ease-out (segment), `smooth` with 160 ms stagger (cards) · none · VO one image "Example notifications: Booking confirmed, GreenVolt Charger, DHA Phase 5, tomorrow 6:00 PM. Charged to 80 percent, Rs 385, 14.2 kilowatt hours." · RM fade.
2. "Turn on notifications" → the system alert (01.40); any answer → All set · M-replace (400 ms, Quiet → Celebrate) after the alert closes · light on tap · VO focus moves into the system alert · RM fade.
3. "Maybe later" → All set · M-replace (400 ms) · light · VO focus on the All set title · RM fade.
4. Back / edge swipe → pop to Location; segment 3 returns to 50% · native · none · — · RM fade.

### All set (01.41–01.42)
1. Appear (cross-dissolve from Quiet) → the Celebrate glow blooms (scale 0.9→1) · 400 ms dissolve + 800 ms ease-out bloom · none · — · RM cross-fade only.
2. Success Mark → disc scales 0.6→1, then the check stroke draws · `bouncy` + 300 ms ease-out draw · **success** when the draw ends · VO image "Done" (skipped when the title is focused) · RM static mark; the haptic still plays.
3. Confetti Density=Burst → 36 pieces (`brand/primary`, `energy`, `mesh/glow`, `mesh/accent`, white) burst from behind the mark and fall, once · 1.6 s · none · hidden from VO · RM and Low Power: no confetti.
4. Title, recap card and buttons enter · M-rise (stagger 60) · none · VO focus on "You're all set, Ayesha!" (heading), then the body, then the pills read as one element "Driver, BYD Atto 3, Type 2, CCS 2" · RM fade.
5. Both buttons ignore taps for the first 600 ms (no accidental tap during the burst) · — · — · — · —.
6. "Find my first charger" → marks onboarding complete (logic) → Home: cross-dissolve, the map eases from Lahore to the user location, the tab bar rises (+150 ms) · M-replace + `camera` (500 ms) + M-rise · light · VO focus on the Home search field · RM fade, instant camera.
7. "Explore the app first" → the same destination (logic) [P10] · as 6 · light · as 6 · as 6.
8. No back gesture (end of flow).

### Role switch (01.43–01.44)
1. Push from Profile → the icon well scales 0.8→1; title and body enter · `bouncy` + M-rise · none · VO focus on "Become a driver" (heading) · RM fade.
2. "Continue" → push Add your vehicle? (no progress, no eyebrow) · M-push · light · VO focus on "Add your vehicle?" · RM fade.
3. Back on Become a driver → pop and cancel the role switch; Profile's mode switcher thumb springs back to Host (logic "snaps back") · M-push (pop) + `bouncy` · none · VO focus returns to "Driver mode" · RM fade, thumb jumps.
4. After a saved vehicle (or Set up later → Continue) → All set (skips Location and Notifications) · M-replace (400 ms) · as All set · as All set · RM fade.

### Link card (01.45/01.46)
- No interactions here; Home permission behaviour is 02 §4.1 rules 3–7.

### Toast (shared component 1088:631)
- Behaviour = **Toast motion** (§2.1). Position = bottom edge 12 above the top-most bottom button. Only one Toast at a time; a new one replaces the current with a `fade.quick` cross-fade.

---

## 6. Mobbin references (≥3 per major screen)

**Splash**
- **Lifesum — splash.** https://mobbin.com/screens/f90906fb-d6f4-4375-8569-6ea35b6d84c4 — What we take: one centred mark on a single calm field, with no chrome. Our version is lighter (Quiet mesh) but just as quiet.
- **CLEAR — splash.** https://mobbin.com/screens/76e6d254-e857-4483-9b83-7d531153437b — What we take: mark stacked over the wordmark at the same optical centre. That is the basis of our P → wordmark morph.
- **Revolut — onboarding flow.** https://mobbin.com/flows/7291bae9-7b5a-4b40-a911-316447f4437c — What we take: the splash wordmark holds its exact position as the first onboarding screen loads, so the launch has no cut.
- **Box Box Club — "You're All Set!".** https://mobbin.com/screens/1fa594d0-b42d-4cda-ae43-0fddfb92cf5d — What we take: the brand mark lit by a soft glow behind it, as on our mesh P.

**Story / intro**
- **Pangea Charging — onboarding (EV).** https://mobbin.com/flows/300aabc4-c2f3-4c5f-b5c2-89e48a2a0962 — What we take: one benefit per slide in a short title + one-liner tone ("Avoid Broken Chargers / Live navigation and charger alerts"). We skip their auto-advance stories, because users read at their own pace.
- **Mindtrip — welcome carousel.** https://mobbin.com/screens/b4c10274-a959-4381-9e02-7ce071d01a67 — What we take: the large rounded illustration card in the top half, centred title and subtitle, dots, and a full-width Next at the bottom.
- **Places — "Your Places Membership".** https://mobbin.com/screens/1ecbff2d-14dc-40ff-9339-b76823f479c0 — What we take: illustrating with the product's own UI (map + time chips) instead of cartoons. We do the same with our real Map Pins, Chip and Station Card.
- **Lifesum — Life Score slide.** https://mobbin.com/screens/94acf22a-4b69-4954-9e9e-c9372176cff1 — What we take: one big light-weight number as the hero of a slide (our 68% gauge and "+ Rs 1,240").
- **Monzo — onboarding flow.** https://mobbin.com/flows/9ac93ca6-671e-46ea-92c1-ef050166a6b3 — What we take: a fanned stack of product cards as the welcome hero. We reuse the idea in the slide-2 composition and later in Charging Passes.

**Sign in**
- **mymind — onboarding.** https://mobbin.com/flows/d139ac42-5257-4eeb-9886-f804a062a0f0 — What we take: a soft mesh field, the mark at the top, one big title, pill social buttons, and generous empty space. This is the closest mood to Mesh Quiet.
- **MacroFactor — create account.** https://mobbin.com/screens/b65a9219-04c5-471e-9f93-af66c78f7ed3 — What we take: Apple (black) / Google / Email stacked at the same height, with the legal line as a footer.
- **Sweatcoin — welcome.** https://mobbin.com/screens/5855f4bf-5022-4b80-9946-94cdc46237a5 — What we take: logo + one-line promise + Apple button, "Already have an account? Log in" with only the link part emphasised, and quiet legal text.
- **Perplexity — sign-in sheet.** https://mobbin.com/screens/3f400971-e98a-43e5-a951-53bd4ac50ccd — What we take: the button hierarchy (Apple black, Google neutral fill, email with an envelope glyph) and the Terms / Privacy footer.
- **Wispr Flow — sign in.** https://mobbin.com/screens/b13d07d8-9c54-4900-b67e-82b33b7fb1cd — What we take: centred calm, and the legal line limited to a 2-line measure.
- **Brink — native Sign in with Apple sheet.** https://mobbin.com/screens/fac111c9-1e14-416c-b7af-00879e1348da — What we take: the Liquid Glass Apple sheet (Name, Share/Hide My Email) for the 01.10 reference frame.

**Create account**
- **Liven — create account.** https://mobbin.com/screens/538faf0f-f9b7-468c-8fda-fc9bd5137012 — What we take: the form sits directly on a soft gradient top; the button spinner sits inside the button; "Already have an account? Log in" at the bottom.
- **TheFork — create your account.** https://mobbin.com/screens/0ca2ae4b-6064-4179-8680-5660a6fe1ae9 — What we take: green check-circle requirement rows under the password and a deep-green primary. Our Requirement Row copies this.
- **foodpanda — let's get you started.** https://mobbin.com/screens/be4de992-05ba-4b2c-879e-acebcefcacc2 — What we take: requirements that tick live as you type, and labels inside the fields.
- **Whatnot — sign up.** https://mobbin.com/screens/65858171-c4db-43f0-8747-5cac914dad88 — What we take: compact label-in-field density (three fields above the fold) and a single dark CTA.
- **ShopBack — log in with email.** https://mobbin.com/screens/6e39fa14-aadb-4221-b5fe-eff234f360a0 — What we take: the password rule written as a quiet hint directly under the field and a trailing visibility toggle inside it (our Requirement Row + [P16]).

**Verify email**
- **Mesh — check your email.** https://mobbin.com/screens/5d96cd3e-af3f-4eb5-b0a7-d19cc4a7989b — What we take: a centred card, the email address emphasised inside the sentence, and an "Open Mail App" primary.
- **Depop — check your inbox.** https://mobbin.com/screens/fd03dc84-8c32-4f9c-b062-307316b6d83d — What we take: the sealed envelope with the brand mark as the wax seal (our Mesh-P seal), plus a resend countdown.
- **Grab — check your email.** https://mobbin.com/screens/e77e2c51-a625-4658-906a-f910eedeb973 — What we take: a single illustration + title + 2-line body, with one CTA in the thumb zone.
- **Opera — check your inbox.** https://mobbin.com/screens/20509a77-dae8-4ba3-98da-4c10fa00c209 — What we take: the email on its own emphasised line, and a "Resend email" link above a "Continue" primary. This is exactly our logic.
- **Wispr Flow — check your email.** https://mobbin.com/screens/e9a447f0-17e1-401f-bd7b-72751e18bd30 — What we take: "This page will auto-reload", the basis of [P3] auto-check on return.

**Log in**
- **Tripadvisor — welcome back.** https://mobbin.com/screens/97ecc37a-f57a-46df-a485-60b0447087d2 — What we take: a deep-green palette on light, left-aligned big title, and "Forgot password?" directly under the password field.
- **Glovo — welcome back.** https://mobbin.com/screens/aaa254c1-7eee-48dd-8341-89bf0e092fbd — What we take: right-aligned "Forgot your password?" in the brand colour, with the primary pinned at the bottom.
- **MacroFactor — log in.** https://mobbin.com/screens/a1d8907d-839d-43bf-8c79-6c168d9c1043 — What we take: a minimal two-field form with the CTA close to the fields, and a legal footer.
- **Vestiaire Collective — welcome back.** https://mobbin.com/screens/6838a2bf-86e0-489d-85f1-31ea5d0186d2 — What we take: "Not yet a member? Sign up" anchored at the bottom.
- **Alan — log in error.** https://mobbin.com/screens/a395d774-7679-41a6-9ed8-a2f17ab8f608 — What we take: a tinted error card sitting between the form and the Log in button, not a toast. That is 01.23's Inline Notice Error Card above the CTA.
- **Polarsteps — welcome back.** https://mobbin.com/screens/a0880ebc-09f8-4f5c-9e97-3f2e2b90cf03 — What we take: a text "Show" toggle inside the focused password field (our [P16] while `eye` is missing) and a clearly stroked focus state.

**Reset password**
- **Liven — forgot password.** https://mobbin.com/screens/d67a2d42-a71d-4edb-936f-974091dd7e8d — What we take: the same gradient-top form template as their sign-up (one family).
- **Glovo — forgot your password?** https://mobbin.com/screens/77990aeb-8b81-45fa-808f-4dc17c0f83e5 — What we take: the email is prefilled, the primary sits at the bottom, and the tone is warm.
- **Viator — forgot password?** https://mobbin.com/screens/8d8dfd1c-831f-41aa-afe4-38d6bb119fd0 — What we take: an emerald primary with a one-line reassurance below it.
- **Yazio — reset alert.** https://mobbin.com/screens/de03cfc2-cda9-46f6-aa17-3f432003fa3f — What we take: the non-committal "If you have an account, we'll send…" confirmation, matching our logic copy.
- **ElevenLabs — reset sent, back on log in.** https://mobbin.com/screens/b4abe6aa-be63-42b0-873a-e723e6e497ac — What we take: after the request the user is back on the login form and a floating "If a user with the email … exists" message confirms it. That is 01.26 (pop to Log in + Toast).
- **Starbucks — forgot password sent.** https://mobbin.com/screens/264bb221-d679-4b60-a4d4-2f7f8a3dab6a — What we take: "Thanks – if you have a Starbucks account, we've sent you an email": the same privacy-safe tone as our real copy, with no extra screen.

**Choose role / steps**
- **Substack — "What brings you here?".** https://mobbin.com/screens/b149ca79-f03f-452e-84d2-8f8da6b62c1d — What we take: two large cards with icon + title + description and a trailing radio, with the selected card outlined in the brand colour.
- **Bumble — "What brings you to Bumble?".** https://mobbin.com/screens/4eee7d7b-20aa-420c-96f8-ea7d90343d70 — What we take: a top progress bar, two mode cards, and a footnote explaining the consequence.
- **Klarna — choose how to get started.** https://mobbin.com/screens/36cc0a64-52e3-4871-8e24-7b4e427bfda9 — What we take: a small tag pill inside the card (our "1 min" badge) and a secondary "Skip for now" pattern.
- **Tripadvisor — who's coming with you?** https://mobbin.com/screens/466206c0-6763-4f44-aada-35245f633b69 — What we take: a thin emerald progress line in the nav row and selection shown by fill change.
- **Tesla — onboarding flow.** https://mobbin.com/flows/7431873b-0069-4c5b-a7ee-e038903e949e — What we take: the small "Step 1 of 3" eyebrow above the title (EV peer).

**Add your vehicle? (choice)**
- **Cash App — relationship choice.** https://mobbin.com/screens/00f637bf-401e-47d7-ac70-4ada949936e4 — What we take: two radio cards plus a centred footnote above the CTA (our connector-match info note).
- **MacroFactor — program style.** https://mobbin.com/screens/d0e155ed-6da1-4e5f-a03a-675b24be45c9 — What we take: an icon left, title + 2-line description, and a radio right, at the same density as our Choice Card.
- **Lloyds — manage your vehicle.** https://mobbin.com/screens/82a43748-2d02-47c9-9cfc-38da4f55df4f — What we take: benefits first, then a registration field and "Browse without connecting" as the later option.

**Add vehicle form** (shared with 08)
- **Setel — adding a vehicle.** https://mobbin.com/flows/f07d0419-b7c8-47c6-a7f6-f2d3f64a600e — What we take: the plate field, selectable type tiles with icons, and an "(OPTIONAL)" label style. It is a Southeast Asian fuel/EV app, a close market analogue.
- **BlaBlaCar — adding a vehicle.** https://mobbin.com/flows/97ecf3f9-4845-41f5-a177-50edb17280c7 — What we take: a searchable brand → model list, the basis of the future catalogue picker [P9].
- **Tesla — vehicle details.** https://mobbin.com/flows/9d431e35-a2ca-4e05-88e7-39f0b54b6b7a — What we take: a make/model/spec form with a single Save; specs (range/battery) are treated as optional.
- **Blue Apron — protein preferences.** https://mobbin.com/screens/79fea225-ad70-4434-8594-a7ba42060be5 — What we take: a 2-column multi-select tile grid with icons where selected tiles get a tint + outline (our Connector Tile).

**Location**
- **Tripadvisor — see what's good nearby.** https://mobbin.com/screens/9b1649df-9d4d-4b3b-80b4-17b3174b90fc — What we take: a real map tile with the blue location dot as the illustration, plus one strong CTA.
- **Deliveroo — "Hey there! Where are you?".** https://mobbin.com/screens/949bb9c4-8ef4-4f07-8cc1-3f9f35600e0b — What we take: brand pins clustered around the user on a map crop. Ours shows prices.
- **Sesame — enable location access.** https://mobbin.com/screens/6b07c7e6-01ac-46d8-8855-2f8f3c7e56c6 — What we take: previewing the system alert and recommending "Allow While Using App". This is our 01.38 reference frame.
- **Cash App — allow location access.** https://mobbin.com/screens/a83fa99d-5202-4250-898a-8ccb1745143d — What we take: the "Not now" / primary pairing, with the decline option fully visible and not hidden.
- **Hypelist — turn your location on.** https://mobbin.com/screens/bfe5ae4c-661a-48f4-b62f-dee1ac22575b — What we take: the back arrow + progress line in one nav row, and "Skip for now" under the CTA.

**Notifications**
- **Ro — get updates.** https://mobbin.com/screens/b9dd6b3d-879f-43b4-9968-cc0cf06231e9 — What we take: stacked real notification cards over a soft mesh, then title, body, Enable / Skip. This is the closest match to our Quiet mesh.
- **Luma — get notified.** https://mobbin.com/screens/f8b9c208-0980-466d-a9f3-696fb4cd6876 — What we take: notification rows overlapping a phone outline so they read as lock-screen notifications.
- **Claude — notifications prompt.** https://mobbin.com/screens/c5cbd6f5-1c04-4111-acee-c0080b68e97f — What we take: the "Turn on notifications" primary + quiet "Not now" hierarchy and honest body copy.
- **Lloyds — never miss a response.** https://mobbin.com/screens/1d2e548f-513b-43a1-b148-e8e0071a7eea — What we take: a deep-green device slab carrying one notification. That inspired our Mesh-Hero lock-screen card.
- **American Airlines — notifications.** https://mobbin.com/screens/e69211f8-aecd-4e8f-98c2-e0aa7283c133 — What we take: a "Time Sensitive" lock-screen mock, the reason booking/charging alerts deserve Time Sensitive later.

**All set**
- **Garmin Connect — you're all set.** https://mobbin.com/screens/299a4cd4-f97a-4069-8026-00d823009df6 — What we take: a white check ring on an immersive background, with two stacked CTAs of different weight.
- **Monzo — all set!** https://mobbin.com/screens/df289546-b75d-4454-b77c-2f7733ab3841 — What we take: a restrained confetti burst around one centred message.
- **Cash App — you're all set.** https://mobbin.com/screens/97ddcf1e-0e3d-4897-801c-d0679cfe8c33 — What we take: a solid check mark + a short personal line, with no clutter.
- **Box Box Club — you're all set.** (URL under Splash.) What we take: a dark brand glow with a white pill primary, which is our On Mesh button.

**Role switch · Become a driver**
- **Lyft — "You have taken the first step".** https://mobbin.com/screens/967bbdfb-5fbd-47c5-9606-67fd2eafcae6 — What we take: becoming a driver inside a rider app shown as one large brand-coloured icon, a short title, a one-line reason and a single primary at the bottom. Our 01.43 composition.
- **Garmin Connect — "Setup Garmin Wallet".** https://mobbin.com/screens/8d3f90fb-fc25-4713-bc02-95c7ad85a1f0 — What we take: a big outline icon, title, and a body that names the prerequisite step before the feature unlocks, then one "Get Started". Same job as "add your vehicle first to get verified".
- **Grab — "Grab for Family".** https://mobbin.com/screens/426fc4f9-d114-4bac-a070-ad5cf340ad9e — What we take: a pushed screen with a back arrow, a title, a one-line value statement and a pinned green Continue (our emerald primary at 772); back simply leaves the mode.

**Home permission surfaces** (owned by 02; listed for the link card)
- **Polarsteps — inline permission cards.** https://mobbin.com/screens/5006956b-68c1-4e35-aba0-290589260ab3 — What we take: an icon + title + reason + single action for a permission asked again later.
- **Opal — sign-up sheet.** https://mobbin.com/screens/5011b2b9-7a00-4b62-b368-44e139b8cf6e — What we take: a compact rounded sheet with one primary and a text-weight secondary, used for 02's LocationPermissionDialog sheet.
- Cash App and Tripadvisor (above) for the copy hierarchy.

---

## 7. New components needed

Sibling specs cite this table as "01 §6"; it is §7 here. **Reused as-is (not new):** Nav Bar 1087:643, Toast 1088:631, Connector Tile 1088:745 (+ 08's Error and Disabled variants), Text Field 1070:590 (+ 08's Suffix prop), and every other instance listed in §3.

| Component | Purpose | Variants | Props / notes |
|---|---|---|---|
| **Auth Button** | Sign-in providers at one size and with one loading behaviour | Provider = Apple · Google · Email × State = Default · Pressed · Loading · Disabled | 370×52, same radius variable as Button / Large. Apple: #000 fill (pressed #1C1C1E), white label, glyph = SF Pro text U+F8FF (Apple logo) at 19 Medium; HIG "Continue with Apple". The black is Apple-mandated: note it in the description as the one unbound fill. Google: `bg/surface` + `stroke/hairline`, official multicolour "G" (asset needed; placeholder FLAG), `text/primary`. Email: `action/secondary` (tint) + envelope (wanted symbol `envelope`; FLAG). Prop Label. |
| **Step Progress** | Onboarding steps 1–3, laid over the Nav Bar | Step = 1 · 2 · 3a (third segment half) · 3b (full) | 258×4, 3 segments, gap 6, pill radius; filled `action/primary`, empty `bg/fillStrong`; accessibility element "Step n of 3". |
| **Page Control** | Story pager | Pages = 4 × Current = 1…4 | Dots 8×8 `bg/fillStrong`; active capsule 24×8 `action/primary`; gap 8. |
| **Choice Card** | Single-select radio cards (role, add-vehicle-now/later; later reusable for planner "By time / By target") | State = Default · Pressed · Selected · Disabled | 370×hug (min 88), padding 16, radius `radius/lg`. Icon well 44 tinted (radius 12) with Icon swap; Title (Headline); Description (Subheadline secondary, 2 lines); Show badge (bool) + Badge (Status Pill S); trailing radio 24 (empty = 1.5pt ellipse in `icon/tertiary`, drawn, since `circle` is missing; selected = `checkmark.circle.fill` `icon/brand`). Default = Frost Strong + hairline; Selected = Surface + 2pt `action/primary`; Disabled = content 60%. |
| **Requirement Row** | Live password rule | State = Unmet · Met · Error | 16 icon + Footnote. Unmet: drawn 1.5pt ellipse `icon/tertiary`; Met: `checkmark.circle.fill` `status/available`; Error: exclamationmark.triangle.fill `icon/error` + `text/error`. Prop Label. |
| **Inline Notice · extension** (04 owns the component) | Inline success / warning / error / info lines and cards (verify, API errors, connector info) | Add Tone = **Success** and Style = **Plain** to 04's Inline Notice (Tone = Warning · Info · Neutral · Error × Action) | Card = 04's anatomy (370 wide, padding 12/14, radius md, tone tint fill: `status/warningTint` · `bg/tint` · `bg/fill` · `status/errorTint`, + `status/availableTint` for Success). Plain = no fill, icon 16 + Footnote in the tone colour (`text/error`, `text/warning`, `text/available`, `text/secondary`), centred. One component app-wide; there is no separate "Inline Message". |
| **Notification Preview** | Lock-screen previews (onboarding, 06.27/06.28) and the in-app foreground banner (Appendix 2; 07.05, 09.10) | Style = Lock screen · In-app banner | 338 or 370 wide × hug, radius 22, Frost Strong + Frost/Card, padding 14. Lock screen: App icon 38 (Brand / App Icon instance), Title (Subheadline Emph `text/primary`) with Time right-aligned (Footnote `text/secondary`), Body (Subheadline `text/secondary`, 2 lines). In-app banner: adds a header row "PAKPLUG" (Caption 1 Emph `text/secondary`) · time, then Title and Body. |
| **Success Mark** | Completion mark (All set; Charge complete 06; Identity 08) | Size = L 88 · M 56 × Style = On mesh (white disc, brand check) · On light (brand disc, white check) | Check vector separate for the draw-on animation. |
| **Confetti** | Celebrate-mesh burst layer | Density = Burst (36 pieces) · Light (24, used by 06) | 402×560 group; pieces bound to `brand/primary`, `energy`, `mesh/glow`, `mesh/accent`, white (not the legacy `mesh/1–3`). |
| **Button / Large · new types** | Actions on deep meshes (All set; later Charge complete, Live) | Type = On Mesh · On Mesh Plain × State = Default · Pressed · Disabled · Loading | On Mesh: `bg/surface` fill, `text/brand` label, Shadow/Button; Pressed `bg/frostStrong`. On Mesh Plain: no fill, `text/onMesh` label (white on the deep base 4.7–5.7:1 ✓); Pressed = `bg/glass` fill. Add them to set 978:427 (06 adds On Mesh Destructive). |
| **Illustration / Map Card** | Product-UI illustrations | Variant = Prices (Story 2) · Route (Location) | 370×400 / 370×292, radius 28, clip, Map fill + Map Pin / User Location / Chip / Station Card instances; Route has a dashed `action/primary` 3pt path. |
| **Illustration / Inbox** | Verify email | — | 160×120 Frost Strong envelope (rect + flap vector) with a P Mark Mesh 40 seal. |
| **Illustration / Lock Screen** | Notifications | — | 370×292 radius 28, clip; Mesh Hero instance 402×874 at the card's negative offset; Dynamic Island capsule 126×37 black; slot for Notification Previews. |
| **iOS / Keyboard · Layout** (extends 03 §6) | Keyboard frames in this flow | Add Layout = Default · Email · Phone pad · Decimal pad to 03's component (Return = Enabled · Disabled; Suggestions bar = On · Off; 05 adds Caps / Go) | 402×336 incl. QuickType bar; OS-owned label. One component app-wide. |
| **iOS / Permission Alert** (system mock) | Location / notifications prompts (reused by 02.03; 06 adds Kind=Photos) | Kind = Location · Notifications | iOS 27 Liquid Glass alert, radius 34, capsule buttons; Location adds a map preview + "Precise: On". OS-owned label. |
| **iOS / Apple ID Sheet** (system mock) | Sign in with Apple reference | — | Reference only. OS-owned label. |

---

## 8. Proposals (not in the logic map; each goes on the FLAG card)

- **P1. Sign-in order Apple → Google → Email** (the code has email first). HIG asks that Sign in with Apple be at least as prominent; one-tap options first convert better. Presentation only.
- **P2. "Open Mail" secondary on Verify email.** The user's next real action is opening Mail. It costs one URL scheme. Not in the code.
- **P3. Verification polish:** auto-check when the app returns to the foreground (uses the existing app-resume refresh), plus a 30 s resend cooldown ("Resend in 0:30"). This avoids a dead "Continue" tap and spam-resends.
- **P4. Estimate honesty in marketing previews:** Story slide 3 "68%" and the notification preview "Charged to 80% ⚡" imply the app reads the battery, which it can't. Propose "≈68% est." and "Charged to ≈80% ⚡" (06.28 already uses the ≈ form). Frames here keep the real copy for now.
- **P5. Copy where the logic map has no exact string:** sign-in error, create-account field errors ("Full name is required", "Enter a valid email address"; 08.25 reuses them), API errors, login error, reset error, choose-role error, illustration VO labels, and the preview timestamps "now" / "1h ago". Rayan should swap in the code's real strings if they exist.
- **P6. Completed truncated copy:** LocationPermissionDialog body ("…show how far each charger is, and guide you there."), the denied-forever alert ("…system settings to see stations near you."), and the iOS location purpose string (reuse the dialog sentence). Identical to 02's P17. Verify against the source.
- **P7. Step 3 split visually:** Location fills the third segment to 50% and Notifications to 100%. Both keep the logic's "STEP 3 OF 3" label, which otherwise reads as a stall.
- **P8. Battery field helper "Used to estimate charge % and cost."** (shared with 08 P21). The charge planner (start % + time → kWh, cost, end %) needs battery size; onboarding is the cheapest place to collect it.
- **P9. Vehicle catalogue picker (future):** pick brand → model from a list (BlaBlaCar/Setel style) that auto-fills battery and connectors (BYD Atto 3 → 60.5 kWh, Type 2 + CCS 2). Needs a catalogue API; not designed tonight.
- **P10. Differentiate the All-set buttons:** "Find my first charger" → Home centred on the user, with the nearest Available station's card open; "Explore the app first" → plain Home. Today both run `finishToRoleHome`.
- **P11. "Continue as host"** CTA label when Host is selected (the logic names only "Continue as driver").
- **P12. Button / Large On Mesh + On Mesh Plain types.** Emerald-on-emerald fails visually; Glass with a white label risks contrast. Needed again for Charge complete and Live.
- **P13. The existing Toast (1088:631) replaces every Material snackbar** in this flow, floating 12pt above the bottom button (brief rule). On Reset-password failure, show only the inline notice, not a toast as well.
- **P14. Splash choreography:** P → wordmark unfold, and the spinner only after 1.5 s (the code always shows it); Splash hands off seamlessly to Story 1.
- **P15. Location screen on Quiet mesh with an emerald route map card** instead of the coded full dark-green screen, so steps 1–3 stay one family.
- **P16. Password show/hide** as a trailing text button "Show" / "Hide" (Polarsteps pattern) until the `eye` / `eye.slash` symbols are exported; then swap to the glyph.
- **P17. Missing SF Symbols / assets to export on a Mac:** `envelope`, `apple.logo` (until then the SF Pro U+F8FF glyph), `eye`, `eye.slash`, `circle` (drawn ellipse until then), `ev.plug.ac.type.1`, `ev.plug.dc.chademo`, and the official Google "G" logo.
- **P18. Loading state on "Continue as driver"** (01.48). The logic names an inline error for this step, which implies a request, but no loading state; the design adds the standard button spinner so the error has a visible cause.

---

## 9. Edge cases and defaults chosen

1. **Returning social user** → straight to role home from Sign in (no Choose role). Shown as a canvas note on 01.07, not a frame.
2. **Onboarding seen + logged out** → Splash morphs straight into Sign in (no Story).
3. **Auth check timeout (10 s) / safety (12 s)** → Sign in silently. No error UI (logic).
4. **Choose role has no back button** (the account exists; going back would mean signing out). Default chosen; Hammad can add "Sign out" later.
5. **Verify email back** → pops to Create account with the values intact (platform default). The account already exists, so a re-submit becomes an API error (01.15 copy covers it).
6. **Log in skips email verification** (logic gap). Noted for Rayan; no UI change.
7. **Apple private relay**: no email verify step for social sign-in; the relay address later shows the Edit-profile note (08).
8. **Long first names** wrap to 2 lines in "You're all set, {first name}!" (the title block is sized for 2 lines), never truncated. The recap pill row wraps inside the card.
9. **Several connectors** → one recap pill joined with " · " ("Type 2 · CCS 2"). No vehicle → "Driver" only (01.42).
10. **Location denied or Not now** → Notifications anyway. Home later shows 02.02 or 02.04 and falls back to Lahore (Limited Mode).
11. **Notifications denied** → All set anyway. The Push toggle lives in Account & settings (08).
12. **Role switch** skips Location and Notifications and hides progress and eyebrow (01.44). Back cancels the switch.
13. **Double taps** on any CTA are ignored while it is Loading. The Loading variant disables input.
14. **Keyboard open:** the CTA rides above the keyboard; forms scroll so the focused field is never covered; the large title collapses into the Nav Bar.
15. **Dynamic Type (AX sizes):** story illustration cards shrink to min 240 tall and the text scrolls; auth buttons grow in height (min 52) and labels wrap to 2 lines; Choice Cards hug; the All set recap card hugs.
16. **Small phones (iPhone SE 375×667)** are not drawn. Rules: the Sign-in P mark hides, story cards drop to 300, two-action screens keep 16pt gaps.
17. **Offline during any submit** → that screen's Inline Notice Error ([P5] copy); no separate offline screen.
18. **Add vehicle save failure** → Toast Error "Error: …" (logic snackbar; frame 08.46); the draft is kept.
19. **"Back to login" on Reset** goes to Sign in, not Log in (logic). Kept, and noted as a small inconsistency for Rayan.
20. **Android** is out of scope: no Apple button there (logic: iOS/macOS only), so Google + Email only.
21. **PrivacyPolicyScreen** (Sign-in legal link) is a pushed text screen the logic map doesn't describe; not drawn here.
22. **A Toast still visible when its screen is left** (e.g. "Vehicle added successfully!") stays in the root overlay and finishes its timer on the next screen.
23. **Reduce Transparency** turns every Frost Strong card (Choice Card default, recap card, Notification Preview, Stat Tile override) into Surface + hairline; contrast only improves.

---

## 10. Logic check (for the section's Logic card)

- J1 Splash: logo, wordmark, "Charge Your Journey", spinner, 1.5 s routing, 10 s / 12 s timeouts → 01.01–01.02, §5 Splash.
- J2 Story: 4 pages with exact copy (incl. chip "Rs 42/kWh"; 68%, "Charging · 22 kW", "Rs 385 so far", "80% by 6:40 PM"; "+ Rs 1,240 this week"), Skip on the middle slides only and jumping to the last slide, Next / Get started → 01.03–01.06.
- J3 Sign in: email / Apple / Google, "Already have an account? Log in", "New here? Your account is created automatically.", Terms footer → PrivacyPolicyScreen, shared loading (button spinners), inline error, new vs returning social user → 01.07–01.10.
- J4 Create account: 4 fields, "At least 6 characters" check, errors only after the first submit, API error, Create account loading, Log in replaces → 01.11–01.15.
- J4b Log in + Forgot password: inline error, no verify gate, prefilled email, Send reset link spinner, success snackbar copy then pop, "Back to login" → /login, inline error (+ snackbar → [P13]) → 01.21–01.27.
- J5 Verify: link-based, "Didn't get it? Resend" / "Resending…" / "Verification email resent." / "Couldn't resend — try again in a moment.", Continue loading → verified or "Not verified yet…" → 01.16–01.20, 01.47.
- J6 Choose role: progress 1, "STEP 1 OF 3", two cards with Driver as default, Continue as driver, Host → host flow, inline error → 01.28–01.30, 01.48.
- J7 Add your vehicle?: progress 2 + "STEP 2 OF 3" hidden in role switch, two select-only cards, "1 min" pill, info line, Add my vehicle (advances only after a real save) / Continue → 01.31–01.32, 01.44.
- I AddEditVehicle (onboarding draft): "Add vehicle" title, Brand / Model required errors, CONNECTOR TYPE 2×2 with "Select at least one connector type", Battery 1–1000 error, Plate uppercased, Set as primary, Save loading, "Vehicle added successfully!", "Error: …", draft kept on back; adding a vehicle marks the driver verified (no UI here; 08.59–08.61) → 01.33–01.36, 08.43, 08.46.
- J8 Location: 3-segment progress, "STEP 3 OF 3", route illustration, copy, Allow location (OS prompt) / Not now → Notifications, back arrow → 01.37–01.38 (dark green screen → [P15]); B LocationPermissionDialog + denied-forever alert → link card 01.45/01.46 → 02.02/02.04.
- J9 Notifications: progress 3, "STEP 3 OF 3", two preview cards with exact copy, Turn on (OS prompt) / Maybe later → All set → 01.39–01.40.
- J10 All set: confetti + check, "You're all set, {first name}!", both body variants, recap pills (Driver + vehicle + connectors), both buttons → /driver-home (same action) → 01.41–01.42.
- Role-switch variant: "Become a driver" copy, Continue → step 7 → All set (skips Location and Notifications), back cancels → 01.43–01.44.
- Appendix 2: auth-loss redirect → /login (entry 3); app-resume refresh (used by [P3]).

---

## Review notes (2026-10-04)

What the review changed, and why:

**Consistency with the brief and the components that already exist**
1. **Toast.** The draft defined a new top-anchored Toast (Tone Info, Lines variants, dropping from the status bar, swipe up). The brief and `NEW-COMPONENTS.md` already have `Toast` 1088:631 (Neutral / Success / Warning / Error, Message / Action / Action label) floating **12pt above the bottom button**. Every Toast now uses that component and position (01.26 y 628, 01.35 y 704, the "Vehicle added" toast at y 644 on Location). The motion now matches 08 (rise from y+16, `smooth`, swipe down). The "Toast" row was removed from §7, and P13 was reworded.
2. **Connector Tile.** The draft defined a new 177×76 tile with Off/On. The existing `Connector Tile` 1088:745 is 177×112 (Selected=No/Yes). 01.33–01.36 now use it with 08's Error and Disabled variants and **08.39–08.44's exact coordinates**, because it is the same screen. The large title "Add vehicle" became the Nav Bar inline title, as in 08.
3. **Nav Bar.** The draft used a loose Icon Button for back and said the Nav Bar "is planned". It exists (1087:643). Every pushed screen now uses `Nav Bar` Inline at (0,54), with the title empty until scroll. Step Progress sits over it at (72,78), and Choose role turns Leading off. Content now starts at y 122 (08 parity). Titles, fields and links on Create account, Log in, Reset, Verify, Choose role, Add your vehicle?, Location, Notifications and Become a driver were re-coordinated, and text-link lines now use the 772 two-action slot.
4. **Inline Message → Inline Notice.** 04 already defines `Inline Notice` for the same job. The draft's "Inline Message" was merged into it: this flow only adds Tone=Success and Style=Plain. All references were renamed.
5. **iOS / Keyboard.** This was defined twice (01 and 03). There is now one component (03 §6), and this flow adds Layout variants.
6. **Motion.** The draft's ad-hoc springs ((0.40,0.90), (0.45,0.85), (0.6,0.9), (0.50,0.60), etc.) were replaced with the shared 02 §4.0 tokens (`snappy` / `smooth` / `bouncy` / `fade.*` / `camera`) and 06's `sweep` / `roll`. The M-* composites now carry the exact values 08 quotes, plus a new M-grow for inline notices. The haptic map was aligned with 02/08: submit taps are *medium*, text links and system alerts have none, and *success* is only used for real completions.
7. **Celebrate contrast (All set).** The draft put a white title and body at y 352–440, which is the bright `energy` blob on the Celebrate mesh, where white measures about 2:1. The layout now follows 06's measured Celebrate placement: mark at (157,100), title in `text/primary` inside the glow, body and recap pills on a Frost Strong recap card, and On Mesh buttons on the deep base. A screenshot check with a fallback was added.
8. **Hero mesh in illustration cards.** The draft "scaled the mesh into the card", which would have distorted it. The card is now a window onto a 402×874 instance at a negative offset. The gauge centre is `text/onMesh` on the deep region.
9. **SF Pro light type.** Story titles now use Large Title (34 Medium, the brief's screen-title rule) instead of Title 1. Numbers are in Display (Light). There are no Bold or Semibold mentions. "iOS 26" was corrected to iOS 27 Liquid Glass (D8). The Apple button black is the one documented unbound fill.

**Missing states and logic coverage**
10. Added **01.47 Verify email · Resending** (real copy "Resending…", which was only described in prose) and **01.48 Choose role · Saving** (button loading, P18).
11. **01.45/01.46** were rebuilt Home frames that duplicated 02.02/02.04, with a different sheet height (352 vs 372). They are now a link card, as 02 requests. The frame count stays 46.
12. **01.13:** the password error was printed twice (field message + rule row). The field message is now off, and the rule row carries it.
13. **01.09:** the error used to push the link and legal text down into the home-indicator zone. It now sits above "New here?" and nothing moves. 08.15's reference to the footnote at 520 is preserved.
14. Logic-check lines were added for: I AddEditVehicle (draft, verified side effect, battery range → 08.43, "Error: …" → 08.46), the Story chip and live numbers, the Send reset link spinner, PrivacyPolicyScreen, and Appendix 2.

**Data honesty**
15. The placeholders "Your name" / "you@email.com" / "03XXXXXXXXX" are now marked as reused Edit-profile hints. The invented password placeholder was removed. Preview timestamps "now" / "1h ago" were added to P5. P4 now points to 06.28's "≈80%" form.

**Micro-interactions**
16. §5 was rewritten so every row has a trigger, response, timing or token, haptic, VoiceOver and RM. Previously many rows (Choose role 4–5, Add your vehicle? 2–6, Add vehicle 1/4–6/9–10, Location 2–4, Notifications 2–3, All set 6, Role switch, Log in 1/4, Reset 1/4, Sign in 4/7–10, Verify 2/6) had no haptic, VO or RM. Also added: auto-focus rules that skip VoiceOver users, the Model-return scroll, the toast carry-over to Location, the 600 ms tap guard on All set, segment refills on back, the silent auto-check on foreground, and Reduce Transparency / Low Power defaults.

**Mobbin**
17. Added 8 references: Role switch had none and now has Lyft, Garmin Connect Wallet and Grab for Family. Log in gained Alan (error card above CTA) and Polarsteps ("Show" toggle, the basis of the new P16). Create account gained ShopBack. Reset password gained ElevenLabs (toast back on log in) and Starbucks. Every major screen now has ≥3 references; Home permission refs stay, marked as owned by 02.

**Proposals**
18. P16 changed to a text "Show"/"Hide" button, since the eye glyph is missing. P17 gained `circle` (the radio and rule-row empty state is now a drawn ellipse). P18 was added.
