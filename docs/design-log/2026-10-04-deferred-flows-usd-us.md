# 2026-10-04 · Deferred flows, USD toggle, US · West Lafayette edition

All work is in Figma: [PakPlug Design System](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System) (`x2fPubLkytfeO9btWSoTu6`). Every new screen is assembled from existing v4 components; no new components were added. Each section has screens, a label above and a note under each screen, and a Logic check frame. Mobbin ref boards and micro-interaction boards were skipped to save effort.

## New sections

| Page | Section | Screens | Section ID |
|---|---|---|---|
| Flow 4 · Station + Booking | 4B · Reviews, directions & currency | 04.12–04.19 | see page `1089:8868` |
| Flow 4 · Station + Booking | 4D · Book · Vehicle | 04.35–04.40 | see page `1089:8868` |
| Flow 6 · Live + Complete | 6C · Lock Screen & Dynamic Island | 06.22–06.28d | see page `1089:8870` |
| Flow 8 · Profile + Vehicles | 8E · Settings, region & currency | 08.09–08.16 | `1297:4495` |
| Flow 8 · Profile + Vehicles | 8F · Sign out | 08.17–08.22b | `1297:6148` |
| Flow 9 · Messages | 9A Inbox · 9B Thread · 9C Inquiry · 9D Options & call | 09.01–09.21 | page `1089:8873` |
| Flow 10 · US · West Lafayette | 10A Discover & station · 10B Book, charge & complete · 10C Bookings, messages & profile | 10.01–10.20 | page `1294:2` |

Moved to make room: 4C → y 7182, 4E → y 14606, 6D → y 11280, 6E → y 16014.

## Currency rules (PKR / USD)

- **Settings → Region & currency** (08.10, 08.11): region (Pakistan | United States), prices (Rs | $) and distance (km | mi) are separate settings.
- **Quick toggle:** an `Rs | $` segmented control under the station stats (04.18) and in Book a slot (04.19). It writes the same setting as 08.10.
- **Pakistan region:** hosts price in Rs and the driver pays in Rs. `$` is an estimate, always shown with `≈`, at a dummy rate of Rs 280 = $1, rounded to 2 decimals. Map pins drop the `≈` to save space. Receipts stay in Rs.
- **US region:** `$` is the native currency, with no `≈`. `Rs` shows as `≈ Rs` when flipped (10.19, 10.20).

## US dataset (Flow 10)

- **Stations:** Boilermaker · State St (401 W State St, West Lafayette, IN 47906), Chauncey Hill Home Charger, Wabash Landing Garage, Research Park DC Hub.
- **People:** Emily Carter (driver), Jake (host), Marcus Lee, Olivia Brooks, Ryan Miller, Hannah Kim, Tyler Nguyen.
- **Cars:** Chevrolet Bolt EUV (J1772, CCS1 · 65 kWh, primary), Tesla Model 3 (NACS · 75 kWh), Nissan Leaf. Plate IN 482 BKR.
- **Plugs:** J1772 (AC), CCS1, NACS.
- **Units and formats:** miles, mph, M/D dates, (765) phone numbers.
- **Prices:** about $0.32/kWh for Level 2. Converted as Rs × 0.32/42, so 1 h at 6.8 kWh comes to $2.18.

## Review pass (automated lint, all 10 flow pages)

- **Clean:**
  - no missing fonts or leftover placeholder copy
  - no duplicate screen codes
  - no notes colliding with labels
  - no stray `$` on Pakistan pages, no stray `Rs` on US pages
- **Expected, not bugs:** text past the screen edge only in horizontally scrolling chip rows and date strips. Copy reading "Message" is the real quick-action tile and composer placeholder.
- **Fixed:** Flow 1 labels sat 36 px above their screens; all 44 now sit at 30 px, like every other flow.

## Open flags

- **Hammad:**
  - Does the US pilot bill in USD natively? Flow 10 assumes it does.
  - Replace the dummy FX rate.
- **Rayan:**
  - Store region, currency and units as a user setting, plus a daily FX rate endpoint.
  - Build the native ActivityKit extension for 6C, with an Android ongoing notification as the equivalent.
  - "Find a charger" in the empty inbox calls `maybePop` (a no-op).
  - There's no API to start a thread before booking.
  - Block and report need moderation APIs.
- **Icons:** Connector Row and Connector Tile only swap between Type 2, CCS2 and GB/T. The US screens need J1772 (`ev.plug.ac.type.1`), CCS1 (`ev.plug.dc.ccs1`) and NACS (`ev.plug.dc.nacs`). The exporter needs macOS.
