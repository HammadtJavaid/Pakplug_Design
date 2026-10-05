# 07 · Bookings: Charging Passes (list, every status, pass detail, cancel, Wallet)

> **00-system alignment (2026-10-04, read first).** `00-system.md` is the single answer for navigation, sheets, motion, haptics, shared components, section names, formats, tones and materials; where this spec still differs, 00-system wins. Applied to this spec: (1) Section names are `Flow 7A`–`7D` (00-system §4). (2) Pass detail sheet: large detent top y 62, grabber (183,67), header = `Sheet Header` Form at (0,78) with a Fill S Close (never a Nav Bar inside a sheet); the layers below keep their y values. (3) Real copy is verbatim: "Confirming..." keeps its three dots. (4) Ready and Live dots use `pulse` (1.33 s ring, 00-system), not a 1.6 s opacity loop. (5) 07.30 is `Sheet / Action` Kind=Call, leading-aligned (C3). (6) Status Pill Spinner, Quick Action Tile Badge, Alert Stacked + Message lead, Perforation and Skeleton Block are C14; Avatar is C8; Notification Preview and iOS / Refresh Control mocks follow C13 rules. (7) Step haptics are `scrub`; `tick` is 06's 1 s clock.

Spec for the Figma build of Flow 07. Research only: no Figma calls were made.
Sources: `BRIEF.md`; `driver-logic-map.md` §G (`DriverMyBookingsScreen`, buckets, empty states, `DriverBookingCard` → `BookingListCard`, `DriverBookingDetailsBottomSheet`, `DriverCancelBookingModal`, `BookingDetailScreen` (unreachable)), §A (shell, tab intents, charging pill), §D (±15-minute start window, too early / ended copy), §H (chat booking banner "Upcoming booking" / "Charging now", read-only details sheet, `ManualCallSheet`), Appendix 1 (pushes, badges, offline banner, "Confirming..."), Appendix 2 (foreground banner, 6 s), Appendix 3 (Bookings copy), Appendix 4 (paused bookings in no tab; raw status in details); design spec §4.1-4 (native segmented control) and D9 (B · Charging Pass: "the pass detail is the booking detail; the pass turns live while charging"); sibling specs `02-discover.md` (motion tokens, haptic map), `04-station-book.md` (04.43 "You're booked" hands the pass to this flow, Inline Notice, Avatar, call host sheet, directions sheet), `05-charge-start.md` (Next Booking Card, "Ready to start", `roll`, scanner 05.07, charger code "GV7-K42"), `01-onboarding.md` (Notification Preview · In-app banner). 17 Mobbin searches (iOS; 12 in the draft + 5 in review), 65 unique Mobbin links kept (56 screens + 9 flows). Host names follow 09's thread table: Bilal (GreenVolt), Usman (Model Town, no phone number), Kamran (Gulberg Galleria).

Notation
- `[BK#]` = a proposal from this flow (not in the logic map). Every `[BK#]` is listed in §7 and must appear in the FLAG — PROPOSALS block of the logic-check card. `[04-P#]` / `[CH#]` point to proposals already made in Flows 04 / 05.
- "Real copy" = quoted verbatim from the logic map. Everything else is a proposal and is marked.
- Component references use the brief inventory: `Name [set id] → Variant id`.
- Motion tokens and the haptic map are the ones in 02 §4.0 (`snappy`, `smooth`, `bouncy`, `fade.quick` 150 ms ease-out, `fade.std` 220 ms ease-out) plus 00-system §2.1 (`roll`, `scrub`, `pulse`). One addition here, §4.0: `sheen`. No other new curves.
- Numbers follow the app format: `Rs 1,877`, `6.8 kWh`, `≈26%` (battery is always an estimate), `6:00 PM`, `1 h 10 min`. Times are 12-hour everywhere [BK22].

---

## 1. Overview

**Goal.** Bookings is the driver's wallet of **Charging Passes** (concept B, approved D9). One glance answers "what's next, when can I start, and how do I get in?" Every pass carries one honest status, and the next pass is always the big one on top. Opening a pass *is* the booking detail. The pass changes as time passes: Upcoming → Ready to start (inside the ±15-minute window) → Charging now (live, while a session runs) → Completed. If something goes wrong, it becomes Cancelled by you, Cancelled by host or Expired. Cancelling is one native destructive alert, and it lands you on the Cancelled tab with the pass already there.

**What the logic gives us (unchanged):** three tabs Upcoming · Completed · Cancelled, which are swipeable pages; the buckets; the optimistic "Confirming..." booking; socket `booking_updated` refresh; pull to refresh; offline cache banner; three empty states with **Explore chargers** on Upcoming; the details sheet (charger, Booking information, Access notes, host with Call / Message + unread dot, View charger, Cancel booking); the cancel dialog and its success/error paths; the review links on completed bookings.

**What the design adds (flagged):** a Wallet-style front pass for the next booking; live statuses on the pass (Ready to start, Expiring soon, Charging now) [BK2, BK3, BK26]; **Scan to start** right on the pass [BK8]; charger code on the pass detail [BK9]; Directions [BK10]; Add to Apple Wallet [BK12]; "Book again" on finished or failed passes [BK14]. It also fixes the two data quirks the code has: paused bookings fall into no tab [BK4], and the details pill uses the raw status [BK5].

### 1.1 Status model (one table for list, pass and sheet)

The status→tone mapping follows **C7** (`Status Pill` section 980:287: "status→tone table for every code status"). The build agent must open C7 and diff it against this table before building. **If a row differs, C7 wins**, and only the pill tone changes.

| # | Code condition (logic) | Tab (bucket) | Pill label | Status Pill tone (variant S) | Pass face (Charging Pass status) | Tappable |
|---|---|---|---|---|---|---|
| S1 | Optimistic pending booking (`pendingBookingProvider`) | Upcoming, on top | "Confirming..." (real, rendered verbatim with three dots, 00-system §5.1) | Neutral S 980:332, Dot off + 10pt spinner [new prop, §6] | **Confirming** (new) | **No** (logic) |
| S2 | `confirmed`, now < start − 15 min | Upcoming | "Upcoming" (real) | Info S 980:326 | Upcoming (existing 1010:441 / 1010:417) | yes |
| S3 | `confirmed`, start − 15 min ≤ now < end, no session, more than 15 min left | Upcoming | "Ready to start" [BK2] (same label as 05.01) | Success S 980:314, Dot on (pulsing) | **Ready** (new) | yes |
| S4 | as S3, ≤ 15 min left in the window, no session (pairs with push `BOOKING_EXPIRING`) | Upcoming | "Expiring soon" [BK26] (echoes the real push title "Booking expiring soon"; "Ending soon" is reserved for 06's live-session pill at 5 min left, so the two never collide) | Warning S 980:320, Dot on | **Ready** + warning edge | yes |
| S5 | `confirmed` or `paused` **and** an active session on this booking (`sessionProvider`) | Upcoming | "Charging now" (real: chat banner copy) [BK3] | Live S 980:344, Dot on (pulsing) | **Live** (new) | yes |
| S6 | `paused`, no active session | **Upcoming** (fix: code puts it in no tab) [BK4] | "Paused" (real: details pill) | Warning S 980:320 | **Paused** (new) | yes |
| S7 | `completed` | Completed | "Completed" (real) | Success S 980:314, Dot off | Completed (existing 1010:471 / 1010:425) | yes |
| S8 | `cancelled`, actor = driver | Cancelled | "Cancelled by you" (real: details) [BK6 on the list] | Neutral S 980:332 | Cancelled (existing 1010:496 / 1010:433) | yes |
| S9 | `cancelled`, actor = host | Cancelled | "Cancelled by host" (real: details) [BK6] | Error S 980:338 | Cancelled | yes |
| S10 | `cancelled`, actor unknown | Cancelled | "Cancelled" (real) | Neutral S 980:332 | Cancelled | yes |
| S11 | `expired`, **or** `confirmed` with end ≤ now (no session started = no-show) | Cancelled | "Expired" (real) | Warning S 980:320 | **Expired** (new: Cancelled face + warning pill) | yes |

- **No-show** has no status in code. A confirmed booking whose window passes without a session is shown as "Expired" (logic). We keep that label and explain it on the pass detail: "No charging session was started during this slot." [BK15]. If the backend later adds a no-show fee, S11 gets the label "No-show" and Error tone. That change needs no new component.
- **Live pass in its last 5 minutes** (6:55 PM, brief: "Ending soon at 6:55"). S5 keeps the Live pill "Charging now"; only the 3pt top edge cross-fades energy → status/warning and the countdown reads "5 min left". This is the same moment 06 shows its "Ending soon" pill and the accessory switches to State=Ending 967:135 (06-P27). No separate status row and no new variant: it is the `Edge` = Warning prop on the Live face (§6).
- **Pill contrast on emerald faces.** The Status Pill tints were measured on light surfaces. Before building, screenshot one Front pass at 2× with every S pill on the emerald face. If a tint fill renders translucent and its label drops below 4.5:1, put the pill on a 2pt-padded bg/surface 948:41 capsule (same fix as 05.25). Never recolour the pill label white.
- **Pill vs. countdown.** The pill is the status. The countdown is a separate line on the pass ("Starts in 10 min") [BK7], so the pill label stays stable and short.
- **Details sheet uses the same derived status** as the list (S1–S11) [BK5]. The code reads the raw status, so a past confirmed booking shows "Upcoming" in the sheet while the list says "Expired". The fix is shown in 07.27 as a before/after annotation.

### 1.2 Dummy data (consistent with the brief and Flows 04–06)

Driver Ayesha Khan · BYD Atto 3 (primary) · MG ZS EV. Hosts (shared with 09's thread table): GreenVolt = **Bilal**, 0321 4567890 (as in 04.17); Model Town Home Charger = **Usman**, no phone number (09 T2); Gulberg Galleria Charger = **Kamran** (09 T4). Charger code of GreenVolt: **GV7-K42** (as in 05). Today = **Sat 4 Oct 2026**, Asia/Karachi. Prices are the brief's estimate maths (kWh × 0.92 × rate), matching 04's "1 h Rs 286".

| Pass | Station | When (list format, logic `"{Today|Tomorrow|EEE, MMM d}, h:mm a · {duration}"`) | Times | Vehicle · connector | Amount |
|---|---|---|---|---|---|
| P-A (the story) | GreenVolt · DHA Phase 5 | "Today, 6:00 PM · 1 h" | 6:00 PM → 7:00 PM | BYD Atto 3 · Type 2 (AC) | Rs 286 (est.; billed Rs 286 when completed) |
| P-B | Model Town Home Charger | "Tomorrow, 9:00 AM · 1 h 30 min" | 9:00 AM → 10:30 AM | BYD Atto 3 · Type 2 (AC) | Rs 577 (11 kW × 1.5 h × 0.92 = 15.2 kWh × Rs 38) |
| P-C | Gulberg Galleria Charger | "Wed, Oct 8, 7:30 PM · 30 min" | 7:30 PM → 8:00 PM | MG ZS EV · CCS2 (DC) | Rs 1,877 (brief: 27.6 kWh × Rs 68) |
| Completed 1 | GreenVolt · DHA Phase 5 | "Today, 6:00 PM · 1 h" | | BYD Atto 3 · Type 2 (AC) | Rs 286 · link "Leave a Review" |
| Completed 2 | Model Town Home Charger | "Thu, Oct 2, 9:00 AM · 1 h 10 min" | | BYD Atto 3 · Type 2 (AC) | Rs 449 (11.8 kWh × 38) · "Edit Review" |
| Completed 3 | Gulberg Galleria Charger | "Fri, Sep 19, 7:30 PM · 32 min" | | MG ZS EV · CCS2 (DC) | Rs 2,002 (29.4 kWh × 68) · "View Review" |
| Completed 4 | Johar Town Fast Hub | "Sat, Sep 13, 5:00 PM · 45 min" | | MG ZS EV · CCS2 (DC) | Rs 1,139 (20.7 kWh × 55) · "Review period ended" |
| Cancelled 1 | GreenVolt · DHA Phase 5 | "Thu, Oct 2, 8:00 PM · 1 h" | | BYD Atto 3 · Type 2 (AC) | "—" · Cancelled by you |
| Cancelled 2 | Model Town Home Charger | "Mon, Sep 29, 9:00 AM · 1 h 30 min" | | BYD Atto 3 · Type 2 (AC) | "—" · Cancelled by host |
| Cancelled 3 | Gulberg Galleria Charger | "Sat, Sep 27, 7:30 PM · 30 min" | | MG ZS EV · CCS2 (DC) | "—" · Expired |
| Cancelled 4 | Johar Town Fast Hub | "Sun, Sep 14, 5:00 PM · 45 min" | | MG ZS EV · CCS2 (DC) | "—" · Cancelled |

Live numbers at 6:32 PM (from the brief and 05/06): 32 min in, 28 min left, +3.6 kWh, ≈26% est., Rs 152 so far.
Access notes (dummy, a real field): "Gate code 4471. Park in the left bay — the charger is on the garage wall."

### 1.3 Entry points
- Tab bar → **Bookings** (index 2).
- Booking success: 04.43 "View in Bookings" / swipe down. The logic "replaces the whole stack with the driver shell on the Bookings tab". The new pass flies to the top of Upcoming.
- 04.46 "Open Bookings" (connection interrupted) [04-P23]: lands on Upcoming. The pull-to-refresh hint is in 07.14.
- Push `BOOKING_STATUS_CHANGED` ("Booking update") → `/my-bookings`, which the logic opens as a **pushed route** (back chevron, no tab bar) and ignores `bookingId`. The logic version is framed in 07.40. Designed: it opens the Bookings tab with that pass's detail on top [BK20]. The foreground in-app banner tap (Appendix 2) goes to the same place.
- Notifications list (08.53): a `BOOKING_STATUS_CHANGED` or `BOOKING_EXPIRING` row marks itself read, then opens `/my-bookings` (logic §I; pushed, 07.40). Designed: same as the push (BK20 / CH20).
- Chat system cards "Booking cancelled" / "Booking expired" / "Charging session completed" (09.16; tappable in logic) → the same read-only pass detail as the chat banner (07.29).
- Charge tab Next Booking Card (05.01–05.03 [CH1]) → pass detail 07.21 / 07.23.
- Chat booking banner ("Upcoming booking" / "Charging now") → read-only pass detail 07.29 (logic: no cancel, no chat).

### 1.4 Exits

| From | Action | Goes to | Owner flow |
|---|---|---|---|
| Upcoming empty · **Explore chargers** | tap | Home tab (logic: tab intent 0) | 02 |
| Ready pass / detail · **Scan to start** [BK8] | tap | Scanner 05.07 (the logic's checks run after the scan) | 05 |
| Live pass / detail · **View session** | tap | `ActiveSessionScreen` (slideUp) | 06 |
| Detail · Charger card **View charger** | tap | Station details 04.12 (`/station-details`) | 04 |
| Detail · **Message** | tap | `ChatThreadScreen(bookingId)` on root | Messages |
| Detail · **Call** | tap | thread resolve → `ManualCallSheet` (07.30) | Messages |
| Detail · **Directions** [BK10] | tap | `Sheet / Directions` → Google Maps (07.31) | 04 |
| Completed · **Leave a Review / Edit Review / View Review** | tap | `LeaveReviewModal` (new / edit / read-only) | 06 (Complete) |
| Completed / Cancelled / Expired · **Book again** [BK14] | tap | Book a slot for that station (04.24) | 04 |
| Cancelled by host · **Find another charger** [BK14] | tap | Home tab | 02 |

### 1.5 Sequence

```
Bookings tab ─segment / swipe─▶ Upcoming | Completed | Cancelled     (pull to refresh · socket booking_updated · offline cache)
   │
   └─tap pass─▶ Pass detail (sheet, large detent)
                 ├─ Scan to start ──▶ 05 Scanner            (Ready, Expiring soon)
                 ├─ View session ───▶ 06 Live               (Charging now)
                 ├─ Directions / Message / Call / View charger
                 ├─ Add to Apple Wallet ─▶ PassKit sheet ─▶ "View in Wallet"   [BK12]
                 └─ Cancel booking ─▶ Alert "Cancel booking?" ─Keep booking─▶ back
                                              └─Cancel booking─▶ blocking spinner ─▶ ok: Cancelled tab + toast
                                                                                  └▶ error: toast (server message);
                                                                                     "cannot be cancelled"/"expired" → Cancelled tab
```

### 1.6 Sections on Driver Flows (946:8)

Four sections, each ≤ 14 frames (00-system rule). Place each one 160 below the current page bottom at x = 0. Copy the fills from 1076:2. Title (Title 1) goes at (80,80) and the status line (Footnote, text/secondary) at (80,124).

| Section | Frames | Status line |
|---|---|---|
| `Flow 7A · Bookings · Charging Passes` | 07.01–07.09 + 07.40 (10) | "Bookings tab as Wallet-style passes: every status, live updates · 10 frames · built from components" |
| `Flow 7B · Bookings · Empty, loading & errors` | 07.10–07.20 (11) | "Empty tabs, loading, pull to refresh, offline cache, errors · 11 frames" |
| `Flow 7C · Bookings · Pass detail` | 07.21–07.31 (11) | "The pass detail is the booking detail: every status, host, directions · 11 frames" |
| `Flow 7D · Bookings · Cancel & Wallet` | 07.32–07.39 (8) | "Cancel booking (native alert, blocking, success, errors), Add to Apple Wallet · 8 frames" |

---

## 2. Screens & states

### 2.0 Shared geometry

**A. Bookings tab** (07.01–07.20). 402×874, root tab.

| Layer | Position / size | Component / fill |
|---|---|---|
| Background | (0,0) 402×874 | `Mesh Quiet` 951:7417 (brief: lists). Normal text colours. |
| Status bar | (0,0) | `iOS / Status Bar` Dark 996:398. Override the clock to the frame's scenario time. |
| Nav bar | (0,54) 402×103 | `Nav Bar` Style=Large 1087:624, Title#1087:0 "Bookings" (logic), Leading off, Trailing 1 off, Trailing 2 off. |
| Tabs | (16,165) w 370 | `Segmented Control` 3 segs: sel1 970:197 / sel2 970:204 / sel3 970:211; override the inner texts "Upcoming" · "Completed" · "Cancelled" (logic). Resize the width to 370 and keep the component height (≈36). Native `UISegmentedControl` (design spec §4.1-4). |
| Page content | x 16, w 370, from y 217 | Each tab is its own vertical scroll page (logic: swipeable `PageView`). The header (title + tabs) stays fixed. When the content scrolls up, the large title collapses to inline and the tabs pin under it on a bg/frostStrong band (native behaviour). |
| Accessory (session only) | (20,728) 362×52 | `Tab Bar Accessory / Live Charging` State=Charging 967:124 |
| Tab bar | (20,788) 362×64 | `Tab Bar` Selected=Bookings 966:135, Messages badge "2" |
| Home indicator | (0,840) | `iOS / Home Indicator` Dark 996:425 |
| Toast slot | (16,724) 370 | `Toast` [1088:631], 12 above the tab bar (12 above the accessory when it shows: y 664) |

**Pass sizes.** The front pass is a `Charging Pass` Front variant set to **370 wide**. Rescale proportionally if the master is narrower, then read the real height. This spec assumes **370×232**. The stacked pass is a Stacked variant at 370 wide; this spec assumes **370×88**, or **370×120** with a review link. If the real heights differ, keep the gaps below (12 between the pass and the next element, 10 between stacked passes, 24 before a group header) and shift everything else.

**Front pass anatomy** (for the new status variants; match the existing Front Upcoming 1010:441 and inspect it before building):
- Radius `radius/lg` 22 with clip. Face = brand/primary 947:3 (Upcoming family) or the existing Completed / Cancelled faces. Shadow `effect/shadowSoft`.
- Padding 16. **Row 1:** `Brand / Mark / PakPlug P` Style=Solid 991:69 at 20pt + station (Title 3, white, 2 lines max). The `Status Pill` S sits top-right. Under the pill: the countdown (Footnote, white, right-aligned) [BK7].
- **Row 2:** date "TODAY · SAT 4 OCT" (Caption 1 Emph, white, tracking +4%).
- **Row 3:** Time Window anatomy: "6:00 PM" (Display/M 28 Light, white) · thin arrow + "1 h" (Footnote, white) centred · "7:00 PM" (Display/M). If the existing pass already nests `Time Window` [1011:440], reuse it.
- **Perforation:** a 1pt dashed white 35% line with 12pt semicircle notches cut into both edges (decorative; Wallet / Meetup ticket).
- **Footer:** 3 columns. Labels (Caption 2 Emph caps, white): VEHICLE / CONNECTOR / **EST. TOTAL** on Upcoming, Confirming, Ready, Live and Paused faces (the amount is the booking estimate, brief: every estimate is labelled) and **TOTAL** on Completed (billed amount) and Cancelled / Expired faces [BK35]. Values: "BYD Atto 3" (Subheadline, white) / "Type 2 (AC)" (Subheadline, white) / "Rs 286" (Display/S 22 Light, white).
- **All text on emerald is solid white.** White on #0C7A4A is 5.4:1. White at 76% fails (≈3.8:1), so never use translucent white for text. The `sheen` band is capped at 8% white over text zones for the same reason (§4.0).
- **No chevron on passes.** The logic card has a trailing chevron; the whole pass is the tap target and the press state (§4.1-3) is the affordance, as in Wallet [BK34].

**Stacked pass anatomy:** 370×88, radius lg, padding 14/16. Text colours follow the face: solid white on the emerald Upcoming-family faces; on the existing Completed / Cancelled faces keep the master's text colours (inspect 1010:425 / 1010:433 first; if those faces are light, use text/primary + text/secondary, never white). **Row 1:** P mark 16 + station (Headline, 1 line, truncate) + `Status Pill` S trailing. **Row 2:** schedule "Tomorrow, 9:00 AM · 1 h 30 min" (Subheadline) + amount trailing (Display/S). **Row 3:** "BYD Atto 3 · Type 2 (AC)" (Footnote). Completed adds a 32pt **Review Link** row under a hairline (total 120).

**B. Pass detail sheet** (07.21–07.31). It sits over a Bookings tab composition.

| Layer | Position / size | Component / fill |
|---|---|---|
| Behind | (0,0) | The list frame it came from (07.02 unless stated), with `bg/scrim` 948:48 over it at full frame. The presenting view does **not** scale (iOS 26 large-detent sheet on iPhone). Status bar: keep Dark 996:398 unless the screenshot shows the scrimmed top band darker than mid-grey; then use Light 996:411 (brief: Light only where the top is dark). |
| Sheet | (0,62) 402×812 (00-system large detent) | bg/surface 948:41, top corners `radius/sheet` 38, effect Frost/Elevated, clip. Grabber 36×5 bg/fillStrong 948:47 at (183,67), radius pill. Detents: **large only**. A medium detent would cut the pass in half. |
| Sheet header | (0,78) 402×52 | `Sheet Header` Form 1008:413 (00-system: never a Nav Bar inside a sheet), Title "Booking details" (logic; the logic's status pill beside the title moves onto the pass, same derived label [BK5]), Subtitle off, no Back, trailing Close = `Icon Button` Fill S 979:286 xmark 958:72 (VoiceOver "Close"). It stays pinned while the content scrolls, with a hairline (stroke/hairline) below it once scrolled. |
| Pass | (16,136) 370×232 | `Charging Pass` Front, status per frame |
| Context line | (16,380) w 370 | Footnote, text/secondary, centred, 1–2 lines (per frame) |
| State CTA (optional) | (16,412) 370×52 | `Button / Large` per frame. When there is no CTA, everything below moves up 64. |
| Quick actions | y = CTA bottom + 16 (or 412), w 370 | 3 × `Quick Action Tile`, FILL, gap 8: **Directions** = Primary 1008:423, Icon arrow.triangle.turn.up.right.diamond.fill 1024:496 [BK10]; **Message** = Tinted 1008:427, Icon message.fill 966:7, unread dot [§6]; **Call** = Tinted, Icon phone.fill 1024:476. Label texts "Directions" / "Message" / "Call". The logic's Call and Message circles move here from the host card (same actions, new placement) [BK11]. Call is hidden when no socket URL is configured (logic), and the row becomes 2 tiles. |
| Charger card | y = tiles bottom + 16, 370×112 | Container bg/grouped 948:42, `radius/md` 16, padding 16, horizontal gap 12: 40pt circle bg/tint 948:45 with ev.charger.fill 1024:480 20pt icon/brand (logic: "bolt avatar"; ev.charger.fill is the station glyph used for the same well in 05.35, so the app keeps one station icon; bolt.fill 958:35 stays reserved for "charging now") · column: "GreenVolt · DHA Phase 5" (Headline) / "Street 12, Block CCA, DHA Phase 5, Lahore" (Footnote, text/secondary, 2 lines) / plug icon 16 (ev.plug.ac.type.2 981:294, icon/secondary) + "Type 2 (AC) · 7.4 kW" (Footnote) · trailing "View charger" (Footnote Emph, text/brand, logic label) + chevron.right 958:55 icon/tertiary. The whole card is the tap target. |
| Booking information | below, scrolls | `List Group Header` [983:389] Label "Booking information" (logic) · group container bg/grouped radius 16, clip · 4 × `List Row` Value 983:352 (Icon off): "Scheduled date" / "Oct 4, 2026" · "Scheduled time" / "6:00 – 7:00 PM" · "Duration" / "1 hour" · "Total cost" / "Rs 286" (value text set to Display/S). Labels are the logic's; only the value formats change [BK22]. Separators on, except the last row. Upcoming only: under the group, Footnote text/secondary "Estimate. The charger's meter decides the final amount." [BK21 = 04-P19]. |
| Access notes | below | `List Group Header` "Access notes" (logic, shown only when present) · card bg/grouped radius 16 padding 16: Subheadline text/primary (dummy note above). |
| Host | below | `List Group Header` "Host" · card bg/grouped radius 16 padding 12/16, 64 tall: **Avatar** M (04 §6) "B" · "Bilal" (Headline) / "Charger host" (Footnote, text/secondary; logic). Identity only; the actions live in the tile row [BK11]. Initials and name follow the booking's host (Model Town = "U" Usman, Gulberg = "K" Kamran). |
| Apple Wallet | below, centred | **Wallet Badge** [new, BK12] 160×50 (official artwork placeholder). It is hidden when the device can't add passes. |
| Destructive | below | `Button / Large` Destructive Secondary Default 978:397 "Cancel booking" (logic: outlined red). Shown only when the booking is confirmed or paused **and** not past its window (logic), **and** no session is live on it [BK13]. 16 above the home indicator at the end of the scroll. |
| Home indicator | (0,840) | Dark 996:425 |

**C. Alerts.** The sheet stays behind and `bg/scrim` covers the full frame. `Alert` [1014:577] is centred. Inspect its text nodes with get_metadata before overriding. Design spec §4.1-5 replaces the logic's centred custom dialog with a native alert, so its warning icon is dropped (native alerts have none).

### 2.1 Frame table

Priority: **P1** build tonight; **P2** if time allows.

#### Flow 07A · Bookings · Charging Passes

| # | Frame name | Pri | Background | Layout top → bottom (instances + overrides) | New |
|---|---|---|---|---|---|
| 07.01 | `07.01 · Bookings · Upcoming · Ready to start` | P1 | A · clock 5:50 PM | Segmented sel1. **Front pass** P-A, status **Ready** at (16,217): `Status Pill` Success S 980:314 "Ready to start" (Dot on) [BK2], countdown "Starts in 10 min" [BK7], station "GreenVolt · DHA Phase 5", date "TODAY · SAT 4 OCT", "6:00 PM" → "7:00 PM" + "1 h", footer "BYD Atto 3" / "Type 2 (AC)" / "Rs 286". Ready face: 3pt energy 948:83 top edge + `sheen` still at 8% (layer "Sheen annotation"; 8% is the text-safe cap, §4.0). At (16,461): `Button / Large` Primary Default 978:277 "Scan to start", Leading icon on, Icon#978:21 qrcode.viewfinder 958:61 [BK8]. At (16,525) centred: Footnote text/secondary "You can start now. Your slot ends at 7:00 PM." [BK7]. At (16,567): `List Group Header` "Later" [BK1]. At (16,599): Stacked pass P-B (Upcoming, `Status Pill` Info S "Upcoming", "Tomorrow, 9:00 AM · 1 h 30 min", "Rs 577", "BYD Atto 3 · Type 2 (AC)"). At (16,697): stacked P-C, partly under the tab bar ("Wed, Oct 8, 7:30 PM · 30 min", "Rs 1,877", "MG ZS EV · CCS2 (DC)"). Tab bar, home indicator. | Charging Pass · Ready |
| 07.02 | `07.02 · Bookings · Upcoming · Later today` | P1 | A · clock 3:35 PM | Front pass P-A status **Upcoming** (existing 1010:441): pill Info S "Upcoming" (logic), countdown "Starts in 2 h 25 min". At (16,461): clock 958:88 12pt icon/secondary + Footnote text/secondary "You can start from 5:45 PM" (same as 05.02 [CH20]). "Later" header at (16,503). Stacked P-B at (16,535) and P-C at (16,633). Nothing else; whitespace is intended. | none |
| 07.03 | `07.03 · Bookings · Upcoming · Confirming` | P1 | A · clock 3:31 PM | Logic's optimistic booking (legacy path, still read by the tab). Front pass P-A status **Confirming**: emerald face with the `sheen` shimmer still (white 0→8%→0 band at 40% across the face, layer "Shimmer annotation"; 8% keeps white text ≥ 4.5:1, §4.0), `Status Pill` Neutral S "Confirming..." with a 10pt spinner instead of the dot (real copy "Confirming..."), countdown hidden, footer amount "Rs 286". The pass has **no** press state (not tappable, logic). Below it, Footnote text/secondary centred: "Hang on — we're confirming your slot." [BK31] (the optimistic state is our own API call, not the host, so the line must not mention the host) (optional: hide the line if Hammad prefers the pill alone). "Later" + P-B, P-C as 07.02. | Charging Pass · Confirming; Status Pill · Spinner |
| 07.04 | `07.04 · Bookings · Upcoming · Charging now` | P1 | A · clock 6:32 PM | Front pass P-A status **Live** [BK3]: `Status Pill` Live S 980:344 "Charging now" (Dot on), countdown "28 min left", the Time Window row swapped for a live row: "≈26%" (Display/M) + "est." (Footnote) on the left, "Rs 152" (Display/S) + "so far" (Footnote) on the right; under it a **Pass Progress** bar 338×6 (track white 25%, fill energy 948:83 at 53% = 32 of 60 min), labels "6:00 PM" / "7:00 PM" (Caption 2, white) at its ends. Footer unchanged. At (16,461): `Button / Large` Primary Default "View session", Leading icon bolt.fill 958:35. "Later" header at (16,537) + P-B stacked at (16,569) (ends 657, clear of the accessory). `Tab Bar Accessory / Live Charging` State=Charging 967:124 at (20,728): Title#967:0 "Charging · ≈26%", subtitle "28:00 left · Rs 152" (as 05.04 / 02.13; logic string "28:00 to full · Rs 152", reworded by 02-P11). Canvas note beside the frame (Caption 1, text/tertiary): "6:55 PM: top edge → status/warning, countdown '5 min left', accessory → State=Ending 967:135 '5:00 left · Rs 262' (06.17). Pill stays 'Charging now'." | Charging Pass · Live; Pass Progress |
| 07.05 | `07.05 · Bookings · Upcoming · Expiring soon` | P1 | A · clock 6:46 PM | No session was started. Front pass P-A status **Ready** with `Status Pill` Warning S 980:320 "Expiring soon" [BK26] and a 3pt status/warning 948:75 top edge instead of energy; countdown "14 min left to start". "Scan to start" Primary at (16,461). Footnote centred at (16,525): "Your slot ends at 7:00 PM." **In-app banner** (`Notification Preview` Style=In-app banner, 01 §6) at (32,58) 338 wide: App icon, "PAKPLUG" · "now", Title "Booking expiring soon", Body "Start charging before your window ends." (real push copy). "Later" + P-B below. | none |
| 07.06 | `07.06 · Bookings · Upcoming · Paused (fix)` | P1 | A · clock 4:10 PM | State demo for S6. Front pass P-A status **Paused**: emerald face with a 4pt status/warning leading-edge bar, `Status Pill` Warning S "Paused" (real), countdown "Starts in 1 h 50 min". At (16,461): **Inline Notice** Warning (04 §6) 370 wide, icon exclamationmark.triangle.fill 1025:474: "This booking is paused right now. Message the host before you go." [BK17]. "Later" + P-B below. Canvas note (Caption 1, text/tertiary, beside the frame): "Code: `paused` falls into no tab (Appendix 4). Fix: Upcoming, because it is still ahead and still cancellable (logic shows Cancel for paused)." | Charging Pass · Paused |
| 07.07 | `07.07 · Bookings · Completed` | P1 | A · clock 8:15 PM | Segmented sel2 970:204. `List Group Header` "October" [BK22 month grouping] at (16,217). Stacked **Completed** passes (370×120 with Review Link): Completed 1 at (16,249) "Leave a Review" (Review Link State=Leave); Completed 2 at (16,379) "Edit Review" (State=Edit). Header "September" at (16,523). Completed 3 at (16,555) "View Review" (State=View); Completed 4 at (16,685) "Review period ended" (State=Ended, dimmed), partly under the tab bar. Pill Success S "Completed" on each. Schedule durations are the actual session lengths (logic). | Review Link |
| 07.08 | `07.08 · Bookings · Cancelled` | P1 | A · clock 8:15 PM | Segmented sel3 970:211. "October" at (16,217): Cancelled 1 at (16,249), pill Neutral S "Cancelled by you" [BK6], amount "—" (logic: 0 → "—"). "September" at (16,361): Cancelled 2 at (16,393), pill Error S 980:338 "Cancelled by host" [BK6]; Cancelled 3 at (16,491), status **Expired** face, pill Warning S "Expired" (real); Cancelled 4 at (16,589), pill Neutral S "Cancelled" (real). Row 3 of Expired reads "No session started · MG ZS EV" [BK15]. | Charging Pass · Expired |
| 07.09 | `07.09 · Bookings · Host cancelled (live update)` | P1 | A · clock 4:02 PM | After socket `booking_updated` (logic: refresh). The front pass is now P-B (Upcoming, "Tomorrow, 9:00 AM", countdown "Tomorrow") because P-A left Upcoming. In-app banner at (32,58): header "PAKPLUG" · "now" (real relative-time format, Appendix 2), Title "Booking update" (real push title), Body "Bilal cancelled your booking at GreenVolt · DHA Phase 5 for today, 6:00 PM." (layer note: "example — the server's push body is shown verbatim"). Layer note on the banner: "tap → logic pushes /my-bookings (07.40); designed: opens this pass's detail [BK20]". Canvas motion strip (3 thumbnails 120 wide, Caption 1 labels): "1 · pass flips to its cancelled face" → "2 · collapses out of Upcoming" → "3 · next pass slides up to the front". "Later" + P-C. | none |
| 07.40 | `07.40 · Bookings · Opened from a push (logic)` | P2 | A · clock 4:03 PM | The logic's `/my-bookings` pushed route (Appendix 1 push tap). `Nav Bar` Style=Inline 1087:607 at (0,54) instead of Large: Title#1087:0 "Bookings", Leading#1087:3 on (chevron.left 1025:481, VoiceOver "Back"). Segmented at (16,114), content from y 166 as 07.09 (P-B front, "Later" + P-C). **No tab bar** (pushed over the shell) and no accessory. Canvas note: "Logic today; designed path is BK20 (Bookings tab + the pass detail open). Keep this frame so Rayan sees both." | none |

#### Flow 07B · Bookings · Empty, loading & errors

| # | Frame name | Pri | Background | Layout top → bottom | New |
|---|---|---|---|---|---|
| 07.10 | `07.10 · Bookings · Upcoming · Empty` | P1 | A · clock 12:10 PM | Segmented sel1. **Ghost Pass** [BK23] at (16,233) 370×208: dashed 1.5pt stroke/separator 948:87 outline (dash 6/6), radius lg, fill bg/frost 948:43, perforation notches like a real pass, `Brand / Mark / PakPlug P` Style=Mesh 1082:123 at 40pt centred at 60% opacity. `State View` Empty 1072:573 at (16,465) 370 wide: icon layer hidden (the ghost pass is the illustration), Title "No bookings yet", Message "Find a charger nearby and book your first slot.", Show action on → "Explore chargers" (all real). If the State View action is a Medium button, keep it. | Ghost Pass |
| 07.11 | `07.11 · Bookings · Completed · Empty` | P1 | A | Segmented sel2. `State View` Empty centred in the page (centre y ≈ 470): Icon#1072:4 bolt.car 1025:500, "No completed bookings" / "Finished sessions will appear here.", Show action off (real). | none |
| 07.12 | `07.12 · Bookings · Cancelled · Empty` | P1 | A | Segmented sel3. `State View` Empty: Icon calendar 958:39, "No cancelled bookings" / "Cancelled or expired bookings will appear here.", action off (real). | none |
| 07.13 | `07.13 · Bookings · Loading` | P1 | A | Segmented sel1 (interactive). `State View` Loading 1072:584 centred at y ≈ 470, text nodes hidden (logic: spinner only). Canvas note: "same centre loader when a tab has any station still loading (logic)". | none |
| 07.14 | `07.14 · Bookings · Refreshing` | P1 | A · clock 3:35 PM | 07.02 content shifted down 64. **iOS / Refresh Control** [§6] spinner 20pt centred at y 233 (between the tabs and the pass). Old data stays visible (logic: "Reloads keep the old data on screen"). Canvas note: "light haptic at the 64pt threshold". | iOS / Refresh Control |
| 07.15 | `07.15 · Bookings · Offline (cached)` | P1 | A · clock 3:35 PM | **Inline Notice** Neutral at (16,217) 370 wide: icon info.circle 1025:472 (wanted `wifi.slash`, FLAG), "Showing cached bookings (offline)" (real). Content as 07.02 shifted down 64 (front pass at 281). | none |
| 07.16 | `07.16 · Bookings · Error` | P1 | A | Segmented sel1. `State View` Error 1072:588 centred: Title "Failed to load bookings" (real), Message "Check your connection and try again." [BK24], Show action on → "Retry" (real). | none |
| 07.17 | `07.17 · Bookings · Signed out` | P2 | A | Tabs hidden. `State View` Empty, Icon person.crop.circle 1023:483, Title "Please log in to view your bookings" (real), Message hidden, action "Log in" [BK24]. Canvas note: "normally unreachable; auth loss redirects to /login (Appendix 2)". | none |
| 07.18 | `07.18 · Bookings · Station failed on a pass` | P2 | A | 07.02 with stacked P-B's station line replaced by exclamationmark.triangle.fill 12pt + "Error loading station: Connection timed out" (real prefix; the suffix is an example error), Footnote, 1 line, truncated. Amount and times still show. | none |
| 07.19 | `07.19 · Bookings · Booking failed (legacy)` | P2 | A | 07.03 after failure: the Confirming pass has collapsed away and P-B is the front pass. `Toast` Tone=Error 1088:626 at (16,724): Message "Failed to create booking" (real error copy), Action on, Action label#1088:10 "Dismiss" (real). | none |
| 07.20 | `07.20 · Bookings · Review period ended` | P2 | 07.07 | `Toast` Tone=Neutral 1088:611 at (16,724): "Reviews can only be submitted within 7 days of the session." (real), no action. Completed 4's Review Link shows its pressed still (40% → 30%). | none |

#### Flow 07C · Pass detail

| # | Frame name | Pri | Background | Layout top → bottom | New |
|---|---|---|---|---|---|
| 07.21 | `07.21 · Pass · Upcoming` | P1 | B over 07.02 · clock 3:35 PM | Sheet nav "Booking details" + ✕. Pass P-A **Upcoming** (pill Info "Upcoming", "Starts in 2 h 25 min"). Context line: "You can start from 5:45 PM" [CH20]. No state CTA. Quick actions at (16,412): Directions · Message (unread dot on: Bilal sent 1 message) · Call. Charger card at (16,500). `List Group Header` "Booking information" at (16,636) and the first row "Scheduled date" / "Oct 4, 2026" peeking under the fold (the cut is intentional; it shows the sheet scrolls). | Quick Action Tile · Badge |
| 07.22 | `07.22 · Pass · Upcoming · Scrolled` | P1 | B over 07.02 | Content scrolled. Nav pinned with a hairline. From y 136: "Booking information" header + group (Scheduled date "Oct 4, 2026", Scheduled time "6:00 – 7:00 PM", Duration "1 hour", Total cost "Rs 286"), 136–420 · Footnote "Estimate. The charger's meter decides the final amount." [BK21] at 428 · "Access notes" header 470 + card 498–566 · "Host" header 590 + host card 618–682 · Wallet Badge centred at (121,706) · `Button / Large` Destructive Secondary Default 978:397 "Cancel booking" at (16,772). | Wallet Badge |
| 07.23 | `07.23 · Pass · Ready to start` | P1 | B over 07.01 · clock 5:50 PM | Pass P-A **Ready** ("Ready to start", "Starts in 10 min"). Context line "You can start now. Your slot ends at 7:00 PM." [BK7]. State CTA `Button / Large` Primary "Scan to start" + qrcode.viewfinder [BK8]. Below at (16,480): **charger code row** [BK9], container bg/grouped radius 16, `List Row` Value 983:352, Icon on → ev.charger 1024:478, Title "Charger code", Subtitle#983:10 "Type it if the QR won't scan", value "GV7-K42" set to Display/S with +6% tracking, Separator off. Quick actions at (16,560), charger card at (16,648) (partly under the fold). | none |
| 07.24 | `07.24 · Pass · Charging now` | P1 | B over 07.04 · clock 6:32 PM | Pass P-A **Live** (as 07.04). Context line "Started 6:00 PM · charging stops on its own at 7:00 PM" [BK3; the auto-stop rule is logic §E]. State CTA `Button / Large` Primary "View session" + bolt.fill. Quick actions, charger card. Canvas note: "Cancel booking is hidden while a session is live on this booking [BK13]; stopping happens in the session (06)." | none |
| 07.25 | `07.25 · Pass · Completed` | P1 | B over 07.07 · clock 8:15 PM | Pass Completed 1 (Completed face, pill Success "Completed", no countdown, footer "TOTAL" "Rs 286" = billed amount). Context line "Charged on Oct 4, 6:00 – 7:00 PM" [BK32]. State CTA `Button / Large` Secondary Default 978:307 "Leave a Review" (real label), Leading icon star 1025:492. Under it, `Button / Large` Tertiary 978:337 "Book again" [BK14]. Quick actions, charger card. When scrolled, Booking information has Total cost "Rs 286" with no estimate footnote (billed), and there is no Cancel booking (logic). | none |
| 07.26 | `07.26 · Pass · Cancelled by host` | P1 | B over 07.08 · clock 8:15 PM | Pass Cancelled 2 (Model Town, Cancelled face, pill Error "Cancelled by host"). Context line "The host cancelled this booking. Message Usman if you have questions." [BK16] (Model Town's host is Usman, 09 T2). CTA `Button / Large` Primary "Find another charger" [BK14] + Tertiary "Book again" [BK14]. Quick actions (Message stays useful; Call opens the no-number Call sheet, because Usman has no phone number, 09.31). Charger card for Model Town Home Charger ("Model Town, Lahore", "Type 2 (AC) · 11 kW"). Host card "U" · "Usman". No Cancel (logic: cancelled). | none |
| 07.27 | `07.27 · Pass · Expired (fix)` | P1 | B over 07.08 · clock 7:05 PM | Pass P-A, **Expired** face, pill Warning "Expired" (derived status, same as the list) [BK5]. Context line "No charging session was started during this slot." [BK15]. CTA Primary "Book again" [BK14]. Quick actions, charger card. No Cancel booking (logic: hidden once the booking is past its window). **Before/after card** on the canvas beside the frame (560 wide, card style): left mini-pill Info "Upcoming" labelled "Code today: raw status `confirmed`" → right mini-pill Warning "Expired" labelled "Designed: derived status, same rule as the list (confirmed + end ≤ now)". | none |
| 07.28 | `07.28 · Pass · Paused` | P1 | B over 07.06 · clock 4:10 PM | Pass P-A **Paused** (pill Warning "Paused", "Starts in 1 h 50 min"). At (16,380) Inline Notice Warning "This booking is paused right now. Message the host before you go." [BK17] instead of a context line. Quick actions with Message first in the reading order (VoiceOver), charger card. Scrolled end (canvas note): Cancel booking is visible (logic: confirmed or paused). | none |
| 07.29 | `07.29 · Pass · Read-only (from chat)` | P2 | B over a chat thread (Messages placeholder: Mesh Quiet + nav "Bilal") | Logic: opened from the chat banner, so **no cancel and no chat**. Pass P-A Upcoming. Quick actions = Directions · Call (2 tiles). Charger card. Scrolled end: host card, no Wallet badge, no Cancel. Loading note (canvas, beside the frame): while the booking is fetched, the sheet is already up with a pass-shaped `Skeleton Block` (04) 370×232 in the pass slot and the tiles/charger card as skeleton bars [BK33]. Fetch error variant note: "Unable to load booking details." (real) as `Toast` Error over the thread (the sheet does not open). | none |
| 07.30 | `07.30 · Pass · Call host` | P2 | 07.21 + stacked sheet | `Sheet / Action` Kind=Call (00-system C3; the Manual Call Sheet, leading-aligned, same as 04.17 / 09.30): grabber · 56 tint well bg/tint + phone.fill icon/brand 24 · Title 2 "Call Bilal" (real pattern) · Body text/secondary "You'll leave PakPlug and call Bilal at 0321 4567890 using your phone's dialer." (real pattern) · `Button / Large` Primary, Leading icon phone.fill, "Call" · Tertiary "Cancel". Notes: no-number body "Bilal hasn't added a phone number yet. Send them a message instead." with Call disabled; thread-resolve failure `Toast` Error "Unable to load contact info. Please try again."; dialer failure "Couldn't open your phone's dialer." (all real). | none |
| 07.31 | `07.31 · Pass · Directions` | P2 | 07.21 + stacked sheet | `Sheet / Directions` 1012:569 bottom-anchored, same overrides as 04.14: "Open in Google Maps", "Get turn-by-turn directions to GreenVolt · DHA Phase 5", "1.2 km · ~2 min drive", "Open Google Maps" / "Cancel" [BK10]. | none |

#### Flow 07D · Cancel & Wallet

| # | Frame name | Pri | Background | Layout top → bottom | New |
|---|---|---|---|---|---|
| 07.32 | `07.32 · Cancel · Confirm` | P1 | 07.22 + C · clock 3:40 PM | `Alert` Destructive 1014:561: Title "Cancel booking?" · Message line 1 (Footnote Emph) "GreenVolt · DHA Phase 5 · Today, 6:00 – 7:00 PM" [BK19] + "Are you sure you want to cancel this booking? This action can't be undone." (real) · buttons "Keep booking" (preferred/safe action, real) and "Cancel booking" (destructive, red, real). Use the weights the `Alert` component already has; do not add Bold/Semibold (brief: SF Pro light type). Button order follows iOS: when stacked, destructive on top and Keep at the bottom; side by side, Keep on the left. Keep whichever layout the component already has. | none |
| 07.33 | `07.33 · Cancel · Cancelling` | P1 | B, 07.22 composition | Logic "blocking spinner": every sheet section at 60% opacity except the button. `Button / Large` Destructive Secondary **Loading** 978:418. Grabber hidden. Nav ✕ at 40% (disabled). Scrim taps do nothing (layer note). | none |
| 07.34 | `07.34 · Cancel · Done` | P1 | A · clock 3:40 PM | Logic: switches to the **Cancelled** tab. Segmented sel3. "October" header; the just-cancelled P-A at (16,249) as a stacked Cancelled pass: "Today, 6:00 PM · 1 h", pill Neutral S "Cancelled by you", amount "—", with a 2pt brand/primary 30% ring (layer "Arrival highlight", fades out after 1.2 s). Cancelled 1 below at (16,347). `Toast` Tone=Success 1088:616 at (16,724): "Booking cancelled successfully" (real). | none |
| 07.35 | `07.35 · Cancel · Failed` | P1 | B, 07.22 restored | Button back to Default. `Toast` Tone=Error 1088:626 at (16,708), 12 above the Cancel button: Message "Couldn't cancel this booking. Please try again." (layer note: "example — the server's message is shown verbatim (logic)"), no action. | none |
| 07.36 | `07.36 · Cancel · Too late` | P2 | A, Cancelled tab | Server message contains "cannot be cancelled" or "expired" → the logic also jumps to Cancelled and refetches. P-A at the top as **Expired** (Warning pill). `Toast` Error "This booking has expired and cannot be cancelled." (example server message). | none |
| 07.37 | `07.37 · Cancel · Reason (optional)` | P2 | 07.22 + stacked sheet (medium detent, top at y 474) | [BK18, not wired] `Sheet Header` Form 1008:413 Title "Why are you cancelling?" Subtitle "Optional. It helps hosts plan their day." · `Chip` Fill/No ×5, wrapping, gap 8: "Plans changed", "Found a closer charger", "Booked by mistake", "Car is charged enough", "Something else"; one shown Fill/Yes · `Button / Large` Destructive 978:367 "Cancel booking" · Tertiary "Keep booking". Canvas note: "Only if Hammad wants it; needs a `reason` field on the cancel API. Default build = alert only." | none |
| 07.38 | `07.38 · Wallet · Add pass (OS)` | P2 | Full-screen OS sheet, bg/grouped | [BK12] **iOS / PassKit Add Sheet** mock: nav "Cancel" · "PakPlug" · "Add" (system blue; OS-owned). Wallet pass preview 338×430, emerald face: header `Brand / Mark / PakPlug P` Style=Solid 991:69 at 24 + `Brand / Wordmark` White 994:127 (the SF Pro wordmark instance, rescaled to 16 high; never typed text) + right "TODAY 6:00 PM"; primary field "GreenVolt · DHA Phase 5"; secondary fields STARTS "6:00 PM" · ENDS "7:00 PM" · VEHICLE "BYD Atto 3"; auxiliary CONNECTOR "Type 2 (AC)" · CHARGER CODE "GV7-K42"; **no barcode**. Layer note "OS-owned · PKAddPassesViewController; pass designed in PassKit JSON". | iOS / PassKit Add Sheet |
| 07.39 | `07.39 · Wallet · Added` | P2 | 07.22 | The Wallet Badge is replaced by a `List Row` Navigation 983:339 in a bg/grouped r16 container: Icon on, glyph wallet.pass.fill 1024:488 (icon/brand), Title "View in Wallet", Separator off [BK12]. `Toast` Success at (16,708): "Added to Apple Wallet" [BK12]. | none |

**Totals:** 40 frames. P1: 29 (07.01–07.16, 07.21–07.28, 07.32–07.35). P2: 11 (07.17–07.20, 07.29–07.31, 07.36–07.40).

**Rows on the canvas** (labels above each phone in Footnote Emph secondary, gap 80):
- 07A: row 1 Upcoming states 07.01–07.06 + micro card §4.1–4.3; row 2 07.07–07.09, 07.40 + card §4.4–4.5 + the **Status model card** (§1.1 table as a 560-wide card) next to it. Refs card left of row 1; Logic card after row 2.
- 07B: one row 07.10–07.20 + card §4.6.
- 07C: row 1 07.21–07.24 + card §4.7–4.8; row 2 07.25–07.31 + card §4.9 + the before/after card at 07.27.
- 07D: row 1 cancel 07.32–07.37 + card §4.10; row 2 Wallet 07.38–07.39 + card §4.11.

---

## 3. Real copy (quoted from the logic map) per screen

### 3.1 Bookings tab (07.01–07.20)
- Header: "Bookings" · tabs "Upcoming" / "Completed" / "Cancelled".
- Pills: "Upcoming", "Completed", "Cancelled", "Expired", "Confirming..." (rendered with the single ellipsis character), "Paused", "Cancelled by you", "Cancelled by host", "Charging now" (chat banner).
- Schedule format `"{Today|Tomorrow|EEE, MMM d}, h:mm a · {duration}"`; completed = actual session duration; amount "Rs X" / billed / "—" when 0.
- Review links: "Leave a Review" · "Edit Review" · "View Review" · "Review period ended" · toast "Reviews can only be submitted within 7 days of the session."
- States: "Please log in to view your bookings" · "Failed to load bookings" + "Retry" · "Showing cached bookings (offline)" · "Error loading station: …" · legacy error snackbar with "Dismiss" (message "Failed to create booking" from §C errors).
- Empty: "No bookings yet" / "Find a charger nearby and book your first slot." / "Explore chargers" · "No completed bookings" / "Finished sessions will appear here." · "No cancelled bookings" / "Cancelled or expired bookings will appear here."
- Pushes (Appendix 1): "Booking update" · "Booking expiring soon" / "Start charging before your window ends." Foreground banner (Appendix 2): title, body and relative time ("now", "Ns ago", "N mins ago"), auto-dismiss 6 s, tap navigates (`/my-bookings`, pushed: 07.40).
- Shell signals on these frames: Messages tab badge "2" (logic caps at "9+"); charging accessory "Charging · {battery}%" / "{mm:ss} to full · Rs X" drawn as "Charging · ≈26%" / "28:00 left · Rs 152" [02-P11].

### 3.2 Pass detail (07.21–07.31)
- "Booking details" · status pill · charger card (station, address, connector, "{maxPower}") · "View charger".
- "Booking information": "Scheduled date", "Scheduled time", "Duration", "Total cost" (labels used verbatim in the frames). Formats: logic "MMM dd, yyyy" / "HH:mm – HH:mm" → shown "Oct 4, 2026" / "6:00 – 7:00 PM" [BK22].
- "Access notes" (only when present) · host initials, name, "Charger host" · Call · Message (+ red unread dot) · "Cancel booking".
- Call sheet: "Call {name}" · "You'll leave PakPlug and call {name} at {number} using your phone's dialer." · "{name} hasn't added a phone number yet. Send them a message instead." · "Call" · "Cancel" · "Unable to load contact info. Please try again." · "Couldn't open your phone's dialer."
- Read-only from chat: "Upcoming booking" / "Charging now" banner labels · "Unable to load booking details."
- Directions (04): "Open in Google Maps" · "Open Google Maps".

### 3.3 Cancel (07.32–07.36)
- "Cancel booking?" · "Are you sure you want to cancel this booking? This action can't be undone." · "Cancel booking" · "Keep booking".
- "Booking cancelled successfully" · server message · ("Test bookings cannot be cancelled via API": debug only, not drawn).

### 3.4 Proposal copy used (all flagged, §7)
"Ready to start" · "Expiring soon" · "Starts in 10 min" / "Starts in 2 h 25 min" / "14 min left to start" / "28 min left" · "You can start from 5:45 PM" · "You can start now. Your slot ends at 7:00 PM." · "Your slot ends at 7:00 PM." · "Later" · "Scan to start" · "View session" · "Charger code" / "Type it if the QR won't scan" · "Directions" / "Message" / "Call" tiles · "Estimate. The charger's meter decides the final amount." · "No charging session was started during this slot." · "No session started" · "The host cancelled this booking. Message Usman if you have questions." · "This booking is paused right now. Message the host before you go." · "Find another charger" · "Book again" · "Started 6:00 PM · charging stops on its own at 7:00 PM" · "Charged on Oct 4, 6:00 – 7:00 PM" · "Check your connection and try again." · "Log in" · "Hang on — we're confirming your slot." · "Why are you cancelling?" + reasons · "Add to Apple Wallet" (Apple badge) · "View in Wallet" · "Added to Apple Wallet" · "Charger code copied" · month headers "October" / "September" · pass footer labels "VEHICLE" / "CONNECTOR" / "EST. TOTAL" / "TOTAL" · "5 min left" (Live pass at 6:55) · host-cancelled line uses the booking's host name.

---

## 4. Micro-interactions

### 4.0 Additions to the system tokens (for 00-system)
- `sheen`: a soft diagonal light band across a pass face. It is a white→energy 948:83 gradient band 120pt wide at a 20° angle and **≤ 8% opacity** at its peak (measured in review: white text on #0C7A4A is 5.4:1 bare, 4.6:1 under 8% white, 4.45:1 under 10%, 4.3:1 under 12%, so 8% is the highest text-safe value; the energy end of the band is darker than white and never the worst case). Ready: one sweep left→right, 900 ms ease-out, repeated every 8 s. Live: a continuous 3.2 s linear loop. Confirming: the same 8% band on a faster 1.2 s linear loop (same rhythm as 04's Skeleton shimmer; it reads as "busy" through speed, not brightness). Off in Reduce Motion and Low Power Mode (static 6% glow in the lower-right instead). Reduce Transparency: off.
- Everything else reuses `snappy`, `smooth`, `bouncy`, `fade.quick`, `fade.std`, `roll`, `scrub`, `pulse` (00-system §2.1).

### 4.1 Arriving on the tab (07.01–07.04)
1. **First appearance after launch** → passes rise in order: the front pass, then each stacked pass 40 ms later (translate y 12 → 0, opacity 0 → 1, `smooth`). This happens once per launch; switching tabs back later does not replay it.
   - Haptic: none.
   - VoiceOver: focus lands on the "Bookings" heading. The front pass is the next element.
   - Reduce motion: one `fade.std` for the whole page.
2. **Arriving from 04.43 "View in Bookings"** → the pass flies from the success screen to the front slot (matched geometry, `smooth` 450 ms, 04 §4 rule 5). The Bookings tab item does one selected bounce (`bouncy`). Stacked passes slide down 8 then settle (`smooth`) to "make room".
   - Haptic: light (04 already fired success).
   - VoiceOver: announces "Booking added. GreenVolt · DHA Phase 5, today 6:00 to 7:00 PM."
   - Reduce motion: cross-fade.
3. **Press any tappable pass** → scale 0.98 + shadow lift from shadowSoft to shadow (`snappy`). Release opens the detail (§4.7-1). Dragging off before release cancels with no action.
   - Haptic: light on open.
   - VoiceOver (front): "Booking, GreenVolt · DHA Phase 5. Ready to start. Today, Saturday 4 October, 6:00 to 7:00 PM, 1 hour. BYD Atto 3, Type 2 AC. Rs 286 estimated. Starts in 10 minutes. Button." Custom actions: "Scan to start", "Get directions", "Message host", "Cancel booking".
   - Reduce motion: no scale; the pass dims to 85% opacity for the touch (02 §4.0 press rule).
4. **Confirming pass (07.03)** → no press state and no haptic (logic: not tappable). `sheen` Confirming loop plays. The spinner in the pill uses the system activity indicator.
   - VoiceOver: "GreenVolt · DHA Phase 5. Confirming. Today 6:00 to 7:00 PM. Dimmed."
   - When it resolves (socket / refetch), the shimmer stops on its next pass end. The pill cross-fades Neutral → Info "Upcoming" (`snappy`), and the countdown fades in (`fade.quick`). No haptic. VoiceOver posts a polite "Booking confirmed".
   - On failure (07.19), the pass collapses (height → 0, opacity → 0, `smooth` 350 ms), the next pass slides up, and the Error toast enters. Haptic: error (fired with the toast, 02 tone rule). VoiceOver: the toast "Failed to create booking" is announced; focus moves to the new front pass.
   - Haptic while confirming and on resolve: none (passive state, not a user action).
   - Reduce motion: no shimmer (static 6% glow); the pill and countdown swap with `fade.quick`; on failure the pass fades out (`fade.quick`) and the gap closes without a slide.
5. **Countdown** ("Starts in 2 h 25 min") → updates every minute (`TimelineView(.everyMinute)`), `roll` on the changed digits only. It never ticks seconds on the list.
   - Haptic: none.
   - VoiceOver reads the current value on focus. It does not announce each change.
   - Reduce motion: `fade.quick` (no digit roll, 02 §4.0).

### 4.2 Status changes on the pass (07.01, 07.04, 07.05, 07.09)
1. **Upcoming → Ready to start** (clock reaches start − 15 min while visible):
   - The pill morphs Info → Success: the colour cross-fades, the width springs, `snappy`.
   - The 3pt energy top edge draws left→right (600 ms ease-out), and one `sheen` sweep follows.
   - "Scan to start" grows out from under the pass (height 0 → 52, `smooth`). The stacked passes move down with it.
   - The context line cross-fades to "You can start now. Your slot ends at 7:00 PM."
   - Haptic: none (a passive change must not buzz, 02 rule).
   - VoiceOver: polite announcement "Your booking at GreenVolt is ready to start."
   - Reduce motion: everything cross-fades in 150 ms.
2. **Ready dot pulse** → the Success dot runs `pulse` (00-system: a ring scales 1 → 2.2 and fades 0.5 → 0, 1.33 s loop). The Live dot uses the same `pulse`. Haptic: none. VoiceOver: the dot is decorative (the pill label carries the status). Static in Reduce Motion and Low Power Mode.
3. **Ready → Expiring soon** (≤ 15 min left, no session) → the pill and the top edge cross-fade to Warning (`snappy`), and the countdown changes to "14 min left to start". If the `BOOKING_EXPIRING` push arrives in the foreground, the in-app banner drops from the top (`smooth`), stays **6 s** (logic) and swipes up to dismiss.
   - Banner tap → logic: `/my-bookings` as a pushed route (07.40), the same as a `BOOKING_EXPIRING` row in Notifications (logic §I). Designed: the Charge tab, where Scan is one tap away (one decision with 05 [CH20]).
   - Haptic: warning, once, with the banner.
   - VoiceOver: the banner is announced and does not take focus.
   - Reduce motion: the banner fades.
4. **Ready → Charging now** (the session starts in 05/06 and `sessionProvider` reports this booking) → the face cross-fades to Live (600 ms ease-out) and the Time Window row cross-fades to the live row. The progress bar grows from 0 to its value (`smooth`), and the "Scan to start" label cross-fades to "View session" (`fade.quick`, same button).
   - Haptic: none (05 already fired on start).
   - VoiceOver: polite "Charging now."
   - Reduce motion: one 150 ms cross-fade of the face, the row and the button label; the progress bar appears at its value.
5. **Live values** → "≈26%", "Rs 152" and "28 min left" `roll` when they change. The data re-renders every 1 s (logic), but the visual update is throttled to once per 10 s for % and Rs and once per minute for "min left", so the list never jitters. The progress bar animates linearly between updates.
   - Haptic: none (passive values).
   - VoiceOver: on focus it reads "Charging now, about 26 percent, estimated. 28 minutes left. Rs 152 so far."
   - Reduce motion: no roll and no sheen.
5b. **Live pass reaches 5:00 left** (6:55 PM) → the 3pt top edge cross-fades energy → status/warning (300 ms ease-out), the countdown reads "5 min left" (`roll`), and the pill stays Live "Charging now". This fires on the same tick as the accessory's switch to State=Ending 967:135 and 06's "Ending soon" pill (06-P27).
   - Haptic: none here (06 fires the warning on the Live screen; a list must not buzz).
   - VoiceOver: polite "5 minutes left. Charging stops at 7 PM." (06 M6 wording), once.
   - Reduce motion: colour change only, no roll.
6. **Window ends with no session** (7:00 PM) → the pass desaturates to the Expired face (400 ms ease-out) with the pill Warning "Expired". After 1.2 s it collapses out of Upcoming (`smooth`) and the next pass moves to the front (matched geometry, `smooth`). The Cancelled tab gets it at the top on the next look.
   - Haptic: none.
   - VoiceOver: polite "Booking expired."
   - Reduce motion: the face swaps with `fade.quick`, then the pass fades out and the next pass appears in place (no collapse, no flight).
7. **Socket `booking_updated`, host cancelled (07.09)** → the pass does a 3D flip on the Y axis to its cancelled face (`smooth` 450 ms, perspective 800), holds 600 ms, then collapses (`smooth`). The next pass slides to the front. The in-app banner "Booking update" drops at the same moment.
   - Haptic: warning.
   - VoiceOver: announces the banner, then "Booking moved to Cancelled."
   - Reduce motion: cross-fade + collapse without the flip.

### 4.3 Tabs, scrolling, refresh and offline (07.01–07.16)
1. **Tap a segment** → the native thumb slides (`snappy`) and the page swipes to that tab (`smooth`). Pages keep their own scroll positions.
   - Haptic: selection.
   - VoiceOver: "Completed, tab, 2 of 3" (native segmented semantics).
   - Reduce motion: the page cross-fades instead of sliding.
2. **Swipe between pages** (logic `PageView`) → the page follows the finger 1:1. The segment thumb tracks the progress continuously and snaps on release (`smooth`, velocity-aware). A rubber band holds at the first and last page.
   - Haptic: selection when the page commits.
   - VoiceOver: three-finger swipe left/right changes the page.
   - Reduce motion: the page still follows the finger (direct manipulation); the release snap becomes a 150 ms cross-fade into the committed page.
3. **Scroll** → the large title collapses into the inline title (native `UINavigationBar`, tracks the scroll 1:1). The segmented control pins under it on a bg/frostStrong band with a hairline that fades in (`fade.quick`) at the first point of overlap.
   - Haptic: none.
   - VoiceOver: the "Bookings" heading keeps the header trait; the segmented control stays next in reading order.
   - Reduce motion: unchanged (scroll-linked). Reduce Transparency: the band becomes bg/surface + hairline.
4. **Pull to refresh** → the system refresh control appears after a 64pt pull.
   - Haptic: light at the threshold.
   - The spinner stays until the refetch ends, and old data stays on screen (logic). Then a diff animation runs (`smooth`): inserted passes fade/scale in from 0.96, removed ones collapse, and moved ones slide.
   - VoiceOver: a "Refresh" custom action on the page; it announces "Bookings updated".
   - Reduce motion: no diff animation, content swaps with `fade.quick`.
5. **Offline** (cache served) → the Inline Notice slides down from under the tabs (`smooth`) and the content moves down with it. It stays while offline. When the connection returns, it collapses (`smooth`) and a silent refetch runs.
   - Haptic: none.
   - VoiceOver: "Showing cached bookings (offline)" is announced once when it appears.
   - Reduce motion: the notice and the content cross-fade in place (`fade.quick`), no slide.
6. **Load error → Retry** → press: Pressed variant + scale 0.97 (`snappy`); release: the button goes to its Loading variant, then the State View cross-fades to content (`fade.std` 220 ms) and the passes rise (§4.1-1).
   - Haptic: light on release; none on success (passive data); error if it fails again, and the State View stays.
   - VoiceOver: "Retry, button"; while loading "Retry, busy"; on a second failure it announces "Failed to load bookings".
   - Reduce motion: no scale (85% dim); content fades in with `fade.std`.
7. **Loading → content** → the spinner appears only after a 150 ms grace delay (`fade.std`, 02 rule 4.1-1, so a fast load never flashes it). When data arrives it fades out (`fade.quick`) and the passes rise as in §4.1-1.
   - Haptic: none.
   - VoiceOver: focus stays on the segmented control; "Bookings loaded" is posted politely only when the load took longer than 1 s.
   - Reduce motion: one `fade.std` for the page.

### 4.4 Completed and Cancelled lists (07.07, 07.08, 07.20)
1. **Review Link** "Leave a Review" / "Edit Review" / "View Review" → the press dims the label to 50% (`fade.quick`). Release opens `LeaveReviewModal` (new / edit / read-only) on root as a sheet (`smooth`).
   - Haptic: light.
   - VoiceOver: "Leave a review for GreenVolt · DHA Phase 5, button" (a separate element from the pass, so the pass tap still opens the detail).
   - Reduce motion: the review sheet cross-fades in (`fade.std`).
2. **"Review period ended"** (dimmed) → touch dims the label 40% → 30% (`fade.quick`); release shows the Neutral toast "Reviews can only be submitted within 7 days of the session." (logic snackbar → Toast), entering per §4.6-3: 4 s on one line, 6 s if it wraps to two.
   - Haptic: none (Neutral toast rule, 02 §4.0; the driver can't fix this, so it isn't a warning).
   - VoiceOver: "Review period ended, dimmed button. Reviews can only be submitted within 7 days."
   - Reduce motion: the toast fades in, no rise.
3. **After a review is submitted** (in 06) → the link cross-fades to "Edit Review" (`fade.quick`). The success toast belongs to 06.
   - Haptic: none here (06 fires success).
   - VoiceOver: the link's label updates silently to "Edit review for GreenVolt · DHA Phase 5".
   - Reduce motion: unchanged (already a fade).
4. **Month group headers** stick while their group scrolls (native section headers, scroll-linked), on the frost band. The next header pushes the current one up 1:1.
   - Haptic: none.
   - VoiceOver: headers carry the header trait, so the rotor jumps month by month.
   - Reduce motion: unchanged (scroll-linked).

### 4.5 Empty states (07.10–07.12)
1. **Arriving on an empty tab** → the Ghost Pass fades in and floats once (translate y 6 → 0, `smooth`). The State View text fades in 80 ms later (`fade.std`).
   - Haptic: none.
   - VoiceOver: the Ghost Pass is hidden (decorative); reading order is title → message → "Explore chargers".
   - Reduce motion: fade only.
2. **"Explore chargers"** → press scale 0.97 (`snappy`). Then the tab bar selection moves to Home (logic: tab intent 0) with the native tab transition.
   - Haptic: light.
   - VoiceOver: "Explore chargers, button. Opens the map."
   - Reduce motion: no scale (85% dim); the tab switch is the native instant swap.

### 4.6 Errors and edge states (07.13–07.20)
1. **Station error on a pass** (07.18) → only that pass shows the error line; it replaces the station line with `fade.quick` when that station request fails. The rest render normally. Pull to refresh retries it; on success the station name cross-fades back (`fade.quick`).
   - Haptic: none (passive).
   - VoiceOver: the pass label starts with "Station couldn't load", then reads the time, vehicle and amount.
   - Reduce motion: unchanged (fades only).
2. **Signed out** (07.17) → "Log in" press (Pressed variant, scale 0.97, `snappy`), release pushes `/login` (native push) [BK24].
   - Haptic: light.
   - VoiceOver: "Log in, button".
   - Reduce motion: no scale; the push cross-fades.
3. **Toasts** (02 §4.0 Toast rules, unchanged) → rest 12 above the tab bar (or the accessory / bottom button); enter from 12pt below with opacity 0 → 1 (`smooth`), leave reversed with `fade.quick`. Display time: 4 s for one line without an action, 6 s for two lines or any toast with an action. Swipe down dismisses. One at a time; a new one replaces the old with `fade.quick`.
   - Haptic follows the tone: Error → error, Success → success, Warning → warning, Neutral → none.
   - VoiceOver: posted as announcements without taking focus.
   - Reduce motion: fade only, no rise.

### 4.7 Pass detail: open, close, pass (07.21–07.28)
1. **Open** → the tapped pass lifts and flies to the sheet's pass slot (matched geometry, `smooth` 450 ms). The sheet rises behind it from the bottom (`smooth`), and the scrim fades in (`fade.std`). The other passes dim to 40% under the scrim.
   - Haptic: light.
   - VoiceOver: focus moves to "Booking details, heading".
   - Reduce motion: the sheet fades in with the pass already in place.
2. **Close** → ✕, swipe down past 30% of the height or with velocity, or a scrim tap (logic). The pass flies back to its slot in the list (`smooth`). An interactive drag scales the pass with the sheet.
   - Haptic: none.
   - VoiceOver: the Escape gesture (two-finger Z) closes it; focus returns to the pass that opened it.
   - Reduce motion: the sheet fades out (`fade.quick`) and the pass is already in its list slot (no flight, no drag scaling).
3. **Countdown in the sheet** → same `roll` per minute as the list. Haptic none; VoiceOver reads on focus only; Reduce motion `fade.quick`.
4. **Long-press the pass** → a context menu with a lifted preview (native): "Get directions", "Message host", "Add to Apple Wallet" [BK12], "Cancel booking" (destructive, only when allowed).
   - Timing: the native lift after a 0.5 s hold (`UIContextMenuInteraction`); the menu dismisses with the system fade.
   - Haptic: medium on lift (native).
   - VoiceOver: the same actions as custom actions on the pass.
   - Reduce motion: the system shows the menu without the lift scale.
5. **Scroll** → the pass scrolls away under the pinned nav, and the nav gets a hairline once content is under it (`fade.quick`). A rubber-band overscroll at the top stretches the pass by 4% (Wallet feel).
   - Reduce motion: no stretch.

### 4.8 Pass detail: actions (07.21–07.31)
1. **Scan to start** → press (scale 0.97, `snappy`). The sheet dismisses, and the scanner (05.07) zooms out from the button's frame. Inside the scanner, the logic's booking and window checks run as in 05.
   - Timing: the sheet dismisses (`smooth`, ≈ 450 ms); 100 ms after it starts, the scanner grows from the button's frame (camera layer scale 0.92 → 1, `smooth`).
   - Haptic: light.
   - VoiceOver: "Scan to start, button. Opens the camera to scan the charger's QR."
   - Reduce motion: the scanner cross-fades in (`fade.std`).
2. **View session** → press (scale 0.97, `snappy`). The sheet dismisses (`smooth`) and `ActiveSessionScreen` slides up from the bottom (logic `ChargingFlowPageRoutes.slideFromBottom`, ≈ 350 ms ease-out).
   - Haptic: light.
   - VoiceOver: "View session, button. Opens live charging."
   - Reduce motion: no scale; the session screen cross-fades in (`fade.std`).
3. **Charger code row** (07.23) → tap copies "GV7-K42" [BK9]. The value flashes bg/tint behind it (`fade.quick` in/out), and the Neutral toast "Charger code copied" shows.
   - Haptic: selection (the copy action; the Neutral toast itself adds none).
   - VoiceOver: "Charger code, G V 7 K 4 2. Double-tap to copy." It is read character by character with the `.spellOut` hint; after the copy it announces "Charger code copied".
   - Reduce motion: unchanged (fades only).
4. **Quick Action Tile press** → scale 0.96 + fill to its pressed token (`snappy`).
   - **Directions** opens `Sheet / Directions` stacked (`smooth`). The detail sheet stays, dims and shrinks to 0.96.
   - **Message** pushes `ChatThreadScreen(bookingId)` on root (logic). The unread dot clears when you return (`fade.quick`).
   - **Call**: the tile shows a 16pt spinner in place of the icon after 300 ms while the thread resolves (logic). Then the Manual Call Sheet stacks. On error, the Error toast "Unable to load contact info. Please try again." shows with an error haptic.
   - Haptic: light on release; error with the Call failure toast.
   - VoiceOver: "Directions, button. Opens directions to GreenVolt · DHA Phase 5." · "Message host. 1 unread message. Button." · "Call host, button"; while the thread resolves, "Call host, busy".
   - Reduce motion: no scale (85% dim); the stacked sheet fades in (`fade.std`) and the parent does not shrink.
5. **Charger card** → press bg/grouped → bg/fill (`snappy`). Release dismisses the sheet and pushes station details 04.12 (`/station-details`).
   - Haptic: light.
   - VoiceOver: "GreenVolt · DHA Phase 5, Street 12, Block CCA. Type 2 AC, 7.4 kilowatts. View charger, button."
   - Reduce motion: the fill change stays (it is not motion); the push cross-fades.
6. **Leave a Review / Book again / Find another charger** → press (scale 0.97).
   - Review: `LeaveReviewModal` stacks.
   - Book again: the sheet dismisses and Book a slot (04.24) is pushed for that station with today selected (a fresh booking; nothing is prefilled from the old one).
   - Find another charger: the sheet dismisses and the tab switches to Home.
   - Timing: sheet dismiss `smooth` (≈ 450 ms), then the push / tab switch.
   - Haptic: light.
   - VoiceOver: "Book again, button. Opens Book a slot for {station}." · "Find another charger, button. Opens the map."
   - Reduce motion: no scale (85% dim); transitions cross-fade (`fade.std`).
7. **Add to Apple Wallet badge** [BK12] → the press dims it to 0.6 (Apple badge rule). `PKAddPassesViewController` presents (OS). After **Add**: back in the sheet, the badge cross-fades to the "View in Wallet" row (`fade.quick`) and the Success toast "Added to Apple Wallet" shows.
   - Haptic: success.
   - **Cancel** in the OS sheet changes nothing.
   - VoiceOver: "Add to Apple Wallet, button".
   - Reduce motion: no change (both steps are already fades).
8. **Unread dot arriving live** → the dot scales 0 → 1 (`bouncy`). Haptic: none. The VoiceOver label of the Message tile updates; nothing is announced. Reduce motion: the dot fades in (`fade.quick`).

### 4.9 Read-only and stacked sheets (07.29–07.31)
1. **Read-only open from chat** → same open motion, but from the chat banner's frame (the pass grows out of the banner, `smooth` ≈ 450 ms). While the booking is fetched, the skeleton pass shimmers (04 rhythm) and cross-fades to the real pass (`fade.quick`) [BK33]. On a fetch error the sheet does not open; the Error toast shows over the thread.
   - Haptic: light on the banner tap; error with the toast.
   - VoiceOver: focus moves to "Booking details, heading"; the skeleton reads "Loading booking".
   - Reduce motion: the sheet fades in (`fade.std`); no shimmer.
2. **Stacked sheets** (Call, Directions) → the stacked sheet rises (`smooth`); the parent sheet dims (scrim 2nd layer, `fade.std`) and scales 0.96 (iOS stacking). Closing one returns to the detail at the same scroll offset.
   - Haptic: none.
   - VoiceOver: focus moves into the stacked sheet; on close it returns to the tile that opened it.
   - Reduce motion: no scale; the parent only dims, and the stacked sheet fades in.

### 4.10 Cancel flow (07.32–07.37)
1. **Tap "Cancel booking"** (end of the sheet) → press (scale 0.97, Destructive Secondary pressed 978:404). The native alert appears (system zoom + dim).
   - Haptic: none on appear (the alert is the warning).
   - VoiceOver: focus moves into the alert. It reads the title, then the message. Buttons: "Keep booking" and "Cancel booking, destructive".
   - Reduce motion: no button scale (85% dim); the system alert cross-fades instead of zooming (native).
2. **"Keep booking"** → the alert dismisses. Nothing changes, and focus returns to the "Cancel booking" button. No haptic.
3. **"Cancel booking"** → the alert dismisses and the blocking state starts (logic):
   - All sheet sections fade to 60% (`fade.std`), the button switches to its Loading variant, the grabber fades out, and ✕ dims to 40%.
   - Swipe-to-dismiss, scrim taps and the context menu are disabled.
   - Haptic: medium on the tap.
   - VoiceOver: "Cancelling booking" (announcement). The button reads "Cancelling, busy".
   - Reduce motion: no change (fades only); the Loading spinner keeps spinning because it reports progress.
4. **Success** → haptic **success** when the API returns. The sequence (≈ 1 s total, `smooth` unless noted):
   1. The pass in the sheet desaturates to the Cancelled face (300 ms ease-out) and the pill cross-fades to Neutral "Cancelled by you".
   2. The sheet dismisses and the pass flies back toward the list.
   3. The segmented thumb slides to Cancelled (`snappy`) and the page swipes over (logic: "switches to the Cancelled tab").
   4. The pass lands at the top of Cancelled as a stacked pass, with the arrival highlight ring fading over 1.2 s.
   5. The Success toast "Booking cancelled successfully" enters.
   6. A refetch runs silently (logic).
   - VoiceOver: announces "Booking cancelled successfully". Focus goes to the cancelled pass.
   - Reduce motion: cross-fade to the Cancelled tab with the toast. No flight and no colour animation.
5. **Error** → haptic **error**. The sheet restores (opacities back to 100%, `fade.std`), the button returns to Default, and the Error toast shows the server message (logic) for 6 s if it wraps to two lines, 4 s on one line (Toast rule §4.6-3; the logic only says "snackbar with the server message"). If the message contains "cannot be cancelled" or "expired" (logic): after 600 ms the success-like transition to the Cancelled tab plays with no success haptic, and the pass shows its real status (Expired). Then the refetch runs.
   - VoiceOver: the toast is announced; focus returns to the "Cancel booking" button.
   - Reduce motion: the jump to Cancelled is a cross-fade (`fade.std`).
6. **Reason sheet** [BK18, P2, only if adopted] → it opens between the alert and the API call. The sheet rises to the medium detent (`smooth`, ≈ 450 ms). Chip tap = selection haptic + scale 0.96 (`snappy`), single select, tap again to deselect. "Cancel booking" in the sheet runs step 3. Skipping is allowed: the button works with no chip. VoiceOver: chips are toggle buttons ("Plans changed, not selected, button"). Reduce motion: the sheet fades in (`fade.std`), chips dim to 85% on touch instead of scaling.

### 4.11 Wallet (07.38, 07.39)
1. **PassKit sheet** → OS-owned motion (the pass slides into a Wallet deck on Add). We only design the pass JSON content and the return state (§4.8-7).
2. **Pass updates in Wallet** [BK12] → when the booking changes (cancelled, time change), the Wallet pass updates through PassKit web service push. A cancelled booking voids the pass ("Cancelled" in the header field) instead of deleting it. That is the Wallet convention, and no notification is sent beyond our own push.

---

## 5. Mobbin references (all iOS)

### 5.1 Bookings tab as a wallet of passes (07.01–07.06)
- **Apple Wallet — boarding pass detail.** https://mobbin.com/screens/fe3800b2-59af-4229-9412-115dcb51c881 — What we take: the pass is the hero object with nothing around it competing; big route-style readout (our "6:00 PM → 7:00 PM"); label/value pairs in small caps; glass circle buttons at the corners. Density: few fields, large type.
- **Apple Wallet — Genius Bar reservation pass.** https://mobbin.com/screens/e1061c73-0be8-42ba-aaed-3bb1c3321a4e — What we take: a *reservation* (not a ticket) as a pass: brand at top-left, time + date top-right, RESERVATION / LOCATION label pairs, notch at the top edge. This is the closest analogue to a charging slot.
- **Apple Wallet — card added, stack edge.** https://mobbin.com/screens/f6094101-de0a-445d-bb32-19b0f938bdc3 — What we take: the deck of other passes peeking at the bottom edge, so the user knows more exist; the restrained "Done" check. It informs the "Later" stack under the front pass.
- **Airbnb — Trips with "In 2 weeks" pill.** https://mobbin.com/screens/d840bcfa-ed41-4d3c-9196-d39b4e7d98ca — What we take: a relative countdown as its own small label on the card ("In 2 weeks"), separate from the status; one big card for the next trip. Copy tone: short and relative.
- **Fly Delta — My Trips, "42 Days Until Check-in".** https://mobbin.com/screens/f1d9f159-1570-42ad-81e8-6002c2f105c3 — What we take: the countdown to the moment you can act ("until check-in") is the headline; it is our "You can start from 5:45 PM". Also the "Updating Trip Details… Last Updated" strip for refresh.
- **Flighty — "Gate Departure in 2h 58m".** https://mobbin.com/screens/a315a3cc-6234-4d7c-a3ce-9271f5a10092 — What we take: one live line that says what happens next and when, in an accent colour, at the bottom of a compact card. It is the model for "Starts in 10 min" / "28 min left".
- **American Airlines — "Boarding now" lock-screen Live Activity.** https://mobbin.com/screens/98fcfd1a-3618-49cb-947e-320beed64867 — What we take: the status change into the act-now moment, with a highlighted word and a status capsule. It is our Upcoming → Ready to start / Charging now morph.

**Added in review: the Live pass (07.04, 07.24) had no direct reference for "live session inside a pass".**
- **Jomo — "Session" Live Activity, big countdown + slim bar.** https://mobbin.com/screens/ac22e3c9-5974-4d31-b371-4da5b9da5848 — What we take: one label, one large tabular countdown ("28:18") and a hairline progress bar under it, nothing else. It is the density target for the Live pass row ("28 min left" + Pass Progress 338×6).
- **Chick-fil-A — "3–8 min estimated wait" Live Activity with a stepped bar.** https://mobbin.com/screens/dbf914ac-dee9-4623-ad06-1c413a491dc7 — What we take: an estimate stated as an estimate ("estimated wait") above a progress bar. It supports writing "≈26%" + "est." on the pass instead of a hard number.
- **Tesla — Charging 62%: slim bar, kW/kWh line, Stop Charging.** https://mobbin.com/screens/57361bb3-6bfc-461c-b36a-3d525cad0388 — What we take: in an EV app the live state is a % + a thin bar + "+1 kWh" in one quiet line; controls live one tap away, not on the card. Our pass keeps "View session" and leaves Stop to 06.
- **Garmin Connect — LiveTrack "Started 9:44 PM", session active.** https://mobbin.com/screens/df79ed23-fdd1-4cce-9cf8-20eff1a9e4ed — What we take: an active session is described by when it started plus a link to its details. Our context line "Started 6:00 PM · charging stops on its own at 7:00 PM".
- **Fiverr — order "In progress" pill + Days/Hours/Minutes countdown.** https://mobbin.com/screens/4cd0309c-61fa-4ef5-b915-e2945023e999 — What we take: the status pill and the countdown are separate objects (pill = state, countdown = time). Same split as our pill vs. countdown rule (§1.1).

### 5.2 Confirming / pending (07.03, 07.19)
- **Airbnb — "Your reservation is pending".** https://mobbin.com/screens/e41ad7e2-c5b7-4a35-9683-6ee4b0a654c2 — What we take: the "Pending" capsule sits on the card itself and the card stays fully readable; one calm sentence explains why. Our "Confirming…" pill + optional line.
- **Fly Delta — "Update Complete / Last Updated".** https://mobbin.com/screens/a4347970-d0e1-4a7a-93ea-28361d6ea5e4 — What we take: a quiet in-place sync indicator (spinner + text), not a blocking loader. It supports keeping the pass visible while confirming or refreshing.
- **Mindtrip — Bookings: placeholder card "Analyzing uploaded file — it will take a moment".** https://mobbin.com/screens/2ad98a53-e98f-4c93-a76d-1c344a5e3650 — What we take (added in review): a booking that isn't real yet keeps its slot in the list as a quiet placeholder with one clock-icon line under it. Exactly our non-tappable Confirming pass + the optional line [BK31].
- **Fiverr — confirmation toast above the tab bar.** https://mobbin.com/screens/79525f85-4861-4fc8-9cf6-bc5544da1342 — What we take: the toast position (just above the floating tab bar), a check glyph and one sentence. Used for our success/error toasts.

### 5.3 Tabs, history lists, cancelled states (07.07, 07.08, 07.34)
- **Perplexity — Reservations: Current / Past / Canceled.** https://mobbin.com/screens/e1f74d6c-00e0-43fe-b17c-66ef69713a29 — What we take: three peer tabs exactly like ours, plus a centred empty state with a line icon, a title and one sentence. Validates the tab names and empty copy density.
- **Luma — Upcoming / Past segmented in the nav, date-grouped list.** https://mobbin.com/screens/50a15c31-b0e5-481e-8093-26351c32d5b6 — What we take: a native-looking segmented control directly under the title; a date group header with the weekday in a lighter tone. Our month headers.
- **Marriott Bonvoy — Trips · Canceled tab** (flow "Canceling a trip"). https://mobbin.com/flows/a88ecbbf-2e00-4be7-989a-7b6230d078ce — What we take: after cancelling, the trip lives in the Canceled tab with its own reference. It confirms the logic's jump to Cancelled.
- **Lyft — Ride history with "Canceled by you".** https://mobbin.com/screens/e15ee76e-a314-45d9-92d2-ba14537a886a — What we take: the actor is in the row ("Canceled by you"), with date group headers and the amount right-aligned ($0.00 for cancelled). Our "Cancelled by you / by host" on the list [BK6] and "—".
- **Uber — Activity: Upcoming empty + Past with "Canceled" and Rebook.** https://mobbin.com/screens/e93a2415-cec1-4cf2-a139-1db7911e1cb1 — What we take: "$0.00 · Canceled" in the meta line and a **Rebook** pill on past items. Our "Book again" [BK14].
- **Uber Eats — Your Plans: Upcoming / History, grey "Cancelled" chip.** https://mobbin.com/screens/47caf358-d532-437d-8f1c-c2f7e6f818ba — What we take: cancelled reads as neutral grey, not alarm-red, when *you* did it. Our Neutral tone for S8/S10.
- **Tripadvisor — Hotels · Past with red "Cancelled" pill.** https://mobbin.com/screens/1112b2fa-cc81-46be-8255-1f4dc2075d93 — What we take: the counter-example. A red pill on every cancellation is loud, so red is reserved for "Cancelled by host" only.
- **Tesla — Charge History.** https://mobbin.com/screens/2df18314-58fa-427d-8629-f6b3dba3cdcd — What we take: EV history rows of date · time, duration under it, energy right-aligned; month navigation. The density target for Completed passes.
- **Grab — Activity: "Rate & tip →" and "Rebook →" inline links on recent rides.** https://mobbin.com/screens/2fd1cc96-aa61-42e0-bfd2-5d19cddf5178 — What we take (added in review): the follow-up actions sit as small text links *inside* the history row, separate from the row tap. That is our Review Link row under a hairline on Completed passes, and our "Book again" [BK14].
- **Starbucks — History: "Want to leave a tip? Tipping available until 11:47AM".** https://mobbin.com/screens/a4e1d7e4-cf81-4ff9-8343-9edb7c93bd00 — What we take (added in review): a time-limited follow-up action states its deadline. Supports the logic's 7-day review window ("Review period ended" + the toast) and a future "Review until Oct 11" hint if Hammad wants it (not drawn).
- **Blue Apron — Orders: "Upcoming / Past orders" tabs with a "Rate your order" card on top.** https://mobbin.com/screens/6e3782b0-f14f-40fd-910a-ea0628566655 — What we take (added in review): upcoming and past split by a quiet tab control, with the "next" object as one large card. Confirms our front pass + tabs.
- **BlaBlaCar — Archived rides: "Cancelled" / "Request not approved" cards.** https://mobbin.com/screens/02ec41a3-9748-40c4-83f3-853a78f57a1e — What we take (added in review): cancelled items keep the full card anatomy (date, times, route) with only the status line changed and a muted icon. Our stacked Cancelled passes keep schedule, vehicle and connector.
- **Lloyds — Expired offers.** https://mobbin.com/screens/e8062694-1959-4945-be48-03faaa98d2a4 — What we take: expired items stay legible but quieter, with "Expired: 31 Dec 25" as a meta line. Our Expired face + "No session started".

### 5.4 Empty, loading, offline (07.10–07.16)
- **American Airlines — "No upcoming trips" card.** https://mobbin.com/screens/c17706bb-f37e-4ec5-8b57-81905c5345e8 — What we take: the empty state is shaped like the thing that will appear, with one clear action ("Book a trip"). It is our Ghost Pass + "Explore chargers".
- **Uber — "You have no upcoming trips / Reserve your ride →".** https://mobbin.com/screens/e93a2415-cec1-4cf2-a139-1db7911e1cb1 — What we take: a friendly one-liner + action; the empty upcoming area doesn't hide the past. Tone check for our real copy.
- **Slopes — Offline Maps empty state.** https://mobbin.com/screens/e8db2a96-12b0-489a-8b2f-2ee3da955932 — What we take: line icon, title, one-sentence explanation and a tinted action. The State View rhythm for Completed/Cancelled empties.
- **Noom — Health tab "Can't connect / Please try again… / Retry" with the tab bar visible.** https://mobbin.com/screens/2419210e-0800-41b0-b0ce-d45c385858cc — What we take (added in review): a root-tab load error is a centred icon + title + one sentence + one compact Retry, and the tab bar stays live. Our 07.16 State View Error.
- **Oura — "Can't load chat / Wait a moment and try again. / Try again".** https://mobbin.com/screens/9dbf6e35-9643-449f-9d0f-c89cc6248a49 — What we take (added in review): the message line is short and blameless. Tone source for our [BK24] line "Check your connection and try again."
- **Fly Delta — Watching tab: segmented control + empty state with one red action.** https://mobbin.com/screens/2e74fbeb-b31a-4947-a1c6-84d99e5e813e — What we take (added in review): the segmented control stays visible and usable above an empty tab, and the one action is a full-width button. Our 07.10 keeps the tabs live above the Ghost Pass.
- **Sesame — offline notice card.** https://mobbin.com/screens/2d85e6ae-5a90-44c0-9ceb-d0cff29fb561 — What we take: an offline message as a soft card at the top of still-visible content (not a modal). Our "Showing cached bookings (offline)" Inline Notice.

### 5.5 Pass detail (07.21–07.28)
- **Fly Delta — boarding pass with tiles below** (flow "Adding to Apple Wallet"). https://mobbin.com/screens/8eddb26c-f76b-4aff-ac16-12e734aa78fe — What we take: pass on top, then two equal tiles for what you need *now* (Gate, Boarding time), then the schedule card. It is the model for pass → quick action tiles → charger card. The Add to Apple Wallet badge sits inside the pass area.
- **Posh — Your Order: pass + action rows.** https://mobbin.com/screens/70c99608-be00-4a4a-8d05-48bc9e9697bb — What we take: under the pass, grouped rows View Event / Add to Calendar / **Add to Apple Wallet** / **Get Directions**; Upcoming/Past segmented at the very top. Confirms the set of actions a pass needs.
- **Fresha — appointment detail: "Getting there".** https://mobbin.com/screens/a5961d42-aa86-4eb1-a59d-cb43a662c483 — What we take: access instructions ("Free parking… ring the door bell") in their own card next to the address with "Get directions", then Reschedule / Cancel rows above. Our "Access notes" card + Directions.
- **Airbnb — reservation: Confirmation code / Cancellation policy / Amount paid.** https://mobbin.com/screens/f4c764a3-7d5b-41ea-a8c7-342030d16e5f — What we take: plain label/value sections with generous spacing and one action link each. Our "Booking information" rows.
- **Apple Wallet — reservation pass details (back of pass).** https://mobbin.com/screens/f3ce79fa-8661-4833-a601-04c40cc95ef5 — What we take: DATE and LOCATION rows in an inset grouped list, with the destructive "Remove Pass" alone in its own group. Our Cancel booking alone at the end.
- **Fresha — appointment actions: Add to calendar / Get directions / Send message / Venue details.** https://mobbin.com/screens/59efcea9-3e9f-4c36-901a-9bf4351a8293 — What we take (added in review): the "do something now" actions sit together right under the booking header, each with a tinted icon well, before the price overview. Same order as our tile row Directions · Message · Call above the charger card [BK11].
- **Tripadvisor — Booking details: confirmation number, Check-in / Check-out pairs.** https://mobbin.com/screens/93eafc68-03a1-4b02-b8a6-b1b5c742563f — What we take (added in review): the sheet title is literally "Booking details" and the info is plain label/value pairs with generous spacing. Validates keeping the logic labels "Scheduled date" / "Scheduled time" as plain rows.
- **Meetup — Ticket with notch and perforation.** https://mobbin.com/screens/427c632f-e3ad-471e-8652-1d95b622e4f3 — What we take: the semicircle notch + dotted perforation that makes a card read as a ticket without skeuomorphism. Our pass perforation.
- **Agoda — Booking Detail "Your booking is confirmed".** https://mobbin.com/screens/de6c07dd-6cd3-4fc1-8e59-3380edb94ccb (first screen of flow https://mobbin.com/flows/b2c1196c-113d-4067-ad30-6ad29cef297b) — What we take: status sentence + booking ID block + date range row + "Manage this booking" with Edit and Cancel side by side. We keep only one destructive action at the end.

### 5.6 Ready to start / charger code / scan (07.01, 07.23)
- **CLEAR — QR + Add to Apple Wallet on a dark vault.** https://mobbin.com/screens/53bd0d89-b12c-42c2-bd4d-ceec73c5f64e — What we take: one access object, one info line ("For access at select stadiums…") and the Wallet badge right under it. Our charger-code row + Wallet badge.
- **Luma — ticket QR sheet with Add to Apple Wallet.** https://mobbin.com/screens/fd60dbd4-6f2f-43e8-a2a8-dbf6954b3f59 — What we take: the access code gets maximum size and contrast, with a single wide action at the bottom. We apply it to the code "GV7-K42" in Display/S.
- **American Airlines — "Ready to Fly": days until trip, check-in timing.** https://mobbin.com/screens/8ba381ea-aa57-440b-a872-0111e31b6a0a — What we take: "Get your boarding pass beginning 24 hours before departure" + "Time remaining to check-in". That is our ±15-minute start window copy ("You can start from 5:45 PM").
- **Polarsteps — flip-digit countdown.** https://mobbin.com/screens/7a6c830b-f828-409f-8d45-b27bf752b863 — What we take: the countdown itself is the delight; digits change in place. Our `roll` on "Starts in 10 min" (kept small, not a flip board).

### 5.7 Cancel flow (07.32–07.37)
- **Tock — Cancel: summary card + "Modify reservation" / "Cancel reservation"** (flow). https://mobbin.com/flows/45509f08-4ae2-4ea2-8436-bd8dac8d9d1b — What we take: before cancelling, restate exactly what is being cancelled (venue, date, time). Our context line in the alert [BK19]. Afterwards, a "Reservation canceled" band at the top of the details.
- **World of Hyatt — Cancel Reservation alert → "Your reservation has been cancelled"** (flow). https://mobbin.com/flows/71e9e653-5933-492a-b6e9-01548a10b5a3 — What we take: the native alert is enough for a cancel confirm; the policy goes in the message, and the confirm is followed by a clear done state. We use a toast + tab switch instead of a second alert.
- **Apple Wallet — "Delete Order" alert (Not Now / Delete).** https://mobbin.com/screens/cf1c45dc-b82e-42fc-a6a9-b4543b2cff77 — What we take: Apple's own destructive alert wording: say what happens and what *doesn't*; the safe action on the left, the destructive one red on the right. Matches "Keep booking" / "Cancel booking".
- **Tripadvisor — "Cancel for Any Reason" sheet.** https://mobbin.com/screens/260c5b5c-96e2-4be8-8b89-df68c4a7238b — What we take: numbered consequences ending with "Cancellations can't be reversed." in bold, and a secondary "No, go back". Tone source for "This action can't be undone." We don't copy the refund box: there is no refund logic in PakPlug.
- **Agoda — "Reason for cancellation (required)"** (flow, screen 2). https://mobbin.com/flows/b2c1196c-113d-4067-ad30-6ad29cef297b — What we take: the counter-example. A 13-item *required* reason list is friction. Our optional 5-chip sheet [BK18] is P2 and skippable.
- **Grab — Manage booking → Cancel booking → "Your booking has been cancelled" toast** (flow). https://mobbin.com/flows/b24fd688-bc7d-4175-af99-834e0f24724f — What we take: the destructive action is a light-red tinted full-width button below the primary, and success is a top toast while the app returns to a useful screen. Our Destructive Secondary + toast on the Cancelled tab.
- **Uber — Reservation detail: "Things to keep in mind", Cancel.** https://mobbin.com/screens/fa3ad858-ff85-4690-8fa3-86b9f191d6ef — What we take: the rules (wait time, cancellation policy) are stated near the cancel button, and the Cancel button is a calm grey slab with red text, not a red slab. It confirms the Destructive Secondary style.
- **American Airlines — "Updating reservation… Please wait." blocking dialog over the trip.** https://mobbin.com/screens/92128d6a-b546-4165-95c3-9d12473493f4 — What we take (added in review): while a change to a reservation is in flight, the screen behind dims and nothing else is tappable. It is the logic's "blocking spinner" (07.33); we keep it inside the button (Loading variant) instead of a second dialog, but the dimmed, locked sheet is the same idea.
- **Booking.com — Manage booking: "Cancel Booking" red text action.** https://mobbin.com/screens/27dd627b-d3ec-4719-bda6-2a927ffe6961 — What we take: the cancel action sits at the end of the details, after the price breakdown, with an ✕ glyph. Placement check.

### 5.8 Host cancelled / expired outcomes (07.09, 07.26, 07.27)
- **Too Good To Go — "Order canceled" band + cancellation status timeline.** https://mobbin.com/screens/44a15e4c-c686-47c0-8d20-14ab632bdbf9 — What we take: the card itself carries the cancelled state in its header colour, and the details stay readable under it. Our Cancelled face with the Error pill for host cancellations.
- **Zocdoc — "Appointment cancelled" + "Find a new provider".** https://mobbin.com/screens/789e37c5-228a-4221-be2d-a650a831b45f — What we take: when the provider cancels, the very next thing is a way forward ("Find a new provider" / "No thanks"). Our "Find another charger" + "Book again" [BK14].
- **Agoda — "Cancelled" header + "Book again".** https://mobbin.com/screens/3e521b44-554e-4809-adb5-cbb690a7d582 — What we take: a short reassurance sentence and a single primary "Book again" on a cancelled booking.
- **Fresha — Cancellation policy (Before / After, no-show fee).** https://mobbin.com/screens/533711bd-8bd8-4eec-a67d-70ff37ea5f7c — What we take: how a no-show would be explained if PakPlug ever charges one (two-column before/after). It is noted for S11's future "No-show" label and not drawn now.

### 5.9 Add to Apple Wallet (07.38, 07.39)
- **Fly Delta — Adding to Apple Wallet** (flow: badge → PassKit "Add" sheet). https://mobbin.com/flows/40b488ad-b1e5-43a3-91b7-3e8b392c12eb — What we take: the official black badge inside the pass area, then the OS preview with Cancel / Add. The pass fields are big and few.
- **Marriott Bonvoy — Adding to Apple Wallet** (flow: "Add to Wallet" tile → "View in Apple Wallet"). https://mobbin.com/flows/0d5392e0-1321-4c26-bf0c-47547a59a67b — What we take: after adding, the same slot becomes "View in Apple Wallet". Our badge → "View in Wallet" row.
- **CLEAR — Adding a CLEAR pass to Apple Wallet** (flow). https://mobbin.com/flows/9e914f2e-1288-4f36-8977-e2a17a93f134 — What we take: a Wallet pass can be minimal (logo, one primary field, one secondary). Our PassKit pass has no barcode, only fields.
- **Shangri-La Circle — Adding card to wallet** (flow). https://mobbin.com/flows/ec56ffda-1174-4b44-849d-7ec42ac5afc6 — What we take: the in-app pass and the Wallet pass share artwork, so they read as the same object in two places. Our emerald face + Solid P in both.

---

## 6. New components needed (not in the inventory)

| Component | Purpose | Variants | Props / anatomy |
|---|---|---|---|
| **Charging Pass · new statuses** (extend 1010:521) | Every booking status as a pass (§1.1) | Add `Status` = **Confirming · Ready · Live · Paused · Expired** × `Layout` = Stacked · Front (10 new variants), next to the existing Upcoming / Completed / Cancelled | Faces: Confirming = Upcoming face + `sheen` 8% fast loop + pill Neutral "Confirming…" with spinner; Ready = Upcoming face + 3pt energy top edge (Warning edge for "Expiring soon" and for a Live pass in its last 5 min, via an `Edge` = Energy / Warning prop) + Success pill; Live = Upcoming face + `sheen` loop ≤ 8% + Live pill + live row (`Percent`, `So far`) + **Pass Progress**; Paused = Upcoming face + 4pt status/warning leading bar + Warning pill; Expired = Cancelled face + Warning pill. Convert the visible texts to component properties on **all** variants: `Station`, `Date`, `Start`, `End`, `Duration`, `Vehicle`, `Connector`, `Amount`, `Total label` ("EST. TOTAL" / "TOTAL") [BK35], `Countdown`, `Show countdown` (BOOL), `Schedule` (stacked line), `Meta` (stacked line 3), `Show review link` (BOOL, Stacked Completed), `Review link` (INSTANCE_SWAP → Review Link). Status Pill stays a nested instance (exposed). All text on emerald = solid white. No chevron [BK34]. Pill contrast on the emerald face is checked on a screenshot before publishing (§1.1). |
| **Pass Progress** | Time progress on the Live pass (07.04, 07.24) | none | 338×6 track white 25% radius pill + energy fill (width = elapsed / slot); `Start label` / `End label` (Caption 2, white). |
| **Review Link** | Inline review action on completed passes (logic) | State = Leave · Edit · View · Ended | 32pt row (44pt hit area by extending into the pass padding): star 1025:492 14pt + label (Footnote Emph). Leave/Edit = text/brand on light faces (white on emerald); View = text/secondary; Ended = text/tertiary at 40%, labelled "dimmed" for VoiceOver. Label texts are the real ones. |
| **Status Pill · Spinner** (extend 980:347; 00-system C14) | "Confirming..." | add BOOL `Spinner` (10pt activity indicator replacing the dot) | Neutral S only in use; keep the label text. |
| **Quick Action Tile · Badge** (extend 1008:431) | Unread dot on Message (logic: red unread dot) | add BOOL `Badge` | 8pt status/error 948:76 dot with a 2pt bg/surface ring, top-right of the icon. Optional `Loading` BOOL (16pt spinner replaces the icon) for Call's thread resolve. |
| **Ghost Pass** | Empty Upcoming illustration (07.10) | none | 370×208, radius lg, bg/frost fill, 1.5pt dashed stroke/separator (6/6), perforation notches, centred `Brand / Mark / PakPlug P` Style=Mesh 40pt at 60%. Decorative (`accessibilityHidden`). |
| **Wallet Badge** | Apple's "Add to Apple Wallet" badge (07.22) [BK12] | none (placeholder) | 160×50 black rounded rect with the Wallet glyph + "Add to Apple Wallet". **Must be replaced by Apple's official artwork** (Apple Wallet badge guidelines: no recolouring, min height 40). Layer name "Apple badge · placeholder". |
| **iOS / Refresh Control** (OS mock) | Pull-to-refresh spinner (07.14) | State = Pulling (partial ticks) · Refreshing | 20pt system activity indicator, text/secondary. Label "OS-owned · UIRefreshControl". |
| **iOS / PassKit Add Sheet** (OS mock, P2) | 07.38 | none | Grouped bg, nav "Cancel" · title · "Add" (system tint), centred pass preview 338 wide. "OS-owned". The Wallet pass inside is a separate frame `Wallet Pass · PakPlug` (emerald, Solid P, fields per 07.38) for the PassKit designer. |

**From other flows (dependencies, not new here):** `Inline Notice` (04 §6: Warning, Neutral), `Avatar` (04 §6: M "B"), `Notification Preview` Style=In-app banner (01 §6), Manual Call Sheet (Messages flow; until then compose as 04.17), `Skeleton Block` shimmer rhythm (04).

**Reused, no change needed:** `Nav Bar` (Large, Inline), `Segmented Control` 3 segs (all three), `Tab Bar` Bookings, `Tab Bar Accessory / Live Charging` Charging, `Charging Pass` (existing six variants), `Status Pill` (Info, Success, Warning, Neutral, Error, Live; S), `Button / Large` (Primary Default, Secondary Default, Tertiary, Destructive, Destructive Secondary Default / Pressed / Loading), `Quick Action Tile` (Primary, Tinted), `List Group Header`, `List Row` (Value, Navigation), `State View` (Empty, Loading, Error), `Toast` (Success, Error, Neutral), `Alert` Destructive, `Sheet / Directions`, `Sheet Header` Form, `Chip` (Fill/No, Fill/Yes), `Mesh Quiet`, `iOS / Status Bar`, `iOS / Home Indicator`.

**Missing SF Symbols (FLAG card):** `wifi.slash` (offline notice; placeholder info.circle), `doc.on.doc` (copy affordance on the charger code; placeholder none, the row itself is the affordance), `arrow.counterclockwise` (Book again leading icon; placeholder none).

**From other flows, also used:** `Skeleton Block` (04) for the read-only fetch [BK33]; `Brand / Wordmark` White 994:127 on the Wallet pass preview (07.38).

---

## 7. Proposals (not in the logic map), flagged

| # | Proposal | Why | In frames |
|---|---|---|---|
| BK1 | **Upcoming sorted soonest-first**; the soonest is the big front pass and the rest sit under "Later". Logic sorts "newest start first". | Wallet puts the most relevant pass on top. With newest-first, tomorrow's booking would sit above today's. Sorting only; buckets unchanged. | 07.01–07.06, 07.09 |
| BK2 | Pill **"Ready to start"** (Success) inside the start window (start − 15 min → end); logic shows "Upcoming". | The logic's ±15-minute rule decides when a driver can start; the pass should say so. Same label as 05.01 for consistency. | 07.01, 07.23 |
| BK3 | **"Charging now"** live pass while a session runs on that booking (copy from the chat banner), with "View session". | Approved concept B: "the pass turns live while charging" (D9). Same data as the accessory. | 07.04, 07.24 |
| BK4 | **Paused bookings go to Upcoming** with a Warning "Paused" pill. (The list card maps paused → "Upcoming"; the details pill already says "Paused", so the list adopts the details label.) | Code puts `paused` in no tab (logic §G (?), Appendix 4), so they vanish. They are still ahead and cancellable (logic), so they belong in Upcoming. | 07.06 |
| BK5 | **Details pill uses the derived status** (e.g. "Expired"), the same rule as the list. The pill moves from beside the sheet title onto the pass. | Code reads the raw status, so a past booking reads "Upcoming" in details and "Expired" in the list (logic §G (?), Appendix 4). | 07.27 |
| BK6 | "Cancelled by you" / "Cancelled by host" on the **list** pill too (logic: details only). | Who cancelled is the first question; Lyft shows it in the row. Host cancellations get the Error tone, own ones Neutral. | 07.08 |
| BK7 | Countdown line on passes ("Starts in 10 min", "28 min left", "Tomorrow") and the window line "You can start from 5:45 PM" / "You can start now. Your slot ends at 7:00 PM." | Turns the ±15-minute rule into something visible. Shares 05's CH20 wording. | 07.01–07.06, 07.21–07.24 |
| BK8 | **"Scan to start"** on the Ready pass and in its detail → scanner 05.07. | Shortest path from the pass to charging; the logic's checks still run after the scan. | 07.01, 07.05, 07.23 |
| BK9 | **Charger code** on the pass detail, with tap to copy. | The manual-entry fallback (05) needs the 6-character code; the driver may not find the sticker. Needs the station's short code in the booking payload. | 07.23 |
| BK10 | **Directions** in booking details (reuses `Sheet / Directions` and 04's copy). | The logic's sheet has no way to navigate to the charger; drivers open it on the way. | 07.21, 07.31 |
| BK11 | Call and Message move from the host card into a **Quick Action row** (Directions · Message · Call); the host card keeps identity only. | Same actions and same rules (Call hidden without socket URL; unread dot). Matches the Apple-Maps action row of 04's place sheet. | 07.21–07.28 |
| BK12 | **Add to Apple Wallet** (official badge, PassKit pass with no barcode, "View in Wallet" after adding, pass voided when cancelled). | Concept B's flagged extra. Needs PassKit signing, a pass web service and Apple's badge artwork. Hidden when the device can't add passes. | 07.22, 07.38, 07.39 |
| BK13 | **Hide Cancel booking while a session is live** on that booking. | Cancelling mid-session has undefined billing. Stopping belongs to the session screen. Logic would show it (confirmed/paused, in window). | 07.24 |
| BK14 | **"Book again"** on Completed / Cancelled / Expired; **"Find another charger"** on host-cancelled. | Every dead end gets a way forward (Uber Rebook, Zocdoc, Agoda). Book again opens 04.24 fresh, with nothing prefilled. | 07.25–07.27 |
| BK15 | Expired explanation: "No charging session was started during this slot." / "No session started". | Covers "no-show" without a new status; a past booking that silently says "Expired" is unclear. | 07.08, 07.27 |
| BK16 | Host-cancelled line: "The host cancelled this booking. Message {host} if you have questions." (drawn for Model Town: "Message Usman…") | Explains the red pill and points to the one useful action. No refund claims: there is no refund logic. | 07.26 |
| BK17 | Paused notice: "This booking is paused right now. Message the host before you go." | Gives `paused` a meaning the driver can act on without claiming why it is paused. | 07.06, 07.28 |
| BK18 | Optional cancel **reason** sheet (5 chips, skippable). **Default: not built into the flow**; P2 frame only. | Hosts could use the signal, but there is no API field. Shown so Hammad can decide. | 07.37 |
| BK19 | Context line in the cancel alert: "GreenVolt · DHA Phase 5 · Today, 6:00 – 7:00 PM". | Restating what is being cancelled prevents the wrong booking being cancelled (Tock). | 07.32 |
| BK20 | Push "Booking update" (and its foreground banner) opens the **Bookings tab with that pass's detail** on top. | Logic pushes `/my-bookings` as a separate route (back chevron, no tab bar, 07.40) and ignores `bookingId`. | §1.3, 07.09, 07.40 |
| BK21 | Estimate footnote under Total cost on upcoming bookings. | Same as 04-P19: billed amounts can differ (completed shows the billed amount). | 07.22 |
| BK22 | 12-hour times and "Oct 4, 2026" dates in details (logic "HH:mm", "MMM dd"); month group headers in Completed / Cancelled. | One time format across the app (05 CH12). Month groups make long histories scannable (Tesla, Lyft). | 07.07, 07.08, 07.22 |
| BK23 | **Ghost Pass** on empty Upcoming. | The empty state shows the object that will appear (American Airlines pattern); calm, on brand. | 07.10 |
| BK24 | Error message line "Check your connection and try again." and a "Log in" action on the signed-out state. | The logic's error is a title only; the signed-out state has no way forward. | 07.16, 07.17 |
| BK25 | Offline notice wants the `wifi.slash` symbol. | Clearer than info.circle; the symbol is not exported yet. | 07.15 |
| BK26 | **"Expiring soon"** Warning pill + "14 min left to start" when ≤ 15 min of the window remain and no session started. | Mirrors the real `BOOKING_EXPIRING` push in the app itself, so the driver sees it even if the push was missed. | 07.05 |
| BK27 | Charger card shows "Type 2 (AC) · 7.4 kW" and drops the logic's status echo ("· Available / Completed / Cancelled / Expired"). | The pass right above already shows the status; "Available" next to a completed booking reads as a charger state and confuses. **Rayan: keep the field if it means live charger availability.** | 07.21 |
| BK28 | Vehicle on the pass face ("BYD Atto 3"). | The booking is created with a vehicle (logic §C), but no screen shows it afterwards. A driver with two cars needs to know which one. | all passes |
| BK29 | Copy casing: Bookings uses "Leave a Review", Complete uses "Leave a review". Suggest sentence case everywhere. Frames keep the real copy. | Consistency, no behaviour change. | note only |
| BK30 | Context menu (long-press) on passes with Directions / Message / Add to Wallet / Cancel. | Native power-user shortcut; same actions as the sheet. | §4.7-4 |
| BK31 | Optional line under a Confirming pass: "Hang on — we're confirming your slot." | Explains the non-tappable pass. If not wanted, hide the line; the pill alone is the logic. (Review: dropped "with the host"; the optimistic state is our API call, not a host approval.) | 07.03 |
| BK32 | Completed context line "Charged on Oct 4, 6:00 – 7:00 PM". | Says when the charge happened without opening Booking information. Uses the booking window; switch to the session's real start/end if the payload has them. | 07.25 |
| BK33 | Read-only detail from chat opens at once with a skeleton pass while the booking is fetched. | The logic fetches before showing anything and only defines the error ("Unable to load booking details."); a tap with no feedback feels broken. | 07.29, §4.9-1 |
| BK34 | No trailing chevron on passes (logic card has one). | The whole pass is the tap target with a press state, like Wallet; a chevron on a ticket face reads as clutter. VoiceOver still says "Button". | all passes |
| BK35 | Pass footer label "EST. TOTAL" on Upcoming-family faces, "TOTAL" on Completed / Cancelled / Expired. | The brief requires every estimate to be labelled; the logic shows the same "Rs X" for an estimate and a billed amount. | all front passes |

---

## 8. Edge cases & defaults chosen (Hammad asleep: decided)

1. **What `paused` means is ambiguous.** The chat banner maps `paused` to "Charging now" (live), while the details sheet shows "Paused" and keeps Cancel. **Default:** `paused` + an active session on the booking → S5 Live; `paused` without a session → S6 Paused in Upcoming. One question for Rayan in the FLAG card: "Is `paused` set while a session runs, or when the host pauses the station?" Either answer is already covered by the variants.
2. **The Confirming state** only occurs on the legacy optimistic path (`pendingBookingProvider`). The live booking flow navigates after the API returns (04.43). It is still designed (P1) because the tab still reads the provider.
3. **Two bookings in the start window at once** (back-to-back slots at different stations): both get Ready. The soonest start is the front pass, and the other becomes the first stacked pass with its own Ready pill. "Scan to start" goes to the same scanner; the scanned station picks the booking (logic).
4. **A session runs on booking A while booking B is in its window:** B stays Ready, but its "Scan to start" opens the Charge tab's State 2 message (logic: "You're already charging…"). The button is not disabled, so the reason stays explicable.
5a. **Live pass at 5:00 left** (6:55 PM): Live pill stays, the top edge turns warning and the countdown reads "5 min left", in step with the accessory's Ending state and 06's "Ending soon" (§4.2-5b). "Expiring soon" is never used on a live pass.
5. **Live pass at the slot end:** the logic auto-stops ("Session time reached. Stopping charging automatically..."). The pass shows the accessory's Stopping state and then moves to Completed when the status updates. If the status lags, the pass stays Live with "0 min left" for at most one refetch.
6. **Completed with a billed amount of 0:** shows "Rs 0" (logic uses the billed amount; "—" is only for cancelled/expired).
7. **Cancelled/expired with an amount > 0:** shows "Rs X" (logic) in text/secondary-equivalent on the pass (white on emerald faces; text/secondary on light faces). We don't claim a refund or a charge.
8. **Cancel during the window, before a session starts** (e.g. 6:20 PM): allowed (logic: cancel shown when not past the window). Same alert.
9. **Cancel while offline:** the flow runs. The API fails, the Error toast shows the network message, and the pass stays Upcoming. The button is not pre-disabled (no logic for it).
10. **The server says "cannot be cancelled"/"expired":** jump to Cancelled and refetch (logic). The pass shows whatever status the refetch returns.
11. **A booking pushed (`booking_updated`) while its detail is open:** the sheet updates in place (pill morph `snappy`). If it became cancelled by host, the Cancel button collapses, the context line changes, and a warning haptic fires. The sheet does not close by itself.
12. **Deep link arrives while another detail is open:** the open sheet cross-fades to the new pass (no stacking).
13. **No access notes:** the section is hidden (logic). **No socket URL:** Call is hidden and the tile row has 2 tiles. **No host phone:** the Call sheet shows the real "hasn't added a phone number" copy with Call disabled (drawn case: Usman, Model Town, as 09.31).
14. **No charger short code** in the payload: hide the charger-code row. **No coordinates:** Directions shows 04's toast "Station location is not available".
15. **Apple Wallet unavailable** (`PKAddPassesViewController.canAddPasses()` false, or iPad without Wallet): hide the badge.
16. **Long station names:** 2 lines on the front pass, then truncate; 1 line on stacked passes. The full name is in the detail's charger card and in the VoiceOver label.
17. **Dynamic Type (largest sizes):** the front pass grows in height and the footer's 3 columns stack into rows; stacked passes move the amount under the schedule. The Display numbers scale with the Display styles.
18. **Many bookings:** no pagination in logic; the list scrolls. The month headers keep it scannable.
19. **Equal start times:** tie-break by station name A→Z.
20. **Card-level station error:** only that pass shows the error line; times and amount still render from the booking.
21. **The "Explore chargers" tab switch** keeps the Bookings tab's state (IndexedStack keeps tabs alive, logic).
22. **Debug "Test bookings cannot be cancelled via API":** not drawn (debug builds only).
23. **Time zone:** everything is Asia/Karachi; the relative words ("Today", "Tomorrow") flip at local midnight on the next minute tick.
24. **Reduce Transparency:** pass faces are opaque already; frost bands and sheets become Surface with a hairline; the `sheen` is off.
25. **Opened from a push while the app is in the background:** logic pushes `/my-bookings` over the shell (07.40). With BK20 the shell switches to Bookings and the pass detail opens; Back is the sheet's ✕.
26. **Messages badge over 9:** the tab bar shows "9+" (logic cap); frames use "2".

---

## 9. Logic-check summary (for the logic cards)

- **§G `DriverMyBookingsScreen`:** pushed-route variant from a push, `bookingId` ignored (07.40, BK20); header "Bookings"; tabs Upcoming · Completed · Cancelled as a native segmented control (design spec §4.1-4), swipeable pages; buckets (Upcoming = confirmed and end > now + optimistic pending; Completed = completed; Cancelled = cancelled + expired + confirmed-past "Expired") and sorts (Completed by end desc, Cancelled newest start first; Upcoming changed [BK1]); paused fix [BK4]; socket `booking_updated` (07.09); pull to refresh (07.14); not logged in (07.17); loading spinner, reloads keep data (07.13, 07.14); error "Failed to load bookings" + Retry (07.16); offline cache banner (07.15); station-loading centre loader (07.13 note); card-level "Error loading station: …" (07.18); legacy optimistic error with Dismiss (07.19); all three empty states with real copy, "Explore chargers" → Home (07.10–07.12).
- **§G `DriverBookingCard` → `BookingListCard`:** station, status pill (Upcoming/Completed/Cancelled/Expired; "Confirming..." not tappable), schedule format, connector, amount rules (billed / "—" / Rs X), chevron (the whole pass is the affordance; no chevron drawn on passes), review links (all 4 + the snackbar), tap → details.
- **§G `DriverBookingDetailsBottomSheet`:** slide-up over a scrim, scrim tap closes; "Booking details" + pill (all six labels incl. by you / by host / Paused; derived status [BK5]); charger card (bolt avatar, name, address, connector + power) [BK27]; "Booking information" with the real labels "Scheduled date" / "Scheduled time" / "Duration" / "Total cost" (formats BK22); "Access notes" when present; host initials, name, "Charger host"; Call (socket URL condition, thread resolve, ManualCallSheet, error copy); Message (unread dot, ChatThreadScreen on root); "View charger"; "Cancel booking" (outlined red, condition) [BK13].
- **§G `DriverCancelBookingModal`:** "Cancel booking?" + message, "Cancel booking" / "Keep booking" (native alert; the icon is dropped per design spec §4.1-5); blocking spinner (07.33); success → Cancelled tab + "Booking cancelled successfully" + refetch (07.34); error → server message (07.35); "cannot be cancelled"/"expired" → Cancelled + refetch (07.36); debug message not drawn.
- **§G `BookingDetailScreen`:** unreachable (§0); nothing drawn. Its "Cancel Booking?" / "No" / "Yes, Cancel" copy is not used.
- **§H chat:** the banner "Upcoming booking" / "Charging now" → read-only details with no cancel and no chat (07.29); "Unable to load booking details." (07.29 note).
- **Appendix 1:** "Confirming..." (07.03); offline banner (07.15); Message unread dot (07.21); pushes `BOOKING_STATUS_CHANGED` "Booking update" (07.09) and `BOOKING_EXPIRING` "Booking expiring soon" / "Start charging before your window ends." (07.05); Messages tab badge "2" on every tab-bar frame.
- **Appendix 2:** foreground in-app banner with relative time "now", 6 s auto-dismiss, tap navigates (07.05, 07.09 → 07.40 / BK20); auth-loss redirect to `/login` (07.17 note). Android tray channels are out of scope (iOS build).
- **Appendix 4:** paused in no tab → fixed [BK4]; raw status in details → fixed [BK5]; no booking success screen → 04.43 hands the pass in (§4.1-2).
- **FLAG — PROPOSALS block:** BK1–BK35, plus the missing symbols `wifi.slash`, `doc.on.doc`, `arrow.counterclockwise`, plus the open question on `paused` (§8-1).

---

## Review notes

Reviewed against `BRIEF.md`, `driver-logic-map.md` §G (+ §A, §D, §E, §H, §I `NotificationsScreen`, Appendices 1–4), sibling specs 02 / 04 / 05 / 06 / 08 / 09. The draft was kept as `scratchpad/07-bookings.pre-review.md`. Changes made in this file:

**Logic coverage and real copy**
1. Restored the real "Booking information" labels **"Scheduled date"** / **"Scheduled time"** (the draft shortened them to "Date" / "Time" without a flag): §2.0 B, 07.21, 07.22, §3.2, §9. Only the value formats stay a proposal [BK22].
2. Added the logic's **pushed `/my-bookings` route** (push tap and Notifications row, `bookingId` ignored) as P2 frame **07.40** (Inline nav + back, no tab bar). §1.3 entry points now list the push, the foreground banner, the Notifications row (logic §I) and the chat system cards (09.16). BK20 rewritten against this. Section 07A is now 10 frames; totals 40 (P1 29, P2 11).
3. `BOOKING_EXPIRING` banner tap: the draft said "→ Charge tab" as if settled. Now states the logic (`/my-bookings`, 07.40) and marks the Charge tab as the 05 proposal [CH20].
4. Added Appendix 2 details (banner header "PAKPLUG" · relative time "now"), the Messages badge "9+" cap, and the accessory's real string "{mm:ss} to full · Rs X" next to the drawn "28:00 left" [02-P11].
5. 07.27 and 07.26 now say why Cancel is absent (past window / already cancelled, logic).
6. BK4 / BK5 now say exactly what changes: the list card maps paused → "Upcoming" today; the details title pill moves onto the pass.

**Invented data and consistency with sibling flows**
7. Host names aligned with 09's thread table: Model Town = **Usman** (no phone number), Gulberg = **Kamran**. 07.26 said "Message Bilal" for a Model Town booking; now "Message Usman", its Call tile opens the no-number Call sheet (as 09.31), host card "U". BK16 copy uses `{host}`.
8. BK31 line "…confirming your slot **with the host**" claimed a host step that does not exist (the optimistic state is our own API call). Now "Hang on — we're confirming your slot."
9. "Ending soon" (S4, no session) collided with 06's "Ending soon" (live session, 5 min left). S4 is now **"Expiring soon"**, echoing the real push title "Booking expiring soon" (S4, 07.05, §3.4, §4.2-3, §6, BK26). The Live pass's own last 5 minutes are now defined (§1.1, 07.04 canvas note, §4.2-5b, §8-5a): warning top edge + "5 min left", in step with the accessory's Ending state (06-P27).
10. New flags for unflagged inventions: BK32 ("Charged on…" context line), BK33 (skeleton while the read-only detail loads), BK34 (no chevron on passes, logic has one), BK35 ("EST. TOTAL" vs "TOTAL" footer label; the brief requires every estimate to be labelled).

**Brief compliance (tokens, contrast, type, brand)**
11. `sheen` contrast was wrong: the draft claimed white text keeps 4.7:1 under a 12% white band; measured it is 4.3:1 (fails). Capped at **8%** (4.6:1) for Ready, Live and Confirming (Confirming was 18%, the 07.01 still 10%). §4.0, 07.01, 07.03, §6 updated. 76% white on emerald corrected to ≈3.8:1.
12. Added a screenshot check for Status Pill tints on the emerald face, with the 05.25 fallback (bg/surface capsule), and a text-colour rule for stacked passes on the existing Completed / Cancelled faces.
13. Alert: removed "bold" for Keep booking (brief: no Bold/Semibold); use the component's weights.
14. Wallet pass preview (07.38) now uses the `Brand / Wordmark` White 994:127 instance (the new SF Pro wordmark) instead of typed "PakPlug".
15. Sheet frames: status-bar rule added (Dark unless the scrimmed top reads dark → Light 996:411). Charger-card glyph choice explained (ev.charger.fill, same as 05.35).

**Micro-interactions made concrete**
16. Added the missing timing / haptic / VoiceOver / Reduce Motion lines to §4.1-4, 4.1-5, 4.2-2, 4.2-4, 4.2-5, 4.2-6, 4.3-2, 4.3-3, 4.3-5, 4.3-6, 4.3-7, 4.4-1…4, 4.5-1/2, 4.6-1…3, 4.7-2/3/4, 4.8-1…6/8, 4.9-1/2, 4.10-1/3/5/6.
17. Aligned with 02 §4.0: Reduce Motion press = 85% dim (draft 0.8), toast enters from 12pt (draft 16pt), toast timing "6 s for two lines or any action", Neutral toast → no haptic ("Review period ended" had a warning haptic). Fixed the "6 s (logic)" misattribution in the cancel error (the logic gives no duration). Added the 150 ms spinner grace delay.

**Mobbin**
18. 5 more searches (same parameters as the brief), 16 new links, 65 unique in total. The Live pass had no direct reference: added Jomo, Chick-fil-A, Tesla, Garmin, Fiverr (§5.1). Also Mindtrip (Confirming, §5.2); Grab, Starbucks, Blue Apron, BlaBlaCar (Completed / Cancelled lists and review links, §5.3); Noom, Oura, Fly Delta (error / empty with tabs, §5.4); Fresha, Tripadvisor (pass detail, §5.5); American Airlines (blocking cancel, §5.7). Every major screen group now has ≥ 4 references.

**Still open for Hammad / Rayan (unchanged):** what `paused` means (§8-1); whether to adopt the cancel reason sheet (BK18); Apple Wallet signing (BK12); the charger short code in the booking payload (BK9).
