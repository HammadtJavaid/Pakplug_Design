# 04 · Station & Book: place sheet, station details, reviews, directions, Book a slot, confirm, booked

> **00-system alignment (2026-10-04, read first).** `00-system.md` is the single answer for navigation, sheets, motion, haptics, shared components, section names, formats, tones and materials; where this spec still differs, 00-system wins. Applied to this spec: (1) Sections: `Flow 4A · Station · Place sheet` (row 1), `Flow 4B · Station · Details, directions & reviews` (rows 2–3), `Flow 4C · Book · Book a slot` (row 4), `Flow 4D · Book · Vehicle` (row 5), `Flow 4E · Book · Confirm, booked & errors` (rows 6–7) (00-system §4). (2) Buttons inside sheet headers are `Icon Button` Fill S 979:286 (Close at x 352), never Glass on an opaque sheet. (3) List rows press with the `bg/fill` highlight (no scale); cards 0.98. (4) Book now (tile, card, pill) plays a light haptic; medium is for commits (Confirm booking). (5) 04.12's content Large Title sits at y 122 (+8 to the rows below it); the title collapses into the bar after 51pt of scroll. (6) 04.17 is `Sheet / Action` Kind=Call (the Manual Call Sheet), leading-aligned with 09.30's coordinates. (7) 04.43's success sheet is `Sheet / Action` Kind=Info with the Success well (Success Mark is only for full-screen completions). (8) Vehicle Select Row = `Vehicle Card` Layout=Row (C5); Inline Notice = C2 (adds Success and Plain); Rating Stars Display = C7; Avatar = C8; Chip Fill/Disabled, List Group Header trailing (incl. the Peak note), Cost Footer info, Skeleton Block and Touch marker are C14 items. (9) Frame names carry no proposal tags: 04.17, 04.30 and 04.43 end with "· proposal". (10) `scrub` haptics are limited to one per 60 ms (not 40 ms).

Build spec for Flow 04. Research only: no Figma calls were made.
Sources: `BRIEF.md`, `NEW-COMPONENTS.md`, `driver-logic-map.md` §B (station preview sheet, `StationDetailScreen`, `GetDirectionsModal`, `StationReviewsScreen`), §C (`BookingCreateScreen`, `BookASlotVehiclePickerSheet`, `BookingCostFooter`, `ConfirmBookingDialog`, submit), §H (`ManualCallSheet` copy only), Appendix 3–4, the revamp design spec (D9: "booking inside the sheet"), the progress log (C9/C12 parts, concepts A/B/D), spec `02-discover.md` (motion tokens, haptic map, 02.08 floating card), and 16 Mobbin searches (11 screen searches, 3 flow searches, 2 deep searches) whose images were reviewed, plus 7 review-pass screen searches (call sheet, contact sheet, confirm sheet, submitting, slot errors, error states, sheet skeleton/directions, inline field errors). 67 unique references are cited in §5 (52 draft + 15 review).

Notation (same as 02)
- `[P]` = proposal (not in the logic map). Every `[P]` is listed in §7 and must appear in the FLAG — PROPOSALS block of the logic-check card.
- "Real copy" = quoted verbatim from the logic map. A `…` inside a quote means the logic map truncates it (Rayan pastes the full string from code).
- Component references use the brief inventory: `Name [set id] → Variant id`, props as `Prop#id`.
- Motion tokens and the haptic map are the ones defined in `02-discover.md` §4.0: `snappy`, `smooth`, `bouncy`, `fade.quick` (150 ms ease-out), `fade.std` (220 ms ease-out), `camera` (350–500 ms ease-in-out). Haptics: selection / light / medium / success / warning / error. One new token is added here: `scrub` (see §4.0).

---

## 1. Overview

**Goal.** From a pin on the map, a driver understands one charger in a glance (status, rating, distance, price, plug), decides, and books a slot without leaving the map. Booking is time-first (concept D readout): the big "6:00 → 7:00 PM · 1 h" readout at the top is always the answer to "what am I booking?", and every control below it (date, duration, window, start time, vehicle) edits that readout. The booked slot lands as a Charging Pass (concept B) and the driver goes to Bookings.

Concept A presentation (logic unchanged, routes become sheet levels):
- **Level 0** · floating preview card (02.08, owned by Flow 02).
- **Level 1** · place sheet at **medium** detent (= logic "station preview sheet" content + quick actions).
- **Level 2** · place sheet at **large** detent (= logic `StationDetailScreen`, `/station-details`).
- **Level 3** · pages pushed *inside* the sheet at large detent: Reviews (`StationReviewsScreen`) and Book a slot (`/booking-create`). Back chevron returns to level 2.
- **Stacked sheets** on top of the sheet: Directions (`GetDirectionsModal`), Choose vehicle (`BookASlotVehiclePickerSheet`), Confirm booking (`ConfirmBookingDialog`), Call host [P].
- When Station Detail is opened from **Saved chargers** (not from the map), it is a normal pushed page (04.12) with the same content; its Book now pushes a full-screen Book a slot with identical content.

**Screens in this flow (9):** place sheet (medium/large), station details (pushed), directions sheet, call host sheet [P3], reviews, Book a slot, choose vehicle sheet, confirm booking sheet, booked (pass appears) [P].
**Frames:** 53 (25 × P1, 28 × P2). 04.49–04.53 were added in review; each sits in the row named in its table entry (numbers are not re-flowed so cross-references from 02, 03, 07 and 09 stay valid).

**Entry points**
| From | Action | Lands on |
|---|---|---|
| 02.08 floating card | swipe up > 60pt | 04.01 (medium) |
| 02.08 floating card | **View Details** | 04.02 (large) |
| 02.08 floating card | **Book now** | 04.24 (Book a slot inside the sheet, large) |
| Home · List card / Search result (Flow 03) | tap → map selects station (logic) | 02.08, then as above |
| Saved chargers card (02.20) | tap | 04.12 (pushed details) |
| Bookings → booking details → **View charger** (Bookings flow) | tap | 04.12 (pushed details) |
| Bookings → Completed / Cancelled / Expired pass → **Book again** [07-BK14] | tap | Full-screen Book a slot for that station, today selected, nothing prefilled (content = 04.24) |

**Closing the place sheet, mapped from the logic.** Logic: "Scrim tap or handle tap closes it." Here: at medium there is no scrim (the map stays live), so a **tap on the map outside the sheet** closes the sheet and deselects the pin (= logic scrim tap). At large, a tap on the dim settles the sheet to medium. The **grabber tap toggles medium ↔ large** (iOS convention) instead of closing [P36]; close stays available as ✕, drag down, and map tap.

**Exits**
| From | Action | Goes to | Owner |
|---|---|---|---|
| Place sheet | drag below medium | 02.08 floating card | 02 |
| Place sheet | ✕ | 02.06 Home · Map, pin deselected | 02 |
| Directions sheet | **Open Google Maps** | Google Maps (external) | OS |
| Book a slot / Choose vehicle | **Add a vehicle** / **Add** / **Add vehicle** | `/add-vehicle` (AddEditVehicleScreen), returns and refreshes; a new fitting vehicle is auto-selected (logic) | Profile flow |
| Booked (04.43) | **View in Bookings** / swipe down | Driver shell, Bookings tab (index 2), Upcoming; new pass on top (logic: "replaces the whole stack with the driver shell on the Bookings tab") | Bookings flow |
| Error 04.46 | **Open Bookings** [P23] | Bookings tab | Bookings flow |

**Sections on Driver Flows (946:8).** Five sections (00-system §4), each placed 160 below the current page bottom at x=0 with the fills of section 1076:2: `Flow 4A · Station · Place sheet` (row 1), `Flow 4B · Station · Details, directions & reviews` (rows 2–3), `Flow 4C · Book · Book a slot` (row 4), `Flow 4D · Book · Vehicle` (row 5), `Flow 4E · Book · Confirm, booked & errors` (rows 6–7). Each has its title (Title 1, text/primary) at (80,80) and a status line (Footnote, text/secondary) at (80,124), e.g. "Place sheet at both detents, every station status · 13 frames · spec 04-station-book.md". Frame labels `04.nn · Screen · State` (Footnote Emph, text/secondary, above each frame, same as 01/02). Rows (each with its own Refs · Mobbin card on the left and Micro-interactions card on the right; each section ends with its own Logic check card whose **FLAG — PROPOSALS** block in text/brand lists that section's [P]s from §7 and the dummy-data note of §2.0):
1. Place sheet: 04.01–04.11, 04.49, 04.50
2. Pushed details, directions, call: 04.12–04.17
3. Reviews: 04.18–04.21
4. Book a slot: 04.22–04.34
5. Vehicle: 04.35–04.40, 04.51, 04.52
6. Confirm + booked: 04.41–04.43
7. Submit errors: 04.44–04.48, 04.53

---

## 2. Screens & states

### 2.0 Shared geometry and rules

**Story data (brief).** Station GreenVolt · DHA Phase 5 · Street 12, Block CCA, DHA Phase 5, Lahore · Type 2 (AC) 7.4 kW · Rs 42/kWh · 4.8★ · 1.2 km · Available. Driver Ayesha Khan. Vehicles: BYD Atto 3 (primary) · 60.5 kWh · Type 2 + CCS 2 · LEB-2481; MG ZS EV · 51 kWh · Type 2 + CCS 2 · LEA-9034. Booking: Today, Sat 4 Oct · 6:00 → 7:00 PM · 1 h · BYD Atto 3. Host "Bilal".

**Added dummy data for this flow (flag on the logic card as dummy, not a proposal):**
- Review counts: GreenVolt **36 reviews** (5★ 30 · 4★ 5 · 3★ 1 · 2★ 0 · 1★ 0 → average 4.8); Gulberg Galleria **21 reviews**; Johar Town Fast Hub **12 reviews**.
- Third vehicle, used only to show incompatibility: **Nissan Leaf · 40 kWh · Type 1 + CHAdeMO · LEC-7720** (a common Japanese import in Pakistan; AddEditVehicle offers Type 1 and CHAdeMO, so this is a valid vehicle).
- Today's availability at GreenVolt (now = 3:40 PM): station open 8 AM–11 PM; past until 3:45 PM; booked 3:30–5:00 PM; **free 5 PM–8 PM (3h)**; booked 8–9 PM; **free 9 PM–11 PM (2h)**; peak 5 PM–9 PM. Tomorrow (Sun 5): free "8 AM – 1 PM · 5h", "3 PM – 11 PM · 8h". Fri 10: fully booked. Wed 8: closed.
- Cost per duration at Rs 42/kWh, 7.4 kW, 92% (brief maths, label "Estimate"): 15 min Rs 71 · 30 min Rs 143 · 45 min Rs 214 · **1 h Rs 286** · 1.5 h Rs 429.
- Reviews: Sana R. · September 28, 2026 · 5★ · "Easy to find inside the block and the host replied in minutes. Charged 6 to 7 while I had chai nearby." / Usman K. · September 21, 2026 · 5★ · "Steady 7.4 kW the whole hour. The cable reaches a front-parked car." / Driver · September 14, 2026 · 4★ · (no body) / Hira M. · August 30, 2026 · 5★ · "Booked on the way home and the slot was free on time."
- Host phone for the Call [P] sheet: "0321 4567890".
- "State demo" frames (Paused, Maintenance, hourly price, no location, no reviews) use GreenVolt with the frame label suffix `(state demo)` so the story stays one station. Hourly demo price: "Rs 300" "/hr" (same value as 02.31 row 7); 1 h booking = Rs 300.
- Vehicle plug strings follow 08 ("Type 2, CCS 2 · 60.5 kWh", the AddEditVehicle tile name); station connector labels follow the brief/02 ("CCS2 (DC)", "Type 2 (AC)"). This split is deliberate and matches 02 and 08.

**Map frames (place sheet over map).**
| Layer | Position / size | Component / override |
|---|---|---|
| Map | 402×874 rect named `Map`, fills copied from 996:430 | camera shifted so the selected pin sits in the centre of the visible map above the sheet |
| Selected pin | ≈ (180, 214) at medium; hidden under the dim at large | `Map Pin` Available selected 974:238, `Price#974:0` "Rs 42" |
| Other pins | dummy set from 02 §2.0 (Rs 68 In use, Rs 38, Rs 55 Unavailable, Rs 40, Rs 45) | `Map Pin` default variants |
| User location | ≈ (128, 300) | `User Location` 974:264 |
| Status bar | (0,0) | `iOS / Status Bar` Dark 996:398 |
| Saved heart + bell | (16,60), (68,60) | `Icon Button` Glass M 979:277 (logic: chrome always on top) |
| Map Controls | (339,60) | `Map Controls` Mode=Map 975:228 (visible at medium; at large they sit under the dim) |
| Tab bar, search, chips | hidden: the sheet is modal over the tab bar [P1 in §7] | — |
| Sheet | medium: (0,404) 402×470 · large: (0,62) 402×812 | Rect `Sheet` fill bg/surface, top radius radius/sheet 38, effect Frost/Elevated, grabber 36×5 bg/fillStrong radius pill centred 5pt below the top edge |
| Dim at large | rect 402×874 `bg/scrim` between map and sheet, bound to the variable as is (the alpha lives in the variable; never override opacity, brief sheet rule) | — |
| Home indicator | (0,840) | `iOS / Home Indicator` Dark 996:425 |

**Sheet header (all place-sheet frames).** `Sheet Header` Place 1008:401 at sheet top + 16, width 402: `Title#1008:0` station name (Title 2, max 2 lines), `Subtitle#1008:3` full address (Subheadline, text/secondary, **2 lines at both detents**: logic preview sheet shows "Address (2 lines)"; the draft's 1-line medium truncated the story address to "Street 12, Block CCA, DHA Phase…"). Trailing cluster: `Icon Button` Fill S 979:286 Icon square.and.arrow.up 1024:503 (**Share** [P]) at x 306 and Fill S Icon xmark 958:72 (**Close**) at x 352 (00-system: Fill on opaque sheets). If 1008:401 has its own close, use it and add Share to its left. Title width max 280.

**Quick actions row.** Auto-layout 370 wide, gap 8, 4× `Quick Action Tile` (FILL width, ≈ 86.5 each):
1. Primary 1008:423, `Icon#1008:6` calendar 958:39, label "Book now" (real).
2. Tinted 1008:427, Icon arrow.triangle.turn.up.right.diamond.fill 1024:496, label "Directions" (real).
3. Tinted, Icon phone.fill 1024:476, label "Call" [P3].
4. Tinted, Icon heart 958:49, label "Save" [P label; logic is the heart toggle]. Saved state: Icon heart.fill 981:289 in icon/brand, label "Saved".

**Stats Row** `Stats Row` 1008:432, 370 wide, labels on top (Apple Maps), values in Display/S:
| Col | Label (`Label 1–4`) | Value (`Value 1–4`) | Notes |
|---|---|---|---|
| 1 | "Status" [P label] | "Available" in text/available (In use → text/inUse, Offline → text/offline, Paused / Maintenance → text/warning) | Replaces the logic status pill in the sheet; Station Card and list keep the pill. |
| 2 | "36 reviews" (real format: "No reviews yet" / "1 review" / "N reviews") | "4.8", `Rating star#1008:17` = true ("N/A" when none, star off) | Tappable → Reviews (logic: rating card tappable). Value underlined only for VoiceOver hint; visually a chevron-less tap. |
| 3 | "Distance" | "1.2 km" ("N/A" without GPS, logic) | — |
| 4 | "Per kWh" | "Rs 42" ("Per hr" when hourly; "N/A" when no price) | From the connector price (the logic has no station-level price). Several connectors with different prices → value "From Rs 42" (lowest) [P37]; mixed kWh and hourly pricing → the column shows the first connector's unit. |

Connector count (logic stat "Connectors: count") moves to the trailing side of the Connectors header: Headline "Connectors" + Footnote text/secondary "1".

**Connector Row** `Connector Row` 370 wide: Available 1008:454 / In use 1008:466 / Unavailable 1008:478, `Plug#1026:0` = ev.plug.ac.type.2 981:294 / ev.plug.dc.ccs2 1024:482 / ev.plug.dc.gb.t 1024:484. Text: plug label "Type 2 (AC)", subtitle "{maxPowerKw} kW · {status}" → "7.4 kW · Available", price "Rs 42", unit "/kWh". Rows separated by List Row-style hairlines inset 58.

**Book a slot frames.** Sheet at large detent (0,62). `Sheet Header` Form 1008:413 at (0,78): `Title#1008:0` "Book a slot", `Subtitle#1008:3` hidden/empty; leading `Icon Button` Fill S 979:286 chevron.left 1025:481 (back to the station, level 2), trailing Fill S xmark (close the whole sheet). Pinned `Cost Footer` 1011:479 at (0,762) 402×112 (Frost Strong + top hairline, includes home-indicator inset). When `Show cost` is on, a 16pt `info.circle` 1025:472 (icon/tertiary, 44pt hit area) trails the amount [P35]: it opens the brief's estimate line "Estimate. The charger's meter decides the final amount." (every booking amount is an estimate; the billed amount comes from the meter). Toasts float 12pt above the footer: bottom edge at y 750.

**Toast placement where there is no footer** (place sheet, pushed details without the pill, Directions failures): bottom edge at **y 828** (12pt above the home-indicator area at 840, same as 02's Saved chargers). With the Floating Action Pill visible (04.03, 04.12): bottom edge at y 760 (12pt above the pill).

**Over-mesh rule.** Only 04.12/04.13/04.43 use a mesh. 04.12 and 04.13 use Mesh Quiet (normal text colours; every card `bg/frostStrong` + Frost/Card, the same card fill as 02.15/02.20 lists on Quiet). 04.43 uses Mesh Celebrate: status bar Dark (top glow, measured rule), nothing else sits directly on the mesh: the pass is its own surface and all copy sits on the Surface success sheet. No frame in this flow puts text/secondary, or a 68% Frost card, on a Hero or Celebrate mesh.

**Bottom margin rule.** Every bottom-pinned button ends at y ≤ 824 (16pt above the home-indicator area at 840, brief template). The Floating Action Pill is floating chrome and ends at 828 (12pt, like toasts).

### 2.1 Frame table

Priority: **P1** must build tonight; **P2** if time allows.

#### Row 1 · Place sheet (map)

| # | Frame | Pri | Background | Layout top → bottom (instances + overrides) | New |
|---|---|---|---|---|---|
| 04.01 | `04.01 · Station · Sheet · Medium` | P1 | Map | Map frame (§2.0) with the sheet at medium (0,404). Grabber (183,409). Sheet Header Place at (0,420) h ≈ 76: "GreenVolt · DHA Phase 5" / "Street 12, Block CCA, DHA Phase 5, Lahore" (2 lines, logic) + Share [P] + Close. Quick actions at (16,508) h 64. `Stats Row` at (16,588) h 52: Status "Available" · "36 reviews" 4.8★ · Distance "1.2 km" · Per kWh "Rs 42". Hairline stroke/separator (16,656) 370. Connectors header at (16,672): "Connectors" + "1". `Connector Row` Available at (16,700): Type 2 · "Type 2 (AC)" · "7.4 kW · Available" · "Rs 42" "/kWh". Peek of next section: Headline "Photos" [P] at (16,784), clipped by the frame. Home indicator. | none |
| 04.02 | `04.02 · Station · Sheet · Large` | P1 | Map + `bg/scrim` dim | Sheet at (0,62). Grabber (183,67). Header at (0,78), subtitle 2 lines. Quick actions (16,158). Stats Row (16,238). Connectors header (16,310) + Connector Row (16,338). **Photos [P5]** header (16,422) "Photos" + 3 placeholder tiles (16,450) 136×96 radius md gap 8 (third peeks, horizontal scroll); each = bg/fill + ev.charger 1024:478 in icon/tertiary 24 centred. **Host** header (16,566) "Host" (real) + host row (16,594) 370×64: **Avatar** M "B" + Headline "Bilal" + Footnote secondary "Charger host" (label from booking details; logic detail shows initials + name only) [P7 label]. **Reviews** header (16,678) "Reviews" + trailing Footnote Emph text/brand "See all" [P6]. **Rating Summary** (16,706) compact: Display/M "4.8" + one star.fill 958:52 16 icon/brand (logic "★ average"; five whole stars would round 4.8 up to 5) + Footnote secondary "Based on 36 reviews" (real). Clipped at 874. | Avatar, Rating Summary, Photo placeholder |
| 04.03 | `04.03 · Station · Sheet · Large · Scrolled` | P1 | Map + `bg/scrim` dim | Sheet (0,62), content scrolled 330pt. **Collapsed header**: grabber + Headline "GreenVolt · DHA Phase 5" (1 line) at (16,80) + Share + Close; hairline under header (scroll-edge). Visible: Host row (16,130); Reviews header (16,214); Rating Summary (16,242) h 64 with **[P] distribution bars** (5→1: 30/5/1/0/0); 2× **Review Row** (16,322) Sana R. and (16,436) Usman K. (bodies 3 lines max + "More"); **Address** row (16,560): `List Row` Navigation 983:339, `Icon glyph` mappin 1025:485, Title "Street 12, Block CCA, DHA Phase 5, Lahore" (2 lines), Subtitle "Get directions" [P] → opens Directions. **Floating Action Pill** 1008:491 at (20,772) 362×56, `Show action 2#1008:18` = true: action 1 "Book now" (primary, **2/3 of the pill width**), action 2 "Directions" (secondary, 1/3) (logic bottom CTA bar: Directions secondary + Book now 2× width). | Review Row |
| 04.04 | `04.04 · Station · Sheet · Large · Loading details` | P2 | Map + dim | As 04.02. Header, quick actions, Stats Row status/distance/price and Connector Row render from the preview data immediately. Rating value and label, Host row and Reviews block show **skeleton** bars (bg/fill, radius xs, shimmer) [P11], only if the detail call takes longer than a 150 ms grace (02 rule) and then for at least 600 ms. | Skeleton (utility) |
| 04.05 | `04.05 · Station · Sheet · Couldn't load` | P1 | Map + dim | Sheet large. Header (name from preview) + Close. Body: `State View` Error 1072:588 centred at y≈380: Icon exclamationmark.triangle.fill 1025:474, Title "Failed to load station details" (real), message "Check your connection and try again." [P, replaces raw error text], `Show action#1072:0` on → `Button / Medium` Primary 978:428 "Retry" (real) + below it `Button / Medium` Tertiary 978:488 "Go Back" (real). | none |
| 04.06 | `04.06 · Station · Sheet · In use (DC)` | P1 | Map, Rs 68 pin → In use selected 974:244 | As 04.01 for **Gulberg Galleria Charger** / "Main Boulevard, Gulberg III" · Stats: Status "In use" (text/inUse) · "21 reviews" 4.6★ · "3.4 km" · "Rs 68". `Connector Row` In use 1008:466, Plug ev.plug.dc.ccs2: "CCS2 (DC)" · "60 kW · In use" · "Rs 68" "/kWh". Book now stays enabled (a later slot is bookable). | none |
| 04.07 | `04.07 · Station · Sheet · Paused (state demo)` | P1 | Map | As 04.01 with Status "Paused" (text/warning). **Inline Notice** Warning [P9 placement] at (16,508) 370×~60: icon exclamationmark.triangle.fill (status/warning), text "This station is currently paused and not accepting new bookings" (real copy, from submit). Quick actions move down 72 to (16,580), Stats Row to (16,660), the Connectors block follows; **Book now tile disabled** (40% content, no press, no haptic) [P9; logic only blocks at submit; same rule as 02-P19 on the floating card]. Directions / Call / Save stay live. | Inline Notice |
| 04.08 | `04.08 · Station · Sheet · Offline` | P2 | Map, Rs 55 pin → Unavailable selected 974:251 | **Johar Town Fast Hub** · "Johar Town, Lahore" · Status "Offline" (text/offline) · "12 reviews" 4.4★ · "7.8 km" · "Rs 55". Inline Notice Info [P copy]: icon info.circle 1025:472, "This charger is offline right now. You can still book a later slot." `Connector Row` Unavailable 1008:478, CCS2: "CCS2 (DC)" · "30 kW · Offline" · "Rs 55". Book now enabled (logic: offline not blocked client-side). | — |
| 04.09 | `04.09 · Station · Sheet · No reviews, no location (state demo)` | P2 | Map centred on Lahore, no user dot | As 04.01 with Stats col 2 Label "No reviews yet" Value "N/A" (star off), col 3 Value "N/A" (logic: distance from GPS only). Without a GPS fix the Directions sheet omits its "{km} · ~{min} min drive" line (logic: optional), see 04.14 note. | — |
| 04.10 | `04.10 · Station · Sheet · Saved` | P2 | Map | As 04.01, Save tile → heart.fill icon/brand, label "Saved" [P3]. No toast (success is the tile itself). | — |
| 04.11 | `04.11 · Station · Sheet · Couldn't save` | P2 | Map | As 04.01, Save tile back to "Save" (reverted). `Toast` Error 1088:626, x 16, bottom edge at y 828 (§2.0 toast placement): `Message#1088:0` "Could not update saved state: …" (real, 2 lines with the error text → 6 s), `Action#1088:5` off. | — |
| 04.49 | `04.49 · Station · Sheet · Maintenance (state demo)` (row 1, added in review) | P2 | Map, Rs 42 pin → Unavailable selected 974:251 (02 status table: Maintenance = Unavailable pin) | As 04.01 with Status "Maintenance" (text/warning, 02 status table). `Connector Row` Unavailable 1008:478: "Type 2 (AC)" · "7.4 kW · Maintenance" (real "{kW} kW · {status}") · "Rs 42" "/kWh". **No notice and Book now enabled** (logic: "Offline and maintenance stations are not blocked client-side (?)"; 02.31 row 5 does the same). | — |
| 04.50 | `04.50 · Station · Sheet · Hourly price (state demo)` (row 1, added in review) | P2 | Map, pin label "Rs 300" | As 04.01 with Stats col 4 Label "Per hr", Value "Rs 300"; `Connector Row` price "Rs 300" unit "/hr" (logic fallback). Note on the frame: Book a slot then quotes "Rs 300 · Ends 7:00 PM" for 1 h; price ≤ 0 → Stats "N/A" and Book a slot ends at "Pricing unavailable" (04.40). | — |

#### Row 2 · Pushed details, directions, call

| # | Frame | Pri | Background | Layout | New |
|---|---|---|---|---|---|
| 04.12 | `04.12 · Station details · Pushed (from Saved)` | P1 | Mesh Quiet 951:7417 | Status bar Dark. `Nav Bar` Inline 1087:607 at (0,54): `Title#1087:0` "" (title appears on scroll), `Leading#1087:3` on (chevron.left), `Trailing 1#1087:6` on → "Trailing button 1" Icon heart.fill 981:289 (saved, icon/brand; logic heart toggle), `Trailing 2#1087:9` on → Icon square.and.arrow.up [P]. **Large Title** (34 Medium, brief: screen titles = Large Title) "GreenVolt · DHA Phase 5" at (16,122) (00-system content start; every y below it in this row moves +8), 2 lines max (≈ 82). Row (16,204): mappin 16 icon/secondary + Subheadline text/secondary "Street 12, Block CCA, DHA Phase 5, Lahore" (2 lines; logic: "Address with pin icon"). Card (16,256) 370×84 radius lg holding `Stats Row` (Status · reviews · Distance · Per kWh, as 04.01). Card (16,356): "Connectors" header + "1" + Connector Row. Card: "Host" + host row (Avatar M "B", "Bilal", "Charger host" [P7]). Card: Reviews header + "See all" [P6] + Rating Summary compact + 1 Review Row. All cards `bg/frostStrong` + Frost/Card, radius lg, gap 16 (§2.0 over-mesh rule). `Floating Action Pill` at (20,772): "Book now" (2/3) + "Directions" (1/3). Home indicator. No tab bar (pushed route). | — |
| 04.13 | `04.13 · Station details · Pushed · Loading` | P2 | Mesh Quiet | Nav Bar Inline (back only, title empty). `State View` Loading 1072:584 centred, title hidden (logic: "blank app bar plus spinner"). | — |
| 04.14 | `04.14 · Directions` | P1 | 04.01 composition + bg/scrim | Place sheet stays at medium, dimmed and scaled to 0.96 behind (iOS stacked sheet). `Sheet / Directions` 1012:569 at the bottom, 402 wide. Overrides (real): title "Open in Google Maps", body "Get turn-by-turn directions to GreenVolt · DHA Phase 5", meta "1.2 km · ~2 min drive" (35 km/h estimate, logic: 1.2 km ÷ 35 km/h = 2.06 min), `Button / Large` Primary "Open Google Maps", Tertiary "Cancel" (Tertiary ends at y ≤ 824). Frame note: without a GPS fix the meta line is omitted (logic "optional"); [P26] on iOS without Google Maps installed a Secondary "Open in Apple Maps" button is added above Cancel (flag only, not drawn). | — |
| 04.15 | `04.15 · Directions · No coordinates` | P2 | 04.01 | Directions tile back at idle; `Toast` Error, x 16, bottom edge y 828: "Station location is not available" (real, 1 line → 4 s). No sheet opens. On 04.12 / 04.03 the same toast sits 12pt above the Floating Action Pill (bottom edge y 760). | — |
| 04.16 | `04.16 · Directions · Couldn't open Maps` | P2 | 04.01 (Directions sheet dismissed) | `Toast` Error, x 16, bottom edge y 828: "Could not open Maps…" (real). Frame note: the other real failure string "Error opening maps…" uses the same toast. | — |
| 04.17 | `04.17 · Call host · proposal` | P2 | 04.01 + bg/scrim | Stacked sheet = `Sheet / Action` **Kind=Call** State=Number (00-system C3; the Manual Call Sheet, same as 09.30), leading-aligned: sheet top 482, grabber at 487; 56 well bg/tint + phone.fill 1024:476 icon/brand 28 at (16,506); Title 2 "Call Bilal" (real pattern "Call {name}") at (16,578); Body text/secondary, 3 lines max, (16,614) w 370: "You'll leave PakPlug and call Bilal at 0321 4567890 using your phone's dialer." (real pattern); `Button / Large` Primary Default at (16,712), Leading icon phone.fill, "Call"; `Button / Large` Tertiary at (16,772) "Cancel" (ends 824). No-number variant note (State=No number): "Bilal hasn't added a phone number yet. Send them a message instead." with Call Disabled 978:291 (real). Dummy number "0321 4567890" is shared with 07.30 / 09.30. | (Manual Call Sheet, from 09) |

#### Row 3 · Reviews (pushed inside the sheet, large detent)

| # | Frame | Pri | Background | Layout | New |
|---|---|---|---|---|---|
| 04.18 | `04.18 · Reviews` | P1 | Map + dim | Sheet (0,62). Grabber. `Sheet Header` Form at (0,78): Title "Reviews" (real), Subtitle "GreenVolt · DHA Phase 5", leading back Fill S chevron.left, trailing Close. **Rating Summary** large (16,150) 370×132, bg/grouped radius lg, padding 16: Display/L "4.8" + star.fill 958:52 (icon/brand) 24 (logic "★ average"), Footnote text/secondary "Based on 36 reviews" (real), [P] 5 distribution bars on the right (Caption 2 labels 5…1, bar track bg/fill 6pt, fill brand/primary, counts Caption 2 text/tertiary 30/5/1/0/0). 4× **Review Row** from y 298, separators inset 16: Sana R. (body 3 lines + "More" [P31]) · Usman K. · Driver (no body; avatar shows the person.crop.circle glyph instead of initials [P32]) · Hira M. (cut by frame). Home indicator. | Rating Summary (L), Review Row |
| 04.19 | `04.19 · Reviews · Loading` | P2 | Map + dim | Header as 04.18. `State View` Loading 1072:584 centred at y≈420: Title "Loading reviews…" (real), message hidden, no action. | — |
| 04.20 | `04.20 · Reviews · Empty (state demo)` | P1 | Map + dim | Header. Rating Summary Empty: "N/A" Display/L text/tertiary, "Based on 0 reviews" (real pattern), bars hidden. `State View` Empty 1072:573 below: Icon star 1025:492, Title "No reviews yet", message "No reviews yet for this station." (real), no action. | — |
| 04.21 | `04.21 · Reviews · Couldn't load` | P1 | Map + dim | `State View` Error 1072:588 centred at y≈420: Icon exclamationmark.triangle.fill, Title "Couldn't load reviews" [P33 title], message "Failed to load reviews. Please try again." (real), `Button / Medium` Primary 978:428 "Retry" (real). | — |

#### Row 4 · Book a slot (inside the sheet, large detent)

All Book frames share: Map + dim background, sheet (0,62), grabber, Sheet Header Form "Book a slot" (§2.0), Cost Footer (0,762), home indicator Dark.

Content stack (scroll), top → bottom, x 16, width 370, section gap 24:
1. **Readout** `Time Window` 1011:440 (h ≈ 104): eyebrow Caption 1 Emph text/secondary "TODAY · SAT 4 OCT" [P13]; `Start#1011:0`, `End#1011:1` in Display/M, `Duration#1011:2` Footnote Emph on a bg/tint capsule between them. States (new variant `State`): Empty → Start "—", End "—", Duration "Pick a time" (text/tertiary); Duration only → "—" / "—" / "1 h"; Start only → "7:15 PM" / "—" / "Pick a duration"; Set → "6:00 PM" / "7:00 PM" / "1 h". On scroll it collapses into a sticky **compact** bar (variant `Size=Compact`, h 44, bg/frostStrong, under the header): Headline "6:00 → 7:00 PM" + Footnote text/secondary "Today · 1 h". [P presentation: concept D time-first readout]
2. **Station card** (logic section 1): `List Row` Value 983:352 inside a bg/grouped radius md container: `Icon glyph` ev.plug.ac.type.2, Title "GreenVolt · DHA Phase 5", `Subtitle#983:10` "Street 12, Block CCA, DHA Phase 5, Lahore · Type 2 (AC) · 7.4 kW" (2 lines), value "Rs 42/kWh". Logic meta line is `"{address} · {connector} · {kW} kW · Rs X/kWh|/hr"`; price moves to the value slot. Logic: "An encrypted-looking address is hidden" → the subtitle then starts at the connector: "Type 2 (AC) · 7.4 kW" (1 line); the row never shows a cipher string.
3. `List Group Header` 983:389 `Label#983:20` "DATE" + **Date strip**: 7× `Date Pill` (Selected 1011:430 / Default 1011:433 / Disabled 1011:436), gap 8, horizontal scroll, last pill peeks: "Today" 4 · "Sun" 5 · "Mon" 6 · "Tue" 7 · "Wed" 8 · "Thu" 9 · "Fri" 10. (Wed 8 = closed day still selectable: logic shows "Station is closed on this day" after selecting; it is *not* Disabled.)
4. `List Group Header` "WHEN" + trailing **Peak note**: 6pt dot status/warning + Footnote text/secondary "Peak 5 PM–9 PM" (real).
5. **Duration chips**: 5× `Chip` Fill/No 970:164 / Fill/Yes 970:175, `Label#970:0` "15 min", "30 min", "45 min", "1 h", "1.5 h" (real); dimmed = new Chip variant Fill/Disabled. Hint Footnote text/secondary "Longest here: 3h" (real pattern "Longest here: {Xh Ym}"), shown whenever the duration chips are shown (the logic gives no hidden state): with nothing picked it is the longest free window of the day; with a start picked it is the longest duration that fits from that start (04.29 "45m").
6. Footnote Emph text/secondary "Day availability" (real) + `Availability Bar` 1011:449 (370 wide): track 12 AM–12 AM; segments past (bg/fillStrong hatched), unavailable/booked (bg/fillStrong), free (status/availableTint with status/available top edge), peak tint band 5–9 PM (status/warningTint overlay), selected window outlined 2pt brand/primary; **now** marker 1pt text/primary at 3:40 PM [P]; axis Caption 2 text/tertiary "12 AM · 6 AM · 12 PM · 6 PM · 12 AM" [P if the component lacks it]; legend "Free · Unavailable · Peak" (real).
7. Footnote Emph text/secondary "Available windows" (real) + window pills: `Chip` Fill/No/Yes/Disabled, labels "5 PM – 8 PM · 3h", "9 PM – 11 PM · 2h" (real format "9 AM – 12 PM · 3h"). Or "No free windows on this day" (real).
8. Footnote Emph text/secondary "Start time" (real) + grid of **Time Chip** (new) 4 columns, chip 86.5×44, gap 8; or placeholder box (bg/fill, radius md, dashed stroke/separator, 370×64) with Footnote text/tertiary "Pick a window above to see start times" (real); fallback "No available times" (real).
9. `List Group Header` "VEHICLE" + **Vehicle Select Row** (= `Vehicle Card` Layout=Row, 00-system C5; 370×64): states in §6.
10. 120pt bottom padding (footer clearance).

| # | Frame | Pri | Scroll / state | Overrides | New |
|---|---|---|---|---|---|
| 04.22 | `04.22 · Book a slot · Loading station` | P2 | — | Body = `State View` Loading: "Loading station…" (real). Footer hidden. | — |
| 04.23 | `04.23 · Book a slot · Couldn't load station` | P2 | — | `State View` Error: Title "Failed to load station" (real), message hidden, `Button / Medium` Secondary "Go back" (real). Footer hidden. | — |
| 04.24 | `04.24 · Book a slot · Start` | P1 | top (offset 0) | Readout Empty at (16,134). Station card (16,254). DATE (16,334) + strip (16,358) h 72, Today Selected. WHEN (16,452) + peak note. Duration chips (16,480) all Fill/No; hint (16,522) "Longest here: 3h" (longest free window today; logic shows the hint with the chips). "Day availability" (16,552) + bar (16,574) h 56. "Available windows" (16,650) + 2 pills (16,674), none selected. "Start time" (16,726) + placeholder box (16,750) "Pick a window above to see start times" (real) — passes under the footer. Footer: `Show cost#1011:5` false, CTA full width `Button / Large` Primary **Disabled** 978:291 "Select a time" (real). | Time Window State, Time Chip, Chip Disabled |
| 04.25 | `04.25 · Book a slot · Window + duration` | P1 | auto-scrolled to the grid (logic: "Selecting one scrolls to the grid") | Compact readout bar (0,130) "— → —" + "Today · 1 h". Visible from WHEN: "1 h" chip Fill/Yes; hint "Longest here: 3h"; bar highlights 5–8 PM; pill "5 PM – 8 PM · 3h" Fill/Yes, "9 PM – 11 PM · 2h" Fill/No; grid 12 chips 5:00 … 7:45 PM: 5:00–7:00 Default, 7:15/7:30/7:45 **Unavailable** ("doesn't fit"). Footer: `Show cost` true, `Amount#1011:3` "Rs 286", `Detail#1011:4` "1 h" (real "Rs min–max · {duration}", single value here), CTA Primary Disabled "Pick a start time" (real). | — |
| 04.26 | `04.26 · Book a slot · Scrubbing start time` | P1 | as 04.25 | Finger (44pt touch marker named `Touch`, documentation only: fill `bg/fillStrong` + 1.5pt `stroke/focus`; a white marker would vanish on the Surface sheet) on the 6:00 PM chip; chip in **Time Chip State=Scrub** (`action/primary` 12% fill + 2pt `action/primary` stroke); **Scrub Loupe** [P] 8pt above the finger: "6:00 PM · ends 7:00 PM". Compact readout live: "6:00 → 7:00 PM" · "Today · 1 h". Bar highlight shows the 6–7 PM sub-range inside the window. Footer previews live: "Rs 286" · "Ends 7:00 PM", CTA label "Confirm booking" Primary Default (the selection commits on release, 4.6-7; vehicle already auto-picked). | Scrub Loupe |
| 04.27 | `04.27 · Book a slot · Ready` | P1 | scrolled to bottom | Compact readout "6:00 → 7:00 PM" · "Today · 1 h". Grid with 6:00 PM **Selected**. "VEHICLE" + Vehicle Select Row Selected: car.fill well, Title "BYD Atto 3 · Type 2 (AC)" (real pattern "{name} · {matching plug label}"), Subtitle "Primary" [P], trailing Footnote Emph text/brand "Change" (real). Footer: Amount "Rs 286" + info.circle [P35], Detail "Ends 7:00 PM" (real "Rs {cost} · Ends {h:mm AM}"), `Button / Large` Primary Default 978:277 "Confirm booking" (real). | Vehicle Select Row, Cost Footer info |
| 04.28 | `04.28 · Book a slot · Full scroll` | P2 | tall frame 402×1480 | Whole content of 04.27 with the full Readout Set (6:00 PM → 7:00 PM, 1 h) at the top, documentation only. | — |
| 04.29 | `04.29 · Book a slot · Start first, longer durations dimmed` | P2 | grid visible | Window "5 PM – 8 PM · 3h" selected, no duration; start **7:15 PM** Selected. Readout "7:15 PM → —" / "Pick a duration". Duration chips: 15/30/45 min Fill/No; "1 h" and "1.5 h" **Fill/Disabled** (logic: "Chips that don't fit from the chosen start are dimmed and disabled"). Hint "Longest here: 45m". Footer `Show cost` false, CTA Disabled "Pick a duration" (real). | — |
| 04.30 | `04.30 · Book a slot · Availability scrub · proposal` | P2 | WHEN visible | Long-press on the bar at ≈ 9:30 PM: loupe above the touch "9:30 PM · Free" ; when over the peak band "6:15 PM · Free · Peak"; over booked "8:15 PM · Unavailable". The window under the finger is pre-highlighted. | Scrub Loupe |
| 04.31 | `04.31 · Book a slot · No free windows` | P1 | top | Date "Fri" 10 Selected. Readout eyebrow "FRI 10 OCT", Empty. Duration chips **hidden** (logic: "shown only if free windows exist"). Bar fully unavailable. Footnote text/secondary "No free windows on this day" (real). [P17] `Button / Medium` Secondary "Go to Sun 5 Oct" (next day with a free window; needs availability for the other 6 strip days, fetched lazily after the empty result, button hidden if none of the 7 days has a window). Grid placeholder hidden. Footer CTA Disabled "Select a time". | — |
| 04.32 | `04.32 · Book a slot · Closed this day` | P2 | top | Date "Wed" 8 Selected. Under WHEN: **Inline Notice** Neutral: clock 958:88 + "Station is closed on this day" (real). Everything else under WHEN hidden. CTA Disabled "Select a time". | — |
| 04.33 | `04.33 · Book a slot · Times loading` | P2 | top | Date "Sun" 5 just tapped. Under WHEN: compact spinner (system medium) centred in a 370×120 area (logic: "compact spinner"). | — |
| 04.34 | `04.34 · Book a slot · Times error` | P2 | top | Under WHEN: Inline Notice Error: "Error loading available times: …" (real) + [P17] action "Retry". Duration chips, bar, windows and grid hidden; footer CTA Disabled "Select a time". | — |

#### Row 5 · Vehicle

| # | Frame | Pri | Background | Layout | New |
|---|---|---|---|---|---|
| 04.35 | `04.35 · Choose vehicle` | P1 | 04.27 behind (scaled 0.96, dimmed bg/scrim) | `Sheet / Choose vehicle` 1014:509 at medium height. Title "Choose vehicle" (real). Rows: **BYD Atto 3** · "Primary" pill · subtitle "Type 2, CCS 2 · 60.5 kWh" (real pattern "plugs · battery") · trailing checkmark 958:91 icon/brand (selected). **MG ZS EV** · "Type 2, CCS 2 · 51 kWh". **Nissan Leaf** · disabled (title text/secondary, icon icon/tertiary, no press) · subtitle in text/warning with exclamationmark.triangle.fill 12: "Doesn't fit this charger (Type 2 (AC))" (real). Footer row/button "Add vehicle" (real) with plus 958:75. | — |
| 04.36 | `04.36 · Choose vehicle · Empty` | P2 | as 04.35 | Body `State View` Empty, Icon car.fill: Title "No vehicles added yet." (real), `Show action` on → "Add vehicle". | — |
| 04.37 | `04.37 · Choose vehicle · Couldn't load` | P2 | as 04.35 | `State View` Error: message "Couldn't load vehicles. Try again, or add one." (real); actions Primary "Retry" [P33 label: logic only says "Try again" in the copy] + Tertiary "Add vehicle" (real). | — |
| 04.38 | `04.38 · Book a slot · No vehicle` | P1 | scrolled to bottom | Times as 04.27 (6:00 PM, 1 h). Vehicle Select Row **Error-None**: car well icon/tertiary, Title "No vehicle added" (real), trailing "Add" (real); 1.5pt stroke/error outline; error line Footnote text/error "Add a vehicle to book this charger" (real). Footer: "Rs 286" · "Ends 7:00 PM", CTA `Button / Large` Primary Default "Add a vehicle" (real; first row of the CTA table wins). Frame note: a **vehicle-load error renders exactly like this** (logic: "Error, or no vehicles: 'No vehicle added' with Add"). | — |
| 04.39 | `04.39 · Book a slot · No matching vehicle` | P1 | scrolled to bottom | Driver has only the Nissan Leaf. Vehicle Select Row **Error-Mismatch**: Title "Choose your vehicle" (real) + "Change" (real), red outline, error line "None of your vehicles match this charger" (real). CTA Primary "Add a vehicle". | — |
| 04.40 | `04.40 · Book a slot · Pricing unavailable` | P2 | scrolled to bottom | Everything set; footer `Show cost` false, CTA Disabled "Pricing unavailable" (real override row: every hourly rate ≤ 0). | — |
| 04.51 | `04.51 · Book a slot · Vehicle loading` (row 5, added in review) | P2 | scrolled to bottom | Times as 04.27. Vehicle Select Row **State=Loading**: system spinner in the 40 well + Skeleton Block M where the title goes, no action label (logic: "Loading: spinner"). Footer: "Rs 286" · "Ends 7:00 PM", CTA "Confirm booking" Primary **Disabled** until the vehicle resolves (the CTA table needs the vehicle row to decide between "Add a vehicle" and "Confirm booking"). | — |
| 04.52 | `04.52 · Choose vehicle · Loading` (row 5, added in review) | P2 | as 04.35 | `Sheet / Choose vehicle` with title "Choose vehicle" and body `State View` Loading 1072:584 (title hidden, logic "loading"); footer "Add vehicle" stays live. | — |

#### Row 6 · Confirm + booked

| # | Frame | Pri | Background | Layout | New |
|---|---|---|---|---|---|
| 04.41 | `04.41 · Confirm booking` | P1 | 04.27 behind (scaled 0.96 + bg/scrim) | `Sheet / Confirm booking` 1012:594: Title "Confirm booking", subtitle "Review your charging slot before you book." (real). Rows: Date "Oct 4, 2026" (real format "MMM d, yyyy"); Time "6:00 – 7:00 PM" ([P18] 12-hour; logic format "HH:mm – HH:mm" = "18:00 – 19:00"); Duration "1 hour" (real format); Total "Rs 286" in Display/S. [P19] Footnote text/secondary under Total: "Estimate. The charger's meter decides the final amount." (brief estimate copy). Buttons: `Button / Large` Primary "Confirm booking", Tertiary "Back" (real); Tertiary ends at y ≤ 824. | — |
| 04.42 | `04.42 · Confirm · Booking` | P1 | as 04.41 | Primary → Loading 978:298 (spinner, label hidden), "Back" → Tertiary Disabled 978:351, grabber hidden (sheet not dismissable while submitting). | — |
| 04.43 | `04.43 · Booked · Pass appears · proposal` | P1 | Mesh Celebrate 951:7418 | Status bar Dark. `Charging Pass` Front Upcoming 1010:441 centred at (24,96) scaled to 354 wide, tilt 0, Shadow/Pin: station "GreenVolt · DHA Phase 5", date "Today, Sat 4 Oct", times "6:00 PM → 7:00 PM", "1 h", vehicle "BYD Atto 3", connector "Type 2 (AC)". **Success sheet** = `Sheet / Action` Kind=Info, Well tone Success, no Close (00-system C3) at (0,476) 402×398, grabber at 481: well 56 `status/availableTint` 948:77 + checkmark.circle.fill 1025:506 28 `status/available` at (16,500); Title 2 "You're booked" [P20] (16,572); Body text/secondary "We'll hold 6:00 to 7:00 PM for you at GreenVolt · DHA Phase 5." [P20] (16,608, 2 lines); info row (16,664): clock 958:88 icon/secondary + Footnote text/secondary "Start charging within 15 minutes of 6:00 PM." [P21 copy of the logic ±15-minute start window]; `Button / Large` Primary "View in Bookings" [P20 label] (16,712); `Button / Large` Tertiary Leading icon arrow.triangle.turn.up.right.diamond.fill "Get directions" [P20] (16,772, ends 824). The pass above ends by y 460, so nothing overlaps. Home indicator Dark. | — |

#### Row 7 · Submit errors (on 04.27 after Confirm; toasts at bottom edge y 750)

| # | Frame | Pri | Toast | Screen change | New |
|---|---|---|---|---|---|
| 04.44 | `04.44 · Error · Slot already booked` | P1 | `Toast` Error 1088:626: "This time slot is already booked…" (real); `Action#1088:5` on, `Action label#1088:10` "Pick another time" [P22; logic offers Retry] | [P22] availability refetches: 6:00 PM chip → Unavailable with a 1-shake; readout End/Start clear to "—" (Duration "1 h" stays); footer CTA "Pick a start time" Disabled. | — |
| 04.45 | `04.45 · Error · Station paused` | P1 | `Toast` Warning 1088:621: "This station is currently paused and not accepting new bookings" (real), no action | none (no API call, logic). | — |
| 04.46 | `04.46 · Error · Connection interrupted` | P1 | `Toast` Warning (3 lines): "Connection was interrupted. Your booking may still have been created—open Bookings and pull to refresh before booking again." (real); action "Open Bookings" [P23; logic offers Retry, which risks a double booking] | Confirm CTA stays enabled. 3-line toast is 96pt tall: top at y 654, bottom edge y 750. | — |
| 04.47 | `04.47 · Error · Network` | P2 | `Toast` Error: "Network error…" (real) + action "Retry" (real) | — | — |
| 04.48 | `04.48 · Error · Couldn't calculate cost` | P2 | `Toast` Error: "Unable to calculate cost. Please check station pricing." (real), no action | Confirm sheet does not open. | — |
| 04.53 | `04.53 · Errors · Other submit messages` (row 7, added in review; board, not a phone) | P2 | 402×520 `bg/canvas` board with 4 `Toast` Error 1088:626 stacked (gap 16, x 16), each with `Action#1088:5` on, `Action label#1088:10` "Retry" (real, 6 s): (1) "{server message}" shown as the frame note "Server message, if any (verbatim from the API)"; (2) "Invalid booking details…"; (3) "Station not found."; (4) "Failed to create booking" (all real). Caption 1 text/secondary label above each toast with its trigger. | none (documentation board) | — |

Other real submit messages: server message, "Invalid booking details…", "Station not found.", "Failed to create booking" (all Toast Error 6 s + Retry) are drawn once on the 04.53 board and listed on the logic card.

---

## 3. Real copy (quoted from the logic map) per screen

### 3.1 Place sheet / Station details (04.01–04.13)
- Preview sheet: name · status pill "Available" / "In use" / "Maintenance" / "Paused" / "Offline" · address (2 lines) · connector row: plug label "Type 2 (AC)", subtitle "{maxPowerKw} kW · {status}" (or "N/A"), price "Rs X" with "/kWh" or "/hr" · **View Details** · **Book now**.
- Station detail: heart toggle; error "Could not update saved state: …"; rating "★ value or N/A", label "No reviews yet" / "1 review" / "N reviews"; distance (GPS only, else "N/A"); connectors count; "Connectors"; "Host" (initials avatar + host name); **Directions** · **Book now**; "Station location is not available".
- States: "Failed to load station details", error text, **Retry**, **Go Back**; loading = blank app bar + spinner.
- Used in this flow: "Book now", "Directions", "Connectors", "Host", "Type 2 (AC)", "7.4 kW · Available", "Rs 42", "/kWh", "36 reviews" (format), "No reviews yet", "N/A", "Failed to load station details", "Retry", "Go Back", "Could not update saved state: …", "Station location is not available", "This station is currently paused and not accepting new bookings" (re-used from submit in 04.07).
- **"View Details"** (real) is not a visible button inside the sheet (the sheet *is* the details): it stays on the 02.08 floating card and is the VoiceOver custom action on the medium sheet (4.1-23), so the real label still exists for assistive tech.
- Status values used: "Available", "In use", "Maintenance", "Paused", "Offline" (all five real), connector subtitle "{kW} kW · {status}" → "7.4 kW · Maintenance" (04.49); hourly "Rs 300" "/hr" (04.50).
- Proposed copy: "Status", "Per kWh" / "Per hr", "From Rs 42" [P37], "Call", "Save" / "Saved", "Photos", "See all", "Charger host" (exists in booking details), "Get directions", offline notice, "Check your connection and try again.", "More" [P31].

### 3.2 Directions (04.14–04.16)
- "Open in Google Maps" · "Get turn-by-turn directions to {station}" · "{km} · ~{min} min drive" (35 km/h) → "1.2 km · ~2 min drive" · **Open Google Maps** · **Cancel** · "Could not open Maps…" · "Error opening maps…".

### 3.3 Call host [P3] (04.17), copy re-used from `ManualCallSheet`
- "Call {name}" · "You'll leave PakPlug and call {name} at {number} using your phone's dialer." · "{name} hasn't added a phone number yet. Send them a message instead." · **Call** · **Cancel** · "Couldn't open your phone's dialer."

### 3.4 Reviews (04.18–04.21)
- Title "Reviews" · "★ average (N/A when no reviews)" · "Based on N review(s)" (singular "Based on 1 review", plural "Based on 36 reviews") · reviewer "First L." or "Driver" · date "MMMM d, yyyy" · whole stars · optional body.
- "Loading reviews…" · "Failed to load reviews. Please try again." + **Retry** · "No reviews yet" / "No reviews yet for this station." · pull-to-refresh.

### 3.5 Book a slot (04.22–04.40)
- "Book a slot" · station meta `"{address} · {connector} · {kW} kW · Rs X/kWh|/hr"` (address dropped when it looks encrypted) · DATE / WHEN / VEHICLE · "Today", "EEE" + day number · "Peak 5 PM–9 PM" (first contiguous peak run) · "15 min", "30 min", "45 min", "1 h", "1.5 h" · "Longest here: {Xh Ym}" · "Day availability" · legend "Free / Unavailable / Peak" · "Available windows" · "9 AM – 12 PM · 3h" format · "No free windows on this day" · "Start time" · "Pick a window above to see start times" · "No available times" · "Station is closed on this day" · "Error loading available times: …" · "Loading station…" · "Failed to load station" + **Go back**.
- Vehicle row: "No vehicle added" + **Add** · "Choose your vehicle" + **Change** · "{name} · {matching plug label}" + **Change** · errors "Add a vehicle to book this charger" / "None of your vehicles match this charger".
- Choose vehicle sheet: "Choose vehicle" · "Primary" · "{plugs} · {battery}" · "Doesn't fit this charger ({station plugs})" · **Add vehicle** · "Couldn't load vehicles. Try again, or add one." · "No vehicles added yet."
- Proposed here: "Pick another time" [P22], "Open Bookings" [P23], "Go to {EEE d MMM}" [P17], "Retry" on times error and vehicle picker error [P17/P33], "Couldn't load reviews" [P33], estimate popover line (brief copy) [P35], scrub loupe strings "{time} · ends {time}" / "· Free" / "· Peak" / "Unavailable" [P15/P16].
- Footer: "Rs {cost} · Ends {h:mm AM}" · "Rs min–max · {duration}" · CTAs "Add a vehicle" / "Select a time" / "Pick a start time" / "Pick a duration" / "Confirm booking" / "Pricing unavailable".

### 3.6 Confirm + submit (04.41–04.48)
- "Confirm booking" / "Review your charging slot before you book." · Date "MMM d, yyyy" · Time "HH:mm – HH:mm" · Duration "1 hour" / "N hours" / "N min" · Total "Rs X" · **Confirm booking** / **Back** · "Unable to calculate cost. Please check station pricing."
- "This station is currently paused and not accepting new bookings" · server message · "Connection was interrupted. Your booking may still have been created—open Bookings and pull to refresh before booking again." · "This time slot is already booked…" · "Invalid booking details…" · "Station not found." · "Network error…" · "Failed to create booking" · snackbars 6 s with **Retry**.
- Success: no copy in logic (no success screen). Everything on 04.43 is [P20]/[P21].

---

## 4. Micro-interactions

Format for every rule: **trigger → response · timing/easing · haptic · VO (VoiceOver) · RM (Reduce Motion)**. Press feedback follows 02 §4.0 and is not repeated: Pressed variants on touch-down, haptics fire on **release**, Buttons scale 0.97, Glass Icon Buttons 0.92, Quick Action Tiles / Chips / Date Pills / Time Chips 0.96, cards 0.98 (all `snappy`, settle ≈ 300 ms), list rows get the `bg/fill` highlight with no scale (00-system §2.1); RM replaces every press scale with 85% opacity. Disabled controls have no press state and no haptic. Toast rules are 02 §4.0 (enter from 12pt below with `smooth`, leave `fade.quick`; 4 s for one line without action, 6 s for two lines or any action; submit errors 6 s per logic; one at a time; haptic follows the tone; polite VO announcement; RM fade only). Loading rule (02): spinners/skeletons appear only after a 150 ms grace and then stay ≥ 600 ms.

### 4.0 Tokens added by this flow
- `scrub`: per-step feedback while a finger drags across discrete values. Visual change is instant (no tween) with the readout digits using a numeric content transition (`.contentTransition(.numericText())`, 120 ms). Haptic **selection** on every step change, rate-limited to one tick per 40 ms so fast drags don't buzz continuously.
- `detent`: the sheet follows the finger 1:1; on release it snaps with `smooth` (response 0.45, damping 1.0, settle ≈ 450 ms). Velocity > 500 pt/s jumps to the next detent in the swipe direction; otherwise the nearest detent wins. Rubber-band above large (resistance 0.3). No haptic (system parity with Apple Maps).
- Everything else uses the 02 tokens (`snappy` ≈ 300 ms, `smooth` ≈ 450 ms, `bouncy` ≈ 400 ms, `fade.quick` 150 ms, `fade.std` 220 ms, `camera` 350–500 ms). Reduce Motion: springs and scale become `fade.quick` cross-fades, `scrub` keeps the haptics but drops the digit roll, shimmer stops, number rolls become plain swaps. Reduce Transparency: Frost/Glass → Surface + hairline; the dim stays `bg/scrim`.

### 4.1 Place sheet (04.01–04.11, 04.49, 04.50)
1. **Swipe up on the floating card (02.08)** → the card's frame morphs into the sheet at medium (matched geometry: name, status and connector row keep their identity; the card's View Details/Book now buttons cross-fade into the quick-action tiles) · `smooth` ≈ 420 ms; map camera eases so the pin sits in the centre of the top 404pt (`camera` 350 ms) · haptic none · VO: focus moves to the sheet title (heading trait) and announces "GreenVolt · DHA Phase 5, station details, sheet" · RM: sheet fades in at medium, camera jumps.
2. **View Details on the card** → same morph straight to large; the `bg/scrim` dim fades in with it · `smooth` ≈ 480 ms · haptic light · VO as 1 · RM: fade.
3. **Drag the grabber/sheet medium ↔ large** → `detent`. The dim is interpolated from 0 to the full `bg/scrim` value with sheet position; the Map Controls fade out above 60% travel (opacity linked to position, no tween) · settle ≈ 450 ms · haptic none · VO: the grabber is an adjustable element "Sheet grabber, medium. Swipe up or down to adjust." (system) · RM: snap without overshoot, dim cross-fades.
4. **Drag below medium** → past 120pt or velocity down > 500 pt/s the sheet collapses back into the floating card (reverse matched geometry); further drag on the card dismisses it (02 rule 5) · `smooth` ≈ 450 ms · haptic none · VO: escape (two-finger Z) collapses one level at a time and announces "Station card" · RM: sheet fades out (`fade.quick`) and the card fades in.
5. **Scroll content at large** → after 24pt the header collapses: Title 2 → Headline single line (scale 1 → 0.77 anchored left + cross-fade, driven by scroll offset, not a tween), subtitle fades, a hairline scroll-edge appears under the header. When the quick-action row scrolls under the header, the **Floating Action Pill** rises from y+24 with opacity 0 → 1 · `smooth` ≈ 450 ms (pill only) · haptic none · VO: the pill is announced once when it appears ("Book now, Directions, available at the bottom") and is last in focus order · RM: pill fades, header swaps without scaling.
6. **Pull down at the top of the large content** → scroll hands off to the sheet (iOS `prefersScrollingExpandsWhenScrolledToEdge`) and the sheet settles at medium · `detent`, ≈ 450 ms · haptic none · VO: n/a (VO users use the adjustable grabber or escape) · RM: snap without overshoot.
7. **Press any Quick Action Tile** → scale 0.96 + fill to the pressed token (Primary → `action/primaryPressed`, Tinted → `bg/fillStrong`) · `snappy` ≈ 300 ms, release springs back · haptic per action on release (rules 8–11) · VO: each tile is a button named by its label · RM: 85% opacity instead of scale. **Disabled tile (04.07)**: no press, no haptic; VO "Book now, dimmed. This station is currently paused and not accepting new bookings." (same string as 02 rule 23).
8. **Book now tile** → the sheet content pushes horizontally to Book a slot (sheet-internal navigation, parallax 30%), detent forced to large · `smooth` 350 ms · haptic light (opens Book a slot; medium is for commits, 00-system §2.2) · VO "Book now, button. Opens Book a slot for GreenVolt · DHA Phase 5."; focus lands on the "Book a slot" heading · RM: cross-fade.
9. **Directions tile** → Directions sheet stacks on top (04.14): place sheet scales to 0.96 and dims (`fade.std` 220 ms), new sheet rises · `smooth` ≈ 450 ms · haptic light · VO "Directions, button" → focus on "Open in Google Maps". **No coordinates** → no sheet; Toast Error "Station location is not available" (1 line, 4 s, bottom edge y 828) · haptic **error** · VO: polite announcement · RM: sheet/toast fade only.
10. **Call tile** [P3] → Manual Call Sheet stacks the same way (04.17) · `smooth` ≈ 450 ms, place sheet recedes 0.96 + dim `fade.std` · haptic light · VO "Call, button. Call Bilal, the host." → focus on "Call Bilal" heading · RM: fade.
11. **Save tile** → heart pops 1 → 1.25 → 1 and fills; label cross-fades "Save" → "Saved" · `bouncy` ≈ 400 ms + `fade.quick` · optimistic. On API failure the tile reverts (reverse pop) and Toast Error "Could not update saved state: …" shows (2 lines → 6 s, bottom edge y 828) · haptic **success** on save / light on unsave / **error** on failure · VO: toggle button "Save, not saved" → "Saved"; failure announced politely · RM: no pop, instant fill.
12. **Share** [P3] → system share sheet with "GreenVolt · DHA Phase 5 · Type 2 (AC) · Rs 42/kWh" + a station link (needs a deep link) · system presentation (≈ 350 ms) · haptic light · VO "Share, button" · RM: system.
13. **Close ✕** → sheet slides down to y 874, pin deselects (reverse spring 1.08 → 1), the floating card does **not** reappear, the Home bottom stack and tab bar return (02 rule 5) · `smooth` ≈ 450 ms (pin `bouncy`) · haptic light · VO "Close, button"; focus returns to the pin · RM: sheet fades out, pin deselects instantly.
14. **Tap the rating stat** → pushes Reviews inside the sheet (parallax 30%) · `smooth` 350 ms · haptic light · VO "Rating 4.8 from 36 reviews, button. Opens reviews." · RM: cross-fade.
15. **Tap "See all"** in the Reviews block → same as 14 (VO "See all reviews, button").
16. **Tap the Address row** (large) → Directions sheet as 9 · haptic light · VO "Street 12, Block CCA, DHA Phase 5, Lahore. Get directions, button."
17. **Photos placeholder** [P5] → no action (placeholder only); not focusable for VO; no press state.
18. **Loading details** (04.04) → skeleton bars shimmer (1.2 s linear sweep) after the 150 ms grace; real values replace them with `fade.quick`, the rating value uses a numeric transition (300 ms) · haptic none · VO: skeletons hidden; one polite "Loading details" announcement · RM: static skeletons, values swap without roll.
19. **Error → Retry** (04.05) → State View fades in (`fade.std`), haptic **error** when the error first appears. Retry → `Button / Medium` Primary Loading 978:449 (≥ 600 ms); success cross-fades the content in (`fade.std`); failure: haptic **error**, button returns. **Go Back** collapses the sheet to the floating card (`smooth` ≈ 450 ms), haptic light · VO: title heading trait; "Retry, button", "Go Back, button" · RM: fades.
20. **Pin tap on another station while the sheet is at medium** → the sheet content cross-fades to the new station with a 12pt slide toward the new pin's side, detent unchanged; old pin deselects, new pin selects (`bouncy`); camera eases · `fade.quick` 150 ms + `camera` 350 ms · haptic selection · VO: polite "Now showing Gulberg Galleria Charger", focus moves to the sheet title · RM: cross-fade without slide, camera jumps.
21. **Status-driven tints** → when the station status changes via refetch (e.g., Available → In use), the Status value cross-fades colour and text and the connector row swaps variant · 300 ms ease-out · haptic none · VO: polite "GreenVolt · DHA Phase 5 is now In use" · RM: same cross-fade (colour only, no movement).
22. **Tap the map outside the sheet at medium** (= logic "scrim tap closes") → same as 13. **Tap the dim at large** → sheet settles to medium (`detent`, ≈ 450 ms) · haptic none · VO: the dim is not focusable (escape does the same) · RM: snap.
23. **Tap the grabber** [P36] → toggles medium ↔ large (`smooth` ≈ 450 ms) · haptic none · VO: the sheet container at medium carries two custom actions, **"View Details"** (real label; expands to large) and **"Close"** · RM: snap.
24. **Maintenance / hourly state demos** (04.49/04.50) → no special motion; Book now behaves as 8 (logic: not blocked client-side).

### 4.2 Pushed station details (04.12–04.13)
1. **Push from Saved chargers / booking details** → standard iOS push; the Large Title collapses into the Nav Bar title after 51pt of scroll (system, scroll-driven) · 350 ms system push · haptic light on the originating tap (owned by 02/07) · VO: focus on the "GreenVolt · DHA Phase 5" heading · RM: system cross-fade push.
2. **Heart (Nav Bar Trailing 1)** → as 4.1-11 (pop `bouncy` ≈ 400 ms, optimistic, revert + 6 s toast at bottom edge y 760 above the pill) · haptic success / light / error · VO toggle "Saved" / "Save" · RM: instant fill.
3. **Floating Action Pill** (always visible here; Book now 2/3, Directions 1/3) → Book now pushes full-screen Book a slot (system push 350 ms, haptic **medium**); Directions stacks the Directions sheet (`smooth` ≈ 450 ms, haptic light) · VO "Book now, button" / "Directions, button", last in focus order · RM: cross-fade / fade.
4. **Loading (04.13)** → spinner after the 150 ms grace, ≥ 600 ms; content fades in · `fade.std` 220 ms · haptic none · VO: polite "Loading" · RM: same fade.
5. **Error (pushed)** → same State View as 04.05 (Retry / Go Back); Go Back pops (system 350 ms, haptic light); Retry as 4.1-19.
6. **Rating stat / See all** → pushes Reviews full-screen (system push 350 ms) · haptic light · VO as 4.1-14.

### 4.3 Directions (04.14–04.16)
1. **Sheet appears** (from 4.1-9) → rises from y 874 · `smooth` ≈ 450 ms; the meta "1.2 km · ~2 min drive" counts in with a numeric transition (300 ms) once distance is known; without a GPS fix the meta line is omitted (logic "optional") · haptic light (from the tile) · VO: focus on "Open in Google Maps" heading; meta read "1.2 kilometres, about 2 minutes drive" · RM: fade, no roll.
2. **Open Google Maps** → Pressed, the app hands off (`UIApplication.open`); the sheet dismisses 150 ms after hand-off (`fade.quick`) so it is gone on return · haptic light · VO "Open Google Maps, button. Leaves PakPlug." **Failure** → sheet dismisses (`smooth`), Toast Error "Could not open Maps…" / "Error opening maps…" (4 s, bottom edge y 828) · haptic **error** · RM: fades.
3. **Cancel / swipe down / scrim tap** → dismiss, place sheet scales back to 1 · `smooth` ≈ 450 ms · haptic none · VO: escape = Cancel; focus returns to the Directions tile · RM: fade.
4. **[P26] iOS without Google Maps** → (flag only) a Secondary "Open in Apple Maps" button sits above Cancel; same press and hand-off as 2.

### 4.4 Call host [P3] (04.17 = Manual Call Sheet from 09)
1. **Appears** → stacked sheet rises, place sheet recedes 0.96 + dim · `smooth` ≈ 450 ms + `fade.std` · haptic light (from the tile) · VO: focus on "Call Bilal" heading, body read in full · RM: fade.
2. **Call** → Manual Call Sheet State=Opening (Button Loading 978:298, ≤ 600 ms) while `tel:` opens; iOS shows its own call confirmation; the sheet dismisses on hand-off (`fade.quick`) · haptic light · VO "Call, button. Leaves PakPlug." **Failure** → Toast Error "Couldn't open your phone's dialer." (4 s) · haptic **error** · RM: fades.
3. **No number** → Call is Disabled 978:291 (no press, no haptic), body uses the no-number copy · VO "Call, dimmed. Bilal hasn't added a phone number yet. Send them a message instead."
4. **Cancel / swipe down** → dismiss · `smooth` ≈ 450 ms · haptic none · VO: escape = Cancel, focus back to the Call tile · RM: fade.

### 4.5 Reviews (04.18–04.21)
1. **Push in** (sheet-internal, `smooth` 350 ms) → the summary's "4.8" counts up from 0.0 (numeric transition, 400 ms) and the distribution bars grow from the left with a 40 ms stagger (`smooth`). Review rows rise 12pt with a 30 ms stagger (cap 200 ms) · haptic light (from the tap) · VO: focus on "Reviews" heading, then the summary (rule 6) · RM: everything fades in place, no count-up.
2. **Long body** → 3 lines + "More" [P31] (Footnote Emph text/brand); tap expands in place, "More" fades · `smooth` height ≈ 450 ms · haptic none · VO: the whole row is one element: "Sana R., 5 stars, September 28, 2026. Easy to find…" with custom action "Expand" (full body is always read) · RM: instant expand.
3. **Pull to refresh** (logic) → system refresh control; threshold at ≈ 80pt pull; spinner ≥ 600 ms; new reviews insert at the top (`smooth`, rows below shift down), the summary number rolls (300 ms) · haptic light at threshold · VO: three-finger swipe down triggers it; "Refreshing" / "Updated" announced · RM: insert with `fade.quick`, no roll.
4. **Back chevron / edge swipe** → pop to the station page inside the sheet (interactive edge swipe, parallax 30%); drag on the grabber still controls detents · `smooth` 350 ms · haptic none · VO: escape = back; focus returns to the rating stat · RM: cross-fade.
5. **Loading / empty / error swaps** → State View cross-fades · `fade.std` 220 ms; loading after the 150 ms grace, ≥ 600 ms. Error: haptic **error** on appear; Retry → `Button / Medium` Loading 978:449 (≥ 600 ms), failure again → haptic **error** · VO: titles carry the heading trait; "Loading reviews…" announced politely · RM: same fades.
6. **VO summary** → "Average rating 4.8 out of 5, based on 36 reviews. 30 five-star, 5 four-star, 1 three-star." Empty: "No reviews yet for this station."

### 4.6 Book a slot (04.22–04.34): the time-first readout
1. **Arrive** (push from Book now; sheet-internal `smooth` 350 ms or full-screen system push 350 ms) → readout shows Empty; date strip scrolls so "Today" is first; vehicle auto-picks the primary compatible vehicle (logic) silently · haptic medium (fired by the Book now tap, not again here) · VO: focus on "Book a slot" heading; the readout is a single element announced as "Today, Saturday 4 October. No time picked." · RM: cross-fade.
2. **Tap a date pill** → pill fills (`snappy`, background cross-fade 150 ms), previous unfills. Window and start clear (logic): the readout's Start/End morph back to "—" (numeric transition), grid collapses to the placeholder (`smooth` height ≈ 450 ms), availability shows the compact spinner if the fetch exceeds 300 ms (≥ 600 ms on screen), then the bar segments grow from the left (`smooth`, 200 ms). Eyebrow updates "SUN 5 OCT". Duration stays (edge case 11) · haptic **selection** · VO: "Sunday 5, button, selected"; after load "2 free windows" (polite) · RM: no growth animation, plain swaps.
3. **Horizontal swipe on the date strip** → free scroll with system deceleration; pills snap to 64pt (pill + gap) offsets (`snappy`); selection haptic on each snap only while the finger is down (`scrub`) · VO: the strip is a row of buttons, swipe right/left moves pill to pill (no adjustable) · RM: snap without spring.
4. **Tap a duration chip** → chip Fill/Yes (`snappy`); the readout Duration capsule morphs to "1 h"; window pills shorter than the duration dim (logic) with `fade.quick`; grid chips that no longer fit turn Unavailable (`fade.quick`, 20 ms stagger from the end of the window); footer cost appears (Amount slides up 8pt + fade, `smooth`) as "Rs 286" · "1 h". Tap the selected chip again → deselect · haptic **selection**. **Disabled chip tap** → chip shakes ±3pt once (2 cycles, 240 ms) and the hint "Longest here: 45m" pulses (opacity 0.6 → 1, 300 ms) · haptic **light** · VO: "1 hour, duration, selected"; disabled: "1.5 hours, dimmed. Longest here: 45 minutes." · RM: no shake/slide, the hint still pulses (opacity only).
5. **Tap a window pill** → pill selects (`snappy`), the bar outlines the window (outline draws left → right, 250 ms ease-out), and the sheet auto-scrolls so "Start time" sits under the compact readout (logic: "Selecting one scrolls to the grid"; `smooth` ≈ 450 ms). Grid chips cascade in (scale 0.96 → 1 + fade, 15 ms stagger row-major, cap 180 ms) · haptic **selection** · VO: "5 PM to 8 PM, 3 hours, window, selected. Start times below."; focus moves to the first start-time chip · RM: outline and chips appear at once (`fade.quick`); the auto-scroll still runs (navigation) but without spring overshoot.
6. **Tap a start-time chip** → chip fills (`action/primary` + text/onPrimary, `snappy`); readout Start/End roll to "6:00 PM → 7:00 PM" (numeric transition 120 ms; digits roll up when moving later, down when earlier); bar shows the 6–7 PM sub-range as a solid brand block inside the outlined window; footer Detail morphs "1 h" → "Ends 7:00 PM"; CTA label cross-fades to "Confirm booking" and enables (`fade.quick` 150 ms). Tap the selected chip again → deselect (logic) · haptic **selection** · VO: "6:00 PM, start time, selected. Ends 7:00 PM. Estimated cost Rs 286." · RM: digits swap without roll.
7. **Scrub the start-time grid** [P15] (04.26) → touch-down on any chip + 150 ms hold enters scrub mode: the Scrub Loupe scales 0.9 → 1 (`snappy`) 8pt above the finger showing "{start} · ends {end}"; chips track the finger across rows and columns (`scrub`), the readout and bar update live. Dragging over an Unavailable chip clamps to the last valid chip and gives one **light** haptic (the "wall"). Release = select (same as 6), loupe fades (`fade.quick`). Scroll is locked while scrubbing · haptic `scrub` selection ticks (≤ 1 per 40 ms) · VO: the grid is an adjustable container; swipe up/down moves 15 min ("6:15 PM, ends 7:15 PM"), double-tap selects · RM: loupe appears without scale.
8. **Scrub the availability bar** [P16] (04.30) → long-press 300 ms on the bar → haptic **light**, loupe appears ("9:30 PM · Free"; "· Peak" inside the peak band; "Unavailable" over booked/past). Dragging moves at 15-min steps with `scrub` haptics; crossing a segment boundary (free ↔ unavailable) gives an extra **light**. Release on a free time: selects the containing window and the nearest valid start, as if 5 + 6 were tapped (auto-scroll included). Release on unavailable: nothing changes, loupe fades (`fade.quick`) · VO: bar becomes adjustable ("Day availability. 3:45 PM, past"), swipe up/down steps 15 min; double-tap selects · RM: no loupe scale.
9. **Scroll** → after the readout scrolls under the header, the compact readout bar slides down from the header and stays sticky; scrolling back to top expands it into the full readout (matched geometry on the times) · `smooth` 250 ms · haptic none · VO: the compact bar becomes the first element after the header and reads as in 10 · RM: compact bar fades in/out (`fade.quick`).
10. **Tap the compact readout** → scroll to top · `smooth` ≈ 450 ms · haptic light · VO: "Today, 6 to 7 PM, 1 hour. Double-tap to show all choices." · RM: jump to top.
11. **Peak note** → not interactive; VO reads "Peak hours 5 PM to 9 PM" before the duration chips.
12. **No free windows** (04.31) → chips area collapses (`smooth` ≈ 450 ms), message fades in (`fade.std`); [P17] "Go to Sun 5 Oct" selects that date (as 2) and scrolls the strip (`smooth`) · haptic selection (on the button) · VO: polite "No free windows on this day"; "Go to Sunday 5 October, button" · RM: fades, strip jumps.
13. **Closed day** (04.32) → Inline Notice fades in (`fade.std`), the WHEN content collapses (`smooth` height) · haptic none (the date tap already gave selection) · VO: polite "Station is closed on this day" · RM: fade only.
14. **Times error** (04.34) → notice fades in (`fade.std`) · haptic **error** on appear; [P17] Retry swaps the notice for the compact spinner (`fade.quick`, ≥ 600 ms); failure again → haptic **error**, notice returns · VO: notice announced politely; "Retry, button" · RM: fades.
15. **Back chevron** → pops to the station page in the sheet; state is discarded (logic has no draft) · `smooth` 350 ms, parallax 30% · haptic light · VO: focus back on the Book now tile. **Close ✕ / drag down** → dismisses the sheet to 02.06 (pin deselects) · `smooth` ≈ 450 ms · haptic light · VO: focus to the pin. No confirmation (cheap to redo) · RM: fades.
16. **Footer CTA disabled tap** (e.g., "Pick a start time") [P25] → the label pulses once (opacity 1 → 0.6 → 1, 300 ms), the sheet scrolls to the missing step (`smooth` ≈ 450 ms) and its section header ("Start time") flashes `bg/tint` for 600 ms · haptic **light** · VO: disabled buttons stay focusable: "Pick a start time, dimmed. Select a start time above." · RM: no pulse; the tint flash stays (colour only); scroll jumps.
17. **Cost changes** → Amount uses a numeric transition (≤ 300 ms, no slot-machine roll) · haptic none · VO: footer is one element "Estimated cost Rs 286, ends 7:00 PM. Confirm booking, button." · RM: plain swap.
18. **Loading station** (04.22) → State View Loading after the 150 ms grace (≥ 600 ms); content fades in (`fade.std`) and the Cost Footer slides up from below (`smooth`) once the station is loaded · haptic none · VO: polite "Loading station…" · RM: fades, footer appears in place.
19. **Station error** (04.23) → State View Error fades in (`fade.std`) · haptic **error** · "Go back" pops to the station page (`smooth` 350 ms, haptic light) · VO: focus on "Failed to load station" heading · RM: fades.
20. **Estimate info** [P35] (info.circle next to the amount) → a small popover bubble above the footer: "Estimate. The charger's meter decides the final amount." · scale 0.96 → 1 + fade (`snappy`), auto-hides after 4 s or on any tap (`fade.quick`) · haptic light · VO: the sentence is also the footer element's hint, so VO users never need the popover · RM: fade only.

### 4.7 Vehicle (04.35–04.40, 04.51, 04.52)
1. **Tap "Change" / the vehicle row** → Choose vehicle stacks over Book a slot, Book sheet recedes to 0.96 + dim · `smooth` ≈ 450 ms + `fade.std` · haptic light · VO: focus on "Choose vehicle" heading; the selected row is read first "BYD Atto 3, Primary, Type 2, CCS 2, 60.5 kilowatt-hours, selected" · RM: fade.
2. **Tap a compatible row** → checkmark moves to it (`snappy` cross-fade 150 ms) and the sheet dismisses after 200 ms (`smooth`); the vehicle row title cross-fades to "MG ZS EV · Type 2 (AC)" · haptic **selection** · VO: "MG ZS EV, Type 2, CCS 2, 51 kilowatt-hours, button"; after dismiss, polite "MG ZS EV selected" · RM: no delay animation, fades.
3. **Tap an incompatible row** → no selection; the warning subtitle shakes ±3pt once (2 cycles, 240 ms) · haptic **warning** · VO: row is not a button; reads "Nissan Leaf. Doesn't fit this charger, Type 2 AC. Dimmed." · RM: no shake, the warning line flashes opacity 0.5 → 1.
4. **Add vehicle** → push `/add-vehicle` (Profile flow, system push 350 ms, haptic light). On return with a fitting vehicle, it is auto-selected and the sheet closes (logic, `smooth`); the vehicle row flashes `bg/tint` once (0 → 100% → 0 over 600 ms) · haptic **success** on auto-select · VO: polite "MG ZS EV added and selected". If the new vehicle doesn't fit: the sheet stays and the new row inserts disabled with its reason (`smooth`), haptic **warning** · RM: no flash, fades.
5. **Error states in the row** (04.38/04.39) → red outline draws in (`fade.std` 220 ms); the error line slides down 4pt + fade (`smooth`). CTA "Add a vehicle" (enabled) pushes `/add-vehicle` · haptic none until tap, then **medium** on the CTA · VO as 6 · RM: fade only, no slide.
6. **VO for error rows** → "No vehicle added. Add a vehicle to book this charger. Add, button." / "Choose your vehicle. None of your vehicles match this charger. Change, button."
7. **Vehicle row loading** (04.51) → spinner + skeleton title after the 150 ms grace; resolves with `fade.quick`; the CTA cross-fades from Disabled to its table state · haptic none · VO: polite "Loading vehicles" · RM: static skeleton.
8. **Picker loading** (04.52) → State View Loading inside the sheet; rows fade in with a 30 ms stagger (`fade.std`, cap 150 ms) · haptic none · VO: "Loading vehicles" · RM: no stagger.
9. **Picker error → Retry** [P33] (04.37) → `Button / Medium` Loading (≥ 600 ms); success fades rows in; failure → haptic **error** · VO: "Couldn't load vehicles. Try again, or add one." read with the title · RM: fades.
10. **Picker empty → Add vehicle** (04.36) → same as 4.

### 4.8 Confirm + booked (04.41–04.43)
1. **Confirm booking (footer)** → if cost can't be computed: Toast Error (04.48, 4 s), haptic **error**, no sheet. Else the Confirm sheet stacks, Book sheet recedes 0.96 + dim · `smooth` ≈ 450 ms · haptic **medium** · VO: focus on "Confirm booking" heading; rows read "Date, Oct 4, 2026. Time, 6:00 to 7:00 PM. Duration, 1 hour. Total, Rs 286, estimate." · RM: fade.
2. **Back / swipe down** → dismiss; Book a slot unchanged · `smooth` ≈ 450 ms · haptic light · VO: focus returns to the footer CTA · RM: fade.
3. **Confirm booking (sheet)** → paused station: sheet dismisses (`smooth`), Toast Warning (04.45, 1–2 lines), haptic **warning**, no API call (logic). Otherwise: haptic **medium** on release, the button goes Loading (04.42, ≥ 600 ms), Back disables, grabber hides, sheet becomes non-dismissable; double-taps ignored (logic: "not while submitting") · VO: button reads "Confirm booking, busy"; polite "Booking" · RM: spinner still rotates (system), no other motion.
4. **Success** [P20] (04.43) → haptic **success** at the moment the API returns. Sequence (total ≈ 900 ms, all `smooth` unless noted):
   - 0 ms: the Confirm sheet and Book sheet fall away together (y +60, fade) while the background cross-fades from map to Mesh Celebrate (`fade.std`).
   - 120 ms: the Charging Pass drops in from above the status bar (y −320 → 96) with `bouncy` (Wallet "pass added" feel), 2° tilt settling to 0°.
   - 360 ms: success sheet rises from the bottom to (0,500); the checkmark draws its stroke (250 ms ease-out); title and body fade up 8pt with a 40 ms stagger.
   - VO: announces "Booked. GreenVolt · DHA Phase 5, today 6:00 to 7:00 PM." Focus on the title. RM: everything cross-fades (`fade.std`), no drop or tilt.
5. **View in Bookings** → the driver shell appears on the Bookings tab (logic destination). The pass flies from its position to the top of the Upcoming list (matched geometry, `smooth` 450 ms); the tab bar's Bookings item does a one-time selected bounce (`bouncy`) · haptic light · VO: focus on the new pass "GreenVolt · DHA Phase 5, upcoming, today 6:00 to 7:00 PM" · RM: cross-fade to the tab, pass appears in place. Swipe down on the success sheet = same destination (escape gesture too).
6. **Get directions** [P20] → Directions sheet stacks over the success screen (as 4.3-1) · `smooth` ≈ 450 ms · haptic light · VO "Get directions, button" · RM: fade.
7. **Idle on success** → nothing auto-dismisses (the driver decides); the pass is not interactive here (tap does nothing, no press state).

### 4.9 Submit errors (04.44–04.48, 04.53)
1. **Toasts** → enter from 12pt below with opacity 0 → 1 (`smooth`) above the footer (bottom edge y 750), stay 6 s (logic), swipe down to dismiss (`fade.quick`); the timer pauses while VO focus is inside, and with VO running action toasts stay until dismissed or 10 s pass (02). Only one toast at a time; a new one replaces the old with `fade.quick` · haptic per tone · VO: polite announcement; action reachable with the Actions rotor · RM: fade only.
2. **Slot already booked** (04.44) [P22] → haptic **error**; availability refetches; the chip that was selected turns Unavailable with one ±3pt shake (2 cycles, 240 ms); readout Start/End roll back to "—" (numeric, 120 ms); footer CTA cross-fades to "Pick a start time" (Disabled, `fade.quick`); "Pick another time" scrolls to the grid (`smooth` ≈ 450 ms) · VO: announces the toast, then "6:00 PM no longer available" · RM: no shake, plain swaps.
3. **Station paused** (04.45) → haptic **warning**; nothing else changes · VO: polite announcement.
4. **Connection interrupted** (04.46) → haptic **warning** (outcome unknown, not a failure); "Open Bookings" [P23] cross-fades to the driver shell on the Bookings tab, Upcoming (`fade.std` 220 ms), where the 07.14 pull-to-refresh hint shows · VO: the 3-line toast is read in full; "Open Bookings, button" · RM: fade.
5. **Network / other errors** (04.47, 04.53) → haptic **error**; "Retry" re-submits with the same payload (footer CTA Loading ≥ 600 ms, no sheet) · VO: "Retry, button" via Actions rotor · RM: fade.
6. **Unable to calculate cost** (04.48) → haptic **error**; no sheet; 4 s (1 line, no action).

---

## 5. Mobbin references (67 unique; all iOS; every major screen ≥ 3)

### 5.1 Place sheet, medium + large (04.01–04.11)
- **Apple Maps — Gas station place card (Royal Gas)**: https://mobbin.com/screens/cc13099d-e1c2-43f0-a565-0e93c51c0c82
  - What we take: the whole medium-detent anatomy. Share glass circle + ✕ in the header, a primary filled tile + tinted tiles, then a 4-column stats row with *labels above values* (Hours "Open" in green, "3 Ratings 👍100%", Distance). Our Status column copies "Hours: Open" in green; photos start right under the stats.
- **Apple Maps — Foothills Park card with floating action bar**: https://mobbin.com/screens/bbcd9d83-7e9b-4d32-b294-41c99f500684
  - What we take: three equal tiles (Directions filled, Download/Website tinted) and the floating glass action pill at the bottom of the card. That pill is our Floating Action Pill at large.
- **Apple Maps — Marked location sheet**: https://mobbin.com/screens/ef3b62fd-3ae4-4c66-9b0f-690df1554b30
  - What we take: tile hierarchy (one emerald primary, the rest tinted), "Details" rows with label over value, generous 16pt rhythm; destructive rows tinted, not red-filled.
- **Apple Maps — Ratings on the large detent**: https://mobbin.com/screens/e41f44a4-feb6-4855-8e3b-1b2310487254
  - What we take: a ratings section inside the place sheet (big number + count) and a sheet-on-sheet stack for a secondary task; the base card scales back.
- **Google Maps — McNellie's place sheet**: https://mobbin.com/screens/5b38f4ff-989f-4634-a8e6-1072bbd2d9ab
  - What we take: rating with count right under the name, a colour-coded status line, the action chip row Directions / Reserve / Call / Save (our Book now / Directions / Call / Save), then a photo carousel.
- **Lyft — Divvy station sheet**: https://mobbin.com/screens/1d433d1f-9c1f-498c-b7a9-9e777e6692c5
  - What we take: numbers-first stats with thin dividers (1 ebikes / 2 classic / 17 open docks) and the price line under the name; a station sheet for a physical asset, close to an EV charger.
- **Shell Recharge — Station detail flow**: https://mobbin.com/flows/a383b7cc-6ad4-428d-8d32-5a85becf571c
  - What we take: EV-domain connector rows: status tag (Available / Occupied in red), plug glyph + "CCS · 180 kW", price per kWh on its own line, "3/4 available". Confirms per-connector price + power + status is the decision unit.
- **Rivian — Finding a charger flow**: https://mobbin.com/flows/d30189e8-f1b1-411f-bd1f-6b3c55ec5bc3
  - What we take: "300 kW max · 5 of 6 chargers available · Open 24hrs" density, charger rows with the real plug icon, *in-use rows greyed but readable*, and the Plan / Send button pair (our Directions / Book now).
- **PayPal — Pay at pump fuel grades**: https://mobbin.com/screens/fefbf5ad-3f1e-44f9-9ba2-a6b867084bb3
  - What we take: price-per-product list inside a grouped card with a quiet disclaimer under it ("Prices are subject to change"). Tone model for our estimate line.

### 5.2 Paused / offline station (04.07, 04.08)
- **Grill'd — ordering unavailable banner**: https://mobbin.com/screens/bbafd6f8-8dfd-4e43-a5e1-3402d39f5f5c
  - What we take: an inline tinted banner with icon + one-sentence reason, placed above the actions; status dot line "Closed – Opens 11AM". Our Inline Notice.
- **Places — Theodora closed, Reserve tile dimmed**: https://mobbin.com/screens/4c1d149d-de4b-4a1f-b9f0-5fb2c82f34eb
  - What we take: when booking is impossible only the Reserve tile dims; Website / Route / Save stay live. Exactly our paused Book now tile [P]. Also the glass inline booking widget (Today · time pills) that inspired booking inside the sheet.
- **Uber Eats — Store currently unavailable**: https://mobbin.com/screens/e0f35c2d-a1be-4dd9-9aaf-61e727c876e9
  - What we take: "Currently unavailable" in the meta line plus a schedule-later path; the alternatives carousel is noted for a later "nearby chargers" proposal.
- **CHOPT — location closed sheet**: https://mobbin.com/screens/f51f6399-6a7c-4756-9a2e-d0439202e6fb
  - What we take: honest copy that you can still book for later ("You can still place an order for a later date"), our offline notice tone.

### 5.3 Station details pushed, host, photos, reviews block (04.02–04.04, 04.12)
- **Airbnb — Guest favorite rating + Reserve footer**: https://mobbin.com/screens/fc136f40-7a43-4d89-9195-70d01010471f
  - What we take: a big light rating number as the hero of the reviews block, previews below, "Show all 298 reviews"; sticky footer with price + CTA.
- **Airbnb — Meet your host**: https://mobbin.com/screens/d71700a0-2e5e-4274-9d02-75b399408802
  - What we take: avatar + name + role, nothing louder. We drop the badges (logic: verified/response time removed on purpose).
- **Airbnb — Photo tour**: https://mobbin.com/screens/f4c764a3-7d5b-41ea-a8c7-342030d16e5f
  - What we take: rounded photo tiles in a horizontal row with the next tile peeking; geometry for the placeholder strip.
- **Grab — Creating a booking flow (restaurant detail → review → booked)**: https://mobbin.com/flows/781fe4f1-a471-4688-b940-36d532d2e822
  - What we take: rating "5.0" + distribution bars on the detail page, chip actions (See Menu / Directions / Book), and the footer "15 Aug, 8:00 PM · 2 people" + Book now: a time-first footer.

### 5.4 Reviews (04.18–04.21)
- **Fresha — Reviews**: https://mobbin.com/screens/06eb9c6b-a547-43a7-9f40-59c61ce72014
  - What we take: closest match to our logic: ★ + average + "(41)", distribution bars, initials avatar ("CB"), name, date line, then 5 stars, optional body.
- **Deliveroo — Reviews**: https://mobbin.com/screens/5c321d6f-2924-4360-aa50-8b5b942205f0
  - What we take: big number left + bars right in one compact summary, "All reviews" header, rows with stars + date on one line; a dark toast for feedback.
- **Klarna — Reviews**: https://mobbin.com/screens/38c6e27e-8773-4675-94fa-5a957ab56ce9
  - What we take: initial-letter avatars in a neutral tint, date next to stars, long bodies in Body size with generous line height.
- **Tripadvisor — Reviews summary**: https://mobbin.com/screens/a0b2c3ac-6fa1-41f1-9bd2-dca379610a74
  - What we take: counter-example. Sub-scores and five labelled bands are too dense for one charger; we keep 5→1 bars only.

- **Shop — skeleton loading screen** (review): https://mobbin.com/screens/d3158271-a0e5-4672-bea0-44ef4aebcb1c
  - What we take: flat `bg/fill` blocks in the exact shape of the content that will arrive, no spinner. Model for the 04.04 skeleton and the 04.51 vehicle-row skeleton.
- **Oura — Can't load, try again** (review): https://mobbin.com/screens/9dbf6e35-9643-449f-9d0f-c89cc6248a49
  - What we take: a centred two-line error ("Can't load chat" / "Wait a moment and try again.") with one soft "Try again" pill inside a sheet. Calm tone for 04.05, 04.21 and 04.23 (State View Error).
- **Noom — We couldn't process, Try again** (review): https://mobbin.com/screens/46a84752-17ac-441b-b955-02f3a9ac5f34
  - What we take: icon + plain title + one sentence that says what to do + one action. Confirms our "Check your connection and try again." [P11] over raw error text.

### 5.5 Directions (04.14–04.16)
- **Apple Maps — Directions with route time pills**: https://mobbin.com/screens/579c8b7d-ef57-4855-a9d0-9ff4c7f86289
  - What we take: the readout hierarchy "19 min" big, "7:42 ETA · 8.5 mi" quiet; we render "1.2 km · ~2 min drive" the same way.
- **Tesla — Trip to a charging station**: https://mobbin.com/screens/f514ed86-c953-4159-a7f6-2a1790d7f0de
  - What we take: EV-domain hand-off sheet: one big primary ("Send to Car · 18m · 14.7 km") and one quiet Cancel. Our Open Google Maps / Cancel pair.
- **Google Maps — navigation sheet**: https://mobbin.com/screens/69f81453-0266-46d5-8164-74324547e634
  - What we take: time first and coloured, distance and arrival second. The destination app our users actually use in Lahore.

- **Mindtrip — Get directions: which map do you use?** (review): https://mobbin.com/screens/ea43a2d0-45d3-49ae-aac5-5227aaa9d4e0
  - What we take: a stacked sheet over a place sheet with Apple Maps and Google Maps as two equal rows. Evidence for [P26] (add "Open in Apple Maps" on iOS).
- **Fly Delta — Gate place sheet with Get Directions** (review): https://mobbin.com/screens/01c43dd1-fbdc-4553-902a-c4e7aee59ce8
  - What we take: a compact place sheet whose one full-width primary is "Get Directions", with ✕ in the header corner. Confirms Directions as a one-tap hand-off, not a screen.

### 5.6 Book a slot (04.22–04.34)
- **Structured — time + duration picker**: https://mobbin.com/screens/247f1d98-01a7-4e26-9e01-f7fb85b1800c
  - What we take: the time-first readout ("1:00–1:15 PM (15 min)") above the controls and a duration segment 15m / 30 / 45 / 1h / 1.5h, the same set as our logic chips.
- **Fresha — Select date and time**: https://mobbin.com/screens/0a1e201a-c0d7-4ce7-8cd1-39ac3921096d
  - What we take: date tiles (weekday / number / month) with unavailable days greyed, and the footer "US$55 · 2 items · 10 mins" + Continue, our Cost Footer pattern.
- **Woolworths — Select collection time**: https://mobbin.com/screens/081d6835-1358-4b9e-a9c7-d8abf6179023
  - What we take: window rows "2pm - 3pm · 1hr window", the capacity note right above the CTA, and date tiles that carry a second line. Tone for "Longest here".
- **Octopus Energy — Book now slots**: https://mobbin.com/screens/b9bb71b5-9788-40c5-8d1c-a4a43b28528e
  - What we take: energy-domain window pills ("8am-12pm") and explicit "Fully Booked" cells; dark-on-light pills read clearly at small size.
- **Grab — Book table time windows**: https://mobbin.com/screens/0f72e22f-5943-4a13-9d89-458261522ea3
  - What we take: window pills "5 - 8PM" / "8 - 11PM" in one row with an outlined selected state; weekday over number in the date row.
- **Tripadvisor — time chips grid + total**: https://mobbin.com/screens/3a68c032-8b12-4d08-a0c2-a63089d33344
  - What we take: equal-width time chips in a grid, the selected one filled, and the total right under the grid.
- **Zocdoc — Book an appointment**: https://mobbin.com/screens/e44c3e62-24dd-47f3-94ce-929f5d78b9a5
  - What we take: "No available appointments" in quiet grey per day instead of an error, and a dense 3-col grid (we use 4 for 15-min steps).
- **Future Pro — date pills + times + disabled Continue**: https://mobbin.com/screens/70e6ec32-efd0-4e6e-9fcf-e1d84883dc2b
  - What we take: the CTA stays visibly disabled until a time exists, matching our "Select a time" / "Pick a start time" table.
- **Tesla — rate plan with peak timeline**: https://mobbin.com/screens/f40214c4-e79e-4b55-9440-551fb622620c
  - What we take: a single horizontal day bar coloured by Off-Peak / Mid-Peak / Peak with a dot legend. Our peak tint over the availability bar.
- **Fi — Activity timeline**: https://mobbin.com/screens/2084a9b7-f30e-4cb2-9b1d-0b7e4a3aa73a
  - What we take: tinted track + solid marks and the 12AM / 6AM / 12PM / 6PM / 12AM axis. Our bar axis and segment contrast.
- **Deepstash — time slider with pin bubble**: https://mobbin.com/screens/64ba3859-5033-4230-a403-51152768419f
  - What we take: the value bubble above the thumb while dragging along an hour axis. Our Scrub Loupe.
- **Me+ — ruler scrubber**: https://mobbin.com/screens/dc528e30-0e81-4f4d-bdc8-f416c37b16f7
  - What we take: big number that changes per tick while a ruler moves under the finger. The feel of our `scrub` token.
- **Lyft — Schedule a ride**: https://mobbin.com/screens/390f1696-2b54-414b-8f2f-6cdee52446b2
  - What we take: the derived line under the picker ("Estimated ride time: 15 min" / "Drop-off: 6:05 PM"), our "Ends 7:00 PM".
- **Places — Upcoming availability**: https://mobbin.com/screens/9c343f80-4c65-4763-a993-31e890e04169
  - What we take: green dot on bookable times and greyed "No available tables" chips; calm unavailable language.
- **Fresha — fully booked on this date**: https://mobbin.com/screens/f82d8a36-8251-4140-bcef-e1a35cd4119e
  - What we take: "fully booked on this date · Available from Wed, 19 Aug" + "Go to next available date". Our [P17] next-day button on 04.31.

### 5.7 Choose vehicle (04.35–04.40)
- **Public — disabled option with reason**: https://mobbin.com/screens/30101b44-0e5f-4c40-b20d-f8e31e634adb
  - What we take: the unavailable option stays readable at reduced opacity with an inline reason tag, and the valid one is clearly selected.
- **Monzo — accounts list with Add account**: https://mobbin.com/screens/c6d4062b-c1e2-4d68-85d2-4c33e7f8d8ac
  - What we take: inset grouped list, trailing check, "Add account" as the last row in brand text. Our Add vehicle footer.
- **Grab — EV car option + schedule chip**: https://mobbin.com/screens/c4cd1967-1778-4a21-a56a-0d357822a4f5
  - What we take: vehicle row with icon + title + meta, and the time readout chip next to the CTA ("12 Jun 9:15 PM").
- **Cleo — Link primary account**: https://mobbin.com/screens/557d4bc0-5b7e-4f8a-a53e-8e8a204e850e
  - What we take: one primary row + an "Add another" row in the same card; quiet info line below.

- **Luma — invalid card, red outline + inline error in a sheet** (review): https://mobbin.com/screens/62ffd6a0-a62b-4d6f-8f18-b8d5d11aeff0
  - What we take: the blocking field gets a red outline and one red sentence directly under it, while the CTA below stays visible. Our Vehicle Select Row Error-None / Error-Mismatch (04.38/04.39).
- **Fresha — Review and confirm with a payment method row + Edit** (review): https://mobbin.com/screens/947d3974-4e93-4fb4-9b81-8f7affad0699
  - What we take: the chosen method as one row with a trailing "Edit" capsule above a pinned "US$15,45 · Pay now" footer, and a red error banner that leaves the footer usable. Our vehicle row "Change" + Cost Footer + error toast.

### 5.8 Confirm + booked (04.41–04.43)
- **Airbnb — Reserving a service flow**: https://mobbin.com/flows/8cbcaf23-5bb1-4f0c-8efa-05806e484b0d
  - What we take: "Confirm and pay" sheet: Price details, Total on its own line, one long primary at the bottom.
- **Marriott Bonvoy — Adding to Apple Wallet flow**: https://mobbin.com/flows/0d5392e0-1321-4c26-bf0c-47547a59a67b
  - What we take: "You're All Set" with Wallet / calendar / Share / Save tiles and a summary of charges; the PassKit add-pass sheet if we ever ship Wallet.
- **Tripadvisor — You're all set sheet**: https://mobbin.com/screens/b8fde94c-e6f3-4836-b357-0eaaf7608ba7
  - What we take: success as a Surface sheet over a rich background, tinted check, dates in a two-column row, one "My bookings" button.
- **CLEAR — card behind the success sheet**: https://mobbin.com/screens/4acdf5dc-6b41-49d2-8592-38454ded7746
  - What we take: the new card sits *above* the success sheet so the user sees the object they just got. Our pass over the sheet.
- **Apple Store — You're all set**: https://mobbin.com/screens/63cc1cbb-36c7-4d38-9a9c-8eefa928f498
  - What we take: calm two-line headline, Add to Apple Wallet badge placement, reminders as a quiet follow-up.
- **Luma — Event created**: https://mobbin.com/screens/8f9dc2c6-c9a6-43d6-8a93-bb15606f9c74
  - What we take: check, date + address rows with icons, two stacked buttons (primary + soft). Rhythm for our success sheet.
- **Agoda — Booking confirmed with time window**: https://mobbin.com/screens/ccfd1301-878d-4659-af3b-994bedebba8a
  - What we take: "08:40 —4h 0m→ 12:40": the Time Window anatomy (two big times, duration in the middle) used by our readout and pass.

- **Fresha — Review and continue (date, time + duration, total)** (review): https://mobbin.com/screens/18644903-663c-467c-9d55-10afae6c79f4
  - What we take: calendar row "Wednesday, 19 August", clock row "1.45-2.00 pm (15 mins duration)", then Total on its own line and one primary. The four logic rows of our Confirm sheet (Date / Time / Duration / Total) read the same way.
- **American Airlines — Your Total + Continue footer** (review): https://mobbin.com/screens/b6a31539-f3de-4766-8730-2552e8a7df3a
  - What we take: "Your Total" label left, amount right, one long primary under it in a sheet. Hierarchy for "Total · Rs 286" above "Confirm booking".
- **Tripadvisor — Confirm and book, submitting** (review): https://mobbin.com/screens/530e67a1-de23-4dc5-9b35-c40b3a907bfe
  - What we take: the primary turns into a spinner-only button and the page stays put while the booking is created. Our 04.42 (Loading 978:298, Back disabled, sheet not dismissable).
- **Zocdoc — We're booking your appointment** (review): https://mobbin.com/screens/729b3720-a37b-487c-ae1c-dcd39a17ca4b
  - What we take: counter-example. A full-screen "booking…" interstitial hides the slot; we keep the Confirm sheet visible and only swap the button.

### 5.9 Errors (04.44–04.48)
- **Panera Bread — "We're sorry!" choose a later time**: https://mobbin.com/screens/69f85fdb-9a62-4666-bb0d-55dc823d8434
  - What we take: the error offers the fix as its action ("Choose a Later Time"). Our "Pick another time" [P22].
- **Posh — Purchasing a ticket flow (setup error banner)**: https://mobbin.com/flows/100d8209-f429-4f9a-8f26-0456179b644c
  - What we take: a short banner with a warning glyph and a plain explanation, over a still-usable screen.
- **Deliveroo — toast** (5c321d6f above)
  - What we take: compact toast above the bottom edge, never covering the primary action.

- **Zocdoc — You have a similar appointment booked** (review): https://mobbin.com/screens/3ae545ce-a65f-457d-b54d-a2fc387d9952
  - What we take: when a duplicate booking is possible, the app points at the existing booking first instead of offering a blind retry. Supports "Open Bookings" over Retry on 04.46 [P23].
- **Fresha — payment failed banner over Review and confirm** (review): https://mobbin.com/screens/947d3974-4e93-4fb4-9b81-8f7affad0699 (also cited in 5.7)
  - What we take: the error floats over a still-intact screen and footer; nothing the driver chose is lost. Our toasts above the Cost Footer.

### 5.10 Call host [P3] (04.17) (added in review; the draft had none)
- **Tripadvisor — Please contact support (phone number as the primary)**: https://mobbin.com/screens/6ee8edf3-98cc-4fba-80d2-a33a199d1e5d
  - What we take: a small sheet over the booking with a plain title, one sentence of context and the call action as the big primary, "Go back" as the quiet second button. Our "Call Bilal" body + Call / Cancel.
- **Shop — Contact KITSCH sheet**: https://mobbin.com/screens/ccae244c-3759-49c0-a2fb-7077e7e27a9d
  - What we take: contact options for a seller live in a short sheet on top of the store page, with a phone glyph and the number spelled out. Confirms showing "0321 4567890" before leaving the app.
- **Fresha — cancel sheet with "Not sure? Contact … · Call" chip**: https://mobbin.com/screens/8e6f1129-17cd-44a6-b927-0d1c29502c03
  - What we take: calling the business is a secondary path next to the main task, with a phone icon chip. Our Call tile sits beside Book now and Directions, never above them.

---

## 6. New components needed (not in the inventory)

| Component | Purpose | Variants | Props / anatomy |
|---|---|---|---|
| **Time Chip** | 15-min start times in the grid (04.25–04.29, 04.44) | State = Default / Selected / Unavailable / Scrub | `Time` (TEXT, "6:00 PM", Subheadline; Selected = Subheadline Emph). 86.5×44 (FILL in a 4-col grid), radius/sm 12, Default fill bg/fill + text/primary; Selected action/primary + text/onPrimary; Unavailable bg/fill 50% + text/tertiary + 1pt diagonal strike (stroke/separator), not focusable as a button; Scrub = action/primary 12% + 2pt stroke action/primary. Touch target ≥ 44. |
| **Chip · Fill/Disabled** (add to Chip 970:186) | Dimmed duration chips and window pills (logic: dimmed and disabled) | new variant Fill/Disabled | Same as Fill/No with content at 40% and no stroke. |
| **Time Window · State + Size** (extend 1011:440) | Time-first readout (Empty / Duration only / Start only / Set) and the sticky compact bar | State = Empty / Duration / Start / Set × Size = Large / Compact | Large adds `Eyebrow` (TEXT, Caption 1 Emph caps); Empty uses text/tertiary "—"; Compact = 370×44, Headline "6:00 → 7:00 PM" + Footnote secondary "Today · 1 h", bg/frostStrong, radius pill. |
| **Vehicle Select Row** = `Vehicle Card` Layout=Row (00-system C5; build it there) | Booking VEHICLE row (logic `BookASlotVehicleRowWidget`) | State = Selected / Choose / None / Error-None / Error-Mismatch / Loading | 370×64 (+22 with error line). car.fill 1024:474 in a 40 tint well, `Title` (Headline), `Subtitle` (Footnote secondary, optional), `Action` (TEXT, Footnote Emph text/brand: "Change" / "Add"), `Error message` (Footnote text/error), `Show error` (BOOL). Error states: 1.5pt stroke/error, radius md. Loading: spinner + skeleton title. Fill bg/grouped. |
| **Avatar** | Initials avatar: host row, review rows (and Messages later) | Size = S 32 / M 40 / L 56 | `Initials` (TEXT, 1–2 letters, Subheadline Emph / Headline / Title 3), fill bg/tint, text/brand. "Driver" reviews use person.crop.circle 1023:483 glyph instead (variant `Kind = Initials / Glyph`; the glyph is [P32], logic says initials avatar). Shared with 07 (host "B") and 09 (inbox). |
| **Review Row** | One review (`CardReviewWidget`) | Body = Yes / No × Expanded = No / Yes | Avatar M, `Name` (Subheadline Emph), `Date` (Footnote secondary, "MMMM d, yyyy"), Rating Stars display S, `Body` (Subheadline text/primary, 3 lines + "More" when collapsed), `Separator` (BOOL). Padding 16/0, gap 8. |
| **Rating Stars · display size** (extend 1088:728) | Non-interactive stars in rows and summaries | add `Size = Input / Display` (Display = 12pt stars, gap 2, no 44pt targets) | Same Value=0…5 variants; star.fill icon/brand, empty star icon/tertiary. |
| **Rating Summary** | Average block in the sheet (compact) and on Reviews (large) | Size = Compact / Large × Bars = On / Off × State = Default / Empty | `Average` (TEXT, Display/M compact, Display/L large), star.fill, `Count` (TEXT "Based on 36 reviews"), 5 bars (track bg/fill 6pt radius pill, fill brand/primary, `Count 5…1` Caption 2 text/tertiary). Empty: "N/A" text/tertiary, bars hidden. Large container bg/grouped radius lg padding 16. |
| **Inline Notice** (= 00-system C2; build it there) | In-content notices: paused / offline station, closed day, times error | Tone = Info / Neutral / Success / Warning / Error × Style = Card / Plain × Action = Yes / No | 370 wide, padding 12/14, radius md, fill = status tint (warningTint / bg/tint / bg/fill / errorTint), icon 20 (exclamationmark.triangle.fill / info.circle / clock), `Message` (Subheadline text/primary), `Action label` (Subheadline Emph text/brand). Not a Toast: it does not float or time out. |
| **Scrub Loupe** [P15/P16] | Value bubble while scrubbing the grid or the availability bar (04.26, 04.30) | Tone = Free / Peak / Unavailable | Capsule h 32, padding 8/12, Glass/Regular + bg/frostStrong, Footnote Emph text/primary "6:00 PM", Footnote text/secondary "· ends 7:00 PM" / "· Peak" (text/warning) / "Unavailable" (text/tertiary); 8pt tail pointing at the finger. |
| **Photo Placeholder** (utility, not a set) [P5] | Photos strip until the API has photos | none | 136×96, radius md, bg/fill, ev.charger 24 icon/tertiary centred. |
| **Skeleton Block** (utility) | Loading values in the sheet (04.04) | Width = S / M / L | bg/fill radius xs, shimmer gradient white 0→40%→0 (1.2 s linear loop). |
| **Peak Note** (utility) | "Peak 5 PM–9 PM" trailing the WHEN header | none | 6pt dot status/warning + Footnote text/secondary; if `List Group Header` gets a trailing slot (P), use that instead. |
| **List Group Header · trailing** (extend 983:389) | "WHEN" + Peak note, "Reviews" + "See all", "Connectors" + count | Trailing = None / Text / Action | `Trailing text` (Footnote text/secondary) or `Action label` (Footnote Emph text/brand). |

| **Cost Footer · info** (extend 1011:479) [P35] | Estimate disclosure next to the booking amount | add `Show info` (BOOL) | 16pt info.circle 1025:472 icon/tertiary trailing `Amount`, 44pt hit area; popover bubble (Glass/Regular + bg/frostStrong, radius sm, padding 8/12, Footnote text/primary) with the brief line "Estimate. The charger's meter decides the final amount." |
| **Touch marker** (documentation utility, not shipped) | Shows where a finger is in scrub frames (04.26, 04.30) | none | 44pt circle, fill `bg/fillStrong`, 1.5pt `stroke/focus`; named `Touch`. |

Dependencies, not new here: **Manual Call Sheet** (09 §6: State = Number / No number / Opening) for 04.17, shared with 07.30 and 09.30; **Toast** 1088:631 replaces 02's proposed Snackbar everywhere in this flow; `Skeleton Block` here is the shimmer rhythm 07 reuses.

---

## 7. Proposals (not in the logic map), flagged

| # | Proposal | Why | Applied in frames? |
|---|---|---|---|
| P1 | The place sheet is modal over the tab bar (tab bar hidden while a station sheet is open) | Apple Maps-style focus; frees the bottom for actions. Logic shows the preview as a stack overlay above the nav. | yes |
| P2 | Booking inside the sheet (sheet-internal push) instead of a full-screen route; full-screen only when coming from Saved / booking details | D9 decision "booking inside the sheet"; keeps map context. Logic route `/booking-create` unchanged. | yes |
| P3 | Quick actions **Call** and **Save** (labelled) and **Share** in the header | Apple/Google Maps pattern. Save = logic heart toggle with a label; Call needs a host phone that is pre-booking-visible (today calling only exists from booking details, resolved by booking); Share needs a station deep link. | yes (Call/Share flagged) |
| P4 | Stats Row with a **Status** column (green "Available") instead of the status pill; connector count moves to the Connectors header | Apple Maps "Hours: Open" pattern; saves a row at medium. | yes |
| P5 | Photos section with placeholders | No photo field exists. Hide the section when a station has no photos (default). Placeholders shown only to reserve the layout. | yes (placeholder) |
| P6 | Reviews block on the station page (summary + 2 previews + "See all") and 5→1 distribution bars on Reviews | Logic shows only the average in a stat card; previews need the reviews call on the detail page; bars need per-star counts (can be computed client-side from the list). | yes |
| P7 | "Charger host" sublabel on the host row | Copy exists in booking details; keeps the row from looking empty. | yes |
| P8 | Address row with "Get directions" in the large detent | A second, discoverable path to Directions. | yes |
| P9 | Paused station: inline notice + Book now disabled **before** booking | Logic only blocks at submit ("No API call"); telling the driver up front avoids a dead end. Reuses the real paused copy. | yes (04.07) |
| P10 | Offline station notice "This charger is offline right now. You can still book a later slot." | Logic allows booking offline stations; the notice explains why it's still bookable. | yes (04.08) |
| P11 | Skeleton loading in the sheet; plain error copy "Check your connection and try again." | Logic loading is a blank app bar + spinner and errors print raw text (same as 02 P15). | yes |
| P12 | Time-first readout (Time Window) at the top of Book a slot + sticky compact readout | Concept D; the readout is derived data only. | yes |
| P13 | Eyebrow "TODAY · SAT 4 OCT" on the readout | Date context next to the times. | yes |
| P14 | "now" marker and hour axis on the availability bar | Lets the driver read the bar; past segments already exist in logic. | yes |
| P15 | Scrub start times (drag across the grid) with loupe | Faster than tapping 15-min chips; haptic per step. Tap still works (logic). | yes (04.26) |
| P16 | Scrub the availability bar (long-press) to pick a window and start | Logic bar is non-interactive. Turns the bar into a direct picker. | yes (04.30) |
| P17 | "Go to {next day}" button when "No free windows on this day"; "Retry" on the times error | Fresha pattern; logic gives no path forward. Needs availability for the other strip days (lazy fetch after an empty day; hidden if no day in the 7-day strip has a window). | yes |
| P18 | 12-hour time on the Confirm sheet ("6:00 – 7:00 PM") | Logic format "HH:mm – HH:mm" is the only 24-hour time in the driver app. | yes |
| P19 | Estimate line under Total on Confirm: "Estimate. The charger's meter decides the final amount." | Brief's estimate copy; billed amount can differ (completed bookings show the billed amount). | yes |
| P20 | Success screen "You're booked" with the Charging Pass appearing; "View in Bookings" + "Get directions" | Logic has no success screen (Appendix 4) and jumps to Bookings; the pass moment is concept B/D. Destination is unchanged. | yes (04.43) |
| P21 | "Start charging within 15 minutes of 6:00 PM." on success | Surfaces the existing ±15-minute start rule (Appendix 4) before the driver arrives. | yes |
| P22 | Slot-taken: refetch availability, mark the chip unavailable, clear start, action "Pick another time" (instead of Retry) | Retrying a taken slot always fails. | yes (04.44) |
| P23 | Connection-interrupted action "Open Bookings" (instead of Retry) | The real copy tells the driver to check Bookings; Retry could double-book. | yes (04.46) |
| P24 | "Primary" sublabel on the selected vehicle row | Matches the picker's Primary pill. | yes |
| P25 | Disabled-CTA tap scrolls to and highlights the missing step | Explains the disabled state without new copy. | interaction only |
| P26 | Directions on iOS: add "Open in Apple Maps" when Google Maps isn't installed (logic falls back to a `geo:` URI, which is Android-only) | iOS reality; no new screen. | flag only |
| P27 | Add to Apple Wallet on success | Needs PassKit + the official badge; concept B flag. | no |
| P28 | Nearby alternatives carousel when a station is paused/offline | Uber Eats pattern. Needs a "similar stations" query. | no |
| P29 | Keep a draft of the booking choices for 10 min if the sheet is closed by accident | Logic has no draft. Not applied (cheap to redo). | no |
| P30 | Motion token `scrub` and `detent` added to Foundations "Motion" (with 02's tokens) | Keeps every flow's scrubbing and sheet behaviour identical. | doc |
| P31 | Review bodies truncated to 3 lines with a "More" link (expand in place) | Logic shows the optional body in full; truncation keeps the sheet scannable. New copy "More". | yes (04.03, 04.18) |
| P32 | "Driver" (anonymous) reviewers get the person.crop.circle glyph instead of initials | Logic renders an initials avatar for every row; "D" for "Driver" reads like a real name. | yes (04.18) |
| P33 | Error titles and actions the logic does not have: "Couldn't load reviews" (title above the real message) and "Retry" on the vehicle picker error (logic copy says "Try again, or add one." but names no button) | State View needs a title and a concrete action. | yes (04.21, 04.37) |
| P34 | All VoiceOver labels, hints, custom actions and announcements in §4 are new strings (accessibility only, not visible copy) | Same convention as 02-P34. "View Details" is reused as a real label for the sheet's custom action. | interaction only |
| P35 | Info icon next to the booking amount with the brief's estimate line (Cost Footer `Show info`) | Every amount in booking is an estimate (dummy maths 7.4 kW × h × 0.92 × Rs 42); the meter bills the real amount. Keeps the real footer copy unchanged. | yes (04.27) |
| P36 | Grabber tap toggles medium ↔ large instead of closing; close = ✕ / drag down / map tap | Logic: "Scrim tap or handle tap closes it." iOS convention (Apple Maps, Find My) makes the grabber a detent toggle; closing on a grabber tap would surprise iOS users. | interaction only |
| P37 | Station-level price stat "From Rs X" when connectors differ in price | Logic only prices per connector; the Stats Row needs one value. | rule only (story station has one connector) |

---

## 8. Edge cases & defaults chosen (Hammad asleep: decided)

1. **Calendar mismatch in the dummy data.** 4 Oct 2026 is actually a Sunday; the brief's shared story says "Sat 4 Oct". Frames keep the brief ("Today" + 4, then Sun 5 … Fri 10) so every flow matches; Rayan uses real dates.
2. **Detents.** Medium = sheet top at y 404 (≈ 54% of the screen); large = y 62. The floating card (02.08) is the level below medium, not a third detent. Selecting another pin keeps the current detent.
3. **Session active + sheet open.** The charging accessory is covered by the sheet (sheet is modal). When the sheet closes, the accessory is back. Booking while charging is allowed (logic has no block).
4. **Station status vs booking.** Available / In use / Offline / Maintenance: Book enabled (logic). Paused: Book disabled up front [P9] and still blocked at submit (logic). In use only means "someone is charging now"; later slots are fine.
5. **Rating.** Average to one decimal; rows use whole stars (logic). No reviews: "N/A" + "No reviews yet"; the Reviews page shows the Empty state. We never write "New".
6. **Distance.** Hidden as "N/A" without a GPS fix (logic). Directions meta then omits the "{km} · ~{min} min drive" line (logic: optional).
7. **Price.** "/hr" stations show "Rs 300/hr" in the connector row and "Per hr" in the stats; price ≤ 0 shows "N/A" and Book a slot ends at "Pricing unavailable".
8. **Multiple connectors.** One Connector Row per plug type (logic). The booking connector = the first connector matching the selected vehicle, preferring Available; the vehicle row label shows that plug ("BYD Atto 3 · Type 2 (AC)").
9. **Durations and windows.** Durations that don't fit the chosen start dim (logic). Windows shorter than the chosen duration dim (logic). If a duration is chosen first and no window fits, all windows dim and the hint reads "Longest here: {longest window}". Selecting a window that can't contain the current start clears the start.
10. **"Longest here" format.** "{Xh Ym}" drops a zero part: "3h", "45m", "2h 30m".
11. **Date change** clears window and start (logic) but keeps the duration. Closed days stay tappable (to show the message) rather than Disabled; Date Pill Disabled is reserved for days past the 7-day range (none visible).
12. **Windows crossing midnight** are clipped at 12 AM; the next day starts its own windows.
13. **"Now" inside a window.** Start chips before now + 15 min are hidden (they are "past" in the bar).
14. **Vehicle auto-pick.** Primary compatible, else first compatible (logic). If the primary is incompatible but another fits, the row shows the fitting one with no error.
15. **No vehicle / no match.** The CTA "Add a vehicle" wins over all time states (first matching row of the logic table). Cost still shows if a time is set.
16. **Repeated taps.** Confirm is ignored while submitting (logic). Tile/chip taps during a running spring retarget the spring (no queueing).
17. **Back/close with choices made.** Discarded silently (logic has no draft). Swipe-down is allowed on Book a slot, not on Confirm while submitting.
18. **Snackbar → Toast.** All logic snackbars render as `Toast` 1088:631 with 02's timing rule: 6 s for submit errors (logic) and for any toast with two lines or an action, 4 s for one line without an action; one at a time; never over the footer, the Floating Action Pill or the home indicator (placements in §2.0).
19. **Long names / addresses.** Header title 2 lines (large) / 1 line (collapsed and compact readout), tail ellipsis; VoiceOver reads full strings. Address 2 lines at both detents (logic), tail ellipsis after line 2.
20. **Dynamic Type (AX sizes).** Stats Row wraps to 2×2; Quick actions become 2×2 tiles; time grid drops to 3 then 2 columns; readout times stack vertically (start over end); Cost Footer amount moves above the CTA.
21. **VoiceOver order in Book a slot:** header → readout → station → DATE → WHEN (peak note, durations, availability, windows, start times) → VEHICLE → footer. The footer is reachable from anywhere with the rotor ("Actions").
22. **Reduce Motion / Transparency.** See §4.0. The pass drop on success becomes a cross-fade; Frost and the dim become solid Surface/scrim.
23. **Android.** Same layouts; sheets are Material bottom sheets with the same two heights; Frost without blur; haptics mapped as in 02.
24. **Confirm sheet rows** stay the logic four (Date, Time, Duration, Total). The vehicle is not added to keep the dialog identical to code.
25. **Availability bar range.** Always 12 AM–12 AM so days compare at a glance; closed hours render as Unavailable.
26. **Success when the app is killed mid-submit.** On next launch the booking simply appears in Upcoming (logic); no success screen is replayed.
27. **Encrypted-looking address** (logic): the Book a slot station row drops the address and starts at the connector ("Type 2 (AC) · 7.4 kW"). The place sheet header shows the same fallback subtitle "Type 2 (AC) · 7.4 kW" rather than a cipher string.
28. **Different prices per connector** → Stats "From Rs {lowest}" [P37]; each Connector Row keeps its own price; Book a slot quotes the connector chosen for the vehicle (edge case 8).
29. **Vehicle list fails to load** → the row renders exactly like "No vehicle added" + Add (logic merges error and none); the picker shows its own error (04.37).
30. **Maintenance** → status text/warning, Unavailable pin (02 table), no notice, Book now enabled (logic (?)). If the backend later blocks it, it will surface as a server-message toast (04.53).
31. **Review counts** → "1 review" / "Based on 1 review" singular; "N reviews" plural; 0 → "No reviews yet" / "N/A".
32. **Dummy calendar.** Review dates (September 28, 21, 14; August 30, 2026) stay before the story's "today" (4 Oct) so nothing reads as a future review.

---

## 9. Logic-check summary (for the logic card)

Covered from the logic map:
- §B station preview sheet: name, status for all five values (as Stats Status + colour; Maintenance 04.49), address (2 lines), connector row (plug label, "{kW} kW · {status}", "Rs X" + "/kWh|/hr"; hourly 04.50), View Details (= large detent + VO custom action), Book now, "Scrim tap or handle tap closes it" (map tap closes; grabber tap → detent toggle [P36]), no disabled state for paused/offline (kept for offline/maintenance; paused disabled up front [P9]). Distance now displayed (02 P2).
- §B `StationDetailScreen`: back, heart toggle + error, status, name, address with pin, 3 stats (rating tappable → reviews, distance GPS-only, connectors count), Connectors list, Host (initials + name), Directions + Book now (2× width) bottom bar (Floating Action Pill), "Station location is not available", loading, error + Retry + Go Back.
- §B `GetDirectionsModal`: every string, Cancel, both failure messages.
- §B `StationReviewsScreen`: title, summary, rows (initials, "First L."/"Driver", date, whole stars, body), loading, error + Retry, empty, pull-to-refresh.
- §C `BookingCreateScreen`: station card + meta (encrypted-looking address hidden), DATE strip (7 days, Today default, clears window/start), WHEN (peak note, loading, error, closed, duration chips + dimming + "Longest here", day availability bar + legend, windows + dimming + scroll to grid, start grid states + placeholder + fallback + tap-to-deselect), VEHICLE row (loading 04.51, none + Add, load error = none, choose, selected, both error lines, auto-pick), vehicle picker (rows, Primary, incompatible reason, Add vehicle + auto-select, loading 04.52 / error 04.37 / empty 04.36), cost footer (both quote formats, full-width CTA when no cost, full CTA table incl. "Pricing unavailable"), confirm dialog (all rows, Confirm/Back, cost failure), submit (paused, success → Bookings tab, all seven error messages with Retry, 6 s: four as frames 04.44–04.47, the other four on board 04.53), "Offline and maintenance stations are not blocked client-side (?)" (04.08, 04.49), screen-level loading/error (04.22/04.23).
- §H `ManualCallSheet` copy re-used for the Call [P3] sheet (component from 09; same as 07.30/09.30).
- Appendix 4: no success screen (now P20, destination unchanged); distance not displayed (now displayed).

Not in this flow:
- Floating preview card, pins, Home states → 02.
- Search → 03.
- Add/Edit vehicle form → Profile flow.
- Bookings tab, pass detail, cancel → Bookings flow.
- Start charging / ±15-minute window enforcement → Charge flow.

---

## 10. Review notes (review pass, 2026-10-04)

What the reviewer changed, against the brief, the logic map (§B preview sheet, `StationDetailScreen`, `StationReviewsScreen`, §C `BookingCreateScreen`) and sibling specs 02/07/08/09:

**Missing or misquoted logic states, errors and copy**
1. Preview sheet address is "Address (2 lines)" in the logic; the draft cut it to 1 line at medium. Now 2 lines at both detents; 04.01 and 04.07 coordinates re-flowed (+20pt).
2. Logic "Scrim tap or handle tap closes it" had no mapping. Added the close map in §1, rules 4.1-22/23 and [P36] (grabber toggles detents, map tap closes).
3. "View Details" (real) had disappeared inside the sheet. Kept as the VO custom action on the medium sheet (§3.1, 4.1-23).
4. Status **Maintenance** had no frame → 04.49 (no notice, Book now enabled, as logic and 02.31 row 5). Hourly price had no frame → 04.50 ("Rs 300" "/hr", "Per hr").
5. Vehicle row **Loading** and picker **Loading** had no frames → 04.51, 04.52. Vehicle-load error = "No vehicle added" noted on 04.38 and in edge case 29.
6. Four real submit errors ("server message", "Invalid booking details…", "Station not found.", "Failed to create booking") were only listed → drawn on board 04.53.
7. "Longest here: {Xh Ym}" was hidden on 04.24 without a logic basis → shown ("3h"), with the rule for what it measures.
8. Station row "encrypted-looking address is hidden" was missing → §2.0 stack item 2, §3.5, edge case 27.
9. StationDetail "Book now (2× width)" → Floating Action Pill split 2/3 · 1/3 on 04.03/04.12.
10. Compact rating summary showed 5 whole stars for 4.8 → single star.fill (logic "★ average").
11. 04.22–04.23, 04.19–04.21 now name their State View variants and ids; 04.16 notes the second real failure string "Error opening maps…".

**Invented data without a flag**
12. New flags P31 ("More" truncation), P32 (glyph avatar for "Driver"), P33 ("Couldn't load reviews" title, "Retry" on the vehicle picker), P34 (all VoiceOver strings), P35 (estimate info on the footer), P36 (grabber behaviour), P37 ("From Rs X" station price). P17 now states the extra availability fetch it needs. Bare "[P]" tags in rows 6–7 now carry their P numbers.

**Brief inconsistencies fixed**
13. Dim was "bg/scrim at 30%"; the brief puts the alpha in the variable → bound as is, everywhere (§2.0, 04.02, 04.03, 4.1-2/3).
14. Toasts at y 790 collided with the home-indicator zone → bottom edge y 828 (no footer), 760 (above the pill), 750 (above the Cost Footer). Toast timings now follow 02's rule (edge case 18).
15. 04.43 Tertiary button ended at y 832, inside the 16pt bottom margin → buttons moved to 708/768 (ends 820). Bottom-margin rule added to §2.0.
16. 04.12 used Title 1 for the screen title → Large Title (brief "screen titles = Large Title"); its cards mixed Surface and Frost Strong → all `bg/frostStrong` (same as 02.15/02.20 on Quiet mesh). Contrast rule restated: no text/secondary or 68% Frost on Hero/Celebrate mesh in this flow.
17. 04.26 touch marker was white on a white sheet (invisible) → `bg/fillStrong` + `stroke/focus`; scrub chip colours bound to `action/primary` (were "brand/primary").
18. 04.17 now matches 09.30 exactly (Manual Call Sheet, coordinates, centred text) so one component serves 04/07/09.
19. Section header now carries the brief's title + status line and the FLAG — PROPOSALS block; frame labels confirmed as `04.nn · Screen · State` like 01/02. Vehicle plug strings ("Type 2, CCS 2") vs station connector labels ("CCS2 (DC)") documented as deliberate (matches 08 and 02).
20. Entry from Bookings "Book again" (07-BK14) added to the entry table.

**Micro-interactions made concrete**
21. §4 rewritten so every rule states trigger → response · timing · haptic · VO · RM. Rules that lacked one or more were filled (4.1-4/6/7/9/10/12/13/14/20/21, all of 4.2, 4.3-1/3, all of 4.4, 4.5-1/3/4/5, 4.6-1/3/5/9/10/12–15/17, 4.7-1/2/4/5, 4.8-1/2/3/5/6, 4.9-1/3/4/5). New rules: 4.1-22/23/24, 4.2-5/6, 4.3-4, 4.6-18/19/20, 4.7-7/8/9/10, 4.8-7. A shared preamble fixes press scales, haptics-on-release, the 150 ms / 600 ms loading rule and toast rules (all from 02 §4.0). Rule numbers cited by other specs (e.g. 07 → "04 §4 rule 5" = 4.8-5) are unchanged.

**Mobbin**
22. Call host (04.17) had 0 references → §5.10 with 3. Confirm sheet had 1 direct reference → +4 (Fresha review, American Airlines total, Tripadvisor submitting, Zocdoc counter-example). Added state-view/skeleton refs (Shop, Oura, Noom), Directions (Mindtrip map choice for P26, Fly Delta), vehicle errors (Luma, Fresha), duplicate-booking error (Zocdoc). 7 review searches, all `platform ios`, `output_destination design_tool`, `output_tool Figma`, `mode standard`, `image_format jpg`. Total 67 unique links; every major screen group has ≥ 3.
