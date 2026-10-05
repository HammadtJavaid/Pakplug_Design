# 03 · Search: search overlay, results, keyword filters, Filter & sort

> **00-system alignment (2026-10-04, read first).** `00-system.md` is the single answer for navigation, sheets, motion, haptics, shared components, section names, formats, tones and materials; where this spec still differs, 00-system wins. Applied to this spec: (1) Sections: `Flow 3A · Search · Sheet, typing & errors` (03.01–03.12, 03.23, 03.24) and `Flow 3B · Search · Results on the map & filters` (03.13–03.22) (00-system §4). (2) The search sheet sits at the large detent, top y 62 (not 60): add 2 to every y inside the sheet in §2.0 A and in the sheet frames (header row 82, chips 138, content 190); grabber at sheet top + 5. (3) Filter & sort over Search: the search sheet recedes to 0.96 (00-system sheet-on-sheet rule), not 0.94. (4) Search rows press with the `bg/fill` highlight (no scale); List Group Header · action is the C14 trailing extension; iOS / Keyboard is C13.

Spec for the Figma build of Flow 03. Research only: no Figma calls were made.
Sources: `BRIEF.md`, `driver-logic-map.md` §B (`_DriverSearchOverlay`, `DriverFilterBottomSheet`, `DriverHomeScreen` chrome, list/map rules, My location FAB), Appendix 3–4, the sibling specs `02-discover.md` (shared geometry, motion tokens, haptic map, Toast rules, status mapping and chip rules are reused, not redefined) and `01-onboarding.md` (`iOS / Keyboard` stand-in), and 62 unique Mobbin references (iOS).

**Material + type rules for this flow (from the brief, applied to every frame):**
- **No Hero mesh in Search.** Backgrounds are the Map image (with `bg/scrim` over it while the sheet is open), the opaque Search sheet (`bg/surface`) and, for 03.21 only, Mesh Quiet 951:7417. Normal text colours apply everywhere (text/primary, text/secondary, text/tertiary, text/brand); `text/onMesh` is not used and the measured Hero-mesh contrast rule has nothing to apply to. If a later flow opens search over the Charge tab (Hero mesh), the sheet is opaque Surface, so its text stays normal; only chrome left on the mesh follows the Hero rule (Frost Strong).
- Floating chrome on the map (capsule, chips, Map Controls, status pills, glass ✕) = the components' Glass variants. Station cards that float over the map or Quiet mesh (03.13 preview, 03.21 list cards) = `bg/frostStrong` + `Frost/Card` (never Frost 68% under grey text). Inside the Search sheet everything is the Fill family (chips Fill/No, Icon Button Fill M). Reduce Transparency: Glass and Frost become Surface + hairline (02 rule).
- **Type:** SF Pro, lighter. Titles and every "Emph" style are SF Pro **Medium**, body Regular, no Bold/Semibold anywhere (the match highlight is a weight change Regular → Medium, never Bold). Numbers that decide something (Rs price, km, kWh, %) use a Display style or the number slot of an existing component (Map Pin price, Station Card price, Search Result Row distance, Chip count).
- **Brand:** the logic's overlay header "repeats the top bar" (logo mark + "Pak" "Plug" wordmark, heart, bell). It is not repeated in the sheet [S1, 02-P27]. The brand on screen is the mesh P inside the capsule (`Search Field` Idle/On map 971:202 = `Brand / Mark / PakPlug P` Style=Mesh on a light surface), which cross-fades to magnifyingglass as the capsule becomes the sheet field. The SF Pro wordmark (`Brand / Wordmark` 994:132) is not used in this flow.

Notation
- `[S#]` = a proposal from this flow (not in the logic map). Every `[S#]` is listed in §7 and must appear in the FLAG — PROPOSALS block of the logic-check card. `[02-P#]` points to a proposal already made in Flow 02.
- "Real copy" = quoted verbatim from the logic map. Anything else is a proposal and is marked. All VoiceOver labels, hints and announcements in §4 are new accessibility copy (not visible) and are covered by [S26] (same convention as [02-P34]).
- Component references use the brief inventory: `Name [set id] → Variant id`.
- Motion tokens are the ones defined in 02 §4.0: `snappy` (spring, settles ≈ 300 ms), `smooth` (spring, settles ≈ 450 ms), `bouncy` (spring, ≈ 400 ms, one ≈ 4% overshoot), `fade.quick` (150 ms ease-out), `fade.std` (220 ms ease-out), `camera` (350–500 ms ease-in-out). A millisecond value written next to a spring token is its settle time, never a different curve. The haptic map (selection / light / medium / success / error; haptics fire on release, never on touch-down), the press-feedback rules and the Toast rules are 02 §4.0. Do not invent new curves.

---

## 1. Overview

**Goal.** A driver can find a charger by name, by address, by area, or by what plug it has, in a few keystrokes and with one thumb. Search starts in the bottom thumb-zone capsule (concept A) and grows into an Apple-Maps-style sheet. It always ends on the map: either a selected station with its floating card, or a chosen area with the stations around it. Filters live in the same chips row on the map and in the sheet, so they always look and behave the same.

### 1.1 What drivers can search, and how (decided)

| Driver types | Example | Source | What happens |
|---|---|---|---|
| Station name (any word in it) | "GreenVolt", "Galleria", "dha" | Local match on the overlay's preloaded stations, max 10 (logic) | **Stations** section; tap → map, station selected, card open |
| Station address / street | "Street 12", "Main Boulevard" | Same local match. Fields matched = name + address (logic shows address as the subtitle; the exact fields are not stated, see §8-6) | **Stations** section |
| Area, landmark, place or full address | "DHA Phase 6", "Liberty Market", "Emporium Mall", "House 45, Cavalry Ground" | Google Places autocomplete, max 5 (logic) | **Places** section; tap → place resolved, map flies to zoom 14, nearby stations fetched |
| Plug-type words | "CCS", "ccs2", "DC", "fast", "Type 2", "type2", "AC" | Local keyword map [S8] | A **filter suggestion row** "Show CCS (DC) chargers" at the top, plus the stations that have that plug, with a plug subtitle "CCS2 (DC) · 60 kW · Gulberg III" instead of the address [S8] |
| Availability words | "available", "available now", "free" | Keyword map [S8] | Filter suggestion row "Show available chargers", plus the preloaded stations whose status is Available (address subtitle) |
| Sort words | "cheap", "cheapest", "nearest", "top rated" | Keyword map [S8] | Suggestion row "Sort by price" / "Sort by distance" / "Sort by rating" only (plus any name/address matches); no Places request |
| Not supported in v1 | host names, prices as numbers, Urdu script for station names | No data in the overlay | Falls through to Places; empty state if nothing |

**Before typing**, the sheet shows (top to bottom): the quick filter chips, **Recent** [S3], **Saved chargers** shortcut [S4], **Nearby** (3 nearest preloaded stations) [S4]. Whenever Recent is empty (first use, after "Clear", after the last × or after sign-out) the **Try searching** chips take Recent's place [S5]. With 0 saved chargers the Saved row is hidden; with no GPS fix Nearby is hidden (§8-2).

### 1.2 Entry points
- Home · Map / Home · List: tap the bottom search capsule "Search chargers" (02.06, 02.15).
- Home after an earlier search: tap the **filled** capsule (e.g. "DHA Phase 6") [S11]. The sheet opens with the text selected so typing replaces it.
- Filter & sort: the "Filters" chip [02-P26] on the map (02), in the list (02) or inside the search sheet (this flow).
- Not an entry: the Map Controls "My location" button. Logic: it "clears selection, closes search, switches to map, recentres". The sheet covers Map Controls, so it can only be tapped when the sheet is closed; with a filled capsule [S11] it clears the query and the place marker (§8-26).

### 1.3 Exits

| From | Action | Goes to | Owner flow |
|---|---|---|---|
| Station row (Stations, Recent, Nearby) | tap | Home · Map, station selected, floating card (= 02.08 composition, 03.13). From the card: View Details → place sheet large detent (04.02), Book now → Book a slot (04.24), swipe up → medium detent (04.01) | 02 → 04 · Station & Book |
| Place row | tap | Home · Map at zoom 14 on that place, refetch nearby (logic) (03.14 → 03.15, or 03.22 with 0 stations) | 02 |
| Filter suggestion row [S8] | tap | Home · Map with that filter applied (chips mirror it) | 02 |
| Saved chargers row [S4] | tap | Saved chargers (02.20); its back button returns to Home with an empty capsule (the shortcut counts as Cancel) | 02 |
| ✕, swipe down, scrim strip, "Back to the map", system back | dismiss | Home in the mode it was opened from (map or list) | 02 |
| Filter & sort → Show results | apply | Back to where it was opened (map, list or search sheet), filters applied | 02 / 03 |

**Sections on Driver Flows (946:8).** Two sections (00-system §4), each placed 160 below the current page bottom at x = 0 (copy the fills of section 1076:2): `Flow 3A · Search · Sheet, typing & errors` (rows 1–3, 14 frames) and `Flow 3B · Search · Results on the map & filters` (rows 4–5, 10 frames). Title (Title 1, text/primary) at (80,80) = the section name; status line (Footnote, text/secondary) at (80,124), e.g. "Search overlay, typing, keyword filters, errors · 14 frames · spec 03-search.md".

---

## 2. Screens & states

### 2.0 Shared geometry

**A. Search sheet frames** (03.02–03.12, 03.16, 03.19, 03.23, 03.24; and behind 03.17–03.18). 402×874.

| Layer | Position / size | Component / fill |
|---|---|---|
| Map | (0,0) 402×874 | Rectangle `Map`, fills copied from 996:430 |
| Scrim | (0,0) 402×874 | Rectangle `Scrim`, bg/scrim 948:48 |
| Status bar | (0,0) | `iOS / Status Bar` Dark 996:398 |
| Search sheet | (0,62) 402×812 (00-system large detent; every y inside the sheet moves +2) | Frame `Search sheet`: fill bg/surface 948:41, top radius 38 (radius/sheet 948:119), effect Frost/Elevated, clip content |
| Grabber | sheet (183,5) 36×5 | Rectangle, bg/fillStrong 948:47, radius pill |
| Header row | (16,80) 370×44, horizontal auto layout, gap 8, centre-aligned | `Search Field` Focused/In sheet 971:243 (layoutSizing FILL) + `Icon Button` Fill M 979:283, Icon = xmark 958:72 (VoiceOver "Cancel search") |
| Chips row | (16,136) h 36, horizontal auto layout, gap 8, overflow clipped at x 402 with a 24pt bg/surface fade on the right | `Chip` Fill/No 970:164 "Filters" (Leading icon on, Icon = slider.horizontal.3 1025:513, Count off) · Fill/No "Available now" · Fill/No "Type 2 (AC)" · Fill/No "CCS (DC)" · Fill/No "GB/T". Selected chips = Fill/Yes 970:175. "Filters" with Count > 0 = Fill/Yes + Count on [S14] |
| Content | starts y 188, x 16, width 370, vertical auto layout, section gap 16 | see each frame |
| Keyboard (when up) | (0,538) 402×336 | `iOS / Keyboard` (defined in 01 §6, Type=Default) with the Return-label property this flow adds = "search" (§6); includes its own home indicator |
| Home indicator (keyboard down) | (0,840) | `iOS / Home Indicator` Dark 996:425 |
| Toast (when shown) | x 16, 370 wide. **Bottom edge** 12pt above the keyboard top (y 526) or, keyboard down, at y 828 (12pt above the home-indicator zone, same as 02 Saved). It grows upward: 1 line ≈ 52pt (top y 474 / 776), 2 lines ≈ 72pt (top y 454 / 756) | `Toast` [1088:631] |

Rules:
- Tab bar, Map Controls, heart, bell and the map's Google attribution are **under** the scrim and sheet, so they are not drawn (they are covered; logic: the attribution is "hidden while search is active"). The top 60pt of dimmed map is the "scrim strip" (tap = dismiss).
- **Field state per frame.** Typing frames (03.04–03.06, 03.08–03.11, 03.16, 03.23, 03.24) use `Search Field` Filled/In sheet 971:251 with the value, the clear × and a caret (2×22 rectangle, `brand/primary` = the iOS tint, radius 1) right after the text; 03.16 replaces the caret with the selection tint. Keyboard-down frames (03.07, 03.12, 03.19) use Filled/In sheet with **no** caret. Empty focused frames (03.02, 03.03) use Focused/In sheet 971:243 (caret at the start of the placeholder). If 971:243 exposes a value slot, the typing frames may use it instead: inspect with get_metadata first, never rebuild the field.
- Materials follow the existing rule: Glass on the map layer, Fill inside sheets. The chips change from Glass to Fill as they move into the sheet (see §4.1-2). The ✕ is Fill M (not Glass) because it sits on the sheet.
- Every section uses `List Group Header` [983:389] (Label#983:20) for its title; rows are `Search Result Row` [971:284] instances stacked with no gap (the row carries its own inset separator).
- **Match highlight:** inside a row title the matched word-prefix is set to text style **Headline** (S:a1bb39a0a592a2851692cd77dbf82bafbf84fd21, SF Pro Medium 17); the rest of the title stays **Body** (S:65b984824a1152616149c0c671280fa40ea03aa5, Regular 17). Both text/primary. Weight only, no colour (keeps the "no Bold" rule; the C2 component already binds the match range to Headline). Use `setRangeTextStyleIdAsync` on the title node.

**B. Map frames** (03.13–03.15, 03.20, 03.22). Identical to 02 §2.0 (status bar, heart (16,60), bell (68,60), Map Controls (339,60), attribution, chips at y 684, search capsule (20,731), Tab Bar (20,788) Selected=Home with Messages badge "2", home indicator). Only the overrides listed per frame differ.

**C. Filter & sort frames** (03.17, 03.18). The search sheet of 03.07 (keyboard down) sits behind, receded: scale 0.96 around its top centre (00-system sheet-on-sheet rule), top at y 70, plus a second bg/scrim over it. `Sheet / Filter & sort` 1012:432 (402 wide) is bottom-anchored at y = 874 − its height (medium detent). If its height exceeds 600, keep it at 600 and let the content scroll under a pinned "Show results".

### 2.1 Frame table

Priority: **P1** build tonight; **P2** if time allows.

| # | Frame name | Pri | Background | Layout top → bottom (instances + overrides) | New |
|---|---|---|---|---|---|
| 03.01 | `03.01 · Search · Opening (motion still)` | P2 | Map | Storyboard still at t = 200 ms of the ≈ 450 ms open: Map · Scrim at 50% opacity · Tab Bar Home at 40% opacity, scale 0.96 · Search sheet mid-rise at (0,340) 402×534, radius 38 · inside it the field morphing: `Search Field` Focused/On map 971:211 at (16,360), width 330 (between 362 and 318) · chips row at (16,416), chips at 50% Glass/No 970:142 over 50% Fill/No (two stacked instances, top one at 50% opacity) · `iOS / Keyboard` at (0,700) (partly risen) · annotation (Caption 1, text/tertiary, on the canvas above the frame) "t = 200 ms of ≈ 450 · smooth". | none (iOS / Keyboard is 01's) |
| 03.02 | `03.02 · Search · Focused · Recents` | P1 | Search sheet (A) | Header: `Search Field` Focused/In sheet 971:243, placeholder "Station name, address, or place" · chips default (all Fill/No) · `List Group Header` "Recent" with trailing action "Clear" [S3] · 3× **Search Result Row / Recent** (new variants, trailing ×): (1) Station: "GreenVolt · DHA Phase 5" / "Street 12, Block CCA, DHA Phase 5, Lahore" (2) Place: "Liberty Market" / "Gulberg III, Lahore" (3) Place: "Emporium Mall" / "Johar Town, Lahore" · 16 gap · `List Row` Navigation 983:339: Icon on, glyph heart.fill 981:289 (icon/brand on bg/tint well), title "Saved chargers", Subtitle "3 saved", Separator off [S4] · `List Group Header` "Nearby" [S4] · `Search Result Row` Station 971:263 ×3 (Nearby excludes stations already in Recent): "Gulberg Galleria Charger" / "Main Boulevard, Gulberg III, Lahore" / "3.4 km"; "Model Town Home Charger" / "Model Town, Lahore" / "5.1 km"; "Johar Town Fast Hub" / "Johar Town, Lahore" / "7.8 km" (rows 2–3 run under the keyboard) · `iOS / Keyboard`, Return "search" disabled (empty field). Canvas notes (no extra frame): (a) while the overlay's station preload is still running, Nearby shows one `Search Result Row` Loading 971:278 "Loading…" (logic copy) under its header; (b) with 0 saved chargers the Saved row is hidden; (c) with no GPS fix Nearby is hidden and recent rows show no distance (§8-2). | Search Result Row / Recent; List Group Header · action; iOS / Keyboard Return property |
| 03.03 | `03.03 · Search · Focused · First time` | P1 | Search sheet (A) | As 03.02 without Recent (first use; the same layout shows after "Clear", after the last × and after sign-out). Instead: `List Group Header` "Try searching" [S5] + a wrapping row of `Chip` Fill/No with Leading icon magnifyingglass 958:6: "DHA Phase 5" · "Type 2" · "Liberty Market" · then Saved chargers row · "Nearby": GreenVolt · DHA Phase 5 "1.2 km", Gulberg Galleria Charger "3.4 km", Model Town Home Charger "5.1 km". | none new |
| 03.04 | `03.04 · Search · Typing · Loading` | P1 | Search sheet (A) | `Search Field` Filled/In sheet 971:251 value "dha" with the clear × · chips default · `List Group Header` "Stations" [S6] · `Search Result Row` Loading 971:278 "Loading…" · `List Group Header` "Places" [S6] · `Search Result Row` Loading 971:278 "Loading…" · keyboard, Return enabled. (Logic: "Initial loading: "Loading…"" while the overlay's station data is still loading.) | none |
| 03.05 | `03.05 · Search · Typing · Places loading` | P1 | Search sheet (A) | Field "dha" · "Stations": `Search Result Row` Station: title "GreenVolt · **DHA** Phase 5" (DHA in Headline), subtitle "Street 12, Block CCA, **DHA** Phase 5, Lahore" (subtitle highlight is Footnote Emph on the match [S6]), trailing "1.2 km" · "Places": one trailing `Search Result Row` Loading "Loading…" (logic: "Places still loading: trailing "Loading…" row") · keyboard. | none |
| 03.06 | `03.06 · Search · Typing · Results` | P1 | Search sheet (A) | Field "dha" · "Stations": GreenVolt row as 03.05 · "Places" (Google order, title/subtitle split per logic, distance [S7]): `Search Result Row` Place 971:271 ×4: "**DHA** Phase 5" / "Lahore, Pakistan" / "1.4 km"; "**DHA** Phase 6" / "Lahore, Pakistan" / "4.6 km"; "**DHA** Raya" / "Lahore, Pakistan" / "9.8 km"; "**DHA** Phase 3" / "Lahore, Pakistan" / "3.2 km" · **Attribution / Google** "In list" under the Places group (here under the keyboard) · keyboard. | Attribution / Google |
| 03.07 | `03.07 · Search · Results · Keyboard down` | P1 | Search sheet (A) | Same results as 03.06, field Filled/In sheet 971:251 (not focused, no caret) · Attribution / Google visible at the end of the list · centred quiet text button "Back to the map" (Footnote, text/secondary, 44pt tall) 24pt below the attribution [S2] · home indicator Dark. | none |
| 03.08 | `03.08 · Search · Plug-type query` | P1 | Search sheet (A) | Field "ccs" · `List Group Header` "Suggestions" · **Search Result Row / Filter** (new): icon ev.plug.dc.ccs2 1024:482 (icon/brand) on bg/tint well, title "Show **CCS** (DC) chargers", subtitle "Filter the map by connector", trailing chevron.right 958:55 [S8] · "Stations": `Search Result Row` Station ×2 with plug subtitles [S8] in the format "{plug label} · {maxPowerKw} kW · {area}" (plug label as on the station card, e.g. "CCS2 (DC)", 02.31): "Gulberg Galleria Charger" / "**CCS**2 (DC) · 60 kW · Gulberg III" / "3.4 km"; "Johar Town Fast Hub" / "**CCS**2 (DC) · 30 kW · Johar Town" / "7.8 km" (status is not shown in search rows, logic) · no Places section (Places skipped for pure plug keywords [S8]) · keyboard. | Search Result Row / Filter |
| 03.09 | `03.09 · Search · Availability query` | P2 | Search sheet (A) | Field "available" · "Suggestions": Search Result Row / Filter, icon checkmark.circle.fill 1025:506 (status/available), title "Show **available** chargers", subtitle "Available now" · "Stations" (available only): GreenVolt · DHA Phase 5 "1.2 km", Model Town Home Charger "5.1 km" · keyboard. | (as 03.08) |
| 03.10 | `03.10 · Search · No results` | P1 | Search sheet (A) | Field "plugzz" · chips default · `Search Result Row` Empty 971:282: icon magnifyingglass, title "No stations or places found." (logic), second line [S16] "Check the spelling, or try an area like "DHA Phase 5"." (Footnote, text/secondary) · keyboard. The filters-on version (different helper line + "Clear filters") is its own frame, 03.24. | none |
| 03.11 | `03.11 · Search · Places failed` | P1 | Search sheet (A) | Field "dha" · "Stations": GreenVolt row (local results still work) · no Places section · `Toast` Error 1088:626, two lines, bottom edge y 526 (top ≈ 454): Message "Could not load place suggestions. Check your connection." (logic), Action off · keyboard. | none |
| 03.12 | `03.12 · Search · Stations couldn't load` | P2 | Search sheet (A) | Offline with no preload [S25]. Field "dha" (Filled, no caret) · chips default · `State View` Error 1072:588 centred in the visible area (y≈220): Icon exclamationmark.triangle.fill 1025:474 (icon/error), Title "Couldn't load stations" / message "Check your connection and try again." [02-P15], Show action on → `Button / Medium` Primary 978:428 "Retry" (real) · **no** Places toast (the State View already explains the connection problem; one error message at a time) · keyboard down (home indicator Dark). | none |
| 03.13 | `03.13 · Search → Station on map` | P1 | Map (B) | 02.08 composition for GreenVolt, camera at zoom 15 [S24]: `Map Pin` Available selected 974:238 "Rs 42" with the camera centred so the pin sits at y≈330 · bottom stack hidden · `Station Card` Map preview 982:287 at (16,606), fill `bg/frostStrong` + `Frost/Card` (02.08): "GreenVolt · DHA Phase 5", `Status Pill` Success S 980:314 "Available", "Street 12, Block CCA, DHA Phase 5, Lahore", connector "Type 2 (AC)" · "7.4 kW · Available" · "Rs 42" "/kWh", distance "1.2 km" [02-P2], buttons "View Details" (Medium Secondary 978:458) + "Book now" (Medium Primary 978:428) · close `Icon Button` Glass S 979:280 xmark at (352,564) · Tab Bar Home. Canvas note: "Search field keeps "dha" while the card is open; it reappears filled when the card closes [S11]." | none |
| 03.14 | `03.14 · Search → Place · Loading` | P1 | Map (B), camera on DHA Phase 6 | **Map Marker / Place** (new) at the map centre (201,400) with label "DHA Phase 6" · no station pins yet · `Map Status Pill` Loading 975:249 "Loading…" centred at y 64 [02-P4] · chips default (Glass/No) · `Search Field` Filled/On map 971:222 at (20,731), value "DHA Phase 6" with × [S11] · Tab Bar Home · home indicator. | Map Marker / Place |
| 03.15 | `03.15 · Search → Place · Stations nearby` | P1 | Map (B) | 03.14 plus pins (02 dummy set; fillers as in 02 §2.0): `Map Pin` Available 974:223 "Rs 42" (GreenVolt, up-left of the marker), Available "Rs 40", In use 974:228 "Rs 45" · `Map Status Pill` Notice 975:253 "3 stations nearby" centred at y 64 [S12] (leaves after 2.5 s) · Google attribution visible above the chips. | none |
| 03.16 | `03.16 · Search · Reopened with query` | P2 | Search sheet (A) | Field Filled/In sheet 971:251 (focused) with "DHA Phase 6" fully selected: selection tint `bg/tint` behind the value plus two 2pt `brand/primary` selection handles, no caret, iOS edit menu not shown · results for "DHA Phase 6": Stations none (section hidden) · Places: "**DHA Phase 6**" / "Lahore, Pakistan" / "4.6 km", "**DHA Phase 6** Sector C" / "Lahore, Pakistan" / "5.0 km" · Attribution · keyboard. | none |
| 03.17 | `03.17 · Filter & sort · Default` | P1 | 03.07 receded + scrim (C) | `Sheet / Filter & sort` 1012:432: title "Filter & sort", trailing "Clear" in text/tertiary (disabled: nothing to clear) [S15]; "Connector type": **All** selected · Type 2 (AC) · CCS (DC) · GB/T; "Availability": **Any** selected · Available now; "Sort by": Recommended · **Nearest** selected · Price · Rating; `Button / Large` Primary 978:277 "Show results". Selected options = Chip Fill/Yes, others Fill/No (or the sheet's own selected/unselected parts if it is built differently: inspect with get_metadata before overriding, never rebuild). | none |
| 03.18 | `03.18 · Filter & sort · Edited` | P1 | as 03.17 | Same sheet with **Type 2 (AC)**, **Available now**, **Price** selected; "Clear" in text/brand (enabled). "Show results" Primary Default. | none |
| 03.19 | `03.19 · Search · Filters applied` | P1 | Search sheet (A), keyboard down | Field Filled "dha" · chips: "Filters" Fill/Yes with Count on, Count value "3" [S14] · "Available now" Fill/Yes · "Type 2 (AC)" Fill/Yes · "CCS (DC)" Fill/No · "GB/T" Fill/No · "Stations": GreenVolt row (Type 2 + Available, so it stays) · "Places": the 4 DHA places unchanged (places are not filtered [S13]) · Attribution · "Back to the map". | none |
| 03.20 | `03.20 · Home · Map · Filters applied` | P1 | Map (B) | 02.06 composition with only 2 pins: Model Town Home Charger `Map Pin` Available "Rs 38", GreenVolt Available "Rs 42" (Gulberg In use and Johar Town Offline are filtered out) · chips Glass row: "Filters" Fill/Yes Count "3", "Available now" Fill/Yes, "Type 2 (AC)" Fill/Yes, "CCS (DC)" Glass/No, "GB/T" Glass/No · search capsule Idle/On map "Search chargers" · Tab Bar Home. | none |
| 03.21 | `03.21 · Home · List · Filters applied` | P2 | Mesh Quiet | 02.15 layout (status bar, heart + bell Glass M, top and bottom Scroll Edge Fades): `Map Controls` Mode=List 975:244 · `List Group Header` "2 stations · Cheapest first" [S18] · `Station Card` List 982:314 ×2, fill `bg/frostStrong` (normal text colours on Quiet), sorted by price: "Model Town Home Charger" · Available · "Type 2 (AC) · Lahore" · 4.9 · 5.1 km · "Rs 38/kWh"; "GreenVolt · DHA Phase 5" · Available · "Type 2 (AC) · Lahore" · 4.8 · 1.2 km · "Rs 42/kWh" (location line = logic literal, 02-P9 not applied) · chips as 03.20 · search capsule · Tab Bar Home. | none |
| 03.22 | `03.22 · Search → Place · No stations nearby` | P2 | Map (B), camera on DHA Raya, no pins | Filters on (state demo): chips "Filters" Fill/Yes Count "1", "Available now" Fill/Yes, others Glass/No · **Map Marker / Place** at (201,400) labelled "DHA Raya" · `Map Status Pill` Notice + Action (02 §6 variant) at top centre y 64: "No stations found" (real, list empty title) + action "Clear" in text/brand [02-P6] (without filters the pill has no action) · `Search Field` Filled/On map 971:222 "DHA Raya" with × [S11] · attribution · Tab Bar Home. The pill stays (no 2.5 s timeout) until the camera moves, filters change or the search is cleared. | none |
| 03.23 | `03.23 · Search · Couldn't open place` | P2 | Search sheet (A) | Field "dha" + caret · results as 03.06; the tapped "DHA Phase 6" row shows its distance again (the resolve spinner has reverted) · `Toast` Error 1088:626, one line, bottom edge y 526: Message "Couldn't open that place. Try again." [S17], Action off · keyboard. Canvas note: the recent-station-gone case uses the same placement with `Toast` Neutral 1088:611 "This charger is no longer listed." [S17]. | none |
| 03.24 | `03.24 · Search · No results · Filters on` | P2 | Search sheet (A) | Field "greenvolt" + caret · chips: "Filters" Fill/Yes Count "1", "CCS (DC)" Fill/Yes, others Fill/No (GreenVolt is Type 2, so the filter hides it [S13]) · `Search Result Row` Empty 971:282: title "No stations or places found." (logic), second line "Some stations are hidden by your filters." (Footnote, text/secondary) [S16] · `Button / Medium` Secondary 978:458 "Clear filters" [S16], hugging, left-aligned to the row text, 12 below · keyboard. | none |

**Totals:** 24 frames. 16 are P1 (03.02–03.08, 03.10, 03.11, 03.13–03.15, 03.17–03.20); 8 are P2 (03.01, 03.09, 03.12, 03.16, 03.21, 03.22, 03.23, 03.24). Frame numbers 03.01–03.21 are not renumbered (02 cites 03.20 and 03.21); new frames are appended.

**Rows on the canvas** (labels above each phone, `03.nn · Screen · State` in Footnote Emph text/secondary, gap 80; same convention as 01, 02 and 04–09):
1. Open & idle: 03.01–03.03, then the Micro-interactions card §4.1–4.2.
2. Typing: 03.04–03.09, then card §4.3–4.5.
3. Empty & errors: 03.10, 03.24, 03.11, 03.23, 03.12, then card §4.6 (+ §4.8-3 for 03.23).
4. Outcomes on the map: 03.13–03.16, 03.22, then card §4.7–4.10.
5. Filter & sort: 03.17–03.21, then card §4.11–4.12.
The Refs · Mobbin card sits left of row 1 (after the title) and lists the refs grouped by row (§5.1–5.5); the Logic check card (§9 table + FLAG — PROPOSALS with S1–S26) sits after row 5.

---

## 3. Real copy (quoted from the logic map) per screen

### 3.1 Capsule and sheet chrome (03.01–03.03, all sheet frames)
- Capsule on the map: "Search chargers" (logic: "Fake search field "Search chargers"; tap opens the search overlay").
- Field hint inside the sheet: "Station name, address, or place" (logic: "text field with hint "Station name, address, or place"").
- Filter entry: logic has a "filter button" in the overlay header; here it is the "Filters" chip (same action: opens "Filter & sort"). "Filters" is new copy [02-P26].
- Dropped from the logic header (not drawn) [S1]: the repeated top bar (logo mark + "Pak" "Plug" wordmark, heart, bell) and the "Map" / "List" toggle.
- New, flagged: "Recent", "Clear" (recents) [S3]; "Saved chargers" + "3 saved" (real copy from `FavoritesScreen`: title "Saved chargers", caption "N saved") used as a shortcut [S4]; "Nearby" [S4]; "Try searching" [S5]; "Back to the map" [S2]. The ✕ has no visible text; VoiceOver "Cancel search" [S1, S26].

### 3.2 Typing and results (03.04–03.09, 03.16)
- Loading: "Loading…" (logic: "Initial loading: "Loading…"" and "Places still loading: trailing "Loading…" row").
- Station row: "title = name, subtitle = address, trailing distance label" (logic). Distance format as on the list card, e.g. "1.2 km".
- Place row: "title and subtitle are split from the place name" (logic). Distance on place rows is new [S7].
- Section titles "Stations" / "Places" [S6]; "Suggestions" [S8].
- Google attribution footer (logic: "Google attribution footer"). Text "Powered by Google" with Google's logo asset (Google's required wording; not invented copy).
- Keyword suggestion rows [S8]: "Show CCS (DC) chargers", "Show Type 2 (AC) chargers", "Show available chargers", "Sort by price", "Sort by distance", "Sort by rating"; subtitles "Filter the map by connector", "Available now", "Change how stations are sorted". The option names inside them ("CCS (DC)", "Type 2 (AC)", "Available now") are real filter-sheet copy.

### 3.3 Empty and errors (03.10–03.12)
- Empty: "No stations or places found." (logic).
- Places failure: "Could not load place suggestions. Check your connection." (logic, shown as a snackbar → our Toast).
- Helper line [S16], no filters on (03.10): "Check the spelling, or try an area like "DHA Phase 5"."
- Helper line [S16], filters on (03.24): "Some stations are hidden by your filters." with the action "Clear filters".
- Stations failed (overlay preload, [S25]; copy [02-P15]): "Couldn't load stations" / "Check your connection and try again." / "Retry" (Retry is real).
- Place could not be opened [S17]: "Couldn't open that place. Try again."
- Recent station gone [S17]: "This charger is no longer listed."

### 3.4 Outcomes on the map (03.13–03.15)
- Station card: same real copy as 02 §3.1 ("View Details", "Book now", status "Available", connector "Type 2 (AC)", "{maxPowerKw} kW · {status}", "Rs X" "/kWh").
- Map loading pill: "Loading…" [02-P4].
- Notice after a place fetch [S12]: "{n} stations nearby" (e.g. "3 stations nearby"; "1 station nearby" for n = 1); "No stations found" (real, from the list empty state) when n = 0, with the action "Clear" only when filters are on [02-P6] (03.22).
- Capsule after a selection [S11]: the place or station name, e.g. "DHA Phase 6" (Google's title part) or the typed query "dha" when a station was picked.

### 3.5 Filter & sort (03.17–03.21)
- "Filter & sort" · "Clear" · "Connector type": "All", "Type 2 (AC)", "CCS (DC)", "GB/T" · "Availability": "Any", "Available now" · "Sort by": "Recommended", "Nearest", "Price", "Rating" (default "Nearest") · "Show results". All real.
- Chips row labels: "Filters" (new label for the logic's filter button, shared with 02), "Available now", "Type 2 (AC)", "CCS (DC)", "GB/T" (real option names).
- List header [S18]: "2 stations · Cheapest first". Sort phrases: Nearest → "Nearest first", Price → "Cheapest first", Rating → "Top rated first", Recommended → "Recommended first".

---

## 4. Micro-interactions

Every rule lists: trigger → response · duration + easing · haptic · VoiceOver · Reduce Motion fallback. Tokens, haptic map, press feedback and Toast behaviour = 02 §4.0 (restated only where this flow differs). Reduce Transparency: the sheet is already opaque; map-layer Glass chips become Surface + hairline (02 rule).

**Press feedback specific to this flow (so no rule below repeats it):**
- `Search Result Row` (station, place, recent, filter suggestion, Nearby) and the Saved `List Row`: row background → `bg/fill` on touch-down (0 ms, no scale, as iOS lists); released with `fade.quick`. A vertical drag > 10pt cancels the press (the list scrolls instead). Reduce Motion: identical (it is a colour change, not motion).
- Chips in the sheet: scale 0.96 (`snappy`), as 02. Icon Button Fill M ✕: scale 0.92 + fill darkens 6% (`snappy`). "Clear" / "Back to the map" text buttons: label dims to 50% on touch-down, `fade.quick` back. Reduce Motion: no scale; 85% opacity instead (02 rule).
- Haptics fire on release. The keyboard's own key clicks are system sound/haptics and are not specified here.

### 4.1 Opening the search (capsule → sheet) (03.01 → 03.02 / 03.03)
1. **Touch down on the capsule** → the capsule scales to 0.98 (`snappy`, ≈ 300 ms settle) and its fill brightens 4%.
   - Haptic: none. VoiceOver: "Search chargers, search field. Double-tap to search."
   - Reduce Motion: no scale; fill change only.
2. **Tap the capsule** → one continuous morph on `smooth` (settles ≈ 450 ms), choreographed on that 450 ms timeline:
   - t 0: the field calls `becomeFirstResponder`, so the keyboard rises on the system curve (~350 ms) in parallel.
   - t 0–450: matched geometry, capsule → field. Frame (20,731,362×47) → (16,80,318×44). The sheet background grows out of the capsule's rect to (0,60,402,814), corner radius 23.5 (pill) → 38.
   - t 0–150: the mesh P mark cross-fades to the magnifyingglass glyph (`fade.quick`).
   - t 120–270: the placeholder cross-fades "Search chargers" → "Station name, address, or place" (`fade.quick`).
   - t 0–220: the scrim fades 0 → bg/scrim (`fade.std`). Tab bar, Map Controls, heart, bell and the map attribution fade to 0 and scale to 0.96 (`fade.quick`).
   - t 40–490: the chips row follows the field (40 ms delay, `smooth`). As it crosses the sheet's top edge, each chip cross-fades Glass/No → Fill/No in 150 ms (same labels and selected state, so the filters visibly travel with you).
   - t 160–450: sheet content (Recent or Try searching, Saved, Nearby) fades in and rises 12pt (`fade.std` opacity + `smooth` position, 30 ms stagger per section).
   - Haptic: none (the keyboard appearing is the feedback, same as 02 rule 4.2-18).
   - VoiceOver: focus lands in the field: "Search. Station name, address, or place. Search field. Is editing." The ✕ is the next element: "Cancel search, button". The sheet is modal (`accessibilityViewIsModal`), so the dimmed map is not focusable.
   - Reduce Motion: no geometry morph. The sheet fades in at its final position (`fade.std`) with the scrim; the keyboard uses the system animation.
3. **Opened from List mode** → identical motion and timings; the content behind the scrim is the Mesh Quiet list instead of the map. Haptic none; VoiceOver and Reduce Motion as rule 2.
4. **A session is active** → the charging accessory sits in the tab-bar layer, so it fades with the tab bar (`fade.quick`) and is covered by the sheet. It returns on dismiss together with the bottom stack, which stays raised 60pt (02 rule 4.2-21). The session keeps ticking underneath; no announcement. Reduce Motion: fade only.
5. **Double tap on the capsule** (two taps < 300 ms) → treated as one open; the second tap lands in the already-focused field (no second morph).

### 4.2 Before typing: recents, saved, nearby, try chips (03.02, 03.03)
1. **Tap a recent row** → same as selecting that station or place (§4.7 / §4.8). The row moves to the top of Recent next time.
   - Press: as the row rule above. Haptic: selection (on release).
   - VoiceOver: "GreenVolt, DHA Phase 5, recent station, Street 12, Block CCA, DHA Phase 5, Lahore. Double-tap to show on map." Custom action "Remove from recents". (Labels replace " · " with ", " so it isn't read as "dot".)
   - Reduce Motion: see §4.7-3 / §4.8-2.
2. **Tap a recent row's ×** (44pt target) → the row collapses (height → 0 and opacity → 0, `snappy`, ≈ 300 ms) and the rows below move up in the same spring. If it was the last one, the "Recent" header collapses too and the **Try searching** chips fade in in its place (`fade.std`) [S5].
   - Haptic: light. VoiceOver: "Remove Liberty Market from recents, button"; afterwards announces "Removed" and focus moves to the next recent row (or to the first Try searching chip).
   - Reduce Motion: the row fades out (`fade.quick`) and the others jump.
3. **Tap "Clear"** (Recent header) → the whole Recent section collapses (`snappy`, ≈ 300 ms) and the Try searching chips fade in in its place (`fade.std`, starting at t 150 ms). There's no confirmation: recents are cheap and stored only on the device (Monzo and GitHub both use a plain text "Clear" in the section header, §5.1).
   - Haptic: light. VoiceOver: "Clear recent searches, button"; announces "Recent searches cleared"; focus moves to the "Try searching" header.
   - Reduce Motion: the section cross-fades to Try searching (`fade.quick`), no collapse.
4. **Tap "Saved chargers"** → the keyboard resigns, the sheet dismisses (reverse morph §4.10-1, `smooth` ≈ 450 ms) and, as it clears (t 300 ms), Saved chargers pushes (02.20, system push 350 ms). The logic for Saved chargers is unchanged. Back from Saved returns to Home with an empty capsule.
   - Haptic: light. VoiceOver: "Saved chargers, 3 saved, button"; after the push focus lands on the "Saved chargers" title.
   - Reduce Motion: the sheet fades out (`fade.std`), then the system cross-fade push.
5. **Tap a Nearby row** → §4.7. Haptic: selection. VoiceOver: "Gulberg Galleria Charger, nearby station, Main Boulevard, Gulberg III, Lahore, 3.4 kilometres. Double-tap to show on map." Reduce Motion: §4.7-3.
6. **Tap a "Try searching" chip** (03.03) → its label is typed into the field at once (no debounce). The caret moves to the end, the clear × fades in and results render (§4.3; the label "Type 2" triggers the keyword row, §4.5).
   - Chip press scale 0.96 (`snappy`). Haptic: selection. VoiceOver: "Search for DHA Phase 5, button"; afterwards the §4.3-8 results announcement.
   - Reduce Motion: no press scale; results cross-fade (`fade.quick`).
7. **Quick chip tap inside the sheet** → toggles like on the map (02 rule 4.2-15): Fill/No ↔ Fill/Yes (`snappy`, background cross-fade 150 ms). Connector chips are single-select (§4.12-3). The "Filters" count rolls (numeric content transition), Nearby / Stations re-filter instantly on the preloaded list (`fade.quick`, keyed rows, no refetch inside the sheet [S13]), and the Home map/list refetches behind the sheet (02 rule 4.2-15).
   - Haptic: selection. VoiceOver: "Available now, filter, selected" (button + selected trait); announces the new station count, e.g. "2 nearby stations".
   - Reduce Motion: no count roll; background swaps without spring.
8. **Scroll the sheet content** → the keyboard dismisses interactively (`scrollDismissesKeyboard(.interactively)`, it follows the finger). The header row and chips stay pinned; a hairline (stroke/hairline) fades in under the chips once content scrolls beneath them (`fade.quick`) and fades out at the top.
   - Haptic: none. VoiceOver: three-finger swipe scrolls; the keyboard is dismissed with the standard escape or by moving focus out of the field. Reduce Motion: the hairline appears without fade; the keyboard follows the system.

### 4.3 Typing (03.04–03.07, 03.16)
1. **First character** → the clear × fades in inside the field (`fade.quick`, scale 0.8 → 1). The idle content stays until the first debounce fires, then cross-fades to results (`fade.quick`), so there's no blank flash.
   - Haptic: none (system key feedback only). VoiceOver: no announcement; "Clear text, button" becomes the next element after the field.
   - Reduce Motion: the × fades in without scale.
2. **Debounce 300 ms** (logic) → local station match runs and renders immediately (≤ 10 rows, logic).
   - Rows enter with `fade.quick` and a 4pt rise; rows that persist (same station id) do not re-animate. Only their highlight range updates. Rows that no longer match leave with `fade.quick` (no collapse jump: the list re-flows in the same frame).
   - Places (≤ 5, logic) start from **2 characters** [S9]; stations start from 1.
   - Haptic: none. VoiceOver: rule 8. Reduce Motion: fade only, no rise.
3. **Match highlight** → the matched **word-prefix** (case-, accent- and space-insensitive) of the title switches to Headline (SF Pro Medium). The same match in the station subtitle uses Footnote Emph (Medium) [S6]. The highlight updates on every debounce with no animation, so the weight never "pulses". VoiceOver reads the plain text (no "bold" attribute). Reduce Motion: n/a.
4. **Places in flight** → a trailing `Search Result Row` Loading "Loading…" appears under "Places" only if the request takes longer than **150 ms** [S22]. That stops a one-frame flash on fast networks. When the response arrives, place rows replace the loading row (`fade.quick`, 20 ms stagger).
   - Haptic: none. VoiceOver: the loading row reads "Loading places"; it is skipped by the rule-8 count. Reduce Motion: no stagger.
5. **Stale responses** → each request carries a sequence id; a response for an older query is dropped, so the results never go backwards [S22]. No visible motion.
6. **Stations data not loaded yet** (03.04) → the "Stations" section shows one Loading row until the overlay's preload finishes (logic: on open it loads all nearby stations, max radius, around the last fetch centre, falling back to GPS, then the camera, then the default). When it lands, the loading row cross-fades to the rows (`fade.std`).
   - Haptic: none. VoiceOver: "Loading stations"; then rule 8 announces the count. Reduce Motion: same cross-fade (fades are kept).
   - If it fails → 03.12 (§4.6-5).
7. **Clear × in the field** → the text clears and focus stays. Results cross-fade back to the idle content (`fade.quick`) and the × fades out (scale 1 → 0.8).
   - Haptic: light. VoiceOver: "Clear text, button"; focus returns to the field ("Search, Station name, address, or place, is editing"). Reduce Motion: fades only.
8. **Results announcement** → once typing pauses for 1 s, VoiceOver gets a polite announcement "1 station, 4 places" (or "No stations or places found."). Section headers carry the heading trait, so rotor → Headings jumps between Stations and Places.
9. **Reopen with a query** (03.16, from the filled capsule [S11]) → the open morph (§4.1-2) runs. The field shows the old text **fully selected**, so the first keystroke replaces it, and cached results show at once (no Loading).
   - Haptic: none. VoiceOver: "Search, DHA Phase 6, search field, is editing, text selected". Reduce Motion: §4.1-2 fade.

### 4.4 Keyboard behaviour (all sheet frames)
1. **Keyboard type** → default, `returnKeyType = .search`, `enablesReturnKeyAutomatically = true` (the Return key is grey while the field is empty), autocorrect **off** (it mangles Lahore names like "Gulberg"), autocapitalisation off, no smart punctuation.
2. **Return ("search")** → hides the keyboard and keeps the results; nothing is auto-selected, so the camera never jumps unexpectedly [S10]. The result is 03.07. The system keyboard animation applies (≈ 250 ms); "Back to the map" fades in under the attribution (`fade.quick`) once the keyboard is down.
   - Haptic: none. VoiceOver: announces the results count again ("1 station, 4 places"). Reduce Motion: system keyboard; button appears without fade.
3. **Scrolling the results** → the keyboard dismisses interactively (it follows the finger). Haptic none; Reduce Motion: system behaviour.
4. **Tap the field again** (keyboard down) → the keyboard returns (system ≈ 250 ms); the caret goes to the end; "Back to the map" fades out (`fade.quick`). Haptic none. VoiceOver: "Search, dha, search field, is editing".
5. **Hardware keyboard** (iPad, Mac) [S21] → ↓ / ↑ move a highlight through the rows (bg/fill), Return opens the highlighted row and Esc = Cancel. Not needed for v1 iPhone.

### 4.5 Keyword queries (03.08, 03.09) [S8]
1. **The query matches a keyword** (whole query or its first word, e.g. "ccs", "type 2", "available", "cheap") → a "Suggestions" section with one Search Result Row / Filter fades in at the top (`fade.quick`, the rows below shift down in the same `snappy` spring). What follows it:
   - Plug words: stations whose plug list contains that type, with the plug subtitle "{plug label} · {kW} kW · {area}" ("CCS2 (DC) · 60 kW · Gulberg III") instead of the address.
   - Availability words: the preloaded stations whose status is Available, with the normal address subtitle.
   - Sort words: no extra rows (only name/address matches, if any).
   - Places are not requested for pure keywords; a query that is a keyword **plus** other words ("ccs dha") runs the normal Stations + Places search and still shows the suggestion row.
   - Haptic: none. VoiceOver: the rule-8 announcement includes it: "1 suggestion, 2 stations". Reduce Motion: fade only, no shift spring.
2. **Tap the suggestion row** → the filter applies, the field clears and the sheet dismisses to the map (reverse morph, `smooth` ≈ 450 ms). From t 300 ms, on the map, the matching chip springs to Fill/Yes (`snappy`), the "Filters" count rolls, and pins refetch (02 rule 4.2-1; Loading pill after 300 ms, 02 rule 4.2-2).
   - Sort keywords change the sort instead (no chip changes; the "Filters" count rolls); in List mode the list header updates ("Cheapest first", [S18]).
   - Haptic: selection. VoiceOver: "Show CCS (DC) chargers, filter suggestion. Double-tap to filter the map." Afterwards it announces "Showing CCS (DC) chargers" and focus lands on the "CCS (DC)" chip.
   - Reduce Motion: sheet fades, chip changes instantly, no count roll.
3. **Keyword for GB/T** → no suggestion row. GB/T has no backend key and would behave like All (logic), so offering it would mislead. Stations with GB/T plugs still match by plug word.

### 4.6 Empty and errors (03.10–03.12, 03.24)
1. **No results** → the Empty row fades in (`fade.std`) with its icon scaling 0.9 → 1 (`snappy`).
   - Haptic: none (an empty result is not an error).
   - VoiceOver: "No stations or places found. Check the spelling, or try an area like DHA Phase 5."
   - Reduce Motion: fade only, no icon scale.
2. **No results because of filters** (03.24) → same entry motion; the helper line reads "Some stations are hidden by your filters." and "Clear filters" [S16] sits under it.
   - **Clear filters** → same effect as **Clear** in the sheet (logic: resets the provider). The chips row animates to its default left → right (`snappy`, 40 ms stagger), the "Filters" count rolls to hidden, and the query re-runs at once: the Empty row cross-fades to the results (`fade.quick`; here the GreenVolt row).
   - Haptic: selection. VoiceOver: "No stations or places found. Some stations are hidden by your filters. Clear filters, button."; afterwards "Filters cleared. 1 station".
   - Reduce Motion: chips swap without stagger; cross-fade only.
3. **Places request fails** (03.11) → the station results stay. The Toast (Error) follows the 02 §4.0 Toast rule: it enters from 12pt below its rest position (bottom edge y 526) with opacity 0 → 1 (`smooth`) and, as a two-line message, stays **6 s** or until swiped down; it leaves with `fade.quick`.
   - It shows **once per sheet session**. Later failures while typing don't stack toasts; the Places section stays hidden. Opening the sheet again resets the counter.
   - Haptic: error (once, Error tone). VoiceOver: the text is posted as a polite announcement without moving focus; the timer pauses while VoiceOver focus is inside the toast.
   - Reduce Motion: fade only.
4. **Keyboard moves while a toast is visible** → the toast rides on the keyboard's top edge with the keyboard's curve (bottom edge to y 828 when the keyboard is down, back to y 526 when it returns). Haptic none; Reduce Motion: it jumps with the keyboard.
5. **Stations preload fails** (03.12) [S25] → State View Error replaces the result list (`fade.std`). With an empty field, Recent (device-only) and Try searching stay above it and only Nearby is replaced. With a query (03.12), the State View is the whole result area and Places are not requested until a Retry succeeds: one error message at a time, and a Places-only list would look complete when our stations are missing. So no Places toast shows while it is up.
   - **Retry**: Pressed (02 §4.0), then the button swaps to `Button / Medium` Primary Loading 978:449 (spinner, label hidden) while the preload re-runs.
   - Success: the State View cross-fades to the results (`fade.std`). Haptic none. VoiceOver: "Stations loaded".
   - Failure again: the button returns to Default, the State View shakes ±4pt twice over 300 ms. Haptic: error. VoiceOver: re-announces "Couldn't load stations".
   - VoiceOver on arrival: "Couldn't load stations. Check your connection and try again. Retry, button."
   - Reduce Motion: no shake; cross-fades only.

### 4.7 Selecting a station (→ 03.13)
1. **Touch down** → row highlight bg/fill. **Touch up** → haptic selection, then:
   - t 0: the keyboard resigns. The query is saved and the station is added to Recent [S3].
   - t 0–450: the sheet collapses downward into the bottom edge (`smooth`, ≈ 450 ms) and the scrim fades out (`fade.std`, 220 ms).
   - t 60–510: the camera flies to the station at **zoom 15** (`camera` 450 ms) [S24]. Zoom 15 reuses the list-card rule; the logic only says "close the overlay and select it on the map".
   - On arrival (≈ t 510): the pin swaps to Available selected and scales to 1.08× (logic size, `bouncy`). The floating card rises from y+40 with opacity 0 → 1 (`smooth`) and the glass ✕ fades in 80 ms later (`fade.quick`, 02 rule 4.2-3).
   - The bottom stack stays hidden while the card is open (02-P3); the capsule keeps "dha" for when the card closes [S11].
   - In List mode: the view switches to map first (cross-fade `fade.std`), then the camera move [S24]; the list-card logic also switches to map.
2. VoiceOver: focus moves to the card title; it announces "GreenVolt, DHA Phase 5. Available. Rs 42 per kilowatt-hour. 1.2 kilometres. Preview."
3. Reduce Motion: the sheet fades out (`fade.std`), the camera jumps and the card fades in at its final position (`fade.std`); the pin swaps without scale.
4. **Recent station no longer exists** (404 on fetch) → the sheet stays open; the row's distance slot shows the 150 ms spinner [S22] while fetching, then the row collapses (`snappy`) and `Toast` Neutral "This charger is no longer listed." [S17] enters above the keyboard (02 §4.0 rule, one line → 4 s).
   - Haptic: none (Neutral tone, 02 §4.0 tone rule). VoiceOver: the toast is announced; focus moves to the next recent row. Reduce Motion: the row fades out; toast fades.

### 4.8 Selecting a place (→ 03.14 → 03.15, or 03.22)
1. **Tap a place row** → haptic selection. If resolving details (logic) takes > 150 ms, the trailing distance cross-fades to a small system spinner (`fade.quick`) [S22]. Further taps on any row are ignored while it resolves.
   - VoiceOver: "Opening DHA Phase 6" (polite). Reduce Motion: same cross-fade.
2. **Details resolved:**
   - The keyboard resigns.
   - The sheet morphs back into the bottom capsule, which now reads "DHA Phase 6" (Filled/On map, matched text geometry; `smooth` ≈ 450 ms) [S11]. The scrim fades out (`fade.std`); chrome and attribution fade back from t 200 ms.
   - The view switches to map (logic) and the camera flies to the place at **zoom 14** (logic; `camera` 500 ms).
   - On arrival: the place marker drops from −16pt with opacity 0 → 1 (`bouncy`).
   - Nearby stations are fetched (logic). If the fetch takes longer than 300 ms, the "Loading…" pill appears (03.14), with a 600 ms minimum on screen (02 rule 4.2-2).
   - Pins pop in nearest-first (02 rule 4.2-1: scale 0.6 → 1, `bouncy`, 20 ms stagger, 300 ms cap).
   - The notice pill "3 stations nearby" [S12] scales 0.9 → 1 in (`snappy`) as the Loading pill leaves, and leaves after 2.5 s (`fade.quick`) (03.15).
   - With 0 stations (03.22) it reads "No stations found" (real) with the 02-P6 "Clear" action if filters are on, and it stays until the camera moves, filters change or the search is cleared. "Clear" → filters reset, refetch, pins pop in, pill collapses (`snappy`). Haptic: selection on "Clear".
   - Haptic: none on arrival. VoiceOver: "Showing DHA Phase 6. 3 stations nearby." (or "Showing DHA Raya. No stations found."); focus moves to the capsule.
   - Reduce Motion: instant camera, fades only (no marker drop, no pin scale, no pill scale).
3. **Details failed** (03.23) → the spinner reverts to the distance (`fade.quick`) and `Toast` Error "Couldn't open that place. Try again." [S17] enters above the keyboard (02 §4.0 rule, one line → 4 s). The sheet and the query stay.
   - Haptic: error. VoiceOver: the toast is announced; focus stays on the row. Reduce Motion: toast fades.
4. **Pan the map afterwards** → the normal camera-idle refetch (02 rule 4.2-2). The place marker stays until the search is cleared. No haptic; no announcement beyond 02's.

### 4.9 Filled capsule on the map (03.14, 03.15, 03.22) [S11]
1. **Tap the capsule** → reopens the sheet with the text selected (§4.3-9). Press as §4.1-1. Haptic: none.
2. **Tap × in the capsule** (44pt target) → the query clears (`fade.quick` text cross-fade back to "Search chargers", the mesh P returns) and the place marker shrinks out (scale 1 → 0.8 + fade, `fade.quick`). The camera does not move and the pins stay. A "No stations found" pill from the place search leaves with it.
   - Haptic: light. VoiceOver: "Clear search, button"; afterwards "Search cleared" and focus stays on the capsule.
   - Reduce Motion: text and marker fade only.
3. VoiceOver for the capsule: "Search, DHA Phase 6. Double-tap to edit." The × is a separate element.
4. **My location** (Map Controls) while the capsule is filled → logic "closes search": the query and the place marker clear exactly as rule 2, then the camera flies to the user (02 rule 4.2-12) (§8-26).

### 4.10 Dismissing the sheet (logic: "All animate out")
1. **Tap ✕** → keyboard down. The reverse morph runs: the sheet shrinks back into the capsule and the chips fly back and turn Glass (`smooth` ≈ 450 ms). The scrim fades out (`fade.std`); the tab bar, accessory, chrome and attribution fade in from t 200 ms (`fade.quick`).
   - Cancel **discards** the typed query; the capsule returns to "Search chargers". Selection keeps it (§4.7, §4.8). Filter changes made inside the sheet stay applied (they applied on tap).
   - Haptic: light. VoiceOver: "Cancel search, button". Focus returns to the capsule.
2. **Swipe down on the grabber, header or chips** (interactive) → the sheet follows the finger (rubber-band above the large detent), the scrim alpha tracks 1 − dy/400 and the keyboard leaves on the first moved point.
   - Release past 120pt or faster than 700 pt/s → dismiss as in 1 (the sheet continues on `smooth` from the finger's velocity). Otherwise spring back (`snappy`).
   - This replaces the logic's "swipe up on the results list", because the sheet now comes from the bottom [S2].
   - Haptic: none (system sheets have none). VoiceOver: not available as a gesture; use ✕ or the escape gesture (rule 5).
3. **Tap the dimmed map strip above the sheet** (top 60pt) → dismiss as in 1. This is the logic's "tap the empty area". Haptic: none (a tap on the background, as 02 rule 4.2-5).
4. **Tap "Back to the map"** (03.07, below the results) → dismiss as in 1. It keeps the logic's "tap the empty area below" but with a visible label [S2]. Haptic: light (it is a button). VoiceOver: "Back to the map, button".
5. **System back** (Android), **Esc**, or the VoiceOver **two-finger Z** escape → dismiss as in 1. Haptic: none.
6. Reduce Motion (all of the above): the sheet fades out (`fade.std`) and the capsule and chrome fade in place.

### 4.11 Filter & sort sheet (03.17, 03.18)
1. **Open from the "Filters" chip in the search sheet** → if the keyboard is up, it resigns first. The filter sheet presents 150 ms later, so the two motions don't fight.
   - The search sheet recedes: scale 0.96, top inset +10 (iOS stacked-sheet behaviour), with a second scrim.
   - The filter sheet rises to its medium detent (`smooth`).
   - From the map or list: the sheet rises over the map with bg/scrim (02 rule 4.2-16).
   - Haptic: light. VoiceOver: the sheet is modal; focus on "Filter & sort", heading trait; then "Clear, dimmed, button" in the default state.
   - Reduce Motion: the filter sheet fades in at the medium detent (`fade.std`); the search sheet does not scale, it only dims under the second scrim.
2. **Option tap** → single-select within each section. The new option springs to Fill/Yes while the old one returns to Fill/No in the same `snappy` spring (150 ms cross-fade). "Clear" turns enabled (text/tertiary → text/brand, `fade.quick`) as soon as any section leaves its default [S15].
   - Haptic: selection. VoiceOver: "Type 2 (AC), selected, 2 of 4" (each section is a radio group).
   - Reduce Motion: instant swap.
3. **Clear** → logic: "resets the provider". Every section animates back to its default (All, Any, Nearest) with a 20 ms stagger (`snappy`). Because the reset is immediate (logic), the chips behind the scrim update in place, and Clear goes back to disabled (text/brand → text/tertiary, `fade.quick`).
   - Haptic: selection. VoiceOver: announces "Filters cleared"; focus stays on "Clear" (now dimmed).
   - Reduce Motion: no stagger; options swap at once.
4. **Show results** → button Pressed state (02 §4.0), then the sheet dismisses (`smooth`, ≈ 450 ms). The chips behind animate to the new state left → right with a 40 ms stagger (`snappy`), and the "Filters" count rolls (numeric transition).
   - Changing sort refetches nearby stations; Recommended uses the scored API (logic). The map gets the Loading pill if the fetch takes over 300 ms (02 rule 4.2-2). The sheet never waits for the fetch (logic: "applies the filters and closes").
   - In the search sheet, station rows re-filter on the preloaded list with keyed `fade.quick` (rows that leave fade out, the rest re-flow). Search rows keep their own order; the sort setting does not reorder them [S13].
   - Haptic: medium (commit). VoiceOver: "Show results, button"; afterwards announces "2 stations" (map/list) or "1 station, 4 places" (search sheet).
   - Reduce Motion: the sheet fades out, chips swap without stagger, no count roll.
5. **Scrim tap, or swipe the sheet down** (> 120pt or > 700 pt/s) → closes **without applying** (logic). Option changes made since opening are dropped. A Clear that already happened stays applied, because the logic resets the provider immediately (see §8-20). The search sheet scales back to 1 and its second scrim fades (`smooth`).
   - Haptic: none. VoiceOver: the escape gesture (two-finger Z) = this close. Reduce Motion: fade out.
6. **Drag to the large detent** → allowed. The content is short, so it just shows more space above; "Show results" stays pinned at the bottom. Haptic none; Reduce Motion: system sheet behaviour.

### 4.12 How the chips mirror the sheet (map, list and search sheet; one rule set)
1. The chips row and the Filter & sort sheet are two views of the **same** filter state (`driverFilterProvider`). Quick chip taps apply at once (no Show results), and the sheet always opens showing the current state.
2. **"Available now" chip** ⇔ Availability = Available now. Off ⇔ Any.
3. **Connector chips** "Type 2 (AC)" / "CCS (DC)" / "GB/T" ⇔ Connector type, **single-select** like the sheet. Tapping another connector chip moves the selection (the old chip deselects in the same spring). Tapping the selected chip sets All.
4. **Sort has no quick chip.** It shows in the "Filters" count and in the list header ("Cheapest first", [S18]).
5. **"Filters" chip** has the label "Filters" and leading slider.horizontal.3, and always opens the sheet.
   - Count = (connector ≠ All) + (availability ≠ Any) + (sort ≠ Nearest) [S14]. The Count is hidden at 0.
   - The variant becomes Fill/Yes when Count > 0 (02.10 and 02.17 already follow this).
6. **Materials:** on the map/list (Glass layer) unselected = Glass/No; in the sheet (Fill layer) unselected = Fill/No. Selected = Fill/Yes everywhere.
7. **Order never changes** when chips are selected (no jumping). If a selected chip is scrolled out of view, the row scrolls it into view on apply (`smooth`).
8. **GB/T** shows as selected but filters like All (logic: no backend key). The flag says so; there is no special UI.
9. VoiceOver for the "Filters" chip: "Filters and sort, 3 active, button. Opens Filter and sort."

---

## 5. Mobbin references (62 unique; all iOS)

Every major screen has at least 3 positive references (counter-examples and rejected alternatives are listed but not counted). New IDs added in review came from `mcp__Mobbin__search_screens` (platform ios, output_destination design_tool, output_tool Figma, jpg, standard) and their images were checked.

### 5.1 Search sheet: opening and idle (03.01–03.03)
- **Apple Maps — Home with bottom search capsule**: https://mobbin.com/screens/edf0fec0-9d0f-4ce8-b206-86becffb51f4
  - What we take: the morph's start state. The glass capsule sits in the thumb zone with nothing else at the bottom. Our capsule (20,731) is the same element that becomes the sheet field.
- **Apple Maps — Search sheet at large detent ("Find Nearby")**: https://mobbin.com/screens/e9bab1d0-8bf2-4307-9f04-7437fecc9f71
  - What we take: the morph's end state. The field plus a round ✕ sit at the top of a large-detent sheet, a sliver of map stays visible above it and capsule shortcuts sit right under the field (our quick chips row).
- **Apple Maps — Add Stop: Recents card with keyboard up**: https://mobbin.com/screens/f389c017-0ba2-40ef-bf74-3ff228ef3f97
  - What we take: the keyboard is up on open and Recents come first, with two-line rows (name / address) and type icons rather than clocks. That is why our recent rows reuse the result-row anatomy.
- **Apple Maps — Searching Apple Maps (flow)**: https://mobbin.com/flows/335660ac-4374-4a08-b194-8e8c40d6775e
  - What we take: the idle sheet's order: shortcuts (Places), Recents, then discovery. We map it to Saved chargers, Recent, Nearby.
- **Monzo — Search suggestions with recents**: https://mobbin.com/screens/2f456ff2-f46a-44fa-a7c2-8c247ed51867
  - What we take: scope chips directly under the field, recent rows with a per-row × and a quiet "Clear recent searches". This gives us the density and tone for Recent + Clear.
- **Rodeo — Recent searches card**: https://mobbin.com/screens/0a55dd26-b430-4f86-9397-6128c308b4f8
  - What we take: very compact recents with a trailing × each, and the circular ✕ next to the field (our Icon Button Fill M).
- **GitHub — "Recent searches" + Clear**: https://mobbin.com/screens/f8e87985-87c7-4e81-b4ee-3c288fa34421
  - What we take: the section header with a trailing text action ("Clear") is our List Group Header · action variant. The keyboard-accessory qualifier tokens (org, user, repo) inspired the plug-type keywords [S8].
- **Substack — Search idle hint**: https://mobbin.com/screens/1348058c-04d8-40c0-87ef-4545d7293846
  - What we take: tell people *what* they can search ("Find people, topics, publications, and more"). We say it with the field hint "Station name, address, or place" and the Try searching chips.
- **Pangea Charging — Saved / Nearby tabs on an EV home**: https://mobbin.com/screens/ff5e97bd-3239-44ba-bae1-1694d838940e
  - What we take: EV proof that Saved and Nearby are the two shortcuts drivers want before typing, with distance as the trailing metric.
- **Grok — ✕ · field · filter header over the keyboard**: https://mobbin.com/screens/fd54c74b-58c0-4dad-8dd0-0fe65f584786
  - What we take: the header composition with close, field and a filter control in one row. We moved the filter into the chips row so it matches the map.
- **Rejected alternative — Shop, field docked above the keyboard**: https://mobbin.com/screens/d8a26d22-8f37-432f-8a54-cfc6518cba1c and **Rodeo, bottom field with results above**: https://mobbin.com/screens/b0a2a290-55fc-481f-9f9c-700d69789be1
  - What we learned: keeping the field at the bottom feels thumb-friendly, but the results then read bottom-up and fight the keyboard. We keep Apple Maps' top-of-sheet field (and the logic's header-on-top).

### 5.2 Typing and results (03.04–03.09, 03.16)
- **Klarna — Results split into titled groups**: https://mobbin.com/screens/70a804a3-40f8-4bfb-9c24-a43286a4d382
  - What we take: separate titled groups ("Stores", "Products") for different result types. This is exactly Stations / Places, and stations come first because they are our own data.
- **Fresha — Sections with trailing distance**: https://mobbin.com/screens/df55875b-448c-4de8-a9b0-d60458b70cba
  - What we take: a right-aligned distance ("1,3 km") on every row of a section, so stations and places compare at a glance [S7].
- **Perplexity — Typed prefix vs completion weight**: https://mobbin.com/screens/b27ec646-8b6f-4dbb-9f5e-54e759155016
  - What we take: weight-only emphasis on the matched part, with no colour. That is our Headline/Body split, and it stays calm in SF Pro Regular/Medium.
- **Glovo — Heavier matched prefix**: https://mobbin.com/screens/46b2de9f-3d18-4906-989d-549baf3d99bf
  - What we take: the highlight follows the typed text on every row, including mid-name matches ("**DHA**" inside "GreenVolt · DHA Phase 5").
- **Luma — Address suggestions in a sheet**: https://mobbin.com/screens/9316b7b9-5dc7-466f-b743-67b67c66235e
  - What we take: the place-row anatomy (pin glyph in a round grey well, title plus locality line) and the sheet with a ✕ next to the field.
- **Mindtrip — Mixed suggestions with type icons**: https://mobbin.com/screens/bb21cfcf-4dbe-42e6-8fa5-6de1c197ee2a
  - What we take: different row types live in one list and are told apart by their leading icon. Ours: charger glyph for stations, mappin for places, plug glyph on a tint well for filter suggestions.
- **corner — scope chips + typed rows**: https://mobbin.com/screens/a4400c99-b9f0-48b0-815d-2c873c8bb633
  - What we take: chips under the field stay visible while typing, so the scope or filters are always in view.
- **Fresha — Scope chips with counts while typing**: https://mobbin.com/screens/014b6ccf-4bbf-4156-871e-2f22bc841eff
  - What we take: a first row that turns the query into an action ("Search for 'hair'"). Our filter suggestion row "Show CCS (DC) chargers" works the same way [S8].
- **Places — Suggestions card + "Back to the map"**: https://mobbin.com/screens/4c64231b-6c8a-47fe-8108-0388a193c157
  - What we take: a quiet text action below the results that returns to the map. It makes the logic's "tap the empty area below" visible [S2].
- **Agoda — Search over the map with "12 Suggestions" (flow)**: https://mobbin.com/flows/83228b2e-1a0f-4d56-8960-705509a4c49e
  - What we take: suggestions shown over a dimmed but still visible map keep the user's spatial context. That supports our 60pt map strip above the sheet.
- **Rodeo — "Results from Map" header**: https://mobbin.com/screens/60e1d6ca-e5be-4e99-b01b-75e995af3fd2
  - What we take: a small grey section label that names the source of the results ("Places" is our version, with the Google attribution as the footer).
- **Transit — "Hollywood": Recent + Stops and stations**: https://mobbin.com/screens/62e5b68b-93eb-4842-a3d9-b12a44255125
  - What we take: typed results split into a short "Recent" group and a typed "Stops and stations" group, each row with a type glyph and a compact attribute line. Same two-tier order as our recents-then-Stations, and proof that a transport app can show attributes (lines, for us plugs) under the name.
- **Etsy — "Shop names including …" section**: https://mobbin.com/screens/7f4c4548-8a61-4c3d-a151-858e9330764e
  - What we take: the matched query part is styled differently from the rest of each suggestion, and a second titled group lists entities (shops) under the suggestions. Confirms highlight + typed sections in one scroll.

**Keyword and plug queries (03.08, 03.09) [S8]**
- **Grab — "Search for 'kkado' in Restaurants / Dishes"**: https://mobbin.com/screens/a0f723fd-470f-40d0-8bf4-826af726aad2
  - What we take: scope chips under the field and rows that turn the typed word into a scoped action. Our "Show CCS (DC) chargers" row is the same move, scoped to a connector.
- **GitHub — "Repositories with …" scope rows with chevrons**: https://mobbin.com/screens/48211ae3-a02e-4a24-b49f-f47668621688
  - What we take: action rows (icon + "X with '{query}'" + trailing chevron) above the keyboard, separate from content results. The anatomy of Search Result Row / Filter (icon well, title, trailing chevron.right).
- **Shell — connector rows "CCS · 180 kW"**: https://mobbin.com/screens/03a69161-0568-4a8e-8bad-1c6a206ac275
  - What we take: the EV-standard way to write a plug line: plug name · power. Our plug subtitle "CCS2 (DC) · 60 kW · Gulberg III" follows it and adds the area.
- **Tesla — Nearby Chargers list with "kW max" and speed toggles**: https://mobbin.com/screens/3351f028-dab2-46f9-b92b-e6c7ecd01634
  - What we take: when the driver filters by charging speed, each row shows the power and the price per kWh; distance stays the trailing number. Supports showing kW in plug-query rows.

### 5.3 Empty, loading and errors (03.04, 03.05, 03.10–03.12, 03.23, 03.24)
- **Rodeo — No Results**: https://mobbin.com/screens/a9e8425e-786f-4d05-9685-c6ac6638a781
  - What we take: magnifier, one title and one helpful line. Our Empty row keeps the logic title and adds a "try an area" hint [S16].
- **Starling — Skeleton lines inside the results card**: https://mobbin.com/screens/e8d323c8-2695-4561-a787-e844fbfc5184
  - What we take: loading lives inside the section it belongs to, not as a full-screen spinner. That is the logic's trailing "Loading…" row under Places.
- **Luma — Skeleton result rows under a filled field**: https://mobbin.com/screens/567ac178-b443-4ca7-84b5-8a9d2d946f0d
  - What we take: placeholder rows keep the list's geometry while the first results load (03.04), with the field fully usable above.
- **Noom — Small toast just above the keyboard**: https://mobbin.com/screens/9b66cd62-1760-49a9-94dd-a29adbe3f058
  - What we take: placement. The toast floats 12pt above the keyboard, short and non-blocking. This is where "Could not load place suggestions…" goes.
- **Lloyds — Inline search error card**: https://mobbin.com/screens/703f45f6-5c95-4b3a-a966-4cedd6f67ae4
  - What we take: the counter-example. An inline error card pushes results down. We prefer the toast because station results still work offline.
- **Fresha — "0 results · Remove filters" + No internet**: https://mobbin.com/screens/b6f7d349-7d9f-466f-87ce-a2ed5c95b585
  - What we take: when filters cause the emptiness, offer the way out in place. That is "Clear filters" on our Empty row [S16], and Retry for 03.12.
- **Wispr Flow — "No Results for 'Mobbin'"**: https://mobbin.com/screens/ddfd985e-b174-43ad-a028-56979103afd9
  - What we take: magnifier + one title + "Check the spelling or try a new search." directly under a still-filled field. The tone of our 03.10 helper line.
- **LinkedIn — "No results found" + "Remove all filters"**: https://mobbin.com/screens/994c2b74-b200-413e-9fef-1f3bb9632ab9
  - What we take: when filters are active, the empty state names them as the cause ("Try removing filters…") and offers the reset as the main action. That is 03.24's "Some stations are hidden by your filters." + "Clear filters".
- **Perplexity — inline "Something went wrong" + Try again under the field**: https://mobbin.com/screens/53c1cd17-3832-45bf-adcc-d86bd15c7a15
  - What we take: the error lives in the result area of the search screen, with the field and Cancel still usable above it. That is 03.12 (State View inside the sheet, not a full-screen takeover).
- **HYPE — "There is no network connection" + Retry**: https://mobbin.com/screens/e058ad1f-07de-4aed-8eac-7944bb0c2483
  - What we take: a short title, "Check your network connection and try again." and one Retry button, centred in a sheet. Matches our copy "Check your connection and try again." and the State View layout.

### 5.4 Outcomes on the map (03.13–03.16, 03.22)
- **Pangea Charging — Searching a location (flow)**: https://mobbin.com/flows/c1c73804-e170-463e-b1a7-7d10f89143e2
  - What we take: on an EV map, the chosen result keeps its name in the search field with a ×, the map recentres on a marker and a place card appears. This is our filled capsule [S11] and place marker.
- **Places — Searching Places (flow)**: https://mobbin.com/flows/64e98700-11fe-4926-b935-60de08c0e195
  - What we take: after selection the field reads "Café Vins ×" and the quick chips stay under it on the map. Clearing it is one tap.
- **Rivian — Finding a charger (flow)**: https://mobbin.com/flows/d30189e8-f1b1-411f-bd1f-6b3c55ec5bc3
  - What we take: an EV map with a search field and filter control, and the Google Maps attribution kept bottom-left. Attribution must survive every search state.
- **Tesla — Nearby chargers (flow)**: https://mobbin.com/flows/5f852fcb-bf0d-4572-a7e4-7e363d02b6a1
  - What we take: after the camera moves, chargers appear with distance and price as the two decision numbers. We confirm the result with the "3 stations nearby" notice [S12].
- **Apple Maps — Gas stations results with chips + sort**: https://mobbin.com/screens/e47f2f0c-d839-4fc4-b378-5613feb3f1fd
  - What we take: the query stays in the field ("Gas Stations ×") above filtered results, and the filter and sort chips live in the same row.
- **Places — "Café Vins ×" with a selected pin and floating card**: https://mobbin.com/screens/04c21f71-a65c-4853-bbcc-e070a1718893
  - What we take: 03.13 exactly: after picking a result, the field keeps the name with a ×, the quick chips stay, the chosen pin is enlarged with its label and a floating card sits above the tab bar.
- **corner — query kept + selected pin + card**: https://mobbin.com/screens/b1a2b070-b7a1-4a29-bb7a-6ca299f6ac26
  - What we take: the selected pin is visually lifted (larger, outlined) while the other pins stay small, and the card's actions (share, directions) sit at its bottom. Our selected pin at 1.08× and the card's View Details / Book now row.
- **Fresha — floating card with ✕ over the selected map pin**: https://mobbin.com/screens/abb05e80-3e17-4903-97c1-e9f92f2c2b2b
  - What we take: a round ✕ that floats at the card's top-right edge, separate from the card content. The position of our glass ✕ at (352,564).
- **Cash App — search-location marker among result pins**: https://mobbin.com/screens/d3acd91b-fce0-4d8b-a022-d1a423d994f5
  - What we take: the searched address is a different marker (black pin with a magnifier) from the result pins, with "Showing locations near …" at the top. The basis of our ink **Map Marker / Place** (03.14, 03.15) and the "{n} stations nearby" notice [S12].
- **Mindtrip — "Tacos" kept in the field + loading pill at top centre**: https://mobbin.com/screens/915b8b44-9102-408d-af2a-60266072067c
  - What we take: while the map fetches results for a search, a small pill at the top centre shows progress and the query stays in the field. That is 03.14's "Loading…" pill at y 64.
- **Tripadvisor — "No results found for this area." over the map**: https://mobbin.com/screens/03568175-b53e-41ab-9def-70c217675e6f
  - What we take: a zero-result area is a quiet floating notice on the map, not a modal. That is 03.22's "No stations found" pill.
- **Meetup — "Map Search Area ×" + No results card**: https://mobbin.com/screens/b010f489-55f3-44c2-ae25-33727141ae17
  - What we take: the searched area stays in the field with a × and the empty result offers a next step. Ours offers "Clear" when filters are on [02-P6]; otherwise moving the map refetches.

### 5.5 Filter & sort and chip mirroring (03.17–03.21)
- **Mindtrip — Filters sheet**: https://mobbin.com/screens/44b7b958-b5db-425d-839e-6d5651f0b0bf
  - What we take: plain section headers, single-select outline chips, a quiet "Clear" and a heavy full-width primary ("Show places"). This is the visual target for our options.
- **LinkedIn — "Reset" in the header + "Show results"**: https://mobbin.com/screens/b779fcd4-2cb2-4fbe-ab2d-39344992a582
  - What we take: confirms the logic's layout (Clear top-right, "Show results" pinned bottom) and the radio behaviour of sort options.
- **Glovo — Sort sheet over a chips row with a count chip**: https://mobbin.com/screens/d08d2231-bb94-4732-9eda-522f652d003b
  - What we take: the chips row behind the sheet shows a count ("Food type 4") that mirrors the sheet. This is our "Filters 3" chip [S14].
- **Tesla — Filtering chargers (flow)**: https://mobbin.com/flows/f56b5cde-9770-4441-a7c9-a13754827d74
  - What we take: after applying, the filter icon gets a count badge ("3"). EV proof that drivers expect a visible active-filter count on the map.
- **Tesla — Filter sheet with speed tiles**: https://mobbin.com/screens/531e63d4-56a5-4279-932a-7258d82ee3c9
  - What we take: charger type shown as large icon tiles; the basis of [S19] (Connector Tile grid, not applied tonight).
- **Pangea Charging — Filter sheet (Price / Speed / Plugs)**: https://mobbin.com/screens/59fa861c-6b07-4acd-b15a-e0940daaface
  - What we take: a short EV filter sheet over the map at a medium detent, with plugs summarised in one line ("NACS, CCS"). It proves a sheet this short is enough.
- **Pangea Charging — Filtering chargers (flow)**: https://mobbin.com/flows/9aafcf13-3b91-40a0-9227-378ff1db0ab0
  - What we take: plug icons in a grid of tiles (NACS / CCS / J1772 / CHAdeMO) [S19], and quick chips ("Fastest", "Cheapest") on the map, which matches our sort keywords [S8].
- **Shell Recharge — "Available" + "Rapid 50kW+" chips on the map**: https://mobbin.com/screens/7286b6e1-5c70-4e37-9361-c4d294176a83
  - What we take: availability and connector-speed as top-level quick chips over the map. This validates "Available now" plus the connector chips.
- **Afterpay — Sort + filters in one sheet with Reset / Apply**: https://mobbin.com/screens/6397c8c1-6e38-4a11-9bbe-fb1bfd323309
  - What we take: sort as radio rows and filters in the same sheet, with one reset. It supports counting sort in the "Filters" badge [S14].
- **Starbucks — "Show 50 stores"**: https://mobbin.com/screens/7b343b35-b4fd-4fa1-9b6f-ead2e1d7cdbb
  - What we take: a live count in the CTA (02-P23, still not applied; needs a count API).
- **komoot — Spinner inside the Apply button while recomputing** (counter-example): https://mobbin.com/screens/05775c8b-e911-48bf-988a-4c78e68bade1
  - What we learned: a spinner in the Apply button keeps the sheet open until the data is back. The logic closes on "Show results", so our feedback moves to where the results appear: the map's "Loading…" pill (02.07) and keyed row updates in the search sheet. Not counted toward the ≥ 3 references for 03.17–03.21.

---

## 6. New components needed (not in the inventory)

| Component | Purpose | Variants | Props / anatomy |
|---|---|---|---|
| **Search Result Row: new variants** (add to set 971:284) | Recents, filter suggestions, resolving and pressed rows (03.02, 03.08, 03.09, §4.8) | Kind = Station · Place · **Filter** (new) · Loading · Empty; Trailing = Distance · **Remove** (xmark 958:72, icon/tertiary, 44pt target) · **Spinner** · **Chevron** · None; State = Default · **Pressed** (bg/fill row background). Minimum to add: `Recent station`, `Recent place`, `Filter suggestion`, `Station resolving`, `Place resolving`, `Pressed` | `Title` (TEXT; match range uses Headline, rest Body), `Subtitle` (TEXT, Footnote text/secondary, 1 line, tail truncation), `Distance` (TEXT, Footnote text/secondary), `Show distance` (BOOL), `Icon` (INSTANCE_SWAP, 20pt in a 32pt well: Station = ev.charger.fill on bg/tint/icon/brand; Place = mappin on bg/fill/icon/secondary; Filter = plug glyph on bg/tint/icon/brand), `Separator` (BOOL, inset to the text). Empty kind adds `Message` (TEXT, Footnote text/secondary, wraps to 2 lines; 03.10 / 03.24 helper lines) and `Show action` (BOOL) with a nested `Button / Medium` Secondary 978:458 ("Clear filters"). Height 56 (keep the existing row height if it differs). Match highlight = Headline/Footnote Emph (both SF Pro Medium) on the matched range only. |
| **List Group Header · action** (add to set 983:389) | "Recent · Clear" and future section actions | Trailing = None · **Action** · **Status** | `Label` (existing), `Action label` (TEXT, Subheadline, text/brand; disabled = text/tertiary), `Status` (TEXT, Footnote text/tertiary, e.g. "Loading…"). 44pt hit area on the action. |
| **Sheet / Search** (composite) | The search sheet chrome, so the 15 sheet frames (03.02–03.12, 03.16, 03.19, 03.23, 03.24) don't hand-assemble it | State = Idle · Typing · Results (keyboard down) | 402×814, bg/surface, radius/sheet top, Frost/Elevated; grabber; header row (`Search Field` In sheet instance + `Icon Button` Fill M xmark); chips row (5 `Chip` instances, exposed); `Content` slot (auto layout, vertical, x 16, width 370); `Query` text exposed via the nested Search Field. |
| **iOS / Keyboard · Return properties** (extends 01's `iOS / Keyboard` system stand-in; do **not** create a second keyboard set) | Shows where the keyboard sits in every typing frame (03.01–03.11, 03.16, 03.23, 03.24) | 01 defines Type = Default · Email · Phone pad · Decimal pad. This flow adds two properties on Type=Default: `Return label` = return · search (05 later adds go) and `Return enabled` = Yes · No (No = grey key while the field is empty, `enablesReturnKeyAutomatically`); Suggestions bar = On · Off | 402×336 incl. its own home indicator, light system keyboard material (system colour, not a brand token), 3 letter rows + bottom row (123, emoji, space, Return), globe and mic row. Return in system blue with the label "search" when enabled. Keep 01's frame label ("System UI", OS-owned, not built in Flutter). |
| **Attribution / Google** | Places attribution required by Google's terms when Places results show (logic: "Google attribution footer") | Placement = In list · On map (matches 1077:144) | "Powered by Google" lockup: Google logo asset (official, grey) + Caption 2 text/tertiary; In list = left-aligned, 16 inset, 24 tall. Rayan should use the Places SDK-supplied logo image. |
| **Map Marker / Place** | Marks the chosen Google place after "fly to zoom 14" (03.14, 03.15, 03.22) | State = Default · Dropping (doc still: −16pt, 50% opacity) | 32pt teardrop pin filled `text/primary` (ink) with the mappin 1025:485 glyph in `icon/onPrimary`, Shadow/Pin effect, label below (Caption 1 Emph, text/primary, 2pt `bg/surface` halo stroke). Distinct from the white price pins so nobody mistakes a place for a charger. |

**Reused, no change needed:** `Toast` (Error and Neutral tones), `State View` (Error), `Map Status Pill` (Loading, Notice), `Chip`, `Search Field`, `List Row`, `List Group Header`, `Sheet / Filter & sort` (state overrides only, plus Clear's disabled colour [S15]), `Station Card` (Map preview, List), `Map Pin`, `Button / Large` + `Button / Medium` (incl. Medium Primary Loading 978:449), `Icon Button` (Fill M, Glass S), `Map Controls`, `Tab Bar` Home, iOS Status Bar Dark, iOS Home Indicator Dark, Mesh Quiet.

**From sibling specs (dependencies, not new here):** `iOS / Keyboard` (01 §6), `Map Status Pill · action` Notice + Action (02 §6, used by 03.22), `Scroll Edge Fade` (02 §6, used by 03.21).

**Missing SF Symbols noted:** "Sort by …" suggestion rows want `arrow.up.arrow.down`. Use line.3.horizontal.decrease 958:16 and note the wanted symbol in the FLAG card.

---

## 7. Proposals (not in the logic map), flagged

| # | Proposal | Why | In frames? |
|---|---|---|---|
| S1 | The search opens as an Apple-Maps-style sheet that grows out of the bottom capsule. Its header is the field + ✕, with the same quick chips row under it. The logic's repeated top bar (logo mark + "Pak" "Plug" wordmark, heart, bell) and Map/List toggle are not repeated inside the sheet (wordmark decision shared with 02-P27). | Concept A (thumb zone, place sheets). The chips row already carries the filter button's job. The Map/List toggle isn't needed because a result always lands on the map (logic: places switch to map). | yes |
| S2 | Dismiss gestures are mirrored for a bottom-origin sheet: swipe **down** (not up), ✕, tap the dimmed map strip, and a visible "Back to the map" text button for "tap the empty area below". | The logic's gestures assumed a top panel. Same intent, native direction, and discoverable. | yes |
| S3 | **Recent** searches: selected results only (not keystrokes), max 6, stored on the device, deduped by id, re-selection moves to top, per-row ×, "Clear" without confirmation, wiped on sign-out. | Drivers return to the same 2–3 chargers. Apple Maps, Monzo and Rodeo all lead with recents. | yes |
| S4 | **Saved chargers** shortcut row ("3 saved"; hidden at 0 saved) and **Nearby** (3 nearest preloaded stations, excluding ones already in Recent, respecting filters; hidden without a GPS fix) on the idle sheet. | The data already exists (the overlay preloads nearby stations; favourites exist). Gives value before typing. The heart in the top bar is covered by the sheet. | yes |
| S5 | **Try searching** chips ("DHA Phase 5", "Type 2", "Liberty Market") whenever Recent is empty: first use, after "Clear", after the last recent is removed, after sign-out. | Teaches what can be searched (area, plug, place) without a tutorial. | yes |
| S6 | Section headers "Stations" / "Places" and the subtitle match highlight. | Makes the logic's two sources visible; the Google attribution sits under Places only. | yes |
| S7 | Distance on Place rows, using Places Autocomplete `origin` (= the fetch centre). | Lets drivers compare places with stations; Fresha and Apple Maps do it. Needs one request parameter. | yes |
| S8 | **Keyword map**: plug words (ccs, ccs2, dc, fast, rapid → CCS (DC); type 2, type2, t2, ac → Type 2 (AC)), availability words (available, available now, free → Available now), sort words (cheap, cheapest, price → Price; nearest, near me → Nearest; top rated, best, rating → Rating). Produces one suggestion row. Plug words list the stations with that plug and swap their subtitle from the address (logic: "subtitle = address") to "{plug label} · {maxPowerKw} kW · {area}"; availability words list the Available stations (address subtitle); sort words add no rows. Places are skipped for pure keywords (a keyword plus other words runs the normal search). Suggestion subtitles "Filter the map by connector", "Available now", "Change how stations are sorted" are new copy. No GB/T suggestion (no backend key). | Hammad asked for plug-type search. It is pure client logic on existing filter state, with no API change. | yes |
| S9 | Places requests start at 2 characters; stations at 1. | Saves Places API cost; a 1-letter place query is noise. | interaction only |
| S10 | Return ("search") hides the keyboard and never auto-selects; scrolling hides the keyboard interactively. | No surprise camera jumps; native behaviour. | yes (03.07) |
| S11 | After a selection the capsule keeps the query/place name (Filled/On map + ×); tapping reopens the sheet with the text selected; × clears it and removes the place marker. Cancel (✕) discards the query. My location clears it too (logic: My location "closes search"). | Apple Maps, Pangea and Places all keep the query; it makes "back to my results" one tap. | yes |
| S12 | Place marker on the map + a "{n} stations nearby" notice pill for 2.5 s after a place fetch. | Confirms that the jump worked and how many chargers are around; the marker shows *which* place was chosen. | yes |
| S13 | Station results respect the active connector/availability filters, applied client-side to the overlay's preloaded list with no refetch while the sheet is open (logic: not stated **(?)**); Places never do. The sort setting never reorders search rows: they keep the preload order (distance from the fetch centre **(?)**). | The chips are visible in the sheet, so results must agree with them; a sort that reshuffles rows while typing would feel random. Rayan to confirm the provider used by the overlay and its order. | yes (03.19, 03.24) |
| S14 | The "Filters" chip count includes a non-default sort; the chip turns Fill/Yes when the count > 0 (same rule as 02-P26; 02.10 already follows it). | The sheet is "Filter & sort"; otherwise a Price sort would be invisible on the map. Tesla and Glovo show counts. | yes |
| S15 | "Clear" is disabled (text/tertiary) when the sheet is at its defaults. | Shows nothing is active; prevents a no-op tap. | yes |
| S16 | The Empty row gets a helper line: "Check the spelling, or try an area like "DHA Phase 5"." with no filters on (03.10); "Some stations are hidden by your filters." plus a "Clear filters" button when filters are on (03.24). | The logic's one-liner gives no way forward; when filters cause the emptiness, saying so is more honest than "check the spelling" (LinkedIn, Fresha). | yes (03.10, 03.24) |
| S17 | Error copy: "Couldn't open that place. Try again." (place details failed, Toast Error) and "This charger is no longer listed." (recent station 404, Toast Neutral). | Neither case is covered by the logic. | yes (03.23; the Neutral case is a canvas note) |
| S18 | List header shows the sort: "2 stations · Cheapest first" (extends 02-P8). | Mirrors the sort, which has no chip. | yes (03.21) |
| S19 | Connector type as a 2×2 `Connector Tile` grid (All / Type 2 (AC) / CCS (DC) / GB/T with plug icons). | Tesla and Pangea use icon tiles; the component already exists. Not applied tonight, so 1012:432 stays as built. | no |
| S20 | "My vehicle" filter: show only chargers that fit the primary vehicle (BYD Atto 3: Type 2 + CCS2). | Removes a decision for most drivers. Needs multi-connector filtering in the backend. | no |
| S21 | Hardware keyboard ↑/↓/Return/Esc in results. | iPad and Mac; cheap to add. | interaction only |
| S22 | Loading-row threshold 150 ms, resolve spinner after 150 ms, and a stale-response guard (sequence id). | No flicker, and results never go backwards. | interaction only |
| S23 | Hide a Place whose name exactly equals a Station name shown in the same list. | Avoids two rows for one physical location. | interaction only |
| S24 | Picking a station from search flies the camera to **zoom 15** and, if Home was in List mode, switches to map first (reuses the list-card rule "switches to map view, centres at zoom 15"). | The logic only says "close the overlay and select it on the map" **(?)**; the preview card only exists in map view, so List mode must switch. | yes (03.13) |
| S25 | A failure state for the overlay's station preload: `State View` Error "Couldn't load stations" / "Check your connection and try again." / Retry (copy = 02-P15) inside the sheet; Places are paused and no Places toast shows while it is up. | The logic defines the preload (max radius, fallbacks) but no failure state **(?)**; without one, "No stations or places found." would lie about why the list is empty. | yes (03.12) |
| S26 | All VoiceOver labels, hints, custom actions ("Remove from recents") and announcements in §4. | Accessibility strings are new copy (not visible); same convention as 02-P34. | interaction only |

---

## 8. Edge cases & defaults chosen (Hammad asleep: decided)

1. **Opened in List mode.** The background is the Mesh Quiet list. A station or place selection switches to map (logic for places; for stations the list-card rule is reused [S24]). Cancel returns to the list.
2. **No GPS fix** (denied, services off, Not now). Distances are hidden on rows (02 edge #4). Nearby is hidden, because it would be misleading on the Lahore default. Places `origin` = map centre. Recent, Saved and Try searching still show.
3. **Station preload still loading.** "Stations" shows a Loading row (03.04); Places run in parallel; rows cross-fade in when ready.
4. **Offline.** Stations still match against the last preload. Places fail with one toast per sheet session (03.11). With no preload at all → 03.12 State View Error + Retry [S25], and no Places toast while it shows.
5. **Very fast typing.** Only the last debounced query renders (300 ms, logic); stale responses are dropped [S22].
6. **Which station fields match.** Default: name + address + plug types [S8], word-prefix, case-, accent- and space-insensitive ("dha5" does not match "DHA Phase 5"; no fuzzy matching in v1). Rayan to confirm the current match fields **(?)**.
7. **Urdu script or Roman-Urdu spellings** ("Gulbarg"). Stations won't match (English names); Places handles spelling variants. Acceptable for v1.
8. **Result caps.** 10 stations, 5 places (logic). No "See more" in v1.
9. **Duplicates.** Nearby hides stations already in Recent. A Place equal to a Station name is hidden [S23].
10. **Session active.** The accessory is covered by the sheet and returns on dismiss with the raised stack (02 rule 4.2-21).
11. **A selected station is excluded by the current filters** (e.g. a recent offline station with Available now on). Still selectable; the card shows its real status and the pin stays until the card closes (02 edge #6).
12. **Recent station deleted on the server.** Toast Neutral "This charger is no longer listed." (no haptic, Neutral tone) and the recent is removed [S17] (§4.7-4).
13. **Dynamic Type (AX sizes).** Row titles wrap to 2 lines; distance moves under the subtitle; the chips row scrolls; the header field grows taller and the ✕ stays 44pt.
14. **Long names and queries.** Titles truncate to 1 line (tail) and subtitles to 1 line; the field scrolls horizontally. VoiceOver reads the full text.
15. **Empty Return.** Disabled (`enablesReturnKeyAutomatically`).
16. **Filters opened while the keyboard is up.** The keyboard resigns first and the sheet presents 150 ms later (§4.11-1).
17. **Orientation.** Portrait only (driver app).
18. **Attribution.** "Powered by Google" shows whenever Places rows are visible (end of the list). The map's own Google attribution is hidden while the sheet is open (logic: "hidden while search is active") and visible again in every map frame after it closes (03.13–03.15, 03.20, 03.22; 02 edge #23).
19. **GB/T.** A chip and sheet option exist (logic) but filter like All. There is no keyword suggestion for GB/T [S8]. Flag: hide GB/T until the backend key exists, or add the key.
20. **Clear vs scrim dismiss.** The logic's Clear "resets the provider" immediately, so a later scrim dismiss cannot undo it. Other option changes are discarded on scrim dismiss (logic). Flag for Rayan in case Clear should be draft-only.
21. **Search while a station card is open.** The capsule is hidden while the card is open (02-P3). Close the card (✕ or swipe) first; the capsule returns filled.
22. **Sort = Recommended.** Uses the scored API (logic). The "recommended" highlight on cards is not rendered (logic gap, Appendix 4) and is out of scope here.
23. **Recents privacy.** Stored only on the device, cleared on sign-out, never synced.
24. **Two sheets stacked** (Filter & sort over Search). At most two levels. Filter & sort never opens a third sheet.
25. **Android.** Same layouts. The search sheet is a full-height modal bottom sheet; there is no Glass, chips use Fill. The keyboard IME action is `search`. Haptics map as in 02 edge #26.
26. **My location with a filled capsule.** Logic: My location "clears selection, closes search, switches to map, recentres". With a filled capsule [S11] it clears the query and the place marker (§4.9-4), then flies to the user. With the sheet open it cannot be tapped (covered).
27. **Zero saved chargers.** The Saved chargers row is hidden on the idle sheet (no dead-end shortcut) [S4].
28. **Recent becomes empty** (last × or Clear). Try searching takes its place at once (§4.2-2/3) [S5]; it never leaves an empty gap.
29. **Taps while a place resolves.** Further row taps are ignored until the details resolve or fail (§4.8-1); ✕ and swipe-down still dismiss and cancel the request.
30. **Keyword + filter already on.** Tapping "Show CCS (DC) chargers" while "CCS (DC)" is already selected keeps it selected (no toggle-off) and just returns to the map.
31. **Search with Dynamic Type at AX sizes and a keyboard.** The visible list area above the keyboard shrinks to about 3 rows; the toast still sits 12pt above the keyboard and may cover the last visible row (acceptable, it is transient).

---

## 9. Logic-check summary (for the logic card)

Every logic item for this flow and where it is shown. "Real" = verbatim copy; [S#] / [02-P#] = proposal in the FLAG block.

| Logic item (driver-logic-map.md) | Covered in | Notes |
|---|---|---|
| §B Search block · fake field "Search chargers"; tap opens the overlay | capsule (02 §2.0), 03.01, §4.1 | real |
| §B Search block · filter square button → filter sheet | "Filters" chip, §4.11-1, §4.12-5 | [02-P26], count [S14] |
| §B Overlay visuals · scrim fade-in | 03.01, §4.1-2 | |
| §B Overlay header · repeats the top bar (logo + wordmark, heart, bell) | not drawn | [S1], shared with [02-P27] |
| §B Overlay header · field hint "Station name, address, or place" | 03.02, §3.1 | real |
| §B Overlay header · filter button, Map/List toggle | "Filters" chip in the sheet; toggle dropped | [S1] |
| §B Station data · loads all nearby stations (max radius) on open around the last fetch centre, fallbacks GPS → camera → default | 03.04, 03.02 note (a), §4.3-6 | failure state [S25] (03.12) |
| §B Query · 300 ms debounce | §4.3-2, §8-5 | stale guard [S22] |
| §B Query · local stations max 10; title = name, subtitle = address, trailing distance | 03.05, 03.06, §4.3-2 | plug subtitle only for plug keywords [S8]; filters applied [S13] |
| §B Query · Google Places max 5; title/subtitle split | 03.06, 03.16 | 2-char start [S9]; distance [S7] |
| §B Result panel · initial "Loading…" | 03.04 | real |
| §B Result panel · Places still loading: trailing "Loading…" row | 03.05, §4.3-4 | real; 150 ms threshold [S22] |
| §B Result panel · empty "No stations or places found." | 03.10, 03.24, §4.6-1/2 | real; helper lines + Clear filters [S16] |
| §B Result panel · snackbar "Could not load place suggestions. Check your connection." | 03.11, §4.6-3 | real; shown as the app-wide `Toast` Error (02 §6) |
| §B Result panel · Google attribution footer | 03.06, 03.07, 03.19 | "Powered by Google" (Google's required wording) |
| §B Action · tap a station → close overlay, select on map | 03.13, §4.7 | zoom 15 + List → map [S24]; recents [S3] |
| §B Action · tap a place → resolve details, switch to map, zoom 14, fetch nearby | 03.14, 03.15, 03.22, §4.8 | marker + notice [S12]; filled capsule [S11]; failure copy [S17] (03.23) |
| §B Dismissal · tap the empty area below, swipe up on results, system back; all animate out | §4.10 | mirrored for a bottom sheet + "Back to the map" [S2] |
| §B Map · Google attribution hidden while search is active | §2.0 A rules, §8-18 | |
| §B Map · My location FAB "closes search" | §4.9-4, §8-26 | clears the filled capsule [S11] |
| §B Filter sheet · stack overlay; title "Filter & sort"; trailing Clear resets the provider | 03.17, 03.18, §4.11-3 | real; disabled Clear at defaults [S15] |
| §B Filter sheet · Connector type All / Type 2 (AC) / CCS (DC) / GB/T (GB/T behaves like All) | 03.17, 03.18, §4.12-8, §8-19 | real; no GB/T keyword [S8] |
| §B Filter sheet · Availability Any / Available now | 03.17, 03.18 | real |
| §B Filter sheet · Sort by Recommended / Nearest / Price / Rating; default Nearest | 03.17, 03.18, 03.21 | real; header [S18] |
| §B Filter sheet · Show results applies and closes; scrim closes without applying | §4.11-4/5, §8-20 | real |
| §B Filter sheet · sort change refetches; Recommended uses the scored API | §4.11-4, §8-22 | search rows not reordered [S13] |
| §B Filter state · price, distance, rating filters exist but aren't surfaced | not drawn | on purpose |
| §B Favorites · "Saved chargers", "N saved" | 03.02 Saved row | real copy reused as a shortcut [S4] |
| §B List · tap → map, zoom 15; empty title "No stations found" | 03.13 [S24], 03.22 | real |
| §A Charging pill above the nav while a session is active | §4.1-4, §8-10 | covered by the sheet, returns on dismiss |

**FLAG — PROPOSALS block (for the card):** S1–S26 from §7, plus the 02 proposals this flow reuses: 02-P2 (distance on the card), 02-P3 (stack hidden + glass ✕), 02-P4 (Loading pill), 02-P6 (Clear on "No stations found"), 02-P15 (error copy), 02-P26 (chips + "Filters"), 02-P27 (no wordmark on Home/search). Missing SF Symbol: `arrow.up.arrow.down` for sort suggestions (line.3.horizontal.decrease used).

Not in this flow:
- The map, list, Saved chargers and Price Trends → 02.
- Station Detail, Reviews, Directions and Book a slot → 04 (04.01, 04.02, 04.24).
- Live charging accessory states → 06.

---

## Review notes (design review pass, 2026-10-04)

Checked against `BRIEF.md`, `driver-logic-map.md` §B (`_DriverSearchOverlay`, `DriverFilterBottomSheet`, `DriverHomeScreen` chrome/list/My location), Appendix 3–4, and the reviewed sibling `02-discover.md` (motion tokens, Toast rules, status mapping, proposals P2–P34) plus `01-onboarding.md` (`iOS / Keyboard`). What changed:

**Missing logic states, errors and copy (added)**
1. Three new P2 frames for states that only lived in prose: **03.22 · Search → Place · No stations nearby** (real "No stations found" + 02-P6 "Clear", persistent pill), **03.23 · Search · Couldn't open place** ([S17] Toast Error; the recent-404 Neutral toast is a canvas note) and **03.24 · Search · No results · Filters on** (honest helper line + "Clear filters"). 21 → 24 frames (16 P1, 8 P2); old numbers kept because 02 cites 03.20/03.21.
2. Idle sheet variants added as canvas notes on 03.02: Nearby "Loading…" row while the preload runs (logic "Initial loading"), Saved row hidden at 0 saved, Nearby hidden without GPS.
3. Logic items the draft skipped are now covered: the overlay header "repeats the top bar" incl. logo + wordmark (explicitly dropped, [S1] + 02-P27); preload "max radius" + fallback order; map attribution "hidden while search is active" (§2.0 rule, §8-18); My location "closes search" (new §4.9-4, §8-26); the Favorites "N saved" copy source.
4. Logic-check summary rewritten as a coverage table (§9, every §B item → frame + rule), with the FLAG block listing S1–S26 and the reused 02 proposals. Exit "Book a slot → 05" corrected to **04** (04.01/04.02/04.24), matching 02's review.
5. "Try searching" now appears whenever Recent is empty (after Clear / last ×), not only on first use, so Clear never leaves a gap.

**Invented data or behaviour without a flag (now flagged)**
6. Plug-query rows swapped the logic's address subtitle for plug info silently: now explicit in [S8], with the format aligned to the station card's plug label ("CCS2 (DC) · 60 kW · Gulberg III"; the draft's "CCS2 · 60 kW DC" disagreed with 02.31). Availability and sort keywords now say what rows they produce.
7. New proposals: [S24] zoom 15 + List → map on station pick (logic only says "select it on the map"); [S25] the overlay preload failure state (03.12 had no logic basis and no flag); [S26] all VoiceOver strings (same convention as 02-P34). [S13] now states that filters apply client-side to the preload and that the sort never reorders search rows (the draft said results "re-sort", which was undefined). [S16] split into two helper lines; [S4], [S5], [S11], [S14], [S17] tightened.
8. 02-P26 is now cited wherever the "Filters" chip label appears.

**Consistency with the brief and the sibling specs**
9. Added a "Material + type rules" block: no Hero mesh in this flow (so text/onMesh is unused and the measured contrast rule has nothing to apply to), Frost Strong for floating station cards, Fill inside the sheet, SF Pro Regular/Medium only (Emph = Medium), numbers in component number slots, and the brand = mesh P in the capsule (wordmark not used).
10. `iOS / Keyboard` was defined a second time with different variants and label; it now **extends 01's component** (adds Return label "search" + Return enabled) instead of creating a second set.
11. Toast placement and timing aligned to 02 §4.0: bottom-edge rule (12pt above the keyboard = y 526, or y 828 with the keyboard down; it grows upward), enters from 12pt below (draft: 16), two-line messages stay 6 s (draft: 4 s). The recent-404 toast is Neutral so it has no haptic (draft paired Neutral with an error haptic, breaking 02's tone rule).
12. Spring tokens were given conflicting durations ("`smooth` 380 ms", "`smooth` 250 ms", a 420 ms morph). All now use the 02 settle times (`smooth` ≈ 450 ms, `snappy` ≈ 300 ms); row/section collapses moved to `snappy`; 03.01's still is "t = 200 of ≈ 450".
13. Typing vs keyboard-down field states defined once (Filled + caret / Filled without caret / Focused when empty), so builders don't guess between 971:243 and 971:251. 03.13 and 03.21 cards now carry the Frost Strong fill from 02.08/02.15; 03.21 notes the literal location line (02-P9 not applied).
14. "Mesh's confirm dialog" (an unreferenced app) removed; the Clear-without-confirmation decision now points at the Monzo/GitHub refs. The komoot entry contradicted the logic ("Show results" closes at once) and is now a counter-example, not counted.

**Micro-interactions made concrete**
15. Added a flow-level press-feedback block (rows = bg/fill highlight with no scale, chips 0.96, ✕ 0.92, text buttons dim; Reduce Motion = 85% opacity; haptics on release).
16. Every rule in §4.1–4.11 now states trigger → response, timing/easing, haptic, VoiceOver and Reduce Motion. Filled gaps include 4.1-3/4, 4.2-2…8, 4.3-1/2/4/6/7/9, 4.4-2/3/4, 4.5-1/2, 4.6-1…5, 4.7-3/4, 4.8-1…4, 4.9-2, 4.10-2…5, 4.11-1/3/4/5. Haptics fixed: scrim-strip tap = none (background tap, as 02), "Back to the map" = light. New rules: 4.1-5 (double tap), 4.6-2 (Clear filters from the empty state), 4.9-4 (My location with a filled capsule); new edge cases §8-26…31.

**Mobbin**
17. The draft claimed 50 references; it had 45 unique. Added 17 new, each from `mcp__Mobbin__search_screens` (ios, design_tool, Figma, jpg, standard) with images checked: keyword/plug queries (Grab, GitHub scope rows, Shell connector line, Tesla kW list), typed results (Transit, Etsy), empty/error (Wispr Flow, LinkedIn, Perplexity inline error, HYPE), outcomes on the map (Places "Café Vins ×" card, corner, Fresha floating ✕, Cash App search marker, Mindtrip loading pill, Tripadvisor and Meetup zero-result notices). 62 unique; every major screen (idle sheet, typing, keyword query, empty/errors, station on map, place on map incl. 0 results, Filter & sort, filters applied) now has ≥ 3 positive references.
