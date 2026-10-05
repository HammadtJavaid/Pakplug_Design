# 10 · US canon dataset (as built in the base Flow 10 frames)

Written by merge step **C1** on 2026-10-05 from every text layer (visible and hidden) and every instance TEXT property of the base frames **10.01–10.20** on page **v4 · 📱 Flow 10 · US · West Lafayette (1294:2)**, after the C1 data fixes (section 17).

**Precedence.** This file is the US source of truth. Where `specs/10-us-locale.md` (first session) or the BRIEF's "US edition dataset" block disagree with it, **this file wins** (MERGE-PLAN ground rule 2). The spec still holds the reasoning, the Region/Currency model, Mobbin refs and proposals; only its *data* is superseded.

**Tags used below.**
- **[drawn 10.xx]**: the value is on that base frame (after C1 fixes).
- **[derived]**: computed from drawn values with the canon formulas (section 6). Use exactly these numbers.
- **[assigned]**: the base never draws it, but a merge step needs it (C2 merges the alternate 10A; C3 writes docs). Chosen to fit the base mapping; flagged so Hammad can see it is new.

**One rule for re-texting** (MERGE-PLAN rule 4): apply mappings in **one simultaneous pass** (a single regex alternation, longest keys first, replacer callback). Several canon values are also *source* values in the alternate build (`$0.52`, `Jake`, `Wabash Landing …`), so chained replaces corrupt the data. Section 16 has the alternate → canon map.

---

## 0. Story in one screen

Emily Carter, West Lafayette, IN (Purdue). Primary car **Chevrolet Bolt EUV** (65 kWh, J1772 + CCS1, plate **IN 482 BKR**); second car **Tesla Model 3** (NACS, 75 kWh, **IN 731 PUR**). Story station **Boilermaker · State St**, 401 W State St, West Lafayette, IN 47906, **J1772 (AC) · 7.4 kW · $0.32/kWh**, 4.8★ (36 reviews), 0.7 mi, Available, host **Jake**.

Booking: **Today, Sat, Oct 4 · 6:00 → 7:00 PM · 1 h** · Bolt EUV · J1772 (AC) · **$2.18 est.**

Plan (92% efficiency): start **20%** (13.0 of 65 kWh) → **6.8 kWh** → **+10%** → **≈30%** · **$2.18**.

Live at 6:32 PM: **28:00 left · 3.6 kWh · ≈26% · $1.16 · 7.4 kW**.

Complete at 7:00 PM: **$2.18** · "6.8 kWh × $0.32/kWh" · ≈30% est. · 6.8 kWh · 1 h.

Story calendar: today = **Sat, Oct 4** (as in every PK flow). Note: in the real 2026 calendar Oct 4 is a Sunday. The whole file uses Saturday, so keep it.

---

## 1. Frame inventory (base, page 1294:2)

| Frame | Node | Label / Note | Status-bar clock | What it shows |
|---|---|---|---|---|
| Section 10A "Flow 10A · US · Discover & station" | 1304:2 | title 1304:3, status 1304:4 | | Logic check card **1304:195** ("Logic check · Flow 10 · US edition") |
| 10.01 · Home · Map | 1304:5 | 1304:31 / 1304:32 | 9:41 | map, 6 pins + cluster 24, chips, search capsule, tab bar Home |
| 10.02 · Home · Map · Station selected | 1304:33 | 1304:54 / 1304:55 | 9:41 | selected $0.32 pin + Station Card Map preview (1304:50) |
| 10.03 · Search · Typing · Results | 1304:56 | 1304:86 / 1304:87 | 9:41 | query **"state st"**: STATIONS 1 row, PLACES 4 rows, keyboard |
| 10.04 · Station · Sheet · Large | 1304:88 | 1304:136 / 1304:137 | 9:41 | place sheet Large (header 1304:106, Stats Row 1304:112, Connector Row 1304:116, host 1304:126/128/129, rating 1304:132) |
| 10.05 · Station · Reviews | 1304:138 | 1304:167 / 1304:168 | 9:41 | Rating Summary 1304:157 + 4 Review Rows 1304:158–161 |
| 10.06 · Home · List | 1304:169 | 1304:193 / 1304:194 | 9:41 | 4 Station Card List 1304:172–175 |
| Section 10B "Flow 10B · US · Book, charge & complete" | 1304:215 | title 1304:216, status 1304:217 | | no Logic card yet (C3) |
| 10.07 · Book a slot · Ready | 1304:218 | 1304:330 / 1304:331 | 9:41 | Book a slot sheet (readout 1304:237, compact 1304:324, vehicle row 1304:322, Cost Footer 1304:328) |
| 10.08 · Confirm booking | 1304:332 | 1304:469 / 1304:470 | 9:41 | Book sheet behind + detached Confirm sheet |
| 10.09 · Charge · Ready to start | 1304:471 | 1304:494 / 1304:495 | **5:50** | Next Booking Card 1304:473 + Start charging shortcuts |
| 10.10 · Planner · By time | 1304:496 | 1304:521 / 1304:522 | **6:00** | hero ≈30% (1304:500), Charge Plan Bar 1304:501, Estimate Card 1304:515 |
| 10.11 · Live · Charging | 1304:523 | 1304:586 / 1304:587 | **6:32** | gauge ≈26%, tiles, Session Progress, overline 1304:578 |
| 10.12 · Complete · Summary | 1304:588 | 1304:615 / 1304:616 | 9:41 (same as PK 06.30, see 15) | Session Summary Card, rate prompt |
| Section 10C "Flow 10C · US · Bookings, messages & profile" | 1304:617 | title 1304:618, status 1304:619 | | no Logic card yet (C3) |
| 10.13 · Bookings · Ready to start | 1304:620 | 1304:634 / 1304:635 | **5:50** | pass P-A Ready 1304:623 + P-B 1304:627 + P-C 1304:628 |
| 10.14 · Pass · Upcoming | 1304:636 | 1304:704 / 1304:705 | **3:35** | list behind (1304:640/642/643) + Booking details sheet (pass 1304:653, header 1304:700) |
| 10.15 · Lock Screen · Charging | 1304:706 | 1304:709 / 1304:710 | lock clock **6:32** | Lock Screen + Live Activity 1304:708 |
| 10.16 · Messages · Inbox | 1304:711 | 1304:731 / 1304:732 | 9:41 | 6 thread rows 1304:720–725 |
| 10.17 · Profile · Default | 1304:733 | 1304:755 / 1304:756 | 9:41 | Profile Header Card 1304:736 + rows |
| 10.18 · My vehicles · Default | 1304:757 | 1304:768 / 1304:769 | 9:41 | Vehicle Cards 1304:761 (Bolt), 1304:762 (Tesla) |
| 10.19 · Region & currency · United States | 1304:770 | 1304:798 / 1304:799 | **7:05** | REGION / SHOW PRICES IN / EXAMPLE / DISTANCE + Toast |
| 10.20 · Station · Prices in Rs (quick toggle) | 1304:964 | 1304:1012 / 1304:1013 | 9:41 | **the deliberate Rs view**: pins and sheet in ≈ Rs |

Layer names in all 20 frames now use US names (C1 renamed 76 PK-named layers (45 in 10A, 13 in 10B, 18 in 10C), e.g. "Map Pin · Boilermaker · State St · $0.32 (selected)", "Station Card · List · Wabash Landing Garage", "Thread · Marcus Lee", "Vehicle Card · Chevrolet Bolt EUV · Primary"). In 10.20 the pin layers are named by their Rs value ("Map Pin · Boilermaker · State St · Rs 90 (selected)").

---

## 2. People

### 2.1 Driver
| Field | Value | Source |
|---|---|---|
| Name | **Emily Carter** | [drawn 10.17] |
| Email | **emily.carter@email.com** | [drawn 10.17] |
| Phone | **(765) 555-0142** (Verified) | [assigned] not drawn in the base; same number as 10-us-locale |
| City | West Lafayette, IN | [drawn 10.01 note, 10.19] |
| Avatar | **"EC"**, Avatar XL **Mesh** (driver's own) | [drawn 10.17] |
| Profile stats | SESSIONS **12** · CHARGED **—** · SAVED **3** | [drawn 10.17] |
| Identity row | "Identity & verification" + Status Pill "Verified"; hidden subtitle **"Driver’s license checked"** (PK: "CNIC checked") | [drawn 10.17] |
| My vehicles row subtitle | "Chevrolet Bolt EUV · Primary" | [drawn 10.17] |
| Other profile rows | Saved chargers · Wallet & earnings "Coming soon" · Notifications badge "2" · Settings · Help & support · Sign out · "PakPlug 1.0.0 (1)" · segmented "Driver mode" / "Host mode" | [drawn 10.17] |

### 2.2 Hosts and inbox (10.16, top to bottom)
| Thread | Avatar (L Tint) | Time | Preview | Pills | Station (meta row) | Role |
|---|---|---|---|---|---|---|
| **Jake** | "J" | now | "The cable is on the hook by the gate." | Live "Charging now" | Boilermaker · State St | host of S1 (story). Full name on Flow 11: **Jake Morrison** |
| **Marcus Lee** | "ML" | 12m | "See you tomorrow. Gate opens at 8:45." | Info "Tomorrow 9:00 AM" (= pass P-B) | Chauncey Hill Home Charger | host of S3 |
| **Olivia Brooks** | "OB" | 2h | "Is the charger available this evening?" | "Mon 6:00 PM" + Neutral "New inquiry" | Research Park DC Hub | host of S4 |
| **Ryan Miller** | "RM" | Yesterday | "Thanks for charging with us!" | — (Meta off) | hidden prop "Wabash Landing Garage" | host of S2 **[assigned]** |
| **Hannah Kim** | "HK" | Mon | "No messages yet" | — | none (hidden prop "") | host of a charger outside the drawn map |
| **Tyler Nguyen** | "TN" | 9/12/26 | "Sure, any time after 5." | — | none (hidden prop "") | host of a charger outside the drawn map |

Inbox filter pills: **All 6 · Unread 2 · Inquiries 1 · Upcoming 2**. Nav title "Messages".

Host avatar in station sheets and the pass detail: Avatar M Tint **"J"**, name **"Jake"**, role **"Charger host"** [drawn 10.04, 10.14, 10.20].

Phones (none drawn) [assigned]:
- Jake (765) 555-0187 (the Call tile is live on S1).
- Marcus Lee: no phone number (home charger; the PK Usman pattern, so Call opens the no-number sheet).
- Olivia Brooks (765) 555-0163.
- Ryan Miller (765) 555-0129.
- Support hotline (765) 555-0100.

Write numbers with a non-breaking space inside body copy, so a number never splits across lines.

### 2.3 Reviewers (S1 Boilermaker · State St, newest first) [drawn 10.05]
| # | Name | Avatar (M Tint) | Date | Stars (Display) | Body |
|---|---|---|---|---|---|
| 1 | **Megan S.** | "MS" | September 28, 2026 | 5 | "Easy to find on State St, and the 7 kW charger was ready when I arrived." |
| 2 | **Derek P.** | "DP" | September 21, 2026 | 5 | "Fast and the host was very helpful. The cable reaches both sides of the car." |
| 3 | **Driver** (anonymous) | "D" initials as built (component rule says Glyph M 1109:1532, see 15) | September 9, 2026 | 5 | none (Body=No) |
| 4 | **Ashley W.** | "AW" | August 30, 2026 | 5 | "Gate was locked at first but Jake opened it within a few minutes." |

Summary: **4.8** · "Based on 36 reviews" · bars 5★ 30 · 4★ 5 · 3★ 1 · 2★ 0 · 1★ 0 (= 4.81). Sheet header "Reviews".

---

## 3. Vehicles [drawn 10.18, 10.07, 10.09, 10.13]

| | Name | Specs (subtitle) | Battery | Plugs | Plate | Notes |
|---|---|---|---|---|---|---|
| 1 · Primary | **Chevrolet Bolt EUV** | **J1772, CCS1 · 65 kWh** | 65 kWh | J1772 (AC) + CCS1 (DC) | **IN 482 BKR** | Primary pill. Used on every booking (P-A, P-B, P-C) |
| 2 | **Tesla Model 3** | **NACS · 75 kWh** | 75 kWh | NACS | **IN 731 PUR** | Note under 10.18: "Bolt EUV primary; Model 3 shows NACS." **Fits none of the four drawn stations** (all are J1772 or CCS1). Never put it on a J1772/CCS1 booking |
| 3 (optional) | Nissan Leaf | J1772, CHAdeMO · 40 kWh | 40 kWh | J1772 + CHAdeMO | IN 215 LEF | [assigned]. Named only in the base logic card; use only if a frame needs a third car |

How each slot writes the car:
- Booking VEHICLE row (Vehicle Card Row Selected): Name **"Chevrolet Bolt EUV · J1772 (AC)"**, Specs **"Primary"**, action "Change"; hidden Plate prop "IN 482 BKR".
- Next Booking Card meta: **"1 h · Chevrolet Bolt EUV"**.
- Charge-tab shortcut: **"Chevrolet Bolt EUV"** / **"Your vehicle · J1772, CCS1 · 65 kWh"**.
- Pass footer: VEHICLE **"Chevrolet Bolt EUV"** · CONNECTOR **"J1772 (AC)"**. Stacked meta: **"Chevrolet Bolt EUV · J1772 (AC)"** / **"Chevrolet Bolt EUV · CCS1 (DC)"**.
- My vehicles footnote: "Your primary vehicle powers connector matching and Recommended stations." Button "Add vehicle".

---

## 4. Stations

| | **S1 · story** | **S2** | **S3** | **S4** |
|---|---|---|---|---|
| Name | **Boilermaker · State St** | **Wabash Landing Garage** | **Chauncey Hill Home Charger** | **Research Park DC Hub** |
| PK analog | GreenVolt · DHA Phase 5 | Gulberg Galleria Charger | Model Town Home Charger | Johar Town Fast Hub |
| Address | **401 W State St, West Lafayette, IN 47906** [drawn 10.02/10.04/10.14] | Brown St, West Lafayette, IN 47906 [assigned] | Chauncey Hill, West Lafayette, IN 47906 [assigned; home charger = area only] | Win Hentschel Blvd, West Lafayette, IN 47906 [assigned; Purdue Research Park] |
| List location line | "J1772 (AC) · West Lafayette" [drawn 10.06] | "CCS1 (DC) · West Lafayette" [drawn] | "J1772 (AC) · West Lafayette" [drawn] | "CCS1 (DC) · West Lafayette" [drawn] |
| Plug | **J1772 (AC)** | **CCS1 (DC)** | **J1772 (AC)** | **CCS1 (DC)** |
| Power | **7.4 kW** [drawn 10.02/10.04/10.07/10.11/10.14] | **60 kW** [derived: PK analog + P-C maths] | **11 kW** [derived: P-B $4.40 = 11 kW × 1.5 h × 0.92 × $0.29] | **30 kW** [assigned: PK analog] |
| Price | **$0.32/kWh** | **$0.52/kWh** | **$0.29/kWh** | **$0.42/kWh** |
| Rating · reviews | **4.8 · 36 reviews** | 4.6 · 21 reviews (count [assigned] = PK) | 4.9 · 9 reviews (count [assigned]) | 4.4 · 12 reviews (count [assigned] = PK) |
| Distance | **0.7 mi** | **2.1 mi** | **3.2 mi** | **4.8 mi** |
| Status | **Available** | **In use** | **Available** | **Offline** |
| Host | **Jake** | Ryan Miller [assigned] | **Marcus Lee** [drawn 10.16] | **Olivia Brooks** [drawn 10.16] |
| Map pin | Available "$0.32" (Available selected when chosen) | In use "$0.52" | Available "$0.29" | Unavailable "$0.42" |
| Connector Row | "J1772 (AC)" · "7.4 kW · Available" · "$0.32" "/kWh" [drawn 10.04] | "CCS1 (DC)" · "60 kW · In use" · "$0.52" "/kWh" | "J1772 (AC)" · "11 kW · Available" · "$0.29" "/kWh" | "CCS1 (DC)" · "30 kW · Offline" · "$0.42" "/kWh" |
| Rs view (10.20 only) | pin "Rs 90", sheet "≈ Rs 90" | pin "Rs 146" | pin "Rs 81" | pin "Rs 118" |

Other values:
- **Fillers**: pins **"$0.30"** and **"$0.34"** (Available); in the Rs view "Rs 84" and "Rs 95". Map Cluster **"24"**.
- **Pin layers in every map frame**: Chauncey Hill $0.29 · Wabash Landing Garage $0.52 (In use) · Boilermaker $0.32 · filler $0.30 · Research Park $0.42 (Unavailable) · filler $0.34.
- **List** (10.06): header "4 stations · Nearest first", in the order S1 → S2 → S3 → S4.
- **S1 sheet** (10.04/10.20):
  - Quick actions: Book now · Directions · Call · Save.
  - Stats Row: Status "Available" · "36 reviews" "4.8" · Distance "0.7 mi" · Per kWh "$0.32".
  - CONNECTORS "1" · PHOTOS · HOST · REVIEWS ("See all", 4.8, "Based on 36 reviews").
- **S1 booking facts** (10.14 pass detail):
  - Hidden header subtitle: "Private charger · 401 W State St, West Lafayette, IN 47906".
  - Connector line: "J1772 (AC) · 7.4 kW" + "View charger".
  - ACCESS NOTES: "Gate code 4471. Park in the left bay — the charger is on the garage wall."
- **S1 availability today** (10.07):
  - Peak "Peak 5 PM–9 PM". Windows "5 PM – 8 PM · 3h" (selected) and "9 PM – 11 PM · 2h". "Longest here: 3h".
  - Start grid 5:00 → 7:45 PM, with 6:00 PM selected and 7:15 / 7:30 / 7:45 PM Unavailable.
  - Date strip: Today 4 (selected) · Sun 5 · Mon 6 · Tue 7 · Wed 8 · Thu 9 · Fri 10.
- **S1 charger code**: **BS7-K32** [assigned; PK GV7-K42 pattern; not drawn].
- **NACS**: no drawn station offers NACS. The "NACS" chip filters to an empty result; the Tesla fits nowhere. If a frame needs a NACS station, FLAG it as a proposal; don't add NACS to S1–S4 silently.
- **State demos on S1** (not drawn; for C2's every-station board) [assigned]:
  - Maintenance.
  - Paused, with the real copy "This station is currently paused and not accepting new bookings"; Book now disabled.
  - Hourly "**$2.29**" "/hr" (Rs 300/hr × 0.32/42; a 1 h booking = $2.29).
  - No price: "Pricing unavailable".

---

## 5. Search (10.03, plus values C2 needs for the merged search frames)

**10.03, as built after C1** (query = **"state st"**, keyboard return "search", placeholder elsewhere "Search chargers"):

| Section | Title (match highlight) | Subtitle | Distance |
|---|---|---|---|
| STATIONS | Boilermaker · **State St** (Body + Headline on "State St") | 401 W State St, West Lafayette, IN 47906 | 0.7 mi |
| PLACES | **State St** | West Lafayette, IN, USA | 0.9 mi |
| | **State St** & N Grant St | West Lafayette, IN, USA | 0.5 mi |
| | **State St** & Chauncey Ave | West Lafayette, IN, USA | 1.0 mi |
| | W **State St** (mid-string match) | West Lafayette, IN, USA | 1.2 mi |

- "Powered by Google" attribution sits under PLACES.
- Note under 10.03: "Places come from Google Places with US bias; stations match by name, street or plug (try "NACS")."
- Highlight rule (Flow 3): set the whole title to Body, then the matched substring to Headline; a subtitle-only match uses Footnote Emph.
- **Search place subtitle format: "West Lafayette, IN, USA"** (Google secondary text). Station subtitles use the full address.

For C2's merged search frames [assigned, consistent with the above]:
- **10.24 · Search · Typing · Results for "purdue"** (from alternate 10.07). No station name or address contains "purdue", so the STATIONS section is hidden. PLACES, with "Purdue" in Headline:

  | Place | Subtitle | Distance |
  |---|---|---|
  | **Purdue** University | West Lafayette, IN, USA | 0.4 mi |
  | **Purdue** Memorial Union | N Grant St, West Lafayette, IN, USA | 0.5 mi |
  | **Purdue** University Airport | West Lafayette, IN, USA | 2.3 mi |
  | **Purdue** Research Park | West Lafayette, IN, USA | **4.6 mi** (alternate said 3.1; S4 sits in the park at 4.8 mi) |

- **10.23 · Search · Focused · Recents** (from alternate 10.06):
  - RECENT:
    - Boilermaker · State St (station) · "401 W State St, West Lafayette, IN 47906"
    - Purdue Memorial Union (place) · "N Grant St, West Lafayette, IN"
    - Wabash Landing (place) · "West Lafayette, IN"
  - Saved chargers "3 saved".
  - NEARBY:
    - Wabash Landing Garage · "Brown St, West Lafayette, IN 47906" · 2.1 mi
    - Chauncey Hill Home Charger · "Chauncey Hill, West Lafayette, IN 47906" · 3.2 mi
    - Research Park DC Hub · "Win Hentschel Blvd, West Lafayette, IN 47906" · 4.8 mi
  - Sheet chips: Available now · J1772 (AC) · CCS (DC) · NACS.
- **10.25 · Search → Place · Purdue University** (from alternate 10.09):
  - Map Marker / Place label "Purdue University"; search field "Purdue University".
  - Pins: Available "$0.32" (S1), "$0.30" (filler), In use "$0.52" (S2).
  - Pill "3 stations nearby".

---

## 6. Prices, formulas and the two "rates"

1. **Native US prices.** Hosts set prices in USD. A US price is never converted and never carries "≈". Money is always **kWh × the displayed $/kWh**, rounded half-up to the cent: $2.18, $4.40, $14.35.
2. **How the base made the US price list** (a *price level*, **not** an exchange rate): **$ = Rs × 0.32 ÷ 42**, rounded to the cent. Use it for any PK pin or price that needs a US twin, e.g. the split cluster pins on 10.21:

   | Rs → $ | | | | | |
   |---|---|---|---|---|---|
   | Rs 30 → $0.23 | Rs 32 → $0.24 | Rs 34 → $0.26 | Rs 35 → $0.27 | Rs 36 → $0.27 | Rs 38 → $0.29 |
   | Rs 39 → $0.30 | Rs 40 → $0.30 | Rs 41 → $0.31 | Rs 42 → $0.32 | Rs 43 → $0.33 | Rs 44 → $0.34 |
   | Rs 45 → $0.34 | Rs 46 → $0.35 | Rs 47 → $0.36 | Rs 48 → $0.37 | Rs 50 → $0.38 | Rs 52 → $0.40 |
   | Rs 55 → $0.42 | Rs 58 → $0.44 | Rs 60 → $0.46 | Rs 65 → $0.50 | Rs 68 → $0.52 | Rs 70 → $0.53 |
   | Rs 75 → $0.57 | Rs 300/hr → $2.29/hr | | | | |

   (The alternate build used "$ = (Rs N − 10) ÷ 100". **Don't use it.**)
3. **Display conversion** (FX, dummy): **Rs 280 = $1**. It is used only when the driver flips the currency:
   - US → Rs (10.20): "≈ Rs 90" in the sheet; pins "Rs 90" without "≈".
   - PK → $ (08.11): "≈ $0.15", "≈ $1.02".

   Round converted values to whole rupees and to cents. Format: **"≈ " with a space**, then the amount.
4. **Distance.** mi = km × 0.621371, 1 decimal (1.2 km → 0.7 mi, 3.4 → 2.1, 5.1 → 3.2, 7.8 → 4.8).
5. **Charging maths** (92% efficiency, the planner footnote's formula):
   - kWh = kW × hours × 0.92, capped by (target% − start%) × battery kWh
   - % added = kWh ÷ battery kWh
   - cost = kWh × $/kWh
   - finish = start + needed kWh ÷ (kW × 0.92), never later than the slot end
6. **Live rounding.** kWh floors to 0.1; dollars floor to the cent; ≈% rounds to the nearest 1%. The billed amount wins at the end (live $2.17 → billed $2.18).

Verified with `scratchpad/c1/canon_math.py` (Decimal, half-up).

---

## 7. Booking story

| Field | Value | Source |
|---|---|---|
| When | **Today, Sat, Oct 4 · 6:00 → 7:00 PM · 1 h** | [drawn 10.07/10.13] |
| Readout (Large) | eyebrow **"TODAY · SAT, OCT 4"** · START "6:00 PM" · END "7:00 PM" · pill "1 h" | [drawn 10.07/10.08] |
| Readout (Compact) | "6:00 → 7:00 PM" · "Today · 1 h" | [drawn 10.07] |
| Station row | "Boilermaker · State St" / "401 W State St, West Lafayette, IN 47906 · J1772 (AC) · 7.4 kW" / value "$0.32/kWh" | [drawn 10.07] |
| Duration chips | 15 min · 30 min · 45 min · **1 h** (selected) · 1.5 h | [drawn 10.07] |
| Cost Footer | **"$2.18"** · "Ends 7:00 PM" · "Confirm booking" | [drawn 10.07] |
| Confirm sheet | "Confirm booking" / "Review your charging slot before you book." · Date **"Oct 4, 2026"** · Time **"6:00 – 7:00 PM"** · Duration **"1 hour"** · Total **"$2.18"** · "Estimate. The charger's meter decides the final amount." · "Confirm booking" · "Back" | [drawn 10.08] |
| Cost per duration | 15 min **$0.54** · 30 min **$1.09** · 45 min **$1.63** · 1 h **$2.18** · 1.5 h **$3.27** | [derived] |
| Booked at | 3:40 PM (PK pattern), "You can start from 5:45 PM" | [drawn 10.14] / PK |

Note under 10.07: "1 h at 6.8 kWh ≈ $2.18."

---

## 8. Charge tab and planner

**Charge tab (10.09, 5:50 PM)**:
- Next Booking Card Ready: "Ready to start" · "Starts in 10 min" · "Boilermaker · State St" · "6:00 → 7:00 PM" · "1 h · Chevrolet Bolt EUV" (Note prop "You can start from 5:45 PM").
- Header "Start charging" / "Scan a charger’s QR code to begin a session.".
- Scan card "Scan to charge" / "Point your camera at the QR on the charger." / "Scan QR code".
- Rows:
  - "Enter charger ID" / "Type the code shown on the charger"
  - "Find a charger" / "Browse chargers on the map"
  - "Chevrolet Bolt EUV" / "Your vehicle · J1772, CCS1 · 65 kWh"

**Planner · By time (10.10, 6:00 PM)**, as built:
- Nav "Start charging". Hero caption "Battery at 7:00 PM", value **"≈30%"**.
- Charge Plan Bar "20% now" / **"+10% est."**.
- Header "Start charging session?". Station row "Boilermaker · State St" / "J1772 (AC) · 7.4 kW · $0.32 / kWh".
- Segmented "Time" | "Target %". Chips 15 min · 30 min · 45 min · **Until 7:00 PM**.
- Estimate Card: ENERGY **6.8** kWh · COST **$2.18** · FINISHES **7:00** PM.
- Footnote "Estimate. The charger’s meter decides the final amount." + "Charging stops on its own when your slot ends at 7:00 PM.". Slide "Slide to start charging".

Planner table (Bolt EUV 65 kWh, start 20% = 13.0 kWh, S1 7.4 kW → 6.808 kWh/h, $0.32) [derived; the 1 h row is drawn]:

| Plan | Energy | % added | Battery at end | Cost | Finishes |
|---|---|---|---|---|---|
| 15 min | 1.7 kWh | +3% | ≈23% | $0.54 | 6:15 PM |
| 30 min | 3.4 kWh | +5% | ≈25% | $1.09 | 6:30 PM |
| 45 min | 5.1 kWh | +8% | ≈28% | $1.63 | 6:45 PM |
| **Until 7:00 PM (1 h)** | **6.8 kWh** | **+10%** | **≈30%** | **$2.18** | **7:00 PM** |
| Target 30% | 6.5 kWh | +10% | ≈30% | $2.08 | ≈6:57 PM |
| Target 80% (slot ends first) | 6.8 kWh (39.0 needed) | +10% | ≈30% | $2.18 | 7:00 PM. Warning: "80% would take about 5 h 44 min. Your slot ends first." |
| Tesla Model 3 on S1 | doesn't fit J1772 (AC) | | | | |
| **DC · S2 Wabash Landing Garage 60 kW · target 80%** | **39.0 kWh** | +60% | **≈80%** | **$20.28** | **≈6:42 PM** (42.4 min) |
| DC · S2 · 30 min | 27.6 kWh | +42% | ≈62% | $14.35 | 6:30 PM |

FLAG for the DC rows: the Bolt EUV peaks at ≈55 kW DC, so a 60 kW charger delivers a little less than this dummy maths (the US-P11 analog).

---

## 9. Live and Lock Screen

**Live (10.11, 6:32 PM)**, as built:
- Overline **"CHARGING · BOILERMAKER · STATE ST"**.
- Gauge "≈" + **"26%"** + "est. battery".
- Hero Stat "Left in your slot" **"28:00"** · "Ends 7:00 PM".
- Tiles: ENERGY **3.6** kWh · SO FAR **$1.16** · POWER **7.4** kW, with "Estimate. The charger’s meter decides the final amount.".
- Session Progress: "Plan · until 7:00 PM" / **"≈30% · $2.18 est."**; "Plugged in 6:00 PM" · "Now 6:32 PM" · "Slot ends 7:00 PM".
- Tip "Stopping under 80% helps your battery last longer.". Button "Stop charging".

**Lock Screen (10.15)**:
- Date **"Saturday, October 4"**, clock **"6:32"**.
- Live Activity · Charging: Station "Boilermaker · State St" · Window "6:00 – 7:00 PM" · Battery "≈26%" + "est. battery" · Time "28:00" + "left" · Meta **"$1.16 so far · 3.6 kWh"**.
- Unused props (set by C1): Energy "+3.6 kWh" · Total "$2.18" · Summary "6.8 kWh · ≈30% est. · 1 h 00 min".

Live timeline [derived; 6:32 drawn]:

| Clock | Elapsed | Left | kWh | ≈ battery | $ so far |
|---|---|---|---|---|---|
| 6:00:08 PM | 0:08 | 59:52 | 0.0 | ≈20% | $0.00 |
| 6:30 PM | 30 min | 30:00 | 3.4 | ≈25% | $1.08 |
| **6:32 PM** | 32 min | **28:00** | **3.6** | **≈26%** | **$1.16** |
| 6:44 PM | 44 min | 16:00 | 4.9 | ≈28% | $1.59 |
| **6:55 PM (Ending soon)** | 55 min | **5:00** | **6.2** | **≈30%** | **$1.99** |
| 7:00 PM | 60 min | 0:00 | 6.8 | ≈30% | $2.17 live → **$2.18 billed** |

Other live surfaces [derived]:
- Tab Bar Accessory: 6:32 "Charging · ≈26%" / "28:00 left · $1.16"; 6:55 "Charging · ≈30%" / "5:00 left · $1.99".
- Live Activity Ending: Battery "≈30%", Time "5:00", Meta "$1.99 so far · 6.2 kWh".
- Dynamic Island: Battery "≈26%" · Time "28:00" · Station "Boilermaker · State St" · Start "6:00 PM" · End "7:00 PM" · Meta "$1.16 so far · 3.6 kWh · 7.4 kW" · Total "$2.18" · Summary "6.8 kWh · ≈30% est. · Tap for your receipt".

---

## 10. Complete and receipt

**Complete (10.12)**, as built:
- Title "Charging complete" / "Your vehicle is ready to go".
- Session Summary Card: Total **"$2.18"**, detail **"6.8 kWh × $0.32/kWh"** (= $2.176, which multiplies out to $2.18, so no 2-decimal kWh line is needed).
- Tiles: Battery **"≈30%"** "est." · Energy **"6.8"** "kWh" · Time **"1"** "h".
- Place row **"Boilermaker · State St · 6:00 – 7:00 PM"**.
- Rate prompt "How was your session?" / "Your rating helps the next driver.". Buttons "Done", "Download receipt". Note under the frame: "Receipt in $."

**Receipt** [assigned; PK 06.36 rows, native USD]:
- Station Boilermaker · State St
- Address 401 W State St, West Lafayette, IN 47906
- Date Oct 4, 2026
- Time 6:00 – 7:00 PM
- Duration 1 hour
- Connector J1772 (AC) · 7.4 kW
- Rate $0.32/kWh
- Vehicle Chevrolet Bolt EUV · IN 482 BKR
- Transaction ID **PP-US-2410-0731**

Receipt tiles: Battery ≈30% est. · Energy 6.8 kWh · Total $2.18.

Host payout on Flow 11: $2.18 − PakPlug fee 15% ($0.33) = **$1.85**.

---

## 11. Bookings (10.13, 10.14)

| Pass | Station | When | Vehicle · connector | Amount | Status / countdown |
|---|---|---|---|---|---|
| **P-A** (story, front) | Boilermaker · State St | Date **"TODAY · SAT, OCT 4"** · 6:00 PM → 7:00 PM · "1 h" (stacked: "Today, 6:00 PM · 1 h") | Chevrolet Bolt EUV · J1772 (AC) | EST. TOTAL **$2.18** | 10.13 (5:50): Ready "Ready to start", "Starts in 10 min", "Scan to start", "You can start now. Your slot ends at 7:00 PM." · 10.14 (3:35): Upcoming, "Starts in 2 h 25 min", "You can start from 5:45 PM" |
| **P-B** (stacked) | Chauncey Hill Home Charger | **"Tomorrow, 9:00 AM · 1 h 30 min"** (front date "TOMORROW · SUN, OCT 5", 9:00 AM → 10:30 AM) | Chevrolet Bolt EUV · J1772 (AC) | **$4.40** | Upcoming |
| **P-C** (stacked) | Wabash Landing Garage | **"Wed, Oct 8, 7:30 PM · 30 min"** (front date "WED, OCT 8", 7:30 PM → 8:00 PM) | **Chevrolet Bolt EUV · CCS1 (DC)** | **$14.35** | Upcoming |

Bookings chrome: nav "Bookings", segmented "Upcoming · Completed · Cancelled", header "LATER".

**Booking details sheet (10.14)**:
- Title "Booking details"; hidden subtitle "Private charger · 401 W State St, West Lafayette, IN 47906".
- Pass Upcoming. Quick actions Directions · Message · Call.
- Station row and "J1772 (AC) · 7.4 kW" "View charger".
- BOOKING INFORMATION: Scheduled date "Oct 4, 2026" · Scheduled time "6:00 – 7:00 PM" · Duration "1 hour" · Total cost "$2.18" + estimate note.
- ACCESS NOTES (above). HOST "J" Jake "Charger host". Apple badge "Add to" / "Apple Wallet". "Cancel booking".

Maths:
- P-B = 11 kW × 1.5 h × 0.92 = 15.18 kWh × $0.29 = $4.40.
- P-C = 60 kW × 0.5 h × 0.92 = 27.6 kWh × $0.52 = $14.35.

**Cancelled list** [assigned; PK 07.08 pattern, not drawn]:

| # | Station | When | Vehicle | Pill |
|---|---|---|---|---|
| 1 | Boilermaker · State St | Thu, Oct 2, 8:00 PM · 1 h | Chevrolet Bolt EUV · J1772 (AC) | Neutral "Cancelled by you" |
| 2 | Chauncey Hill Home Charger | Mon, Sep 29, 9:00 AM · 1 h 30 min | Chevrolet Bolt EUV · J1772 (AC) | Error "Cancelled by host" (Marcus Lee) |
| 3 | Wabash Landing Garage | Sat, Sep 27, 7:30 PM · 30 min | Chevrolet Bolt EUV · CCS1 (DC) | Warning "Expired": "No session started · Chevrolet Bolt EUV" |
| 4 | Research Park DC Hub | Sun, Sep 14, 5:00 PM · 45 min | Chevrolet Bolt EUV · CCS1 (DC) | Neutral "Cancelled" |

---

## 12. Region & currency copy

**10.19 · Region & currency · United States** (7:05 PM, Mesh Quiet, nav "Region & currency"), verbatim:

- **REGION** (Select rows):
  - "Pakistan" / "Lahore, Karachi, Islamabad" (not selected)
  - "United States" / "West Lafayette, IN · pilot" (**selected**)
- **SHOW PRICES IN**:
  - "Pakistani rupee · Rs" / "Converted estimate, marked ≈" (not selected)
  - "US dollar · $" / "Exactly as hosts set them" (**selected**)
- Inline Notice Info: **"US hosts set prices in $ and you pay in $. Rupee prices are estimates at Rs 280 = $1 (dummy rate)."**
- **EXAMPLE**:
  - "Boilermaker · State St" / "Per kWh" / "$0.32"
  - "1 h booking" / "6:00 → 7:00 PM" / "$2.18"
- **DISTANCE**: "Kilometres · km" (not selected) / "Miles · mi" (**selected**)
- Toast Success: **"Region set to United States · $ · mi"** (Undo hidden)
- Note: "United States selected: $ is the billing currency, miles by default. Rs is offered as an estimate (≈) for visitors."

**10.20 · Station · Prices in Rs (quick toggle)**, verbatim. This is the only deliberate Rs view on US data:
- Pins: Rs 81 · Rs 146 (In use) · Rs 84 · Rs 118 (Unavailable) · Rs 95 · **Rs 90** (selected).
- Sheet "Boilermaker · State St" / "401 W State St, West Lafayette, IN 47906".
- Stats: Per kWh **"≈ Rs 90"**.
- "Show prices in" + Segmented **"Rs" | "$"** (Rs selected).
- Connector Row "J1772 (AC)" · "7.4 kW · Available" · "≈ Rs 90" "/kWh". Host Jake, 4.8 / "Based on 36 reviews".
- Note: "A Pakistani visitor flips to Rs: sheet shows ≈ Rs, pins show Rs without ≈. Same toggle and setting as 04.18 / 08.10."

**Pakistan-side twins (base 8E, page 1089:8872), for reference**:
- **08.10 · Region & currency · PKR**:
  - "Pakistan" selected · "Pakistani rupee · Rs" / "Exactly as hosts set them" selected · "US dollar · $" / "Converted estimate, marked ≈".
  - Notice "Hosts set prices in Rs and you pay in Rs. Dollar prices are estimates at Rs 280 = $1 (dummy rate, updated daily)."
  - EXAMPLE "GreenVolt · DHA Phase 5" Rs 42 / "1 h booking" Rs 286. DISTANCE km selected.
- **08.11 · … · USD**:
  - US dollar selected; EXAMPLE "≈ $0.15" / "≈ $1.02".
  - Toast "Prices now show in US dollars (≈)".
- **08.09 Account & settings**:
  - Group "REGION & CURRENCY", row "Region & currency" / "Pakistan · prices in Rs · km" / value "PKR".
  - US twin, for any US Account & settings frame [derived]: **"United States · prices in $ · mi"** / **"USD"**.

---

## 13. Formats (as built)

| Thing | Format | Examples |
|---|---|---|
| Money (native USD) | `$` + 2 decimals, no space | $0.32 · $2.18 · $4.40 · $14.35 · $1.16 |
| Rate | split on pins, cards and connector rows: "$0.32" + "/kWh" · inline: "$0.32/kWh" · planner/logic row: "$0.32 / kWh" | |
| Converted | "≈ " + amount (space) | ≈ Rs 90 · ≈ $0.15. Map pins drop the ≈ ("Rs 90") |
| Estimates | "≈" + number, no space | ≈26% · ≈30% · "≈30% · $2.18 est." · "+10% est." · "est. battery" |
| Energy / power | 1 decimal kWh; kW as rated | 6.8 kWh · 3.6 kWh · 7.4 kW · 60 kW · 11 kW · 30 kW |
| Distance | miles, 1 decimal | 0.7 mi · 2.1 mi · 3.2 mi · 4.8 mi · "4.8 · 0.7 mi" |
| Pass / readout eyebrow | CAPS, comma before month | **TODAY · SAT, OCT 4** · TOMORROW · SUN, OCT 5 · WED, OCT 8 |
| List / pass schedule | Day, Mon d, h:mm AM/PM · duration | "Tomorrow, 9:00 AM · 1 h 30 min" · "Wed, Oct 8, 7:30 PM · 30 min" · "Today, 6:00 PM · 1 h" |
| Detail date | Mon d, yyyy | Oct 4, 2026 |
| Review date | Month d, yyyy | September 28, 2026 |
| Lock Screen date | Weekday, Month d | Saturday, October 4 |
| Inbox older date | M/D/YY | 9/12/26 |
| Time | 12-hour, no leading zero | 6:00 PM · "6:00 → 7:00 PM" (readouts, passes) · "6:00 – 7:00 PM" (detail rows, Live Activity) · "Peak 5 PM–9 PM" · "5 PM – 8 PM · 3h" |
| Durations | | 1 h · 1 hour (confirm, booking info) · 1 h 30 min · 30 min · 28:00 (countdown) · "Longest here: 3h" |
| Phone | (765) 555-0142 | not drawn in the base |
| Plate | "IN 482 BKR" (state, 3 digits, 3 letters) | IN 731 PUR |
| Address | street, city, state ZIP | 401 W State St, West Lafayette, IN 47906 |
| Search place subtitle | City, ST, USA | West Lafayette, IN, USA |
| List-card location line | {plug} · {city} | J1772 (AC) · West Lafayette |

---

## 14. Plugs, chips and icons

- **Station / connector labels**: "J1772 (AC)" · "CCS1 (DC)" (and "NACS" if ever needed).
- **Vehicle specs**: tile names joined with ", ": "J1772, CCS1 · 65 kWh" · "NACS · 75 kWh".
- **Map / sheet chips and Filter & sort options**: **Filters · Available now · J1772 (AC) · CCS (DC) · NACS** [drawn 10.01/10.03/10.06]. Chips name the plug *family*, so "CCS (DC)" stays; it mirrors the PK chip "CCS (DC)" against PK station rows that say "CCS2 (DC)". Filter & sort "Connector type": All · J1772 (AC) · CCS (DC) · NACS.
- **Glyph stand-ins** (FLAG, already on base logic card 1304:195): Connector Row and Tile still use the Type 2 / CCS2 glyphs.
  - J1772 → ev.plug.ac.type.2 981:294 (wanted ev.plug.ac.type.1)
  - CCS1 → ev.plug.dc.ccs2 1024:482 (wanted ev.plug.dc.ccs1)
  - NACS → ev.charger 1024:478 (wanted ev.plug.dc.nacs)
- **Compatibility** (logic): a car fits a station when they share a plug. Tesla (NACS) fits none of S1–S4. Adapters are a proposal; Flow 11 already shows "J1772 adapter" (see 15).

---

## 15. Notes for the next steps (not fixed by C1: layout, design or other pages)

1. **Truncation (C4)**:
   - 10.07/10.08: the VEHICLE row title "Chevrolet Bolt EUV · J1772 (AC)" ellipsizes at 226 pt.
   - 10.13/10.14: the pass footer VEHICLE "Chevrolet Bolt EUV" ellipsizes at 106 pt ("Chevrolet Bol…").
   - Options: allow 2 lines; or move the plug into the row subtitle ("Primary · J1772 (AC)"); or show the model only ("Bolt EUV") in tight slots. The data stays "Chevrolet Bolt EUV".
2. **Geometry** (left as is, because the difference can't be seen): the 10.10 Charge Plan Bar "Added" segment and the 10.11 gauge's planned arc and target dot still use the master's 20 → 31% (PK). The Bolt's exact end is 30.5%. The bar is 2 pt long and the dot is 2.8° late. If anyone detaches them, use Added = 10.47% × 370 = 38.7 pt and target at 30.5%.
3. **10.05 "Driver" review** shows initials "D". The component rule (C21) says the anonymous Driver avatar is Kind=Glyph M 1109:1532.
4. **10.12 clock 9:41** at a 7:00 PM completion is copied from PK 06.30 (also 9:41). If it changes, change both (7:00).
5. **Base logic card 1304:195** DUMMY DATA says "Rs × 0.32/42 → $". This is the price-level mapping, not an FX rate (section 6). When C2 merges into it, reword it to "US prices = PK list × 0.32/42 (price level, not FX); FX dummy rate Rs 280 = $1".
6. **Flow 11 · Host · US** (page 1346:2, second session; not in the merge plan) uses the same story ($2.18, 6.8 kWh, $0.32/kWh, $1.16 so far, payout $1.85 after the 15% fee). Two observations for Hammad:
   - (a) Its "today" is **Sun, Oct 5** (lock screen "Sunday, October 5"; booking "Oct 5, 3:58 PM"), while Flow 10's is Sat, Oct 4.
   - (b) It shows **Marcus Lee as a driver** ("Tesla Model 3", "J1772 adapter", "7.1 kWh · $2.27 paid"), while Flow 10 has him as the Chauncey Hill host. Hosts can also drive, so this is plausible; it is noted so nobody "fixes" one side blindly.

---

## 16. Alternate 10A (first-session dataset) → canon, for C2

Apply as **one simultaneous map** (longest keys first, replacer callback). ⚠ marks a chain hazard: the value is both a source and a target.

**Stations and addresses**

| Alternate | Canon |
|---|---|
| CHARGING · GRANT STREET GARAGE CHARGER | CHARGING · BOILERMAKER · STATE ST |
| Grant Street Garage Charger | Boilermaker · State St |
| Chauncey Square Fast Charge | Wabash Landing Garage ⚠ |
| Wabash Landing Home Charger | Chauncey Hill Home Charger ⚠ |
| Downtown Lafayette Hub | Research Park DC Hub |
| N Grant St, West Lafayette, IN 47906 (S1 address) | 401 W State St, West Lafayette, IN 47906 |
| State St, West Lafayette, IN 47906 (S2 address) | Brown St, West Lafayette, IN 47906 ⚠ (a substring of the canon S1 address: never run it on canon text) |
| Wabash Landing, West Lafayette, IN 47906 (S3 address) | Chauncey Hill, West Lafayette, IN 47906 (the recents place "Wabash Landing" / "West Lafayette, IN" stays) |
| Main St, Lafayette, IN 47901 | Win Hentschel Blvd, West Lafayette, IN 47906 |
| CCS1 + NACS (DC) | CCS1 (DC) |
| CCS1 (DC) · Lafayette | CCS1 (DC) · West Lafayette |

**Prices (⚠ $0.52 is both a source and a target)**

| Alternate | Canon |
|---|---|
| $0.48 | $0.52 |
| $0.52 | $0.42 |
| $0.28 | $0.29 |
| $0.35 | $0.34 |
| $0.32, $0.30 | unchanged |
| "$2.00" "/hr" | "$2.29" "/hr" |
| $2.12 | $2.18 |
| $3.71 | $4.40 |
| $13.80 | $14.35 |
| $18.72 | $20.28 |
| $1.13 | $1.16 |
| $1.94 | $1.99 |
| $0.53 · $1.06 · $1.59 · $3.18 | $0.54 · $1.09 · $1.63 · $3.27 |

Split pins: use the section 6 table, not "(N − 10) ÷ 100".

**Power**: 7.2 kW → 7.4 kW · 62.5 kW → 60 kW · 9.6 kW → 11 kW · 150 kW → 30 kW. The bare tile value "7.2" → "7.4".

**Distances** (station rows only): 0.6 mi → 0.7 mi · 1.1 mi → 2.1 mi · 1.8 mi → 3.2 mi · 2.9 mi → 4.8 mi. Place distances stay, except Purdue Research Park 3.1 mi → 4.6 mi.

**Ratings and counts** are unchanged (4.8/36, 4.6/21, 4.9/9, 4.4/12).

**People**

| Alternate | Canon |
|---|---|
| Sam (S1 host, avatar "S") | Jake ("J") ⚠ |
| Jake (S3 host, avatar "J") | Marcus Lee ("ML") ⚠ |
| Olivia (S2 host, avatar "O") | Ryan Miller ("RM") |
| Megan T. | Megan S. |
| Chris D. | Derek P. |
| Priya S. | Ashley W. |

Review dates and bodies follow section 2.3; "September 14, 2026" → "September 9, 2026".

**Cars**

| Alternate | Canon |
|---|---|
| Tesla Model 3 Long Range | Tesla Model 3 |
| NACS · 82 kWh | NACS · 75 kWh |
| EV 2047 | IN 731 PUR |
| PKP 482 | IN 482 BKR |

Bolt EUV, "J1772, CCS1 · 65 kWh" and (765) 555-0142 are unchanged.

**Story**

| Alternate | Canon |
|---|---|
| 6.6 kWh | 6.8 kWh |
| "6.62 kWh × $0.32/kWh" | "6.8 kWh × $0.32/kWh" |
| live 3.5 kWh · ≈25% | 3.6 kWh · ≈26% |
| ending 6.0 kWh · ≈29% | 6.2 kWh · ≈30% |
| GS7-P31 | BS7-K32 |

Unchanged: plan ≈30% / +10% / "13.0 kWh of 65 kWh", PP-US-2410-0731, TODAY · SAT, OCT 4.

**Chips and filters**: "CCS1 (DC)" → "CCS (DC)" only on chips and Filter & sort options. Station and connector rows keep "CCS1 (DC)".

---

## 17. C1 fixes applied to the base frames (old → new)

| Frame | Node | Old | New |
|---|---|---|---|
| 10.03 | I1304:63;971:257 (query) | "dha" | "state st" |
| 10.03 | I1304:80;971:276 / ;971:277 / ;1188:6946 | "Levee Phase 6" / "West Lafayette, United States" / "2.9 mi" | "State St & N Grant St" / "West Lafayette, IN, USA" / "0.5 mi" |
| 10.03 | I1304:81;… | "Levee Raya" / "West Lafayette, United States" / "6.1 mi" | "State St & Chauncey Ave" / "West Lafayette, IN, USA" / "1.0 mi" |
| 10.03 | I1304:82;… | "Levee Phase 3" / "West Lafayette, United States" / "2.0 mi" | "W State St" / "West Lafayette, IN, USA" / "1.2 mi" |
| 10.03 | I1304:79;971:277 | "West Lafayette, United States" | "West Lafayette, IN, USA" |
| 10.03 | I1304:75;971:268, I1304:79–82;971:276 | no match highlight (station title all Body, place titles all Medium) | Flow 3 highlight: Body + Headline on "State St" |
| 10.05 | 1304:158 Body#1214:18 | "Easy to find inside the block, and the 7 kW charger was ready when I arrived." | "Easy to find on State St, and the 7 kW charger was ready when I arrived." |
| 10.07, 10.08 | 1304:237, 1304:352 Eyebrow (visible) + 1304:324, 1304:439 (Compact, unused) | "TODAY · SAT 4 OCT" | "TODAY · SAT, OCT 4" |
| 10.07, 10.08 | 1304:322, 1304:437 Plate#1094:62 (hidden in Row) | "LEB-2481" | "IN 482 BKR" |
| 10.10 | 1304:500 hero | "≈31%" | "≈30%" |
| 10.10 | 1304:501 Right label | "+11% est." | "+10% est." |
| 10.11 | 1304:578 overline | "CHARGING · GREENVOLT · Levee PHASE 5" | "CHARGING · BOILERMAKER · STATE ST" |
| 10.11 | 1304:556 plan value | "≈31% · $2.18 est." | "≈30% · $2.18 est." |
| 10.12 | 1304:599 Battery tile (≈ kept at 12 pt) | "≈31%" | "≈30%" |
| 10.13, 10.14 | 1304:623, 1304:640, 1304:653 Date | "TODAY · SAT 4 OCT" | "TODAY · SAT, OCT 4" |
| 10.13, 10.14 | same, Meta (unused on Front) | "BYD Atto 3 · Type 2 (AC)" | "Chevrolet Bolt EUV · J1772 (AC)" |
| 10.13, 10.14 | 1304:628, 1304:643 P-C Meta (visible) | "Tesla Model 3 · CCS1 (DC)" | "Chevrolet Bolt EUV · CCS1 (DC)" |
| 10.13, 10.14 | 1304:628, 1304:643 P-C Amount (visible) | "$14.30" | "$14.35" |
| 10.13, 10.14 | P-B 1304:627/642, P-C 1304:628/643 unused props | Vehicle "BYD Atto 3", Connector "Type 2 (AC)", Date "TODAY · SAT 4 OCT", Start/End/Duration 6:00 PM/7:00 PM/1 h | P-B: Bolt EUV · J1772 (AC) · "TOMORROW · SUN, OCT 5" · 9:00 AM/10:30 AM/1 h 30 min. P-C: Bolt EUV · CCS1 (DC) · "WED, OCT 8" · 7:30 PM/8:00 PM/30 min |
| 10.14 | 1304:700 Subtitle (hidden) | "Private charger · Street 12, Phase 5, Lahore" | "Private charger · 401 W State St, West Lafayette, IN 47906" |
| 10.15 | 1304:708 Total, Summary (unused in Charging) | "Rs 286", "6.8 kWh · ≈31% est. · 1 h 00 min" | "$2.18", "6.8 kWh · ≈30% est. · 1 h 00 min" |
| 10.16 | 1304:720–725 Body#1127:41 (notification-only prop) | "Your booking at GreenVolt · DHA Phase 5 is complete." | "Your booking at Boilermaker · State St is complete." |
| 10.16 | 1304:723 / 1304:724 / 1304:725 Station (hidden, Meta off) | "GreenVolt · DHA Phase 5" | "Wabash Landing Garage" / "" / "" |
| 10.17 | I1304:741;1130:2783 (hidden subtitle) | "CNIC checked" | "Driver’s license checked" |
| 10.01–10.20 | 76 layer names | PK names (e.g. "Map Pin · GreenVolt · DHA Phase 5 · Rs 42 (selected)", "Row · DHA Raya", "Thread · Bilal", "Vehicle Card · MG ZS EV", "Avatar · B") | US names (e.g. "Map Pin · Boilermaker · State St · $0.32 (selected)", "Row · State St & Chauncey Ave", "Thread · Jake", "Vehicle Card · Tesla Model 3", "Avatar · J") |

**Leftover check after the fixes**: visible text, hidden text and instance TEXT props on all 20 frames return only the deliberate Pakistan-side strings in **10.19** ("Pakistan" / "Lahore, Karachi, Islamabad", "Pakistani rupee · Rs", "Kilometres · km", the FX notice) and the deliberate Rs view in **10.20**. The regex was Rs/km/Lahore/Karachi/+92/PK names, cars and plates/Type 2/CCS2/GB/T/GreenVolt/DHA/Levee/CNIC/"4 OCT"/≈31/+11%. The only remaining PK-word layer name is "Row · Kilometres · km" (10.19 option row).
