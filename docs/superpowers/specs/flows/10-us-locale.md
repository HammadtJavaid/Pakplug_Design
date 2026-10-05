# 10 · US market + currency: Region & currency, the Rs ⇄ $ switch, and the West Lafayette edition

> **00-system alignment (read first).** `00-system.md` stays the single answer for navigation, sheets, motion, haptics, components, section anatomy and the Pakistani formats (§5.2). This spec adds: (a) the **Region** and **Currency** model and its two new surfaces, (b) the **US formats, plugs and dataset**, (c) the build plan for page **v4 · 📱 Flow 10 · US · West Lafayette (1294:2)**, and (d) four frames plus one new row for **Flow 8E** (page 1089:8872). For US data and for anything about currency, this spec wins. Pakistani Flows 1–9 do not change, except for the §6 additions to 8E (and the same row in 08.28).

Research only: no Figma calls were made. Sources: `brief/BRIEF.md` (dummy-data story), `00-system.md` §2, §4 and §5, `08-profile-vehicles.md` (Account & settings), `05-charge-start.md` (planner), the frame tables of 02, 03, 04, 06 and 07, the build log (source-frame IDs) and `brief/NEW-COMPONENTS.md` (component props). Mobbin: 11 iOS screen searches, every image looked at; 35 references cited in §7.

Hammad's ask (verbatim): *"add usd in pricing like toggle and US west lafeyette locations US named etc cars"*.

Contents: 0 Decisions · 1 Model · 2 Formats · 3 US plugs · 4 US dataset · 5 Section plan (Flow 10) · 6 Additions to Flow 8E · 7 Mobbin references · 8 Proposals · 9 For Rayan.

---

## 0. Decisions in one screen

1. **Two settings on one screen.** **Region** is where you charge: Pakistan or the United States. **Currency** is how prices are shown: Rs or $. Region sets the defaults for currency, distance unit, plug names, phone, plate, date and address formats, and the map's home city. Currency is a separate choice.
2. **Only rupees are ever converted.** In the Pakistan region you can show rupees (the default) or US dollars, which are converted and marked "≈". In the United States region, prices are the hosts' US dollars and are never converted, so the currency is fixed to US dollars.
3. **Honest conversions.** Every converted amount starts with "≈". Every screen that shows one also shows **"Converted at Rs 280 = $1 (dummy rate)."** once. Totals always show what you actually pay, for example "Rs 286 · converted at …".
4. **Where the controls live.** The main control is Settings → Account & settings → **Region & currency**. In the Pakistan region, a compact **Rs | $ switch** also sits on three money cards: the planner **Estimate Card**, the **Price Trends** chart card and the **Charging complete** summary card. The switch changes the same global setting. The receipt image stays in rupees and adds one "≈ $" line.
5. **The US edition.** Emily Carter in West Lafayette, IN (Purdue). Her cars are a Chevrolet Bolt EUV (J1772 + CCS1) and a Tesla Model 3 Long Range (NACS). There are four stations around campus. The story is the same: Today, Sat, Oct 4 · 6:00 → 7:00 PM. The maths is the same too (92% efficiency): 1 h on 7.2 kW = 6.6 kWh → ≈30% · **$2.12**.
6. **The build.** Page 1294:2 gets three sections of 13 + 13 + 14 frames, cloned from finished Pakistani frames with exact replacements. Flow 8E gets four frames (08.62–08.65) and one new Account & settings row.

---

## 1. Model: Region and Currency

### 1.1 What each one is

| | **Region** | **Currency** (display) |
|---|---|---|
| Values | Pakistan · United States | Rupees (PKR, "Rs") · US dollars (USD, "$") |
| Meaning | The market you charge in: which hosts and stations you see, and the currency they charge in (the **native** currency of every price there) | How amounts are written on screen |
| Default | Set from the device region and location at first launch. Silent; visible in Settings | The region's currency |
| What it sets | native currency · distance unit (km / mi) · plug catalogue and names · phone, plate, date and address formats · map home city (Lahore / West Lafayette) · support number · receipt prefix | nothing else |
| Who changes it, where | The driver, in Settings → Region & currency. Locked while a session is active | Pakistan region: either currency (Settings or the Rs ⇄ $ switch). United States region: US dollars only |
| Stored | On the account, so it follows the driver across devices [US-P1] | On the account |

In one line: **Region decides what things cost; Currency decides how you read it.**

### 1.2 Conversion rules
1. **Native first.** What you pay is the host's price, in the station's native currency. PakPlug never converts the charge itself.
2. **Display = native** → exact amount, no "≈": "Rs 286", "$2.12".
3. **Display ≠ native** → converted amount with "≈": "≈$1.02". Only PKR → USD exists in v1. Rupee prices can be shown in dollars; dollar prices are always shown in dollars, in either region. So nothing is ever converted in the US region.
4. **The note.** Every screen that shows at least one converted amount carries **"Converted at Rs 280 = $1 (dummy rate)."** once, next to the first converted money card. A native fact for that screen follows it:
   - planner: "You pay Rs 286."
   - Price Trends: "Hosts charge in rupees."
   - Settings: "You always pay hosts in rupees."
   - Complete: the total keeps the native amount in its detail line: "Rs 286 · converted at Rs 280 = $1 (dummy rate)".
5. **One "≈" per number.**
   - Standalone amounts carry "≈": pins, rates, tiles, totals and region-card prices.
   - Numbers inside a chart, range bar or formula that already sits under an "≈" lead stay plain. This is the same rule as 06 §2.0.2-3 for estimates.
   - In Display styles, the "≈" is about 55% of the number size and top-aligned (00-system §2.3-7).
6. **Rounding.** Convert from the unrounded native value, then round half-up:
   - money and rates: to the cent ($1.02, $0.15)
   - averages and chart values: to a tenth of a cent ($0.169), because the spreads are under 1¢.
7. **Estimates stay estimates.** A converted estimate keeps the estimate line ("Estimate. The charger's meter decides the final amount.") and adds the conversion note. Never write "≈" twice.
8. **Receipts are records.** The receipt image always shows native totals. With $ display it adds one line under the tiles: "≈ $1.02 · converted at Rs 280 = $1 (dummy rate)".
9. **A region switch resets Currency** to the new region's currency, so the result is predictable. In the Pakistan region the driver can pick US dollars again on the same screen. This is the "vice versa": a US visitor charging in Lahore can keep reading dollars.
10. **One dummy rate.** Rs 280 = $1 is a single constant. "(dummy rate)" stays in the copy until Rayan wires a real rate with its time ("Rate from 6:00 PM today") [US-P3].

### 1.3 Where the controls live (decided)

| Surface | Control | Why here |
|---|---|---|
| Settings → Account & settings → **Region & currency** (new row + new pushed screen, §6) | Region (2 rows, checkmark) + "Show prices in" (2 rows in Pakistan; 1 fixed row in the US) | The main home for both settings. Explained, reversible, applies at once |
| Planner **Estimate Card** (05.23–05.30) | Rs ⇄ $ switch, top-right of the card | The decision moment: "what will this cost me?" |
| **Price Trends** chart card (02.25–02.26) | same | Comparing prices across days and areas |
| **Charging complete** summary card (06.30–06.35) | same | Reading the final bill |
| Everything else: pins, cards, place sheet, Book a slot footer, passes, live tiles, accessory, receipt | none (follows the setting) | Keeps the chrome calm: one setting, three shortcuts |

- The switch appears **only in the Pakistan region**; in the US there is nothing to convert.
- It writes the same global setting as the Settings screen. The first use posts a one-time Toast (§1.5-A4).
- The receipt gets no switch: it is a saved image, a record of what was paid.

### 1.4 Currency Switch (new flow-local component; the 10C builder makes it)
- **Where.** Components page 946:7, new section **"F10 · US locals (Currency Switch)"**. Put it right of F7D (x ≥ 24600) on the y 20767 row, after reading the page bounds. Register it in `brief/NEW-COMPONENTS.md` with a Bash heredoc.
- **Set.** `Currency Switch`, variant prop `Currency` = PKR · USD (default PKR).
  - Size and track: 92×32, auto-layout horizontal, padding 2, gap 0, radius `radius/pill` 948:120, fill `bg/fill` 948:46.
  - Segments: two, 44×28, radius pill. Selected = `bg/surface` 948:41 + effect Shadow/Button; unselected = no fill.
  - Labels: Subheadline Emph (SF Pro Medium 15), centred, "Rs" and "$". Selected `text/primary` 948:49, unselected `text/secondary` 948:50.
- **Hit area and VoiceOver.** The hit area is 44 tall (runtime padding). VoiceOver sees one adjustable element, "Currency", with the values "Rupees" and "US dollars". No new tokens.
- **Placement.** Absolute (`layoutPositioning = 'ABSOLUTE'` inside auto-layout parents), at the top-right of the card it controls, vertically centred on the card's title row:

  | Card | Switch position |
  |---|---|
  | Estimate Card | x = card.x + 266, y ≈ card.y + 10 |
  | Trend Chart Card | x = card.x + 262, y ≈ card.y + 12 |
  | Session Summary Card | x = card.x + 258, y ≈ card.y + 16 |

  Screenshot the result and align it to the title optically.

### 1.5 Micro-interactions (tokens from 00-system §2; no new curves)

**A · Rs ⇄ $ switch (10.36–10.39)**
1. **Touch-down on the other segment** → its label dims to 60%; nothing else moves · instant · none.
2. **Tap** → the thumb slides (`snappy`, ≈ 250 ms) and the label colours swap (`fade.quick`).
   - Every money value on the screen changes currency with `roll` (220 ms; only changed digits move). The prefix "Rs " ↔ "≈$" cross-fades with `fade.quick`, the one exception to "symbols never move". Values update in reading order with a 30 ms stagger, at most 4 steps.
   - The conversion note grows into place under the card (`M-grow`: height `smooth`, text `fade.std`); the content below moves with `smooth`.
   - Haptic: **selection** on commit.
   - VoiceOver: the control reads "Currency, US dollars, selected, 2 of 2". Then one polite announcement: "Prices in US dollars, about. Converted at 280 rupees to 1 dollar, a sample rate. You pay in rupees."
   - Reduce Motion: no roll and no grow; values and note cross-fade in 150 ms; the thumb jumps.
3. **Drag the thumb** → it follows the finger, clamped to the track. Crossing the midpoint commits (selection at the crossing); release settles with `snappy`. VoiceOver uses tap or swipe up/down (adjustable).
4. **First switch ever, on any surface** → Toast Neutral (no action), placed by its bottom edge (00-system §1.5): planner 748, Price Trends 828, Complete 700.
   - Copy: **"Now showing US dollars everywhere. Change it anytime in Region & currency."**
   - Motion `smooth` in; stays 6 s · none (Neutral) · polite announcement · RM: fade.
5. **Back to Rs** → reverse: the note collapses (`fade.quick`, then height `smooth`), numbers roll back, no Toast · selection · VO "Prices in rupees." · RM: cross-fade.
6. **Two taps within 300 ms** → the second retargets the running animation (no queued rolls). Haptics at most one per 60 ms (the `scrub` limit).
7. **An estimate changes while $ is on** (planner chip, target drag) → the value rolls straight to the new converted amount, with no rupee flash · `roll` · none (the chip or slider already played its haptic) · VO reads dollars ("about 51 cents").
8. **VoiceOver strings**: "≈$1.02" = "about 1 dollar 2 cents" · "Rs 286" = "286 rupees" · "$0.32/kWh" = "32 cents per kilowatt-hour" · "0.6 mi" = "0.6 miles" (00-system: "≈" reads "about").
9. **Dynamic Type**: the switch grows with Subheadline. From AX1, the card title wraps and the switch drops under it, left-aligned. Tabular figures keep amounts from shifting.

**B · Region & currency screen (08.62–08.65, 10.34, 10.35)**
1. **Account & settings row "Region & currency"** → `bg/fill` highlight on touch-down, then push (`M-push` ≈ 350 ms) · none (row navigation) · VO "Region & currency, Pakistan, Rupees, button" · RM: cross-fade.
2. **A currency row (Pakistan region)** → the checkmark moves: the old one fades (`fade.quick`), the new one scales 0.8 → 1 (`snappy`). It applies at once, with no Save button (the iOS settings pattern) · **selection** · VO "US dollar, selected. Prices show in US dollars, converted." · RM: no scale.
3. **The other region's row** → row highlight, then the alert (08.64) with the `alert` motion · no haptic as it appears (reversible, like Logout) · VO focus on the alert title · RM: opacity only.
4. **Alert "Switch"** → the alert dismisses (`fade.quick`). The checkmark moves; the currency group morphs between two rows and one fixed row (height `smooth`, rows cross-fade `fade.std`); the footnotes cross-fade.
   - Toast Success "Region set to United States" (or "Region set to Pakistan"), bottom edge 828.
   - Haptics: **medium** on the Switch tap (a commit), then **success** with the Toast at least 300 ms later. VO announces the Toast. RM: cross-fades only.
   - Effects elsewhere (no frames):
     - Home re-centres on the region's home city when you are outside that country, with the Map Status Pill "Showing West Lafayette" for 2.5 s [US-P15].
     - Stations reload for the region (skeletons).
     - Units, plug names and formats switch; Add vehicle shows the region's tiles.
5. **Alert "Cancel" / two-finger Z** → dismisses; nothing changes · none · VO focus back on the tapped row · RM: fade.
6. **While charging (08.65)** → region rows sit at 40% and are not focusable as buttons. Tapping one washes the Inline Notice with `bg/fill` (in 150 ms, out 600 ms; the 08 §5.4-8 pattern) · none · VO "United States, dimmed. Finish charging to change your region." · RM: no wash.
7. **US region currency row** (display-only) → no highlight, no chevron · VO "US dollar. 32 cents per kilowatt-hour. Hosts in the United States charge in US dollars."
8. **Back** → pops; the Account & settings row subtitle rolls to its new value, e.g. "Pakistan · US dollars (≈)" · `roll` after the pop · none · RM: instant.

### 1.6 Edge cases (decided; Hammad asleep)
1. **Active session.** Region is locked (08.65); currency can still change, and live values re-render with `roll`.
2. **Bookings in the other region.** Switching is allowed. Bookings keeps every pass, priced natively: rupee passes show "≈$" when display = $; dollar passes always show $.
3. **A US-region driver with old Pakistani bookings** sees those rupee amounts as "≈$", with the note on that screen.
4. **A Pakistan-region driver showing rupees who opens a US booking** sees "$2.12". Dollars are never converted.
5. **Real rates later.** If the rate is unavailable:
   - The "US dollar" row dims with the subtitle "Rates unavailable right now", and the switches hide.
   - A driver on $ falls back to rupees with the Toast Neutral "Showing rupees: exchange rate unavailable." [US-P3].
6. **Phone numbers** keep their own country's format (stored as E.164): Ayesha's "0301 2345678" stays Pakistani after a switch. A new number's placeholder and keyboard follow the region.
7. **Search Places** are biased to the region's country (Google `components=country:pk` / `country:us`).
8. **Price Trends** follows the region (Lahore areas or West Lafayette areas). In the US it is native USD; no US Price Trends frame is drawn tonight.
9. **Saved chargers** from the other region stay in Saved, priced natively.
10. **Region at first launch** is silent, and the location wins over the device region: a Pakistani phone in Indiana starts in the United States. Flag for Rayan.

---

## 2. Formats

| Thing | Pakistan (unchanged, 00-system §5.2) | United States |
|---|---|---|
| Money | Rs 286 · Rs 2,468 (whole rupees) | **$2.12 · $18.72 · $1,234.50**. Symbol before the number, no space; always 2 decimals (never "$2"); comma thousands; zero "$0.00"; negative "−$1.50" |
| Rate | Rs 42/kWh · Rs 300/hr (the logic row keeps "Rs 42 / kWh") | **$0.32/kWh · $2.00/hr**, always with cents (logic row "$0.32 / kWh") |
| Averages, trends | Rs 47.3 | **$0.169** (3 decimals; sub-cent spreads) |
| Converted (PKR → USD only) | — | **"≈$1.02" · "≈$0.15/kWh"** (no space after "≈") |
| Energy | 6.8 kWh | **6.6 kWh**. Any line that multiplies kWh by a $ rate (Complete detail, receipt Energy row, How we estimate) uses **2 decimals**: "6.62 kWh × $0.32/kWh" = $2.12, so it multiplies out to the cent |
| Power | 7.4 kW · 60 kW | 7.2 kW · 9.6 kW · 62.5 kW · 150 kW |
| Battery | ≈31% est. | same rules (≈30% est.) |
| Distance | 1.2 km | **0.6 mi** (1 decimal). Under 0.1 mi → feet rounded to 50 ("450 ft"). 10 mi and over → whole miles ("12 mi") |
| Time | 6:00 PM · "6:00 → 7:00 PM" · "6:00 – 7:00 PM" | same (12-hour, no leading zero) |
| Story date | Today, Sat 4 Oct · eyebrow TODAY · SAT 4 OCT | **Today, Sat, Oct 4** · eyebrow **TODAY · SAT, OCT 4** |
| Detail and list dates | Oct 4, 2026 · Thu, Oct 2 (logic list format) | same |
| Chat date separators | d/m/y (logic) | m/d/y: 10/4/26 |
| Phone | 0301 2345678 · placeholder "03XXXXXXXXX" | **(765) 555-0142** · placeholder "(XXX) XXX-XXXX" · stored +17655550142 · formats as you type |
| Plate | LEB-2481 · placeholder "e.g., LES-1234" | **PKP 482** · placeholder "e.g., ABC 1234" [US-P16] |
| Address | Street 12, Block CCA, DHA Phase 5, Lahore | **N Grant St, West Lafayette, IN 47906** (street, city, state ZIP). Home chargers show the area only: "Wabash Landing, West Lafayette, IN 47906" [US-P8] |
| List-card location line | "{plug} · Lahore" (logic: last comma segment) | **"{plug} · West Lafayette"**, the city, because the last segment of a US address is "IN 47906" [US-P7] |
| Search place subtitle | Lahore, Pakistan | West Lafayette, IN, USA |
| Charger code | GV7-K42 | GS7-P31 |
| Receipt / transaction no. | PP-2410-0482 | **PP-US-2410-0731** [US-P9] |
| Support hotline (08.08) | 0311 6677098 | (765) 555-0100 (dummy) |

VoiceOver: "$2.12" = "2 dollars 12 cents"; "$0.32/kWh" = "32 cents per kilowatt-hour"; "≈$1.02" = "about 1 dollar 2 cents"; "0.6 mi" = "0.6 miles". Phone numbers are read digit by digit.

---

## 3. US plugs

| SAE name | Current | Same as | Station label (cards, rows, chips) | Add vehicle tile: Title / Subtitle | Icon now (stand-in) | Wanted SF Symbol | In the dataset |
|---|---|---|---|---|---|---|---|
| **J1772** | AC (Level 1/2) | **Type 1** (the Pakistani "Type 1" tile) | J1772 (AC) | J1772 / AC · common | ev.plug.ac.type.2 981:294 (FLAG) | ev.plug.ac.type.1 | Grant Street, Wabash Landing · Bolt EUV, Leaf |
| **CCS1** | DC | CCS Combo 1 (does not fit CCS2) | CCS1 (DC) | CCS1 / DC · fast | ev.plug.dc.ccs2 1024:482 (FLAG) | ev.plug.dc.ccs1 | Chauncey Square, Downtown Lafayette · Bolt EUV |
| **NACS** (SAE J3400) | AC + DC | Tesla connector | NACS (DC) at DC hubs · NACS (AC) at wall connectors | NACS / Tesla · AC + DC | ev.charger 1024:478 (FLAG) | the NACS glyph if the installed SF Symbols has one; otherwise a custom SVG | Downtown Lafayette · Model 3 |
| **CHAdeMO** | DC | same plug as Pakistan | CHAdeMO (DC) | CHAdeMO / DC | ev.plug.dc.gb.t 1024:484 (FLAG; the same stand-in as 08) | ev.plug.dc.chademo | Nissan Leaf (optional third car) |
| GB/T | — | Chinese standard | not offered in the US | — | — | — | — |

- **Add vehicle grid (US region).** Connector Tile 177×112, gap 16: (16,338) J1772 · (209,338) CCS1 · (16,466) NACS · (209,466) CHAdeMO. The Pakistani grid is unchanged (Type 2 · CCS 2 · Type 1 · CHAdeMO). After every Plug swap, re-fill the plug's `Symbol` with `icon/brand` (NEW-COMPONENTS note).
- **Vehicle subtitle** (logic "{plugs} · {battery}"): tile names joined with ", ": "J1772, CCS1 · 65 kWh" and "NACS · 82 kWh". "CCS1" is spelled one way everywhere (no space), unlike the Pakistani tile "CCS 2" [US-P5].
- **Station Connector Row**: plug glyph + label + "{kW} kW · {status}" + "$0.32" "/kWh". A hub has one row per connector type: Downtown Lafayette Hub = "CCS1 (DC)" 150 kW and "NACS (DC)" 150 kW.
- **Booking vehicle row** ("{name} · {matching plug label}"): "Chevrolet Bolt EUV · J1772 (AC)".
- **Map quick chips (US)**: Filters · Available now · J1772 (AC) · CCS1 (DC) · NACS.
- **Filter & sort, "Connector type"**: All · J1772 (AC) · CCS1 (DC) · NACS. CHAdeMO is covered by All; a fifth option is FLAG [US-P5].
- **Search keywords** (03 S8, US map):
  - "j1772", "type 1", "level 2", "l2" → J1772 (AC)
  - "ccs", "ccs1", "combo" → CCS1 (DC)
  - "nacs", "tesla", "supercharger", "j3400" → NACS
  - "chademo" → CHAdeMO (DC)
  - "dc", "fast" → every DC plug
- **Compatibility** (logic, unchanged): a car fits a station when they share a plug. The NACS-only Model 3 does not fit J1772 stations, so its row reads "Doesn't fit this charger (J1772 (AC))" (10.19). Adapters are a proposal [US-P10].

---

## 4. US dataset (one story, used in every US frame)

### 4.1 People
- **Driver**: Emily Carter, emily.carter@email.com, **(765) 555-0142** (Verified), West Lafayette, IN. Initials **EC** (Avatar Mesh). Stats as Ayesha: Sessions 12 · Charged — · Saved 3.
- **Hosts**:
  - **Sam**: Grant Street Garage Charger, the story host. Phone (765) 555-0187; Avatar "S".
  - **Jake**: Wabash Landing Home Charger, the home-charger host and the US messaging host. No phone number. He cancelled the Mon, Sep 29 booking. (Jake plays Usman's role; Sam plays Bilal's.)
  - **Olivia**: Chauncey Square Fast Charge.
- **Reviewers** (Grant Street): Megan T. · Chris D. · "Driver" (no name) · Priya S.
- 555-01xx numbers are reserved for fiction; 765 is the Lafayette area code.

### 4.2 Vehicles

| | Name (Brand / Model) | Battery | Plugs (tiles) | Plate | Subtitle |
|---|---|---|---|---|---|
| 1 · Primary | **Chevrolet Bolt EUV** (Chevrolet / Bolt EUV) | 65 kWh | J1772 + CCS1 | **PKP 482** | J1772, CCS1 · 65 kWh |
| 2 | **Tesla Model 3 Long Range** (Tesla / Model 3 Long Range) | 82 kWh | NACS | **EV 2047** | NACS · 82 kWh |
| 3 (optional, only for incompatibility demos) | Nissan Leaf | 40 kWh | J1772 + CHAdeMO | LFE 213 | J1772, CHAdeMO · 40 kWh |

### 4.3 Stations (West Lafayette and Lafayette, IN)

| # | Name | Address (2 lines max) | Plug · power | Price | ★ · reviews | Distance | Status | Host | Map pin (replaces) |
|---|---|---|---|---|---|---|---|---|---|
| S1 (story) | **Grant Street Garage Charger** | N Grant St, West Lafayette, IN 47906 | J1772 (AC) · 7.2 kW | $0.32/kWh | 4.8 · 36 | 0.6 mi | Available | Sam | Available "$0.32" (Rs 42) |
| S2 | **Chauncey Square Fast Charge** | State St, West Lafayette, IN 47906 | CCS1 (DC) · 62.5 kW | $0.48/kWh | 4.6 · 21 | 1.1 mi | In use | Olivia | In use "$0.48" (Rs 68) |
| S3 | **Wabash Landing Home Charger** | Wabash Landing, West Lafayette, IN 47906 (area only: home charger) | J1772 (AC) · 9.6 kW | $0.28/kWh | 4.9 · 9 | 1.8 mi | Available | Jake | Available "$0.28" (Rs 38) |
| S4 | **Downtown Lafayette Hub** | Main St, Lafayette, IN 47901 | CCS1 (DC) + NACS (DC) · 150 kW | $0.52/kWh | 4.4 · 12 | 2.9 mi | Offline | — | Unavailable "$0.52" (Rs 55) |

- **Filler pins**: "$0.30" (was Rs 40) and "$0.35" (was Rs 45). Any other filler "Rs N" becomes $(N − 10) ÷ 100, so Rs 39 → $0.29. The Map Cluster "24" is unchanged.
- **State demos on S1** (same as Pakistan): Maintenance · Paused · hourly "$2.00" "/hr" (a 1 h booking = $2.00) · no price "Pricing unavailable".
- **S1 extras**: charger code GS7-P31. Access note (dummy): "Level 2, bay 14. The charger is on the pillar by the stairs."
- **Map**: the label-free map image (fills of 996:430) stands in for West Lafayette. The user dot, Map Controls and Google attribution stay where they are. No map labels are added.
- **Real vs fictional**: the streets and landmarks are real (N Grant St, State St, Chauncey Ave, Wabash Landing, Main St, Purdue). The stations, hosts, people, plates, prices and ratings are fictional.

### 4.4 The story booking
- **Today, Sat, Oct 4 · 6:00 → 7:00 PM · 1 h · Chevrolet Bolt EUV · Grant Street Garage Charger · J1772 (AC).**
- **Availability**: as Pakistan. Booked at 3:40 PM. Open 8 AM – 11 PM; free 5 – 8 PM (3h) and 9 – 11 PM (2h); peak 5 – 9 PM; "Longest here: 3h".
- **Cost per duration** (7.2 kW × 0.92 = 6.624 kWh/h × $0.32): 15 min **$0.53** · 30 min **$1.06** · 45 min **$1.59** · 1 h **$2.12** · 1.5 h **$3.18**.
- The estimate copy is unchanged: "Estimate. The charger's meter decides the final amount."

### 4.5 Planner maths (92% efficiency; start 20% = 13.0 kWh of 65 kWh; 6:00 PM)

| Plan | Energy | % added | Battery at end | Cost | Finishes |
|---|---|---|---|---|---|
| 15 min | 1.7 kWh | +2.5% | ≈23% | $0.53 | 6:15 PM |
| 30 min | 3.3 kWh | +5.1% | ≈25% | $1.06 | 6:30 PM |
| 45 min | 5.0 kWh | +7.6% | ≈28% | $1.59 | 6:45 PM |
| **Until 7:00 PM (1 h, default)** | **6.6 kWh** | **+10%** | **≈30%** | **$2.12** | **7:00 PM** |
| Target 30% | 6.5 kWh | +10% | ≈30% | $2.08 | ≈6:59 PM |
| Target 80% (slot ends first) | 6.6 kWh (39.0 needed) | +10% | ≈30% | $2.12 | 7:00 PM. Warning copy: "80% would take about 5 h 53 min. Your slot ends first." |
| Tesla Model 3, same station | doesn't fit J1772 (10.19) | | | | |
| **DC · Chauncey Square · target 80%** | **39.0 kWh** | +60% | **≈80%** | **$18.72** | **≈6:41 PM** (40.7 min) |
| DC · 30 min | 28.8 kWh | +44% | ≈64% | $13.80 | 6:30 PM |

Notes card (US), shown beside 10.20:
- kWh = kW × hours × 0.92, capped by (target% − start%) × battery kWh
- % added = kWh ÷ battery kWh
- cost = kWh × $/kWh
- finish = now + needed kWh ÷ (kW × 0.92), never later than the slot end

### 4.6 Live (AC story)
Rules: live values floor kWh to 0.1 and dollars to the cent; ≈% rounds to the nearest 1%; Complete rounds and the billed amount wins.

| Clock | Elapsed | Left | kWh | ≈ battery | $ so far | Used in |
|---|---|---|---|---|---|---|
| 6:00:08 PM | 0:08 | 59:52 | 0.0 | ≈20% | $0.00 | — |
| 6:30 PM | 30 min | 30:00 | 3.3 | ≈25% | $1.05 (plan said $1.06: live floor vs plan rounding, as in Lahore) | — |
| **6:32 PM** | 32 min | **28:00** | **3.5** | **≈25%** | **$1.13** | 10.22, 10.23 |
| 6:44 PM | 44 min | 16:00 | 4.8 live / 4.9 final | ≈27% | $1.55 | — |
| **6:55 PM** | 55 min | **5:00** | **6.0** | **≈29%** | **$1.94** | 10.24 |
| 7:00 PM | 60 min | 0:00 | 6.6 | ≈30% | $2.11 live → **$2.12 billed** | 10.25, 10.26 |

- **Accessory**: 6:32 "Charging · ≈25%" / "28:00 left · $1.13"; 6:55 "Charging · ≈29%" / "5:00 left · $1.94".
- **Session Progress** header: "Plan · until 7:00 PM" / "≈30% · $2.12 est."
- **Ticking**: dollars tick about once every 17 s at this rate ($2.12 an hour).

### 4.7 Complete and receipt
- **Complete (7:00 PM)**: Total **$2.12**, detail **"6.62 kWh × $0.32/kWh"**. Tiles: Battery ≈30% est. · Energy 6.6 kWh · Time 1 h 00 min. Place row: "Grant Street Garage Charger · 6:00 – 7:00 PM".
- **Receipt rows**:
  - Station Grant Street Garage Charger
  - Address N Grant St, West Lafayette, IN 47906
  - Date Oct 4, 2026
  - Time 6:00 – 7:00 PM
  - Duration 1 hour
  - Connector J1772 (AC) · 7.2 kW
  - **Energy 6.62 kWh** (new row [US-P9])
  - Rate $0.32/kWh
  - Vehicle Chevrolet Bolt EUV · PKP 482
  - Transaction ID **PP-US-2410-0731**
- **Receipt tiles**: Battery ≈30% est. · Energy 6.6 kWh · Total $2.12.

### 4.8 Bookings

| Pass | Station | When (logic list format) | Vehicle · connector | Amount | Status |
|---|---|---|---|---|---|
| P-A (story) | Grant Street Garage Charger | Today, 6:00 PM · 1 h | Chevrolet Bolt EUV · J1772 (AC) | $2.12 | Ready to start (clock 5:50 PM) |
| P-B | Wabash Landing Home Charger | Tomorrow, 9:00 AM · 1 h 30 min | Chevrolet Bolt EUV · J1772 (AC) | $3.71 | Upcoming |
| P-C | Chauncey Square Fast Charge | Wed, Oct 8, 7:30 PM · 30 min | Chevrolet Bolt EUV · CCS1 (DC) | $13.80 | Upcoming |
| Cancelled 1 | Grant Street Garage Charger | Thu, Oct 2, 8:00 PM · 1 h | Chevrolet Bolt EUV · J1772 (AC) | — | Cancelled by you |
| Cancelled 2 | Wabash Landing Home Charger | Mon, Sep 29, 9:00 AM · 1 h 30 min | Chevrolet Bolt EUV · J1772 (AC) | — | Cancelled by host (Jake) |
| Cancelled 3 | Chauncey Square Fast Charge | Sat, Sep 27, 7:30 PM · 30 min | Chevrolet Bolt EUV · CCS1 (DC) | — | Expired: "No session started · Chevrolet Bolt EUV" |
| Cancelled 4 | Downtown Lafayette Hub | Sun, Sep 14, 5:00 PM · 45 min | Tesla Model 3 Long Range · NACS (DC) | — | Cancelled |

P-B amount: 9.6 kW × 1.5 h × 0.92 = 13.2 kWh × $0.28 = $3.71. The Bolt is used on the CCS1 passes because the NACS Model 3 doesn't fit CCS1. The Tesla appears on the NACS hub.

### 4.9 Search data
- **Before typing**:
  - Recent: Grant Street Garage Charger (station, "N Grant St, West Lafayette, IN 47906") · Purdue Memorial Union (place, "N Grant St, West Lafayette, IN") · Wabash Landing (place, "West Lafayette, IN").
  - Saved chargers: "3 saved".
  - Nearby: Chauncey Square Fast Charge "1.1 mi" · Wabash Landing Home Charger "1.8 mi" · Downtown Lafayette Hub "2.9 mi".
- **Query "purdue"**: no station's name or address matches, so the Stations section is hidden (the 03.16 pattern). Places, with "Purdue" highlighted:

  | Title | Subtitle | Distance |
  |---|---|---|
  | **Purdue** University | West Lafayette, IN, USA | 0.4 mi |
  | **Purdue** Memorial Union | N Grant St, West Lafayette, IN, USA | 0.5 mi |
  | **Purdue** University Airport | West Lafayette, IN, USA | 2.3 mi |
  | **Purdue** Research Park | West Lafayette, IN, USA | 3.1 mi |

- **Query "state st"**:
  - Stations: Chauncey Square Fast Charge / "**State St**, West Lafayette, IN 47906" / 1.1 mi (address match).
  - Places: **State St** / West Lafayette, IN, USA / 0.4 mi · **State St** & N Grant St / West Lafayette, IN, USA / 0.5 mi · **State St** & Chauncey Ave / West Lafayette, IN, USA / 1.0 mi.
- **Place outcome** (Purdue University): the Map Marker / Place "Purdue University"; pins "$0.32" (S1), "$0.30" and In use "$0.48" (S2); the pill "3 stations nearby".

### 4.10 Reviews (S1, newest first)
- Megan T. · September 28, 2026 · 5★ · "Easy to find on level 2 and the host replied in minutes. Charged 6 to 7 while I grabbed dinner on State Street."
- Chris D. · September 21, 2026 · 5★ · "Steady 7.2 kW the whole hour. The cable reaches a nose-in spot."
- Driver · September 14, 2026 · 4★ · (no body)
- Priya S. · August 30, 2026 · 5★ · "Booked on the way back from campus and the slot was free on time."
- Summary: 4.8 · "Based on 36 reviews" (5★ 30 · 4★ 5 · 3★ 1 → 173 ÷ 36 = 4.81).

### 4.11 Arithmetic check (verified with a script; reviewers, don't "fix" these)
- **AC story, 1 h**: 7.2 × 0.92 = **6.624 kWh/h**, shown as 6.6 kWh. 6.624 ÷ 65 = 10.19%, so 20% + 10% = **≈30%**. 6.624 × $0.32 = $2.1197 → **$2.12**.
  - Watch out: 6.6 × 0.32 = $2.112 would round to $2.11. Money is computed from the unrounded kWh, so any line that shows the multiplication uses 2 decimals: **6.62 × $0.32 = $2.1184 → $2.12** (§2).
- **Target 30%**: 6.5 kWh ÷ 6.624 = 58.9 min → ≈6:59 PM · $2.08.
- **Target 80% on AC**: 39.0 kWh ÷ 6.624 = 5.89 h → "about 5 h 53 min".
- **DC**: 62.5 × 0.92 = 57.5 kWh/h. 20% → 80% of 65 = **39.0 kWh**; 39.0 ÷ 57.5 = 0.678 h = **40.7 min ≈ 41 min**; 39.0 × $0.48 = **$18.72**. 30 min = 28.75 kWh (shown 28.8) → +44.2% → ≈64% · $13.80.
- **Live 6:32**: 6.624 × 32/60 = 3.533 kWh → 3.5; 20% + 5.4% = ≈25%; $1.1305 → $1.13.
- **Live 6:55**: 6.072 kWh → 6.0 (floor); 29.3 → ≈29%; $1.943 → $1.94.
- **Live 7:00**: live floor $2.11 → billed $2.12 (the same pattern as Lahore's Rs 285 → Rs 286).
- **Wabash 1.5 h**: 9.6 × 1.5 × 0.92 = 13.248 kWh × $0.28 = $3.709 → $3.71.
- **Conversions** (÷ 280, half-up):
  - Rs 42 → $0.15 · Rs 68 → $0.24 · Rs 38 → $0.14 · Rs 55 → $0.20 · Rs 40 → $0.14 · Rs 45 → $0.16
  - Rs 286 → **$1.02** · Rs 152 → $0.54 · Rs 2,468 → $8.81 · Rs 1,877 → $6.70
  - Rs 47.3 → $0.169 · Rs 38.4 → $0.137 · Rs 42.0 → $0.150
  - Ranges: Rs 34–44 → $0.121–$0.157 · Rs 38–48 → $0.136–$0.171
  - Axis: Rs 46 / 47 / 48 / 49 → $0.164 / $0.168 / $0.171 / $0.175

---

## 5. Section plan: page "v4 · 📱 Flow 10 · US · West Lafayette" (1294:2)

The page is empty. Three sections in journey order, at x 0: **10A** at y 0, **10B** 160 below 10A, **10C** 160 below 10B. Copy the fills of section 1076:2.

Anatomy is the same as every flow (00-system §4):
- a title (Title 1) and a status line;
- per row: a Refs · Mobbin card on the left (§7.4), then the frames (x 720 + n × 482, gap 80, labels 30 above in Footnote Emph `text/secondary`, notes 16 below), then a Micro-interactions card on the right;
- one Logic check card per section (§5.6).

Frame numbers run 10.01–10.40 across the three sections.

### 5.0 How to build a US frame (all three sections)
1. **Clone the named source frame.** Use a cross-page clone, then `section.appendChild(clone)`; reset x/y; never edit the source.
   - Rename the clone to the exact US name below. Keep its status-bar clock.
   - Write a new label above it, plus a one-line note below, e.g. "US: same logic as 02.08 · S1 card in $ and mi".
2. **Replace text.** Apply the global replacements (§5.1), then the frame's own list. Replace the longest strings first.
3. **Instance text is set through component properties.** Change TEXT properties on the instance with `setProperties`; for frame-local text nodes, replace `characters` (load the node's fonts first and keep mixed-style ranges, such as search highlights). The properties used here:

   | Component | TEXT properties |
   |---|---|
   | Map Pin | `Price#974:0` |
   | Stat Tile | `Label#986:28` · `Value#986:29` · `Unit#986:30` |
   | Hero Stat | `Caption#986:0` · `Value#986:7` · `Detail#986:14` |
   | Sheet Header | `Title#1008:0` · `Subtitle#1008:3` |
   | Connector Tile | `Title#1088:15` · `Subtitle#1088:18` · `Plug#1088:21` (swap) |
   | Vehicle Card | `Name#1094:20` · `Specs#1094:41` · `Plate#1094:62` |
   | Next Booking Card | `Station#1152:0` · `When#1152:5` · `Time#1152:10` · `Meta#1152:15` |
   | Estimate Card | tiles found by name ("Energy", "Cost", "Finishes") |
   | Charge Plan Bar | `Left label#1094:203` · `Right label#1094:207` |
   | Text Field | `Placeholder#1070:6` · `Value#1070:12` |
   | Toast | `Message#1088:0` |
   | Map Marker / Place | `Label#1201:0` |
   | Tab Bar Accessory | `Title#967:0` (+ its subtitle text) |
   | Charging Pass · Wallet | its TEXT props |
   | Region Price Card | `Price#1174:16` |
   | Price Range Bar | `Min#1174:0` · `Max#1174:1` |
   | List Row Type=Value | the nested TEXT "Value" (its default is "Jul 4, 2026") |
4. **Value-driven geometry doesn't override on instances.** The Charge Plan Bar, Level Slider and gauge arcs keep their values on instances: resize the named layers, or detach as 05.24 and 06.02 did. §5.3 lists the widths and angles.
5. **Check every frame.** Screenshot each frame at 0.5. Then search the US frames (10.01–10.34) for leftovers:
   `findAll(n => n.type === 'TEXT' && /Rs |\bkm\b|Lahore|Ayesha|BYD|MG ZS|Type 2|CCS ?2|GreenVolt|Gulberg|Model Town|Johar|DHA|Bilal|Usman/.test(n.characters))`
   - It must return nothing on 10.01–10.34. 10.35–10.40 keep Pakistani data on purpose: they show the Pakistan region.
   - Watch for overflow on:
     - the Live overline "CHARGING · GRANT STREET GARAGE CHARGER" (max 300; middle-truncate the station part);
     - "Tesla Model 3 Long Range · NACS (DC)" on a stacked pass (tail-truncate the name);
     - "1 h · Chevrolet Bolt EUV" on the Next Booking Card;
     - the map pill "Prices in US dollars · Rs 280 = $1 (dummy rate)";
     - the Hero Stat detail "Rs 286 · converted at Rs 280 = $1 (dummy rate)".

### 5.1 Global replacements (10.01–10.34; longest first)

| Pakistan | United States |
|---|---|
| Street 12, Block CCA, DHA Phase 5, Lahore | N Grant St, West Lafayette, IN 47906 |
| CHARGING · GREENVOLT · DHA PHASE 5 | CHARGING · GRANT STREET GARAGE CHARGER |
| GreenVolt · DHA Phase 5 | Grant Street Garage Charger |
| Main Boulevard, Gulberg III, Lahore · Main Boulevard, Gulberg III | State St, West Lafayette, IN 47906 |
| Gulberg Galleria Charger | Chauncey Square Fast Charge |
| Model Town, Lahore | Wabash Landing, West Lafayette, IN 47906 |
| Model Town Home Charger | Wabash Landing Home Charger |
| Johar Town, Lahore | Main St, Lafayette, IN 47901 |
| Johar Town Fast Hub | Downtown Lafayette Hub |
| Type 2 (AC) · Lahore | J1772 (AC) · West Lafayette |
| CCS2 (DC) · Lahore | CCS1 (DC) · West Lafayette (on the S4 card: CCS1 (DC) · Lafayette) |
| ayesha.khan@email.com | emily.carter@email.com |
| Ayesha Khan | Emily Carter |
| AK (avatar initials) | EC |
| 0301 2345678 · 0321 4567890 (as the driver's phone) | (765) 555-0142 |
| Bilal (avatar "B") | Sam (avatar "S") |
| Usman | Jake |
| BYD Atto 3 · LEB-2481 | Chevrolet Bolt EUV · PKP 482 |
| Type 2, CCS 2 · 60.5 kWh · Type 2 + CCS2 · 60.5 kWh | J1772, CCS1 · 65 kWh |
| Type 2, CCS 2 · 51 kWh | NACS · 82 kWh |
| BYD Atto 3 | Chevrolet Bolt EUV |
| MG ZS EV | Tesla Model 3 Long Range |
| LEB-2481 · LEA-9034 | PKP 482 · EV 2047 |
| Type 2 (AC) · 7.4 kW · Rs 42 / kWh | J1772 (AC) · 7.2 kW · $0.32 / kWh |
| CCS2 (DC) · 60 kW · Rs 68 / kWh | CCS1 (DC) · 62.5 kW · $0.48 / kWh |
| 7.4 kW · 60 kW · 11 kW · 30 kW (with the unit) | 7.2 kW · 62.5 kW · 9.6 kW · 150 kW |
| Type 2 (AC) | J1772 (AC) |
| CCS2 (DC) | CCS1 (DC) |
| CCS (DC) (chips, filter) | CCS1 (DC) |
| GB/T (chips, filter) | NACS |
| Rs 42/kWh · Rs 68/kWh · Rs 38/kWh · Rs 55/kWh | $0.32/kWh · $0.48/kWh · $0.28/kWh · $0.52/kWh |
| Rs 42 · Rs 68 · Rs 38 · Rs 55 (pins, stats, price slots with a separate "/kWh") | $0.32 · $0.48 · $0.28 · $0.52 |
| Rs 40 · Rs 45 (filler pins) | $0.30 · $0.35 |
| Rs 300 (with "/hr", state demo) | $2.00 |
| Rs 286 · Rs 577 · Rs 1,877 · Rs 2,468 | $2.12 · $3.71 · $13.80 · $18.72 |
| 1.2 km · 3.4 km · 5.1 km · 7.8 km | 0.6 mi · 1.1 mi · 1.8 mi · 2.9 mi |
| Today, Sat 4 Oct · TODAY · SAT 4 OCT | Today, Sat, Oct 4 · TODAY · SAT, OCT 4 |
| GV7-K42 · PP-2410-0482 | GS7-P31 · PP-US-2410-0731 |

Bare numbers (kWh like "6.8", percentages like "≈30%", tile values like "7.4", other amounts) are **not** safe to replace globally. They are listed per frame.

### 5.2 Flow 10A · US · Discover & search (13 frames)
Status line: "US edition · West Lafayette, IN · map, list, filters, search, station sheet · 13 frames · spec 10-us-locale.md".
Rows: 1 · Map (10.01–10.05) · 2 · Search (10.06–10.09) · 3 · Station (10.10–10.13).

| Frame (exact name) | Clone from (page · id) | Changes after §5.1 |
|---|---|---|
| **10.01 · Home · Map** | 02.06 · Home · Map: Flow 2 · Discover 946:8 · **1076:5** | Pins (`Price#974:0`): Rs 42 → $0.32 (Available) · Rs 68 → $0.48 (In use) · Rs 38 → $0.28 · Rs 55 → $0.52 (Unavailable) · Rs 40 → $0.30 · Rs 45 → $0.35. Cluster "24" stays. Chips (all unselected, Filters without a count): Filters · Available now · J1772 (AC) · CCS1 (DC) · NACS. Search capsule, heart, bell dot, Map Controls, user dot and attribution are unchanged. |
| **10.02 · Home · Map · Cluster opened** | 02.09: 946:8 · **1153:4642** | Pins as 10.01. Split filler pins use the rule $ = (N − 10) ÷ 100. Small clusters "8" and "10" stay. Chips as 10.01. |
| **10.03 · Home · Map · Station selected** | 02.08: 946:8 · **1153:4495** | Selected pin "$0.32" (Available selected). Station Card Map preview: "Grant Street Garage Charger" · Available · "N Grant St, West Lafayette, IN 47906" · plug ev.plug.ac.type.2 (stand-in) "J1772 (AC)" · "7.2 kW · Available" · "$0.32" "/kWh" · meta "4.8 · 0.6 mi". Buttons unchanged ("Details", "Book now"). Other pins as 10.01. |
| **10.04 · Home · Filter & sort** | 02.12: 946:8 · **1153:14902** | Sheet "Connector type": All · J1772 (AC) · CCS1 (DC) · NACS (relabel "Type 2 (AC)", "CCS (DC)" and "GB/T"). In-progress selection: "Available now" + "CCS1 (DC)"; sort Nearest; "Show results". Behind it, the chips (applied, default) and pins are as 10.01. |
| **10.05 · Home · List** | 02.15: 946:8 · **1162:2705** | Header "4 stations · Nearest first". Station Card List ×4: (1) Grant Street Garage Charger · Available · "J1772 (AC) · West Lafayette" · 4.8 · 0.6 mi · "$0.32/kWh" · (2) Chauncey Square Fast Charge · In use · "CCS1 (DC) · West Lafayette" · 4.6 · 1.1 mi · "$0.48/kWh" · (3) Wabash Landing Home Charger · Available · "J1772 (AC) · West Lafayette" · 4.9 · 1.8 mi · "$0.28/kWh" · (4) Downtown Lafayette Hub · Offline · "CCS1 (DC) · Lafayette" · 4.4 · 2.9 mi · "$0.52/kWh". Chips as 10.01. Note under the frame: "location line = city [US-P7]". |
| **10.06 · Search · Focused · Recents** | 03.02: Flow 3 · Search 1089:8867 · **1188:7020** | Recent: (1) Station "Grant Street Garage Charger" / "N Grant St, West Lafayette, IN 47906" · (2) Place "Purdue Memorial Union" / "N Grant St, West Lafayette, IN" · (3) Place "Wabash Landing" / "West Lafayette, IN". Saved chargers "3 saved". Nearby: "Chauncey Square Fast Charge" / "State St, West Lafayette, IN 47906" / "1.1 mi" · "Wabash Landing Home Charger" / "Wabash Landing, West Lafayette, IN 47906" / "1.8 mi" · "Downtown Lafayette Hub" / "Main St, Lafayette, IN 47901" / "2.9 mi". Sheet chips: Available now · J1772 (AC) · CCS1 (DC) · NACS. Map behind: pins as 10.01. |
| **10.07 · Search · Typing · Results for purdue** | 03.06: 1089:8867 · **1194:999** | Field value "purdue" (caret on). Delete the "Stations" header and its row, and move "Places" up into the Stations header's slot. Places ×4 (Search Result Row Place), per §4.9 "purdue". Highlight "Purdue" (characters 0–6) in each title with the Headline style (the rest stays Body). Google attribution stays under Places; keyboard unchanged. |
| **10.08 · Search · Typing · Results for state st** | 03.06: 1089:8867 · **1194:999** | Field "state st". Stations: "Chauncey Square Fast Charge" / "State St, West Lafayette, IN 47906" (highlight "State St" in the subtitle, Footnote Emph) / "1.1 mi". Places: delete the 4th row, then the three rows of §4.9 "state st", with "State St" highlighted in each title, mid-string included. |
| **10.09 · Search → Place · Purdue University** | 03.15: 1089:8867 · **1201:28308** | Map Marker / Place `Label#1201:0` "Purdue University". Search Field Filled/On map value "Purdue University". Pins: Rs 42 → "$0.32" (Available) · Rs 40 → "$0.30" · Rs 45 → In use "$0.48". Pill "3 stations nearby" unchanged; chips as 10.01. |
| **10.10 · Station · Sheet · Medium** | 04.01: Flow 4 · Station + Booking 1089:8868 · **1213:1599** | Sheet Header: "Grant Street Garage Charger" / "N Grant St, West Lafayette, IN 47906". Stats Row: Status "Available" · "36 reviews" 4.8 · Distance "0.6 mi" · Per kWh "$0.32". Connectors "1": Connector Row Available, plug ev.plug.ac.type.2, "J1772 (AC)" · "7.2 kW · Available" · "$0.32" "/kWh". Map pins as 10.01, "$0.32" selected. |
| **10.11 · Station · Sheet · Large** | 04.02: 1089:8868 · **1215:137** | As 10.10, plus the Host row: Avatar M "S" · "Sam" · "Charger host". Rating Summary "4.8" · "Based on 36 reviews". Photos unchanged. |
| **10.12 · Station · Sheet · In use (DC)** | 04.06: 1089:8868 · **1217:926** | Header: "Chauncey Square Fast Charge" / "State St, West Lafayette, IN 47906". Stats: "In use" · "21 reviews" 4.6 · "1.1 mi" · "$0.48". Connector Row In use, plug ev.plug.dc.ccs2 (stand-in for CCS1): "CCS1 (DC)" · "62.5 kW · In use" · "$0.48" "/kWh". Selected pin: In use "$0.48". |
| **10.13 · Station cards · Every US station** | 02.31: 946:8 · **1154:1272** (board) | One Station Card Map preview per row, each with a Caption 1 `text/secondary` label above. Rows 1–4 are S1–S4 (§4.3) with their status pill, address, plug, "{kW} kW · {status}", price "/kWh" and meta "★ · mi". S4 shows plug ev.plug.dc.ccs2, "CCS1 + NACS (DC)" and "150 kW · Offline". Rows 5–8 are S1 state demos: Maintenance · Paused (with the real paused line and Book now disabled) · hourly "$2.00" "/hr" · no price "Pricing unavailable". |

### 5.3 Flow 10B · US · Book & charge (13 frames)
Status line: "US edition · book a slot, plan with the Bolt EUV, charge, complete, receipt · 13 frames · spec 10-us-locale.md".
Rows: 1 · Book (10.14–10.17) · 2 · Plan (10.18–10.21) · 3 · Charge & finish (10.22–10.26). **No Currency Switch on any 10B frame** (US region).

| Frame (exact name) | Clone from (page · id) | Changes after §5.1 |
|---|---|---|
| **10.14 · Book a slot · Ready** | 04.27: 1089:8868 · **1233:7060** | Readout "6:00 → 7:00 PM" · "Today · 1 h" and the time grid (6:00 PM Selected) stay. VEHICLE row (Vehicle Card Layout=Row, Selected): Name "Chevrolet Bolt EUV · J1772 (AC)", Specs "Primary", "Change". Cost Footer: `Amount#1011:3` "$2.12", `Detail#1011:4` "Ends 7:00 PM"; CTA "Confirm booking". Station card in the sheet (if visible) per §5.1. Map behind: pins as 10.01. |
| **10.15 · Confirm booking** | 04.41: 1089:8868 · **1241:7576** | Confirm sheet (detached in the source, 1241:7797): Date "Oct 4, 2026", Time "6:00 – 7:00 PM" and Duration "1 hour" stay; Total "$2.12" (Display/S); estimate line unchanged. The receded Book sheet behind: Cost Footer "$2.12"; vehicle row as 10.14. |
| **10.16 · Booked · Pass appears · proposal** | 04.43: 1089:8868 · **1241:39237** | Pass: "Grant Street Garage Charger" · "Today, Sat, Oct 4" · "6:00 PM → 7:00 PM" · "1 h" · VEHICLE "Chevrolet Bolt EUV" · CONNECTOR "J1772 (AC)" · EST. TOTAL "$2.12". Sheet body: "We'll hold 6:00 to 7:00 PM for you at Grant Street Garage Charger." Info row and buttons unchanged. |
| **10.17 · Charge · Ready to start** | 05.01: Flow 5 · Charge + Planner 1089:8869 · **1154:15541** | Next Booking Card: Station "Grant Street Garage Charger", Time "6:00 → 7:00 PM", Meta "1 h · Chevrolet Bolt EUV"; "Ready to start" and "Starts in 10 min" stay. Shortcut row 3: "Chevrolet Bolt EUV" / "Your vehicle · J1772, CCS1 · 65 kWh". |
| **10.18 · Planner · Battery now · 20%** | 05.21: 1089:8869 · **1167:1642** | Hero "20%" stays. Line "≈12.1 kWh of 60.5 kWh" → "≈13.0 kWh of 65 kWh". Vehicle row (Vehicle Card Row): Name "Chevrolet Bolt EUV", Specs "J1772, CCS1 · 65 kWh", "Change". |
| **10.19 · Planner · Choose vehicle · Tesla doesn't fit** | 05.22: 1089:8869 · **1168:6036** | Behind: as 10.18. Sheet "Choose vehicle": row 1 "Chevrolet Bolt EUV" + Status Pill Neutral S "Primary" + "J1772, CCS1 · 65 kWh", selected (checkmark `icon/brand`). Row 2 is **disabled**: "Tesla Model 3 Long Range" / "NACS · 82 kWh", title and subtitle `text/tertiary`, no checkmark; third line Footnote `text/warning` with exclamationmark.triangle.fill 12: "Doesn't fit this charger (J1772 (AC))" (the logic's pattern). Footer "Add vehicle". If the source's hidden third demo row is the disabled style, reuse it for the Tesla. |
| **10.20 · Planner · By time · Until 7:00 PM** | 05.23: 1089:8869 · **1178:1994** | Hero caption "Battery at 7:00 PM"; value "≈31%" → "≈30%". Charge Plan Bar: Start 0–20% = 74pt, Added 20–30% = **37pt** (was 41); `Right label` "+10% est.". Summary (plug ev.plug.ac.type.2): "Grant Street Garage Charger" / "J1772 (AC) · 7.2 kW · $0.32 / kWh". Chips unchanged ("Until 7:00 PM" selected). Estimate Card: Energy "6.6" "kWh" · Cost "$2.12" "" · Finishes "7:00" "PM". Footnotes unchanged. Beside the frame: the §4.5 maths notes card. |
| **10.21 · Planner · DC fast · Target 80%** | 05.29: 1089:8869 · **1181:2909** | Hero caption "Battery at 6:40 PM" → "Battery at 6:41 PM"; value "≈80%"; bar 20 → 80 and its labels stay. Summary (plug ev.plug.dc.ccs2, CCS1 stand-in): "Chauncey Square Fast Charge" / "CCS1 (DC) · 62.5 kW · $0.48 / kWh". Level Slider Target 80%, preset "80%" and "DC charging slows down above 80%." stay. Estimate: Energy "39.0" kWh · Cost "$18.72" · Finishes "6:41" PM. Reminder line: "We'll remind you at about 6:41 PM." Canvas note: "Time 30 min on this charger → 28.8 kWh · ≈64% · $13.80". |
| **10.22 · Live · Charging (6:32 PM)** | 06.02: Flow 6 · Live + Complete 1089:8870 · **1194:26024** | Overline "CHARGING · GRANT STREET GARAGE CHARGER". Gauge "≈25%" + "est. battery". Ring (frame-local arcs, 3.6° per %): start 0 → 20% white 40% · so far 20 → 25% `energy` (18°) · planned 25 → 30% dotted (18°) · target dot at 30%. Hero Stat "28:00" / "Ends 7:00 PM" stays. Tiles: Energy "3.5" kWh · So far "$1.13" · Power "7.2" kW. Session Progress: header "Plan · until 7:00 PM" / "≈30% · $2.12 est."; fill 53%; labels unchanged. Tip and Stop unchanged. |
| **10.23 · Home · Map · Charging** | 02.13: 946:8 · **1153:15097** | Pins and chips as 10.01. Accessory `Title#967:0` "Charging · ≈25%", subtitle "28:00 left · $1.13". |
| **10.24 · Live · Ending soon (6:55 PM)** | 06.06: 1089:8870 · **1195:299** | Overline as 10.22. Gauge "≈29%" (so far 20 → 29%, planned 29 → 30%). Hero "5:00" / "Ends 7:00 PM". Tiles "6.0" kWh · "$1.94" · "7.2" kW. Session Progress Ending: fill 92%, pill "Ending soon". Inline Notice "Charging stops automatically at 7:00 PM." unchanged. |
| **10.25 · Complete · Summary (7:00 PM)** | 06.30: 1089:8870 · **1216:1598** | Session Summary Card: Hero Stat Value "$2.12", Detail **"6.62 kWh × $0.32/kWh"**. Tiles: Battery "≈30%" "est." · Energy "6.6" "kWh" · Time "1 h 00" "min". Place row: "Grant Street Garage Charger · 6:00 – 7:00 PM". Rate card, Done and Download receipt unchanged. |
| **10.26 · Receipt · Saved image (artefact)** | 06.36: 1089:8870 · **1222:2214** | Tiles: Battery "≈30%" est. · Energy "6.6" kWh · Total "$2.12". Rows per §4.7: duplicate the Connector row to make the new **Energy "6.62 kWh"** row after it. Footer unchanged. The card grows by one row (≈ 22pt); keep it centred. |

### 5.4 Flow 10C · US · Bookings, profile & currency (14 frames)
Status line: "US edition (10.27–10.34) + Region & currency and the Rs ⇄ $ switch on Pakistan-region screens (10.35–10.40) · 14 frames · spec 10-us-locale.md".
Rows: 1 · Bookings & profile (10.27–10.32) · 2 · Region & currency (10.33–10.35) · 3 · Rs ⇄ $ switch, Pakistan region (10.36–10.40). Build the **Currency Switch** (§1.4) before row 3.

| Frame (exact name) | Clone from (page · id) | Changes after §5.1 |
|---|---|---|
| **10.27 · Bookings · Upcoming · Ready to start** | 07.01: Flow 7 · Bookings 1089:8871 · **1250:2** | Front pass P-A: "Ready to start" · "Starts in 10 min" · "Grant Street Garage Charger" · "TODAY · SAT, OCT 4" · "6:00 PM" → "7:00 PM" · "1 h" · footer "Chevrolet Bolt EUV" / "J1772 (AC)" / "$2.12". "Scan to start" and its footnote stay. "Later": P-B and P-C per §4.8 (stacked passes: "{When}", "{amount}", "{vehicle · connector}"). |
| **10.28 · Bookings · Cancelled** | 07.08: 1089:8871 · **1255:1087** | "October": Cancelled 1. "September": Cancelled 2, 3, 4 (§4.8), with the same pills as Pakistan (Neutral "Cancelled by you", Error "Cancelled by host", Warning "Expired", Neutral "Cancelled"). Cancelled 3's row 3 reads "No session started · Chevrolet Bolt EUV". |
| **10.29 · Profile · Default** | 08.01: Flow 8 · Profile + Vehicles 1089:8872 · **1201:6** | Profile Header Card: Avatar XL Mesh "EC" · "Emily Carter" · "emily.carter@email.com"; stats stay (12 · — · 3). Row 1 subtitle: "Chevrolet Bolt EUV · Primary". |
| **10.30 · My vehicles · Default** | 08.30: 1089:8872 · **1205:29871** | Card 1 (Primary): `Name` "Chevrolet Bolt EUV", `Specs` "J1772, CCS1 · 65 kWh", `Plate` "PKP 482". Card 2: "Tesla Model 3 Long Range", "NACS · 82 kWh", "EV 2047". Footnote unchanged. |
| **10.31 · Add vehicle · Empty · US plugs** | 08.39: 1089:8872 · **1222:4350** | Placeholders: Brand "e.g., Tesla" stays (real copy); Model "e.g., Atto 3, Model 3" → "e.g., Bolt EUV, Model 3"; Plate "e.g., LES-1234" → "e.g., ABC 1234". Connector Tiles (Selected=No): (16,338) "J1772" / "AC · common" / plug 981:294 · (209,338) "CCS1" / "DC · fast" / 1024:482 · (16,466) "NACS" / "Tesla · AC + DC" / 1024:478 · (209,466) "CHAdeMO" / "DC" / 1024:484. Re-fill each plug's Symbol `icon/brand` after the swap. |
| **10.32 · Add vehicle · Filled · Tesla** | 08.41: 1089:8872 · **1223:2467** | Tiles as 10.31; NACS is Selected=Yes, the others No. Battery Value "51" → "82" (suffix kWh). Plate "LEA-9034" → "EV 2047". "Set as primary vehicle" Off. |
| **10.33 · Account & settings · United States** | Use **08.16** if 8E has built it (it already has the new row). Otherwise use 08.28: 1089:8872 · **1231:3945**: delete its Toast and add the row per §6.1 | Avatar card "EC" · "Emily Carter" · "emily.carter@email.com". Phone subtitle "(765) 555-0142" + "Verified"; Number plate "PKP 482"; Language "English"; **Region & currency** subtitle "United States · US dollars". |
| **10.34 · Region & currency · United States** | 08.62 if built; otherwise build per §6.2, starting from a clone of 08.28 with its content removed (this keeps the Nav Bar overrides and the group styling) | US-region version, §6.2. |
| **10.35 · Region & currency · Pakistan · US dollars** | 08.63 if built; otherwise build per §6.2 | Identical to 08.63; the screen holds no personal data. |
| **10.36 · Planner · Estimate in rupees (Pakistan region)** | 05.23: 1089:8869 · **1178:1994** | Pakistani data unchanged. Add the Currency Switch `Currency=PKR` at the Estimate Card's top-right (§1.4). |
| **10.37 · Planner · Estimate in US dollars (Pakistan region)** | 10.36 | Switch `Currency=USD`. Cost tile "Rs 286" → **"≈$1.02"**. Summary subtitle → "Type 2 (AC) · 7.4 kW · ≈$0.15 / kWh". Footnote: line 1 "Estimate. The charger's meter decides the final amount." · line 2 "Charging stops on its own when your slot ends at 7:00 PM." · **line 3 "Converted at Rs 280 = $1 (dummy rate). You pay Rs 286."** (Footnote `text/secondary`, at least 12pt above Slide to start; if it doesn't fit, drop line 2 in this frame and say so in the note). Canvas motion strip: "Rs 286 → ≈$1.02 · roll 220 ms · selection haptic". |
| **10.38 · Price Trends · US dollars (Pakistan region)** | 02.25: 946:8 · **1177:2896** | The context row "LAHORE · LAST 7 DAYS" / "Updated 6:30 PM" stays. Trend Chart Card: Currency Switch `USD` at its top-right; Avg Value "≈$0.169", Detail "per kWh"; y-axis "Rs 46 / 47 / 48 / 49" → "$0.164 / $0.168 / $0.171 / $0.175". Bars and the avg line keep their geometry (the conversion is linear). New Footnote `text/secondary` 8 below the card: **"Converted at Rs 280 = $1 (dummy rate). Hosts charge in rupees."**; move "By Region" and the cards down by its height. Region Price Card 1 (Model Town): `Price` "≈$0.137", range `Min` "$0.121" `Max` "$0.157" (marker unchanged). Card 2 (DHA), peeking: "≈$0.150", "$0.136"–"$0.171". First-use Toast Neutral, bottom edge 828 (§1.5-A4). |
| **10.39 · Complete · US dollars (Pakistan region)** | 06.30: 1089:8870 · **1216:1598** | Currency Switch `USD` at the Session Summary Card's top-right. Hero Stat Value **"≈$1.02"**, Detail **"Rs 286 · converted at Rs 280 = $1 (dummy rate)"**. Tiles (≈31% · 6.8 kWh · 1 h 00 min) and the place row unchanged. |
| **10.40 · Home · Map · US dollars (Lahore)** | 02.06: 946:8 · **1076:5** | Pins: Rs 42 → "≈$0.15" · Rs 68 → "≈$0.24" · Rs 38 → "≈$0.14" · Rs 55 → "≈$0.20" · Rs 40 → "≈$0.14" · Rs 45 → "≈$0.16". Chips unchanged (Pakistani plugs). Map Status Pill Notice at the shared anchor y 116, centred, Surface = Frost Strong, glyph recoloured `icon/secondary` (02.32 note): **"Prices in US dollars · Rs 280 = $1 (dummy rate)"**; it leaves after 2.5 s. |

### 5.5 Micro-interactions cards (one per row)
- **10A rows** take the 02, 03 and 04 cards; restate them in one line each and add the US deltas:
  1. VoiceOver reads "$0.32 per kilowatt-hour" as "32 cents per kilowatt-hour" and "0.6 mi" as "0.6 miles".
  2. The J1772 (AC) · CCS1 (DC) · NACS chips mirror the sheet (03 §4.12): connectors are single-select · selection haptic · "Loading…" pill after 300 ms.
  3. US keywords (§3): "tesla" or "nacs" shows the suggestion row "Show NACS chargers" (stand-in icon ev.charger) plus the NACS stations.
  4. "purdue" returns places only; the Stations header hides with `fade.quick`.
  5. Mid-string matches are highlighted in place ("State St" inside "State St & N Grant St"): titles Medium, subtitles Footnote Emph.
  6. Home chargers show the area only until booked [US-P8].
- **10B rows** take the 04, 05 and 06 cards, plus:
  1. Dollar values `roll` by the cent; "$" never moves.
  2. Live dollars floor to the cent and roll about every 17 s.
  3. The disabled Tesla row has no press and no haptic. VO: "Tesla Model 3 Long Range, dimmed. Doesn't fit this charger, J1772."
  4. The Complete total counts up from $0.00 to $2.12 (`count` 700 ms, cents roll last); its detail line fades in after it (`fade.std`).
  5. The receipt image is saved in dollars (native).
- **10C row 1** takes the 07 and 08 cards, plus:
  1. US tiles order: J1772 · CCS1 · NACS · CHAdeMO. Selecting NACS plays selection.
  2. US phone fields use `.phonePad` and auto-format to "(765) 555-0142" as you type.
- **10C rows 2 and 3** = §1.5 B and A.

### 5.6 Logic check card (one per section)
- **COVERED**: the same screens and states as the cloned Pakistani frames. The US edition changes data, formats, plug names and currency only; the logic is unchanged.
- **REAL COPY**: kept verbatim ("Book now", "Confirm booking", "Doesn't fit this charger ({plug})", "Charging complete", "Your vehicle is ready to go", "Stopping under 80% helps your battery last longer.", etc.).
- **NEW COPY**: US formats (§2), place and person names (§4), the Region & currency strings (§6.2), the conversion note and the switch Toast (§1.5).
- **FLAG — PROPOSALS** (title `text/brand`):
  - 10A: US-P4, US-P5, US-P7, US-P8, US-P15
  - 10B: US-P4, US-P5, US-P9, US-P10, US-P11, US-P12
  - 10C: US-P1, US-P2, US-P3, US-P6, US-P13, US-P14, US-P16
  - Every section: the missing symbols (§8)
- **DUMMY DATA**: the US dataset in §4. "Rs 280 = $1" is a dummy rate. The streets and Purdue landmarks are real; the stations, hosts, people, plates, prices and ratings are fictional.
- **FOR RAYAN**: the §9 items relevant to the section.

---

## 6. Additions to Flow 8E · Profile · Account & settings (page 1089:8872)

### 6.1 The new row in Account & settings
Add it to **08.16 · Account & settings · Default** and to every 8E frame drawn from it (08.16b, 08.17, 08.19, 08.20, 08.21, 08.22). It is the fourth row of the ACCOUNT group, after Language:
- `List Row` Type=Navigation (Trailing=Chevron) 983:339, Icon on, `Icon glyph` creditcard 1025:494 (wanted `dollarsign.arrow.circlepath`, FLAG), Title **"Region & currency"**, Subtitle **"Pakistan · Rupees"**, Separator off. Language's separator turns on.
- **Layout**:
  - ACCOUNT group (16,254), 370×256, ends at 510.
  - "PREFERENCES" header at (16,534); its group at (16,562), ends at 754.
  - Delete account group at (16,778), ends at 842. It runs under the home indicator because the list scrolls; add the bottom Scroll Edge Fade from y 760, as 08.01 does.
- **States**: 08.16b keeps "Pakistan · Rupees". In 08.17 Loading the subtitle is a Skeleton Block 120×12. 08.18 (error) has no rows.
- **Subtitle values**: "Pakistan · Rupees" · "Pakistan · US dollars (≈)" · "United States · US dollars".
- **Consistency**: add the same row to **08.28 · Edit profile · Saved** (1231:3945, section 8D), with the same group shift.
- VO: "Region & currency, Pakistan, Rupees, button".

### 6.2 New frames (all Mesh Quiet; status bar Dark; `Nav Bar` Inline at (0,54), Title "Region & currency", Leading on with chevron.left; content from y 122; home indicator Dark; no bottom button, because selections apply at once)

| Frame (exact name) | Layout and copy |
|---|---|
| **08.62 · Region & currency · Pakistan** | See "08.62 layout" under this table. |
| **08.63 · Region & currency · US dollars shown** | 08.62 with "US dollar" Selected and "Pakistani rupee" not selected. Everything else is identical: the subtitles are previews and don't change. Canvas note: "Applies at once. The Account & settings row now reads 'Pakistan · US dollars (≈)'. Every rupee amount in the app shows as ≈$ with the conversion note; receipts stay in rupees + one ≈ line." |
| **08.64 · Region & currency · Switch to United States** | 08.62 + `bg/scrim`; the "United States" row shows its pressed highlight under the scrim. `Alert` two buttons side by side: use Destructive/Side by side 1014:561 relabelled, with the right label recoloured `text/brand` (the 02.04 recipe, 1162:2006); this is not destructive. Title **"Switch to the United States?"** · message **"You'll see chargers in the United States, with prices in US dollars and distances in miles. Your bookings in Pakistan stay in Bookings."** · buttons **"Cancel"** (left) / **"Switch"** (right, preferred). |
| **08.65 · Region & currency · While charging** | 08.62 with the REGION group at 40% opacity (not tappable). An `Inline Notice` (C17 1117:2083) Tone=Neutral, plain style, 370×48, replaces the region footnote at (16,286): info.circle + **"Finish charging to change your region."** The SHOW PRICES IN group stays enabled. Pushed screens hide the accessory (00-system §1.4); the note under the frame says "a session is active". |

**08.62 layout** (top to bottom):
1. `List Group Header` 983:389 **"REGION"** at (16,122).
2. Frost Strong group at (16,150), 370×128: radius lg 22, Frost/Card, 1pt `stroke/highlight`. Two `List Row` Type=Select (C18), Icon off:
   - **"Pakistan"** / Subtitle **"Rupees · km · Type 2, CCS2, GB/T"**, Selected=Yes (checkmark `icon/brand`).
   - **"United States"** / **"US dollars · miles · J1772, CCS1, NACS"**, Selected=No, Separator off.
3. Footnote `text/secondary` at (16,286), w 370: **"Your region sets the chargers you see, the currency hosts charge in, distances and plug names."**
4. `List Group Header` **"SHOW PRICES IN"** at (16,346).
5. Group at (16,374), 370×128:
   - **"Pakistani rupee"** / **"Rs 42/kWh · exact"**, Selected=Yes.
   - **"US dollar"** / **"≈$0.15/kWh · converted"**, Selected=No.
6. Footnote at (16,510): **"Converted at Rs 280 = $1 (dummy rate). You always pay hosts in rupees."**

**US-region version** (used by 10.34; also the result of 08.64 → Switch):
- REGION: "Pakistan" not selected, "United States" Selected=Yes; the same footnote.
- "SHOW PRICES IN": one `List Row` Type=Value 983:352, Icon off, Title **"US dollar"**, Subtitle **"$0.32/kWh · exact"**, Value **"USD"** (`text/secondary`; override the nested "Value" text), no chevron, not tappable, Separator off.
- Footnote: **"Hosts in the United States charge in US dollars, so prices are never converted."**
- Reverse alert: **"Switch to Pakistan?"** / **"You'll see chargers in Pakistan, with prices in rupees and distances in kilometres. Your bookings in the United States stay in Bookings."** / "Cancel" · "Switch".

**Toasts** (Toast 1088:631 Success, bottom edge 828): "Region set to United States" · "Region set to Pakistan".

### 6.3 8E rows, docs and logic
- **Row order** (12 frames, ≤ 14):
  1. Account & settings: 08.16 · 08.16b · 08.17 · 08.18 · 08.19
  2. **Region & currency: 08.62 · 08.63 · 08.64 · 08.65**
  3. Delete account: 08.20 · 08.21 · 08.22
- **Row 2 Refs · Mobbin card**: §7.1.
- **Row 2 Micro-interactions card**: §1.5 B, rows 1–8.
- **Logic check additions**: "NEW FEATURE (Hammad's request, 2026-10-04); not in the logic map" → US-P1, US-P3, US-P6; missing symbol `dollarsign.arrow.circlepath`; all Region & currency copy is new.

---

## 7. Mobbin references (iOS; images reviewed)

### 7.1 Region & currency settings (8E row 2 · 10C row 2)
- **Phantom — Preferences (Display Language · Currency)** · https://mobbin.com/screens/5037e4db-971d-4b16-a9d3-66d13fd4c8bf — What we take: Language and Currency sit together as value rows in one group. Our "Region & currency" row goes right under "Language".
- **MoonPay — Preferences: Currency "EUR"** · https://mobbin.com/screens/f0367201-1f23-46b2-a0d9-7fb6fc049fae — What we take: an icon-well row with a short current value and a chevron. Ours uses the subtitle "Pakistan · Rupees".
- **Cash App — Display currency** · https://mobbin.com/screens/61e380fa-2c55-4901-9cdb-a79c148e46e8 — What we take: just two display options, each with a one-line conversion preview under its name. Ours: "Rs 42/kWh · exact" and "≈$0.15/kWh · converted".
- **Etsy — Currency with "$ Device Default" checked** · https://mobbin.com/screens/7b560011-da63-46cf-a7cd-d8cd7eee4abe — What we take: the default follows where you are. Our currency defaults to the region's.
- **Apple Store — Country or Region ("Default: Use my billing address")** · https://mobbin.com/screens/487c7f4c-9913-4ea6-875a-42f63cb796cb — What we take: a short region list with a checkmark and one plain line about the default.
- **GOAT — Currency ("Purchases will transact in your selected currency. Offers and selling are available in USD only.")** · https://mobbin.com/screens/a9419b30-ffc7-481a-969b-8a674172a287 — What we take: one sentence saying which currency money actually moves in. Our "You always pay hosts in rupees." and "…so prices are never converted."
- **Agoda — Price display ("Suggested currencies")** · https://mobbin.com/screens/f33fbf8d-a11a-4158-82ce-3d5bbe16f9a0 — What we take: the currency that matches where you are comes first.
- **UNIQLO — "Switching country" alert** · https://mobbin.com/screens/0114302a-9286-47dd-92f7-d0ba74c6f22c — What we take: say what changes before a region switch. Our alert names the chargers, dollars and miles, and what stays.
- **UNIQLO — Settings: Country row** · https://mobbin.com/screens/1a3b48ee-1033-4a59-9d15-10aefc51a0b2 — What we take: the region as the row's second line.
- **Etsy — "Confirm Currency" alert** · https://mobbin.com/screens/26200133-3bbb-4c93-98c8-0a968370df35 — What we take: a native two-button confirm that names both sides. We confirm the region change only.
- **Airalo — "Change to Pound sterling (GBP) £?"** · https://mobbin.com/screens/23d798af-69d7-42f4-9ed3-b851e3ccf3b1 — What we take (counter-example): confirming a *display* currency is friction. Ours applies at once and is reversible.

### 7.2 Two currencies and the quick switch (10C row 3)
- **Fly Delta — fares with "USD · Miles · Miles + Cash" segments** · https://mobbin.com/screens/650052e4-fa2a-4562-b994-de2f60dfb427 — What we take: one segmented control re-prices every number on a price-heavy screen. Our Rs ⇄ $ switch.
- **Tesla — Charge Stats ("Cost" card with a "Per kWh" toggle top-right)** · https://mobbin.com/screens/f332f73c-408f-46ec-9201-de21fdd6cfb2 — What we take: the toggle sits at the top-right of the card it changes. Same place on the Estimate, Price Trends and Complete cards.
- **Revolut — Spend from (US$1.49 above $1.98)** · https://mobbin.com/screens/fc569ad6-a597-46c5-a9dd-c328ff695ebd — What we take: an amount and its converted twin stacked, the secondary in grey. Our total + "Rs 286 · converted at…" detail.
- **Revolut — Buy Gold "$2" with a swap chip beside the amount** · https://mobbin.com/screens/ee690326-d4bb-49d6-9d4d-2019ed56efe5 — What we take: flip the display currency right next to the number. We label both sides (Rs ⇄ $) so the state is readable and works with VoiceOver.
- **Wise — "You send 5.00 SGD / gets 65,959 VND" with the rate chip "1 SGD = 20,109.40 VND"** · https://mobbin.com/screens/e3c2f498-d3fb-4f94-b01e-6a45f6b5b093 — What we take: the rate stated once, compactly, above the money. Our one conversion note per screen.
- **Wise — Review your Auto Conversion details ("Estimated total to convert 1.02 SGD")** · https://mobbin.com/screens/f990eb35-85c9-41e4-9a75-4f11cd79e79c — What we take: converted totals are labelled as estimates. Our "≈".
- **Apple Wallet — transaction (Local Amount $7.90 · Exchange Rate 0.789 · Total US$6.23)** · https://mobbin.com/screens/3b29e0d1-9ce1-4b0b-83aa-d394a3de3017 — What we take: a record keeps the local amount and lists the rate and the converted total as their own rows. Our receipt stays in rupees + one "≈ $" line.
- **Agoda — Total Price + "Your currency selections affect the prices charged or displayed to you"** · https://mobbin.com/screens/7840360c-bc61-443f-8f1b-b5e0398d1b62 — What we take: a plain note near the total that the currency on screen is a choice.
- **Freenow — "You'll pay around 21–32€"** · https://mobbin.com/screens/2cfe689b-2070-4b61-b445-10fd61053f5b — What we take: the approximation is stated next to the amount. Ours is "≈" + the note.

### 7.3 US EV charging and US formats (10A, 10B, 10C row 1)
- **Shell Recharge — Chicago map with chips and a station card (CCS / CHAdeMO, "– mi")** · https://mobbin.com/screens/7286b6e1-5c70-4e37-9361-c4d294176a83 — What we take: US connector names and miles on map cards and chips. Our J1772 / CCS1 / NACS chips.
- **Chime — Chicago map with "$2.96" pins, card "1.3 miles"** · https://mobbin.com/screens/f2f4eb32-521b-49de-a5ca-cfe1c31e1287 — What we take: dollar pins with cents read well at pin size.
- **Tesla — Nearby Chargers ("$0.66/kWh · 250 kW max")** · https://mobbin.com/screens/3351f028-dab2-46f9-b92b-e6c7ecd01634 — What we take: "$0.66/kWh" with cents and no spaces. Our rate format.
- **Pangea Charging — Tesla charger sheet ("Chargers NACS", "325 S Michigan Ave", "3 Stalls · 6 kW")** · https://mobbin.com/screens/9bb1751a-e251-4941-ad4e-5b2ce4b3c44f — What we take: NACS named as the connector on a US charger, with a US street line.
- **Pangea Charging — Nearby list ("0.2mi", "$0.00/kWh")** · https://mobbin.com/screens/ff5e97bd-3239-44ba-bae1-1694d838940e — What we take: list rows carry miles. Our list cards.
- **Pangea Charging — connector tiles (NACS, CCS, J1772, CHAdeMO)** · https://mobbin.com/screens/13378ba3-c301-412f-b020-42c97f191097 — What we take: the four US plugs as tappable tiles. Our US Connector Tile grid (also cited by 08).
- **Shell Recharge — station pricing ("$1.49 + $0.39/kWh · Idle fee $1/minute")** · https://mobbin.com/screens/03a69161-0568-4a8e-8bad-1c6a206ac275 — What we take: US prices can stack a session fee and idle fees. An open question [US-P12]; v1 shows per kWh or per hour only.
- **Lyft — "State St & Harrison St" station sheet** · https://mobbin.com/screens/97cfdcb8-09b7-42c8-8992-251acd1aa82b — What we take: US intersections as place titles. Our "State St & N Grant St".
- **Subway — Nearby ("0.3 MI · 809 Santa Cruz Ave · Menlo Park, CA 94025")** · https://mobbin.com/screens/8d318daf-33fc-44f9-977a-0cde6fc86e7c — What we take: a street line + "City, ST ZIP". Our addresses.
- **Tesla — Charging ("$8.18 · 13.6440 kWh @ $0.60/kWh")** · https://mobbin.com/screens/b42e1fcd-d26b-4e32-b486-a08401880814 — What we take: a big total with one exact formula line. Our Complete hero "$2.12 · 6.62 kWh × $0.32/kWh".
- **Tesla — Charging Session details ("Charging Fees 13.6440 kWh @ $0.60/kWh $8.18 · Energy Delivered · Session Time")** · https://mobbin.com/screens/01bb5bc5-a5d5-45cd-a253-a66b3b6699e1 — What we take: billing lines carry enough kWh precision to multiply out to the cent. Our 2-decimal rule and receipt Energy row.
- **Shell Recharge — Charging… ("Estimated charging cost $0.00 · Final price may include additional fees · Energy 0.00 kWh")** · https://mobbin.com/screens/57d1f042-956b-4c98-83df-999c766c231e — What we take: an estimate disclaimer beside a live dollar amount, cents always shown. Our "$0.00" start and estimate line.
- **Polestar — Charge ("33% 65 mi")** · https://mobbin.com/screens/fbcf0b2e-ad96-43c4-ae45-6756da69bc33 — What we take: US EV apps speak miles. We keep battery as % only (no range promise).
- **Yami — US address form (City Menlo Park · State CA · Phone US +1 (650) 213-7552)** · https://mobbin.com/screens/ab120018-601b-4160-982d-3f5fa0bc55a3 — What we take: US phone "(650) 213-7552" with +1, and the City / State / ZIP order. Our "(765) 555-0142".
- **Mindtrip — Filters ("1 mile · 3 miles · 10 miles · 30 miles")** · https://mobbin.com/screens/5d9e3f12-c4cd-45e7-8525-01add98b897b — What we take: whole miles from 10 up. Our distance rule.

### 7.4 Which refs go on which card (at least 3 per row)

| Row | Refs |
|---|---|
| 10A row 1 · Map | Shell Recharge map · Chime · Tesla Nearby · Mindtrip |
| 10A row 2 · Search | Lyft · Subway · Pangea Nearby |
| 10A row 3 · Station | Pangea Tesla sheet · Shell pricing · Tesla Nearby |
| 10B row 1 · Book | Shell Charging… · Tesla Charging · Pangea Tesla sheet |
| 10B row 2 · Plan | Pangea connector tiles · Polestar · Shell Charging… |
| 10B row 3 · Charge & finish | Tesla Charging · Tesla Charging Session · Apple Wallet · Shell Charging… |
| 10C row 1 · Bookings & profile | Yami · Pangea connector tiles · Subway |
| 10C row 2 · Region & currency | Phantom · MoonPay · Cash App · Etsy (Device Default) · Apple Store · GOAT · UNIQLO (switching) |
| 10C row 3 · Switch | Fly Delta · Tesla Charge Stats · Revolut ×2 · Wise ×2 · Apple Wallet · Agoda (total) · Freenow |
| 8E row 2 | all of §7.1 |

---

## 8. Proposals (for the FLAG — PROPOSALS blocks)

| ID | Proposal | Drawn in |
|---|---|---|
| US-P1 | **Region & currency** (Hammad's request): a Settings row + pushed screen. Region and display currency are stored on the account; the default comes from location + device region; the region is locked while a session is active | 08.16, 08.62–08.65, 10.33–10.35 |
| US-P2 | **Rs ⇄ $ switch** on three money cards (planner Estimate Card, Price Trends chart card, Complete summary card), Pakistan region only. It writes the global setting; first use posts a one-time Toast | 10.36–10.39 |
| US-P3 | **Conversion rules.** PKR → USD only; "≈" on converted amounts; one note per screen with "(dummy rate)"; the native amount always visible on totals; receipts stay native + one "≈ $" line; a real rate source with a timestamp later; fallback when rates are unavailable | 10.37–10.40, 08.62 |
| US-P4 | **US formats.** Money with cents; rates with 2 decimals, averages with 3; miles and feet; US phone, plate, date and address; 2-decimal kWh in USD billing lines | all 10x |
| US-P5 | **US plug catalogue.** J1772 (= Type 1), CCS1, NACS, CHAdeMO; "CCS1" spelled one way; US tiles, chips, filter and search keywords. CHAdeMO in the filter later | 10.01, 10.04, 10.31, 10.32 |
| US-P6 | **Region switch alert**, the "Region set to …" Toast, and the lock "Finish charging to change your region." | 08.64, 08.65 |
| US-P7 | **List-card location line = the city.** The logic's last comma segment is "IN 47906" for US addresses | 10.05 |
| US-P8 | **Home chargers show the area only** (no street) until booked. Also worth applying to Pakistan | 10.06, 10.13 |
| US-P9 | **Receipt numbers per market** ("PP-US-…") and an "Energy 6.62 kWh" row on US receipts | 10.26 |
| US-P10 | **Adapters** ("I carry an adapter": NACS ⇄ J1772, CCS1 → NACS) so a Tesla can book J1772 hosts. Not designed; 10.19 shows today's logic | 10.19 (note) |
| US-P11 | **Estimates cap power at the car's maximum.** The Bolt EUV peaks at ≈ 55 kW DC, so a 62.5 kW charger delivers less than the dummy maths assumes (the same gap exists in Pakistan) | 10.21 (note) |
| US-P12 | **Open questions on US pricing**: session fees, idle fees, per-minute pricing, and sales tax on receipts | Logic card |
| US-P13 | **Rupee display inside the US region**, e.g. for Pakistani students at Purdue. Off in v1 (US prices are never converted); the model allows it later | Logic card |
| US-P14 | **Press and hold any "≈$" amount** to see the rupee price (context menu). Not drawn | Logic card |
| US-P15 | **After a region switch, Home centres on the region's home city** when you are outside that country ("Showing West Lafayette" pill) | Micro card |
| US-P16 | **US Add vehicle placeholders**: "e.g., Bolt EUV, Model 3" and "e.g., ABC 1234" | 10.31 |

**Missing symbols** (FLAG on every section that uses them): `ev.plug.ac.type.1` (stand-in ev.plug.ac.type.2 981:294) · `ev.plug.dc.ccs1` (stand-in ev.plug.dc.ccs2 1024:482) · a NACS glyph (stand-in ev.charger 1024:478) · `ev.plug.dc.chademo` (stand-in ev.plug.dc.gb.t 1024:484) · `dollarsign.arrow.circlepath` (stand-in creditcard 1025:494).

---

## 9. For Rayan (implementation notes, not drawn)
1. **Data.**
   - `user.region` ∈ {PK, US} and `user.displayCurrency` ∈ {PKR, USD} live on the account. displayCurrency is forced to USD when region = US.
   - Every price, booking and session carries its native `currency`.
   - Store money as integer minor units with a currency code: whole rupees for PKR, cents for USD.
2. **Formatting.**
   - PKR: `NumberFormat.currency(locale: 'en_PK', symbol: 'Rs ', decimalDigits: 0)`.
   - USD: `NumberFormat.simpleCurrency(locale: 'en_US')`.
   - Converted values: prefix "≈". Averages in USD: 3 decimals.
   - Compute money from unrounded kWh; show 2-decimal kWh in USD billing lines.
3. **Conversion.** PKR → USD only. The rate is backend config (dummy 280) with a timestamp; the UI shows "(dummy rate)" until it's real.
4. **Units.** mi = km × 0.621371; 1 decimal; feet under 0.1 mi; whole miles from 10.
5. **Connectors.**
   - Add CCS1 and NACS to the enum, plus a J1772 label alias for TYPE_1; station connectors carry AC/DC.
   - Add vehicle tiles depend on the region; vehicle compatibility is unchanged (shared plug).
6. **Lists.** The card location line uses the city for US addresses, not the last comma segment.
7. **Search.**
   - Google Places with `components=country:us` (or `pk`) by region.
   - US keyword map (§3).
   - Name/address match is unchanged, so "purdue" finds places only.
8. **Phone.** Store E.164; display in the number's own national format; new numbers validate by region (US 10 digits, auto-format).
9. **Region.** Default from location, then the device region. Block switching while a session is active. Reset displayCurrency on switch. Re-centre Home on the region's city when you are outside it.
10. **Receipts** are numbered per market ("PP-US-…"). Tax lines are open (US-P12).
11. **Estimates** should use min(charger kW, the vehicle's max kW) once vehicles carry a max DC rate (US-P11).
