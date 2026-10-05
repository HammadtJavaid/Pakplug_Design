# 02 · Discover — map, list, station cards, Saved chargers, Price Trends

> **00-system alignment (2026-10-04, read first).** `00-system.md` is the single answer for navigation, sheets, motion, haptics, shared components, section names, formats, tones and materials; where this spec still differs, 00-system wins. Applied to this spec: (1) Sections: 1076:2 becomes `Flow 2A · Discover · Map & station cards` and moves into journey order after Flow 1D; `Flow 2B · Discover · Location & list` and `Flow 2C · Discover · Saved & price trends` are new (frame lists: 00-system §4). (2) Book now and View Details play a light haptic; medium is for commits only. (3) Pushed screens (02.20–02.29) start their content at y 122: add 4 to every y in those rows. (4) The Permission Sheet (02.02) is `Sheet / Action` Kind=Permission, leading-aligned with 16pt margins (C3). (5) Map Status Pill action, error and Surface, List Group Header trailing, Scroll Edge Fade and the Station Card actions check are C14; Toast placement is the bottom-edge table (00-system §1.5). (6) §4.0's tokens, press rules, haptics and toast rules are restated in 00-system §2, which wins.

Spec for the Figma build of Flow 02. Research only: no Figma calls were made.
Sources: `BRIEF.md`, `NEW-COMPONENTS.md` (Nav Bar, Toast, Rating Stars, Connector Tile now exist), `driver-logic-map.md` §A (shell, charging pill), §B (`DriverHomeScreen`, `FavoritesScreen`, `RegionalPriceTrendsScreen`), Appendix 1–4, the existing frame **Home · Map 1076:5** (section 1076:2), the sibling specs that depend on this one (01 Home permission frames, 03 chip rules §4.12, 04 place-sheet levels, 06 accessory states) and 58 Mobbin references (all iOS).

**Material + type rules for this flow (from the brief, applied to every frame):**
- No Hero mesh in Discover. Backgrounds are the Map image or Mesh Quiet 951:7417 only, so normal text colours apply everywhere (text/primary, text/secondary, text/tertiary). `text/onMesh` is not used in this flow.
- Floating chrome on the map (heart, bell, Map Controls, chips, search capsule, status pills) = Glass (the components' own Glass variants). Station cards that float over the map or Quiet mesh (02.08 preview, list cards, Saved cards) = `bg/frostStrong` + `Frost/Card`; never Frost 68% under grey secondary text. Data cards (Price Trends chart and region cards) = `bg/surface`. Reduce Transparency: Glass and Frost become Surface + hairline.
- Type: SF Pro, lighter. Every number that decides something (Rs price, kWh, %, km, time, Rs/kWh averages) uses a Display style (Light) or the number slot of an existing component (Hero Stat, Stat Tile, Station Card price, Map Pin). Titles Medium, body Regular. No Bold/Semibold anywhere, including alert buttons (the preferred alert action is shown by position and `text/brand`, not by weight).
- Brand: the logic's top-bar "logo mark plus 'Pak' 'Plug' wordmark" is not drawn on Home [P27]. On the map the brand is the mesh P inside the search capsule (`Search Field` Idle/On map 971:202 = `Brand / Mark / PakPlug P` Style=Mesh on a light surface). The SF Pro wordmark (`Brand / Wordmark` 994:132) lives on Splash, Story and Sign in (Flow 01).

Notation
- `[P]` = proposal (not in the logic map). Every `[P]` is listed in §7 and must appear in the FLAG — PROPOSALS block of the logic-check card.
- "Real copy" = quoted verbatim from the logic map. A `…` in a quote means the logic map truncates the string; Rayan should paste the full string from code (see §7, P17).
- Component references use the brief inventory: `Name [set id] → Variant id`.
- Motion tokens used everywhere in this spec (§4.0): `snappy`, `smooth`, `bouncy`, `fade.quick`, `fade.std`, `camera`.

---

## 1. Overview

**Goal.** A driver opens PakPlug and within seconds sees nearby chargers they can afford and use. They can compare them on a map or in a list, preview one, then go to its details or book it. Saved chargers and Lahore price trends are one tap away. The surface stays calm and Maps-native (concept A): the map is the background, controls are Glass, content cards are Frost or Surface, and numbers use Display Light.

**Screens in this flow (7):**
1. **Home · Map**: the hub. Frame 1076:5 already exists; keep its layout.
2. **Home · List**: the same data as cards.
3. **Station cards board**: every dummy station and every status on the floating preview card (02.31), so each station has its card.
4. **Filter & sort sheet**: an overlay on Home.
5. **Location permission surfaces**: pre-prompt sheet, iOS prompt, denied alert and services-off notice. These are the canonical Home permission frames; Flow 01's 01.45–01.46 are the same screens and should be placed as a link card to 02.02/02.04 instead of being built twice.
6. **Saved chargers** (`FavoritesScreen`).
7. **Price Trends** (`RegionalPriceTrendsScreen`).

**Invisible logic on Home init (no frame, noted on the logic card):** auto-switches `activeRole` to Driver when the user has the Driver role and isn't mid role-switch.

**Entry points**
- Home tab (index 0) of `DriverMainScreen`. This is the default after onboarding: "Find my first charger".
- `driverMainTabIntentProvider` = 0. Saved chargers "Explore chargers" and the empty Bookings state both set it.
- Profile → Saved chargers opens Saved chargers directly.
- App launch with an active session: the charging accessory is already visible (logic: "Hydrates any active driver session").

**Exits**
| From | Action | Goes to | Owner flow |
|---|---|---|---|
| Station preview card | swipe up > 60pt | Place sheet, medium detent (04.01) | 04 · Station & Book |
| Station preview card | View Details | `/station-details` = place sheet, large detent (04.02) | 04 · Station & Book |
| Station preview card | Book now | `/booking-create` "Book a slot" inside the sheet (04.24) | 04 · Station & Book |
| Search field "Search chargers" | tap | Search overlay | 03 · Search |
| "Filters" chip | tap | Filter & sort sheet (02.12) | this flow (03 §4.11 shares the rules) |
| Bell | tap | `NotificationsScreen` (08.53) | 08 · Profile |
| Heart (top-left) | tap | Saved chargers (02.20) | this flow |
| Map Controls · chart.bar | tap | Price Trends (02.25) | this flow |
| Charging accessory | tap | `ActiveSessionScreen` (slideUp) | 06 · Live & Complete |
| Charging accessory · Stop | tap | `EndChargingSessionModal` → Charging complete | 06 · Live & Complete |
| Saved card | tap | pop, then push `/station-details` (presented as one push, 04.12) | 04 · Station & Book |
| Saved chargers empty · Explore chargers | tap | sets Home tab, pops → 02.06 | this flow |

**Section on Driver Flows (946:8).**
- Three sections (00-system §4): the existing section **1076:2** becomes `Flow 2A · Discover · Map & station cards` (rename it, keep its fills and children, move it to x 0 / page bottom + 160 when its turn comes after Flow 1D); `Flow 2B · Discover · Location & list` and `Flow 2C · Discover · Saved & price trends` are new sections.
- Rename frame **1076:5** to `02.06 · Home · Map` but do not move its children.
- The existing title, Refs card and logic card (1077:145) are updated, not duplicated.

---

## 2. Screens & states

### 2.0 Shared geometry (measured from 1076:5, 402×874)

| Layer | Position / size | Component |
|---|---|---|
| Status bar | (0,0) | `iOS / Status Bar` Dark 996:398 |
| Heart (Saved chargers) | (16,60) 44×44 | `Icon Button` Glass M 979:277, Icon = heart 958:49 |
| Bell (Notifications) + red dot | (68,60) 44×44 | `Icon Button` Glass M, Icon = bell 958:10 (red dot as in 1076:5) |
| Map Controls (list · price trends · my location) | (339,60) ≈46×145 | `Map Controls` Mode=Map 975:228 / Mode=List 975:244. Replaces the logic's search-block **Map \| List** toggle and the two bottom-right FABs "My location" / "Price Trends" [P28]. Logic: the FABs are map-view only, so in Mode=List only the Map toggle is live (Price Trends and My location are hidden or 30% + not focusable; builder: use whatever the Mode=List variant shows and do not add buttons). Because the controls sit top-right, the logic rule "FABs raised to 92 px while a session is active" is not needed. |
| User location | at the GPS point | `User Location` 974:264 (= Google's native my-location dot). No zoom or compass controls (logic: both off). |
| Google attribution | x 22, ≈14pt above chips | text node as in 1077:144. Always visible on the map; hidden only while the search overlay is open (logic, Flow 03). |
| Quick chips row [P26] | y 684, h 36, x 20, horizontal scroll | `Chip`: "Filters" Glass/No 970:142 + Leading icon slider.horizontal.3 1025:513 (Count off at 0; Count on + Fill/Yes 970:175 when Count > 0); "Available now", "Type 2 (AC)", "CCS (DC)", "GB/T" as Glass/No; selected = Fill/Yes 970:175. The logic has only a "Filter square button (tuning icon)"; the "Filters" chip is that button, and the four quick chips are a mirror of the sheet. Rules = 03 §4.12 (connector chips single-select; Count = (connector ≠ All) + (availability ≠ Any) + (sort ≠ Nearest); order never changes). |
| Search field | (20,731) 362×47 | `Search Field` Idle/On map 971:202, placeholder "Search chargers" |
| Tab bar | (20,788) 362×64 | `Tab Bar` Selected=Home 966:79, Messages badge "2" |
| Home indicator | (0,840) | `iOS / Home Indicator` Dark 996:425 |

**Bottom stack** means attribution + chips + search field. It moves as one unit:
- **Session active:** the accessory sits at (20,728) and the stack rises by **60pt** (52 accessory + 8 gap). Search goes to y 671, chips to y 624 and attribution to y ≈610. Animate Google Map `padding.bottom` by the same amount.
- **Station selected:** the stack hides (fades and drops 12pt). The floating card takes its place.
- **Toast visible:** `Toast` [1088:631] floats with its **bottom edge 12pt above the chips row** (y 672 with no session; y 612 with a session). The Toast grows upward (1 line ≈ 52pt, 2 lines ≈ 72pt). Attribution and map `padding.bottom` rise by the Toast height + 12 so attribution stays visible above it. The brief's "12pt above the tab bar" rule is adapted here because the search capsule and chips occupy that band on Home; everywhere without the bottom stack (Saved chargers) the brief rule applies unchanged.

**Chip default.** Every 02 frame starts with **no filters active**: "Filters" has no count and all quick chips are unselected.
- 1076:5 currently shows "Available now" selected and "Filters 1". That contradicts the In use and Offline pins it shows.
- Fix: set those two chips to the default in 1076:5. This changes state, not layout.
- The filters-applied look is 02.10 (map, empty), 02.12 (sheet) and 02.17 (list, empty); 03.20/03.21 show filters applied with results.

**Status → visual mapping (one table for pins, pills and cards in every 02 frame; matches 04 §2 text colours):**

| Station status (logic) | `Status Pill` S | `Map Pin` | Card status text colour |
|---|---|---|---|
| Available | Success 980:314 "Available" | Available 974:223 / selected 974:238 | text/available |
| In use | Info 980:326 "In use" | In use 974:228 / selected 974:244 | text/inUse |
| Maintenance | Warning 980:320 "Maintenance" | Unavailable 974:233 / selected 974:251 | text/warning |
| Paused | Warning 980:320 "Paused" | Unavailable 974:233 / selected 974:251 | text/warning |
| Offline | Neutral 980:332 "Offline" | Unavailable 974:233 / selected 974:251 | text/offline |

Saved cards map busy → In use and anything else → Offline (logic), using the same rows.

**Pins (consistent dummy set, used in every map frame).** These are `Map Pin` instances with the `Price#974:0` text property:
- GreenVolt · DHA Phase 5: Available "Rs 42". It is the pin nearest the user dot, about 90pt above-right.
- Gulberg Galleria Charger: In use "Rs 68".
- Model Town Home Charger: Available "Rs 38".
- Johar Town Fast Hub: Unavailable "Rs 55".
- Filler pins: "Rs 40", "Rs 45".
- `Map Cluster` Large "24".
- Pin fallback (logic): if the pin bitmaps fail to load, the app draws Google's default green marker with no price label. Not framed; noted on the logic card so Rayan keeps the fallback when the pins become price pills [P1].

[P25] Retro-label 1076:5's pins to this set (labels only), so the selected state matches.

### 2.1 Frame table

Backgrounds:
- **Map**: copy the fills of rect 996:430 onto a 402×874 rectangle named `Map`.
- **Mesh Quiet**: instance 951:7417, resized 402×874.
- Sheets are Surface with radius/sheet 38, a 36×5 grabber and a bg/scrim behind.

Priority: **P1** must build tonight; **P2** if time allows.

| # | Frame name | Pri | Background | Layout top → bottom (instances + overrides) | New |
|---|---|---|---|---|---|
| 02.01 | `02.01 · Home · Finding your area` | P1 | Mesh Quiet (logic: "No map is shown") | Status bar Dark · heart + bell Glass M (bell dot hidden) · Map Controls Mode=Map, all three buttons at 100% (logic: chrome always on top) · `State View` Loading 1072:584 centred at y≈380: Title "Finding your area…" (real), message hidden, Show action off · bottom stack (chips default, search Idle) · Tab Bar Home · Home indicator. Normal text colours (Quiet mesh). | none |
| 02.02 | `02.02 · Home · Allow location` | P1 | 02.01 underneath + `bg/scrim` | **`Sheet / Action` Kind=Permission** (00-system C3) at (0,502) 402×372, Surface, radius/sheet 38 top, grabber 36×5 at y+5, leading-aligned, content x 16 w 370: icon well 56 `bg/tint` radius 16 with location.fill 1024:472 28 `icon/brand` at (16,526) · Title 2 text/primary "Allow location access?" (real) · Body text/secondary, 3 lines, w 370: "PakPlug uses your location to center the map on you, show how far…" (real, truncated in the logic map) completed as "…show how far each charger is, and guide you there." [P17, same completion as 01-P6] · `Button / Large` Primary Default 978:277 "Allow location" at (16,712) · `Button / Large` Tertiary Default 978:337 "Not now" at (16,772) · Home indicator Dark. Tab bar hidden under the scrim. Logic presents `LocationPermissionDialog` as a dialog; the sheet presentation is [P29]. | `Sheet / Action` Kind=Permission (00-system C3) |
| 02.03 | `02.03 · Home · iOS location prompt` | P2 | 02.01 + system dim (black 20%) | `iOS / Permission Alert` Kind=Location (system mock defined in 01 §6; do not create a second alert mock): title "Allow “PakPlug” to use your location?", message = Info.plist purpose string (reuse the 02.02 body sentence, 01-P6), precise-location mini map "Precise: On", three stacked buttons "Allow Once" / "Allow While Using App" / "Don't Allow". Frame note: "OS-owned · not built in Flutter". | none (reuses 01's mock) |
| 02.04 | `02.04 · Home · Location access off` | P1 | 02.01 + `bg/scrim` | `Alert` Default 1014:570 centred: title "Location access" (real), message "Location permission is turned off for PakPlug. Enable it in system settings…" (real, truncated) completed as "…system settings to see stations near you." [P17, same as 01-P6], buttons "Not now" (left, text/primary) / "Open settings" (right = preferred action, text/brand, component weight; no Bold). Cupertino styling via `showAdaptiveDialog` [P29]. | none |
| 02.05 | `02.05 · Home · Location services off` | P1 | Map centred on Lahore default; **no** User Location dot | Same chrome as 1076:5; Map Controls my-location glyph = `location` 958:19 outline (not tracking) · pins (dummy set) · `Toast` Neutral 1088:611, 370 wide, x 16, bottom edge at y 672 (12pt above the chips; 2 lines ≈ 72pt tall, so top ≈ 600): Message#1088:0 "Location services are off. Showing the default area; turn on location for stations near you." (real), Action#1088:5 on, Action label#1088:10 "Settings" [P5] · attribution raised to y≈586 (above the Toast) · chips · search · Tab Bar. | none (Toast exists) |
| 02.06 | `02.06 · Home · Map` (= existing 1076:5) | done | Map | Keep layout. Only change: chips to default and pin labels to the dummy set (see 2.0) [P25]. | none |
| 02.07 | `02.07 · Home · Map · Loading stations` | P1 | Map | 1076:5 + `Map Status Pill` Loading 975:249 centred horizontally at y 64 (between the bell and the Map Controls), label "Loading…" [P4]. Existing pins at 100% (old results stay until new ones arrive). | none |
| 02.08 | `02.08 · Home · Map · Station selected` | P1 | Map, camera shifted so the selected pin sits at y≈330 | 1076:5 with: Rs 42 pin → `Map Pin` Available selected 974:238 (1.08×, logic) · bottom stack hidden [P3] · **floating preview** `Station Card` Map preview 982:287 at (16,606) 370×170, fill `bg/frostStrong` + `Frost/Card`, overrides: name "GreenVolt · DHA Phase 5", `Status Pill` Success S 980:314 "Available", address "Street 12, Block CCA, DHA Phase 5, Lahore" (2 lines max), connector Plug ev.plug.ac.type.2 981:294 "Type 2 (AC)" · "7.4 kW · Available" · "Rs 42" "/kWh" (price in the card's Display/Light number slot), [P2] distance "1.2 km" in the meta line; actions `Button / Medium` Secondary 978:458 "View Details" + Primary 978:428 "Book now" (equal widths, gap 8). If 982:287 lacks the buttons row, append it inside the card (padding 16). · close `Icon Button` Glass S 979:280 Icon xmark 958:72 at (352,564), floating 8pt above the card's top-right [P3] · Tab Bar Home. | none (instance only) |
| 02.09 | `02.09 · Home · Map · Cluster opened` | P2 | Map zoomed in by 2 levels around the old cluster position | The "24" cluster replaced by about 6 pins and 2 `Map Cluster` Small 974:259 ("8", "10") in a radial spread; faint 1pt `stroke/hairline` "ghost ring" at the old cluster centre (30% opacity, motion still) to document the split animation [P1]. Rest = 1076:5. | none |
| 02.10 | `02.10 · Home · Map · No stations` | P1 | Map, no pins | 1076:5 with "Available now" chip Fill/Yes, "CCS (DC)" Fill/Yes, "Filters" chip **Fill/Yes 970:175, Count "2"** (03 §4.12) · `Map Status Pill` Notice 975:253 at top centre (y 64): "No stations found" (real) + trailing action "Clear" in text/brand [P6] | **Map Status Pill · action** variant (§6) |
| 02.11 | `02.11 · Home · Map · Couldn't load` | P1 | Map, last-known pins dimmed to 40% [P6] | `Map Status Pill` Error + Action (new) at top centre (y 64): icon exclamationmark.triangle.fill 1025:474 (icon/error) + "Couldn't load stations" + action "Retry" (Retry is real; the label is [P15]) | same as above |
| 02.12 | `02.12 · Home · Filter & sort` | P1 | Map + `bg/scrim` | `Sheet / Filter & sort` 1012:432 at medium detent. Real copy: title "Filter & sort", trailing "Clear" (text/brand here because filters differ from default; text/tertiary + disabled when everything is default, 03-S15); "Connector type": All · Type 2 (AC) · CCS (DC) · GB/T (single-select); "Availability": Any · Available now; "Sort by": Recommended · Nearest · Price · Rating (Nearest = default); `Button / Large` Primary "Show results". In-progress state: "Available now" + "CCS (DC)" selected, sort Nearest. Behind the scrim the chips still show the **applied** (default) state; they change only on Show results. Tab bar under the scrim (logic: overlay above the nav). | none |
| 02.13 | `02.13 · Home · Map · Charging` | P1 | Map | 1076:5 + `Tab Bar Accessory / Live Charging` State=Charging 967:124 at (20,728): Title#967:0 "Charging · ≈26%", subtitle "28:00 left · Rs 152" [P11] · bottom stack raised 60pt · Map Controls unchanged. The other accessory states (Ending 6:55 "Charging · ≈30%" / "5:00 left · Rs 262", Stopping, No window "— · Rs 152", Couldn't stop Toast) are framed once in 06.17–06.20 on this same base; do not rebuild them here. | none |
| 02.14 | `02.14 · Home · Map · Charging · Station selected` | P2 | Map | 02.08 composition but the card is at (16,546) (above the accessory), close at (352,504) · accessory stays. | none |
| 02.15 | `02.15 · Home · List` | P1 | Mesh Quiet | Status bar · heart + bell · `Map Controls` Mode=List 975:244 at (339,60) (Map toggle only, logic) · `List Group Header` 983:389 Label "4 stations · Nearest first" [P8] at (16, 60 + max(44, Mode=List height) + 16) ≈ (16,122) · 4× `Station Card` List 982:314 (370×112) from y≈154, gap 12, fill `bg/frostStrong` (normal text colours on Quiet). Overrides in §3.2 · top Scroll Edge Fade under the status bar + top buttons · bottom Scroll Edge Fade (bg/canvas 0→92% from y 640 to 788) behind the bottom stack · chips · search · Tab Bar · Home indicator. | none |
| 02.16 | `02.16 · Home · List · Loading` | P1 | Mesh Quiet | As 02.15, header hidden, 4× `Station Card` List Loading 982:359 (shimmer) [P7]. | none |
| 02.17 | `02.17 · Home · List · Empty` | P1 | Mesh Quiet | As 02.15 without cards; chips: "Available now" + "CCS (DC)" Fill/Yes, "Filters" Fill/Yes Count "2"; `State View` Empty 1072:573 centred y≈360: Icon ev.charger 1024:478, Title "No stations found", message "No charging stations found in this area. Try moving the map or adjusting filters." (both real), Show action on → `Button / Medium` Secondary 978:458 "Clear" [P6]. | none |
| 02.18 | `02.18 · Home · List · Error` | P1 | Mesh Quiet | `State View` Error 1072:588: Title "Couldn't load stations" [P15], message "Check your connection and try again." [P15] (logic prints `ErrorState(message)` raw), action `Button / Medium` Primary 978:428 "Retry" (real). | none |
| 02.19 | `02.19 · Home · List · Charging · Scrolled` | P2 | Mesh Quiet | List scrolled about 120pt (first card half under the top Scroll Edge Fade); `Tab Bar / Minimized` 967:169 at (20,788) (component size); accessory inline to its right, resized to fill the remaining width with gap 8 (iOS 26 `tabBarMinimizeBehavior = .onScrollDown`); chips hidden, search only [P20]. | none |
| 02.20 | `02.20 · Saved chargers` | P1 | Mesh Quiet | Status bar Dark · `Nav Bar` Inline 1087:607 at (0,54): Title#1087:0 "Saved chargers" (real), Leading#1087:3 on (chevron.left 1025:481), Trailing 1/2 off · Footnote text/secondary "3 saved" (real format "N saved") at (16,118) · 3× `Station Card` Saved 982:331 from y 148, gap 12, fill `bg/frostStrong`: GreenVolt, Model Town, Gulberg (heart filled, icon/brand) · Home indicator. **No tab bar** (route covers tabs; it pops back to set the Home tab). | none |
| 02.21 | `02.21 · Saved chargers · Removed` | P1 | Mesh Quiet | 02.20 with "Model Town Home Charger" gone (Gulberg moved up), caption "2 saved" · `Toast` Neutral 1088:611 at x 16, bottom edge y 828 (12pt above the home-indicator zone): Message "Removed from Saved chargers", Action on, Action label "Undo" [P12]. | none (Toast exists) |
| 02.22 | `02.22 · Saved chargers · Loading` | P2 | Mesh Quiet | Nav Bar as 02.20, caption hidden, 3× `Station Card` Saved Loading 982:366 [P7]. Logic shows a spinner only when the list is empty **and** loading; a reload with rows present shows no loader. | none |
| 02.23 | `02.23 · Saved chargers · Empty` | P1 | Mesh Quiet | Nav Bar as 02.20 (caption hidden) · `State View` Empty 1072:573 centred: Icon heart 958:49 (icon/brand), Title "No saved chargers yet", message "Tap the heart on a charger to save it here for quick access.", action `Button / Medium` Primary 978:428 "Explore chargers" (all real). | none |
| 02.24 | `02.24 · Saved chargers · Couldn't update` | P2 | Mesh Quiet | 02.20 with all 3 cards (row restored) · `Toast` Error 1088:626, bottom edge y 828: Message "Failed to update saved station. Please try again." (real), Action off. | none |
| 02.25 | `02.25 · Price Trends` | P1 | Mesh Quiet | Status bar · `Nav Bar` Inline 1087:607 at (0,54): Title "Price Trends" (real FAB label), Leading on · context row y 118: Caption 1 Emph text/secondary "LAHORE · LAST 7 DAYS" (real) + trailing Caption 1 text/tertiary "Updated 6:30 PM" (real format "Updated …") · **Trend Chart Card** (16,146) 370×236, `bg/surface`: Headline "7-day price trend"; `Hero Stat` M Leading 986:437 Caption "Avg", Value "Rs 47.3", Detail "/kWh" (real "Avg Rs X.X"); 7 bars with dashed avg line + "AVG" tag · Title 3 "By Region" (16,406) + trailing Footnote secondary "Cheapest first" (both real) · **Region Price Card** #1 (16,442) 370×~200, `bg/surface`, with `Status Pill` Success S "CHEAPEST RIGHT NOW" (real) · card #2 peeking below the fold from y≈654. | **Trend Chart Card**, **Region Price Card**, **Price Range Bar** |
| 02.26 | `02.26 · Price Trends · Full scroll` | P2 | Mesh Quiet (tall frame 402×1560) | All 4 region cards + footer Caption 1 text/tertiary "Updated 6:30 PM · Based on 24 active stations across Lahore" (real format) + bottom 48 padding. | as above |
| 02.27 | `02.27 · Price Trends · Loading` | P1 | Mesh Quiet | Nav Bar Inline "Price Trends" + `State View` Loading 1072:584: "Loading price trends…" (real) | none |
| 02.28 | `02.28 · Price Trends · Couldn't load` | P1 | Mesh Quiet | Nav Bar + `State View` Error 1072:588: "Unable to load regional price trends" / "We couldn't load price trends. Please try again." + `Button / Medium` Primary 978:428 "Retry" (all real) | none |
| 02.29 | `02.29 · Price Trends · No data` | P2 | Mesh Quiet | Nav Bar + `State View` Empty 1072:573, Icon chart.bar 958:23: "No pricing data available yet" / "Check back after stations go live…" (real; full string from code, P17) + `Button / Medium` Secondary 978:458 "Refresh" (real) | none |
| 02.30 | `02.30 · Home · Map · Offline station selected` | P2 | Map | 02.08 composition for **Johar Town Fast Hub**: Rs 55 pin → `Map Pin` Unavailable selected 974:251 · card: `Status Pill` Neutral S 980:332 "Offline", address "Johar Town, Lahore", connector Plug ev.plug.dc.ccs2 1024:482 "CCS2 (DC)" · "30 kW · Offline" · "Rs 55" "/kWh", "7.8 km" [P2] · **View Details** + **Book now** both enabled (logic: no disabled state; booking is blocked later in Flow 04). | none |
| 02.31 | `02.31 · Station cards · Every station & status` | P1 | `bg/canvas` board, 402×1560 (not a phone; no status bar) | One `Station Card` Map preview 982:287 per row, x 16, gap 16, each with a Caption 1 text/secondary label above. Rows: (1) GreenVolt · DHA Phase 5 · Available · Type 2 (AC) · "7.4 kW · Available" · Rs 42/kWh · 1.2 km; (2) Gulberg Galleria Charger · In use (Info S 980:326) · "Main Boulevard, Gulberg III, Lahore" · CCS2 (DC) · "60 kW · In use" · Rs 68/kWh · 3.4 km; (3) Model Town Home Charger · Available · "Model Town, Lahore" · Type 2 (AC) · "11 kW · Available" · Rs 38/kWh · 5.1 km; (4) Johar Town Fast Hub · Offline (as 02.30); (5) GreenVolt `(state demo)` · Maintenance (Warning S 980:320) · "7.4 kW · Maintenance" · Book now enabled (logic); (6) GreenVolt `(state demo)` · Paused (Warning S) · "7.4 kW · Paused" · Book now = `Button / Medium` Primary **Disabled** 978:442 + Footnote text/warning under the buttons "This station is currently paused and not accepting new bookings" (real copy, from submit) [P19, aligned with 04-P9]; (7) GreenVolt `(state demo)` · hourly price "Rs 300" "/hr" (logic fallback); (8) GreenVolt `(state demo)` · no price + no power: subtitle "N/A" (real), price slot "Pricing unavailable" (real copy from Book) in text/secondary. | none |
| 02.32 | `02.32 · Home · Map · Showing Lahore` | P2 | Map centred on Lahore default; **no** User Location dot | After "Not now" (02.02), "Don't Allow" (02.03) or "Not now" in 02.04: chrome as 1076:5, my-location glyph outline, pins (dummy set) · `Map Status Pill` Notice 975:253 at top centre (y 64) "Showing Lahore" [P31], leaves after 2.5 s. No Toast (logic shows no message on refusal). | none |

**Totals:**
- 32 frames: 31 new plus the existing 1076:5 (21 × P1, 10 × P2, 1 done). Frame numbers 02.01–02.29 are referenced by specs 03–08, so new frames are appended (02.30–02.32), never renumbered.
- Frame labels above each phone are `02.nn · Screen · State` in Footnote Emph text/secondary (same convention as 01 and 03–08), gap 80, in rows. States of one screen sit side by side.

**Rows** (each row: Refs · Mobbin card on the left, frames, Micro-interactions card on the right; one Logic check card at the end of the section):
1. Arrival + location: 02.01–02.05, then 02.32.
2. Map: 02.06–02.14, then 02.30.
3. Station cards board: 02.31 (its own short row, so Rayan can read every card state in one place).
4. List: 02.15–02.19.
5. Saved: 02.20–02.24.
6. Price Trends: 02.25–02.29.

Each row gets its own Micro-interactions card (§4) to its right. Section 01's Home permission frames (01.45–01.46) become a link card pointing to 02.02 and 02.04 (one build, one source).

---

## 3. Real copy (quoted from the logic map) per screen

### 3.1 Home · Map (02.01–02.14, 02.30–02.32)
- Chrome:
  - Search placeholder "Search chargers".
  - "Map" / "List" (the segmented toggle's labels become the VoiceOver labels of the Map Controls toggle, [P28]).
  - "Filter & sort" (sheet title). The logic's filter button is icon-only; the chip label "Filters" is new copy [P26].
  - FAB labels "My location" and "Price Trends" become the VoiceOver labels of the Map Controls.
  - Top bar: Favorites heart and Notifications bell with a red unread dot (`notificationsProvider.unreadCount > 0`).
  - Top bar logo mark + "Pak" "Plug" wordmark: not drawn on Home [P27]; VoiceOver reads the search capsule's P mark as "PakPlug".
- Loading (no centre yet): "Finding your area…"
- Loading (map refetch): "Loading…" pill [P4] (copy reused from the search overlay; logic shows an unlabeled spinner chip).
- Location services off (snackbar → `Toast` Neutral): "Location services are off. Showing the default area; turn on location for stations near you."
- Denied forever (alert): "Location access" / "Location permission is turned off for PakPlug. Enable it in system settings…" / **Not now** / **Open settings**. Completion of the truncated string [P17]: "…system settings to see stations near you." (identical to 01-P6).
- Denied (pre-prompt): "Allow location access?" / "PakPlug uses your location to center the map on you, show how far…" / **Allow location** / **Not now**. Completion [P17]: "…show how far each charger is, and guide you there." (identical to 01-P6).
- Fallback after refusal: no message in the logic; "Showing Lahore" notice pill [P31].
- Preview card:
  - Name.
  - Status pill: one of "Available", "In use", "Maintenance", "Paused" or "Offline".
  - Address (2 lines).
  - Connector row: plug label "Type 2 (AC)", subtitle "{maxPowerKw} kW · {status}" (or "N/A"), price "Rs X" with "/kWh" or "/hr".
  - Buttons: **View Details** (secondary) and **Book now** (primary).
- Preview card states not covered by the logic: Paused reason line "This station is currently paused and not accepting new bookings" (real copy from Book submit, moved up front [P19]); price missing → "Pricing unavailable" (real copy from Book).
- Charging pill: title "Charging · {battery}%"; subtitle "{mm:ss | h:mm:ss} to full · Rs X", "Ending · Rs X" or "— · Rs X"; action **Stop**. Error: "Could not stop session: $e".
  - As drawn (02.13): "Charging · ≈26%" / "28:00 left · Rs 152" [P11]. From 5:00 left the accessory switches to State=Ending and keeps counting ("5:00 left · Rs 262"); the logic's "Ending · Rs X" shows at ≤ 0 (06-P27). Null window: "— · Rs 152" (State=No window 967:146). Stopping: "Stopping…" (06.18). Error Toast: "Could not stop session: Network error" (06.20).
- Filter sheet: "Filter & sort", "Clear", "Connector type" (All, Type 2 (AC), CCS (DC), GB/T), "Availability" (Any, Available now), "Sort by" (Recommended, Nearest, Price, Rating; default Nearest), "Show results".
- Not surfaced, on purpose (logic: "exist in state but aren't surfaced"): price, distance and rating filters. No UI is drawn for them.
- Computed but not rendered (logic): list card `estimatedTime` (travel time) and `recommendedHighlight` (top 3 when sort = Recommended). Not drawn; recorded as [P32].

### 3.2 Home · List (02.15–02.19)
- Card data:
  - Name.
  - Status: Available / In use / Maintenance / Paused / Offline.
  - Location line `"{firstPlugType} · {last comma-segment of address}"`.
  - ★ rating, or `N/A`.
  - Distance, e.g. "9.3 km".
  - Price `"Rs 1,234/kWh"`, falling back to `"/hr"`, then `N/A`.
- Card overrides (sorted Nearest; default sort per logic):
  1. "GreenVolt · DHA Phase 5" · Available · "Type 2 (AC) · Lahore" · 4.8 · 1.2 km · "Rs 42/kWh"
  2. "Gulberg Galleria Charger" · In use · "CCS2 (DC) · Lahore" · 4.6 · 3.4 km · "Rs 68/kWh"
  3. "Model Town Home Charger" · Available · "Type 2 (AC) · Lahore" · 4.9 · 5.1 km · "Rs 38/kWh"
  4. "Johar Town Fast Hub" · Offline · "CCS2 (DC) · Lahore" · 4.4 · 7.8 km · "Rs 55/kWh"
- The location line follows the logic literally: the last comma segment, which is always "Lahore". P9 proposes the neighbourhood instead.
- Empty: "No stations found" / "No charging stations found in this area. Try moving the map or adjusting filters."
- Error: `ErrorState(message)` with **Retry**. Today it prints the raw message; P15 proposes plain copy.

### 3.3 Saved chargers (02.20–02.24)
- Title "Saved chargers"; caption "N saved".
- Card status mapping: available → Available; busy → In use; anything else → Offline. Price per kWh. Has a heart.
- Error snackbar (logic) → `Toast` Error: "Failed to update saved station. Please try again."
- Empty: "No saved chargers yet" / "Tap the heart on a charger to save it here for quick access." / **Explore chargers**
- Cards in 02.20:
  - GreenVolt · DHA Phase 5: Available · Rs 42/kWh · 4.8 · 1.2 km
  - Model Town Home Charger: Available · Rs 38/kWh · 4.9 · 5.1 km
  - Gulberg Galleria Charger: In use · Rs 68/kWh · 4.6 · 3.4 km

### 3.4 Price Trends (02.25–02.29)
- "LAHORE · LAST 7 DAYS" · "Updated …"
- "7-day price trend" · "Avg Rs X.X"
- "By Region" · "Cheapest first"
- Region card: "CHEAPEST RIGHT NOW" (first card only) · region name · "N stations" · "Rs X.X" "/kWh" · BELOW AVERAGE / AVERAGE / ABOVE AVERAGE · "↓/↑/→ N% this week" · "Price range · marker = today's avg" · "Peak demand at H" / "Charge before H to avoid peak pricing"
- Footer: "{updated} · Based on N active stations across Lahore"
- States:
  - Loading: "Loading price trends…"
  - Error: "Unable to load regional price trends" / "We couldn't load price trends. Please try again." / Retry
  - Empty: "No pricing data available yet" / "Check back after stations go live…" / **Refresh**

**Dummy data for the region cards.** The station total is 24, which matches the map cluster "24". The weighted average is Rs 47.3.

| Region | Stations | Rs/kWh | Band | Week | Range (min–max) | Peak tip |
|---|---|---|---|---|---|---|
| Model Town | 6 | 38.4 | BELOW AVERAGE | ↓ 4% this week | Rs 34 – Rs 44 | Peak demand at 7 PM · Charge before 7 PM to avoid peak pricing |
| DHA | 9 | 42.0 | AVERAGE | → 0% this week | Rs 38 – Rs 48 | Peak demand at 8 PM · Charge before 8 PM to avoid peak pricing |
| Johar Town | 4 | 55.0 | ABOVE AVERAGE | ↑ 3% this week | Rs 48 – Rs 62 | Peak demand at 6 PM · Charge before 6 PM to avoid peak pricing |
| Gulberg | 5 | 61.5 | ABOVE AVERAGE | ↑ 6% this week | Rs 52 – Rs 68 | Peak demand at 7 PM · Charge before 7 PM to avoid peak pricing |

**Chart.** The axis shows the 7 days ending today: Sun 47.6 · Mon 48.1 · Tue 47.9 · Wed 47.6 · Thu 47.8 · Fri 47.0 · **Sat 47.3 (today, emerald)**.
- The y-axis runs from Rs 46 to Rs 49, so the variation is visible. Gridline labels are Caption 2, text/tertiary.
- The logic map says "Mon–Sun chart". The frames show a rolling 7 days ending today (Sun → Sat) so today's bar is always the last one [P33]. If Rayan keeps Mon–Sun, Sun (tomorrow) renders as an empty bar slot with no value, and today stays emerald.
- All Price Trends numbers are dummy (24 stations = the map cluster "24"; Rs 47.3 average). The screen and every field exist in the logic; only the values are invented, which is the brief's dummy-data rule.

---

## 4. Micro-interactions

### 4.0 System-wide tokens (same in every flow; add to Foundations as "Motion" [P])

| Token | iOS (SwiftUI) | Flutter | Use |
|---|---|---|---|
| `snappy` | `.snappy` (response 0.30, damping 0.85) | `SpringDescription(mass:1, stiffness:440, damping:36)` | press states, chips, pills, pin select |
| `smooth` | `.smooth` (response 0.45, damping 1.0) | stiffness 195, damping 28 | cards and sheets entering/leaving, stack moves |
| `bouncy` | `.bouncy` (response 0.40, damping 0.70) | stiffness 250, damping 22 | heart toggle, pin pop-in |
| `fade.quick` | 150 ms ease-out | `Curves.easeOut` | content swaps, dismissals |
| `fade.std` | 220 ms ease-out | `Curves.easeOut` | state view swaps, scrims |
| `camera` | 350–500 ms ease-in-out | `animateCamera` | map camera moves |

**Haptics (one map for the whole app):**
- **selection**: pin or chip tap, toggles, scrubbing.
- **light**: navigation buttons, card tap, pull-to-refresh threshold.
- **medium**: commit actions (Show results). Book now and View Details are **light** (they open a flow; 00-system §2.2).
- **success**: saved.
- **warning**: not used in Discover.
- **error**: an action failed.

**Reduce Motion:**
- Every slide, scale, bounce and camera flight becomes a `fade.quick` cross-fade or an instant camera move.
- No shimmer (static placeholders at 100%).
- No digit rolling.

**Reduce Transparency:** Glass and Frost become Surface with a hairline border.

**Settle times (for Rayan's Flutter springs and for the motion notes on the canvas):** `snappy` settles in ≈ 300 ms, `smooth` ≈ 450 ms, `bouncy` ≈ 400 ms with one visible overshoot (≈ 4%).

**Press feedback (every tappable thing in Discover, so no rule below has to repeat it):**
- `Button / Large` and `Button / Medium`: swap to the Pressed variant on touch-down, scale 0.97 (`snappy`); release restores. Disabled variants have no press state and no haptic.
- Glass `Icon Button` (heart, bell, ✕, back) and each `Map Controls` button: scale 0.92 and fill brightens 6% (`snappy`).
- Cards (preview, list, Saved): scale 0.98 (`snappy`); a drag of more than 10pt cancels the press.
- Chips: scale 0.96 (`snappy`).
- Reduce Motion: no scale; the pressed element dims to 85% opacity for the touch instead.
- Haptics fire on **release** (the action), never on touch-down.

**Toast (`Toast` 1088:631, the brief's component; replaces every logic snackbar in this flow):**
- Enters from 12pt below its rest position with opacity 0 → 1 (`smooth`); leaves the same way in reverse (`fade.quick`).
- Stays 4 s for one line without an action, 6 s for two lines or any toast with an action (Undo, Settings). Same timings as 04 §4 and 08 §2. Swipe down dismisses.
- One at a time; a new toast replaces the old one with `fade.quick`.
- Haptic follows the tone: Error → error, Warning → warning, Success → success, Neutral → none.
- VoiceOver: the message is posted as a polite announcement without moving focus; the action is reachable with the Actions rotor ("Undo"). The timer pauses while VoiceOver focus is inside the toast, and with VoiceOver running action toasts stay until dismissed or 10 s pass.
- Reduce Motion: fade only.
- Placement: Home = bottom edge 12pt above the chips (§2.0); Saved chargers = bottom edge at y 828.

**VoiceOver conventions:** screen titles and section headers carry the heading trait; status is read after the name ("GreenVolt · DHA Phase 5, Available"); prices read "Rs 42 per kilowatt-hour"; estimates read "about" for "≈". All VoiceOver strings in this spec are new (accessibility labels, not visible copy) and are listed under [P34].

### 4.1 Arrival & location (02.01–02.05, 02.32)
Order follows the logic's location sequence: (1) services off → (2) denied forever → (3) denied → (4) granted.
1. **App lands on Home without a map centre** → 02.01. The State View spinner (system `UIActivityIndicatorView` medium) and "Finding your area…" fade in (`fade.std`, 220 ms) after a 150 ms grace delay, so a fast GPS fix never flashes the loader. Chrome is present immediately.
   - Haptic: none.
   - VoiceOver: posts the polite announcement "Finding your area". Chrome stays focusable.
   - Reduce Motion: no change (the spinner is the system one; with Reduce Motion it pulses instead of spinning, which is iOS behaviour).
2. **GPS fix arrives (granted)** → the map fades in over the mesh (300 ms ease-out), already centred on the user (no fly-in). The User Location dot scales 0.6 → 1 (`bouncy`). Pins pop in (rule 4.2-1). The State View fades out (`fade.quick`).
   - Haptic: none.
   - VoiceOver: announces "Map loaded, {n} stations nearby" (polite, once).
   - Reduce Motion: cross-fade only; the dot appears without scale.
3. **Permission status = denied (not forever)** → 02.02. The scrim fades to `bg/scrim` (`fade.std`) and the Permission Sheet rises from y 874 to y 502 (`smooth`, ≈ 450 ms). The tab bar stays under the scrim.
   - Swipe down (> 80pt or > 500 pt/s), a scrim tap or the grabber = **Not now** (rule 6).
   - Haptic: none (the app asked, the user did nothing yet).
   - VoiceOver: the sheet is modal (`accessibilityViewIsModal`); focus moves to "Allow location access?", heading trait. The escape gesture = Not now.
   - Reduce Motion: the sheet fades in at its final position.
4. **Tap "Allow location"** → Pressed variant (§4.0). The sheet dismisses (`smooth`, down to y 874) and, 100 ms after it clears, the iOS prompt (02.03) appears.
   - Haptic: light (on release).
   - VoiceOver: "Allow location, button. Opens the iOS permission prompt."
   - Reduce Motion: sheet fades out.
5. **iOS prompt** (02.03, OS-owned; timing, VoiceOver and Reduce Motion are the system's):
   - "Allow While Using App" / "Allow Once" → rule 2.
   - "Don't Allow" → rule 6 (Lahore fallback, 02.32). No toast.
   - Haptic: none (OS dialog).
6. **Tap "Not now"** (02.02), or refusal anywhere → the sheet dismisses (`smooth`). The map fades in on Lahore (300 ms ease-out) with no user dot; the Map Controls location glyph shows the outline state (`location` 958:19). The "Showing Lahore" notice pill (02.32) scales 0.9 → 1 in at top centre (`snappy`), stays 2.5 s, then leaves with `fade.quick` [P31]. Cards and the preview hide distances while there is no GPS fix [P30].
   - Haptic: light on the "Not now" tap; none for system refusals.
   - VoiceOver: announces "Showing Lahore" (polite).
   - Reduce Motion: pill and map fade only.
7. **Permission denied forever** → 02.04. `Alert` Default 1014:570 shown with `showAdaptiveDialog` [P29]: the scrim fades in (`fade.std`) and the alert scales 1.08 → 1 with opacity 0 → 1 (250 ms ease-out, the iOS alert motion).
   - **Open settings** opens `UIApplication.openSettingsURLString`. On return (logic: "App-resume") the location sequence re-runs. If granted, the camera eases to the user (`camera` 450 ms) and the User Location dot scales in (`bouncy`).
   - **Not now** → alert fades out (`fade.quick`) → rule 6.
   - Haptic: none on appear; light on either button.
   - VoiceOver: focus on "Location access", heading; buttons read "Not now, button" / "Open settings, button".
   - Reduce Motion: the alert fades in without scale.
8. **Location services off** → 02.05. The map renders on Lahore (300 ms fade). The `Toast` Neutral rises (§4.0 Toast rules: from 12pt below, `smooth`). Attribution and map `padding.bottom` rise by the Toast height + 12 in the same spring. Two lines + an action → stays **6 s** or until swiped down; the stack settles back (`smooth`).
   - **Settings** [P5] opens `UIApplication.openSettingsURLString` (the Location Services switch lives in system Privacy settings; iOS can't deep-link there). Pressed state as §4.0.
   - Haptic: none on appear (Neutral tone; a passive notice must not buzz); light on "Settings".
   - VoiceOver: the message is announced; "Settings" is on the Actions rotor; the timer pauses while focus is inside.
   - Reduce Motion: fade.
9. **GPS never answers** (no fix after 10 s) [P18] → rule 6 without the "Not now" haptic. If the services flag is off, rule 8 instead. Otherwise no extra message.
   - VoiceOver: "Showing Lahore" as in rule 6.
10. **Location granted later** (via Settings or the my-location button) while showing Lahore → camera flies to the user (`camera` 500 ms), the dot scales in (`bouncy`), the glyph fills (`location` → `location.fill`, symbol replace) and distances fade into the cards (`fade.quick`). Haptic: none. VoiceOver: "Showing your location". Reduce Motion: instant camera, fade.

### 4.2 Home · Map (02.06–02.14, 02.30, 02.31)
Format: trigger → response · timing · haptic · VoiceOver · Reduce Motion. Press feedback is §4.0 and is not repeated.
1. **Pins appear after a fetch** → each new pin scales 0.6 → 1 and fades in (`bouncy`), staggered 20 ms nearest-first, with a total cap of 300 ms. Pins that persist across fetches do not re-animate (keyed by station id). Removed pins fade out (`fade.quick`).
   - Haptic: none. VoiceOver: no announcement per pin (rule 2 announces the batch). Reduce Motion: fade only, no stagger.
2. **Pan/zoom ends (camera idle)** → the debounced refetch runs (logic: `onMapMoved` → debounced refetch; the debounce constant lives in code, 400 ms assumed here).
   - If the fetch takes longer than **300 ms**, the "Loading…" status pill (02.07) scales 0.9 → 1 and fades in (`snappy`) [P4]. It stays at least 600 ms to avoid flicker and leaves with `fade.quick`.
   - Haptic: none.
   - VoiceOver: no focus steal; one polite announcement, "Loading stations", then "{n} stations" when done.
   - Reduce Motion: the pill fades in and out without scale.
3. **Tap a pin** → the pin swaps to its *selected* variant (colour inverts) and scales to 1.08× (logic size, `bouncy`).
   - The camera eases (`camera` 350 ms) so the pin sits above the card's top edge + 24pt (edge case 7).
   - The bottom stack drops 12pt and fades (`fade.quick`).
   - The floating card rises from y+40 with opacity 0 → 1 (`smooth`). The glass ✕ fades in 80 ms later (`fade.quick`).
   - Haptic: **selection**.
   - VoiceOver: each pin is an accessibility element (Google Map markers are not by default; Rayan adds a semantics overlay [P34]): "{name}, {status}, Rs {price} per kilowatt-hour, {distance}. Double-tap to preview." After selection, focus moves to the card title.
   - Reduce Motion: the card fades in at its final position and the camera jumps.
4. **Tap another pin while the card is open** → the old pin deselects (reverse spring) and the new one selects. Card content slides 12pt toward the new pin's side and cross-fades (`fade.quick`); the card frame keeps its position; the camera eases (`camera` 350 ms).
   - Haptic: selection. VoiceOver: focus stays on the card; the new name and status are announced. Reduce Motion: content cross-fades without sliding; camera jumps.
5. **Dismiss the card** (tap empty map, swipe the card down more than 40pt or faster than 500 pt/s, or tap ✕) → the card falls 40pt and fades (`smooth`). The pin deselects (reverse spring) and the bottom stack returns (`smooth`). The logic's "scrim tap or handle tap closes it" maps to the empty-map tap and the ✕ [P3].
   - Haptic: none (tap on map or swipe); light (✕).
   - VoiceOver: ✕ = "Close preview, button". The two-finger Z escape gesture also closes. Focus returns to the pin.
   - Reduce Motion: card fades out in place.
6. **Drag the card without committing** (swipe < 40pt down or < 60pt up) → the card follows the finger with 0.5 rubber-band resistance and springs back (`snappy`). Haptic: none. Reduce Motion: no follow; the gesture only commits or does nothing.
7. **View Details** → the card expands into the place sheet at the **large** detent (04.02 = `/station-details`) via matched geometry (`smooth`, ≈ 450 ms). **Swipe the card up more than 60pt** → the place sheet at the **medium** detent (04.01). Presentation-only change (04 owns the sheet); the logic pushes `/station-details`.
   - Haptic: light.
   - VoiceOver: "View Details, button. Opens station details." After the transition focus lands on the station name in the sheet.
   - Reduce Motion: the sheet cross-fades in (`fade.std`).
8. **Book now** → Pressed → the card expands straight into Book a slot inside the sheet at the large detent (04.24, `smooth`). Paused stations: see rule 23.
   - Haptic: light (opens Book a slot; medium is reserved for commits, 00-system §2.2).
   - VoiceOver: "Book now, button. Opens booking for GreenVolt · DHA Phase 5."
   - Reduce Motion: cross-fade.
9. **Tap a cluster** [P1] → the cluster scales to 1.1 and fades (`snappy`). The camera zooms +2 levels centred on it (`camera` 450 ms). Child pins and clusters radiate out from the cluster centre to their positions (`snappy`, 20 ms stagger), as in 02.09.
   - Haptic: light.
   - VoiceOver: "24 stations. Double-tap to zoom in."
   - Reduce Motion: instant zoom, pins fade in place.
10. **Map Controls · List** (list.bullet) → the map cross-fades to the list (02.15, `fade.std`). Cards rise 16pt with a 30 ms stagger (`smooth`). The control glyph morphs list.bullet → map (SF Symbol replace transition, 200 ms) and the control group collapses to its List mode (`snappy`). **Map** reverses it; the camera is where the user left it.
    - Haptic: selection.
    - VoiceOver: "List, button" → after the switch, "Map, button"; announces "List view" / "Map view".
    - Reduce Motion: cross-fade, no rise.
11. **Map Controls · Price Trends** (chart.bar) → standard iOS push to 02.25 (system 350 ms).
    - Haptic: light. VoiceOver: "Price Trends, button". Reduce Motion: system cross-fade push.
12. **Map Controls · My location** → clears selection, closes search, switches to map and recentres on GPS (logic). The camera flies there (`camera` 500 ms) and the glyph fills (location → location.fill, symbol replace) while following the user; any pan returns it to the outline.
    - No GPS: services off → the 02.05 Toast (rule 4.1-8); permission refused → camera to Lahore and the "Showing Lahore" pill (rule 4.1-6). Logic: "falls back to the default city".
    - Haptic: selection. VoiceOver: "My location, button"; announces "Showing your location" or "Showing Lahore". Reduce Motion: camera jumps.
13. **Heart (top-left)** → standard push to Saved chargers (02.20).
    - Haptic: light. VoiceOver: "Saved chargers, button". Reduce Motion: system cross-fade push.
14. **Bell** → standard push to Notifications (08.53).
    - The red unread dot (logic: `unreadCount > 0`, refreshed on mount and on return) scales in 0 → 1 (`bouncy`) when the count becomes > 0 and scales out (`snappy`) when it drops to 0.
    - Haptic: light on tap; none for the dot. VoiceOver: "Notifications, button" (+ ", unread" while the dot shows). Reduce Motion: the dot fades.
15. **Quick chip tap** (e.g. "Available now") [P26] → the chip toggles Glass/No ↔ Fill/Yes (`snappy`, background cross-fades 150 ms). Connector chips are single-select (03 §4.12): tapping "Type 2 (AC)" while "CCS (DC)" is on moves the selection in the same spring; tapping the selected one returns to All. The "Filters" count appears or changes with a numeric content transition and the "Filters" chip turns Fill/Yes when Count > 0. A refetch runs and pins update (rule 1, Loading pill per rule 2).
    - Haptic: selection.
    - VoiceOver: "Available now, filter, button, selected / not selected".
    - Reduce Motion: no count roll; background swaps without spring.
16. **"Filters" chip** → 02.12. The scrim fades in (`fade.std`) and the sheet rises to the medium detent (`smooth`); it can be dragged to large (03 §4.11-6).
    - Haptic: light.
    - VoiceOver: "Filters and sort, 2 active, button. Opens Filter and sort." (same string as 03 §4.12-9). Focus moves to "Filter & sort", heading.
    - Reduce Motion: sheet fades in at the medium detent.
17. **Inside Filter & sort** (rules shared with 03 §4.11; restated so 02.12 is buildable alone):
    - Option tap → single-select within the section: the new option springs to Fill/Yes while the old one returns to Fill/No (`snappy`, 150 ms cross-fade). "Clear" turns enabled (text/tertiary → text/brand, `fade.quick`). Haptic: selection. VoiceOver: "CCS (DC), selected, 3 of 4" (each section is a radio group). Reduce Motion: instant swap.
    - **Clear** → logic "resets the provider" immediately: every section returns to All / Any / Nearest with a 20 ms stagger and the chips behind the scrim update in place. Haptic: selection. VoiceOver: announces "Filters cleared". Reduce Motion: no stagger.
    - **Show results** → Pressed, the sheet dismisses (`smooth`), filters apply and the chips animate to the new state left → right (40 ms stagger). A sort change refetches; Recommended uses the scored API (logic). Haptic: **medium**. VoiceOver: "Show results, button"; afterwards announces "{n} stations". Reduce Motion: sheet fades out, chips swap without stagger.
    - **Scrim tap or swipe down** → closes **without applying** (logic); option changes since opening are dropped (a Clear already happened stays applied). Haptic: none. VoiceOver: escape gesture = close.
18. **Search field tap** → the capsule scales to 0.98 on touch-down and morphs into the Search overlay (03): it rises to the top and the scrim fades in. Flow 03 owns the rest.
    - Haptic: none (the keyboard appearing is the feedback). VoiceOver: "Search chargers, search field. Double-tap to search." Reduce Motion: cross-fade (03 §4.1).
19. **Error pill "Retry"** (02.11) → the pill's label swaps to a spinner + "Loading…" (`fade.quick`).
    - Success: the pill collapses (`snappy`) and pins return to 100% (`fade.quick`). VoiceOver: "{n} stations".
    - Failure: the pill shakes ±4pt twice over 300 ms. Haptic: error. VoiceOver: re-announces "Couldn't load stations".
    - VoiceOver on the pill: "Couldn't load stations. Retry, button."
    - Reduce Motion: no shake; the label cross-fades back.
20. **"No stations found · Clear"** (02.10) → clears filters (same as **Clear** in the sheet), the pill collapses (`snappy`), the chips return to Glass/No and pins pop in (rule 1).
    - Haptic: selection. VoiceOver: "No stations found. Clear filters, button." Reduce Motion: pill and pins fade.
21. **Session starts/exists** (02.13; the other accessory states are 06.17–06.20 on the same base) → the accessory rises from behind the tab bar (`smooth`). The bottom stack lifts 60pt in the same spring and map `padding.bottom` animates with it.
    - The time ticks every 1 s (logic) with a monospaced-digit numeric transition. The cost rolls only when the rupee value changes.
    - **From 5:00 left** the accessory switches to State=Ending 967:135 with a 300 ms tint cross-fade and keeps counting ("5:00 left · Rs 262"); at ≤ 0 the subtitle becomes the logic's "Ending · Rs X" (06-P27). Null window → State=No window 967:146, "— · Rs 152". Haptic: none (06 sends the Live Activity / banner).
    - **Tap the body** → slideUp `ActiveSessionScreen` (06). Haptic: light.
    - **Stop** → `EndChargingSessionModal` (root, 06.14). Haptic: medium. On confirm → State=Stopping 967:157 ("Stopping…"), the stop-in-flight guard ignores repeat taps (logic), then Charging complete pushes. On error → `Toast` Error "Could not stop session: …" (real template, 06.20) above the raised chips, haptic error, accessory returns to Charging.
    - **Session ends while on Home** → the accessory slides down behind the tab bar (`smooth`) and the stack lowers 60pt in the same spring (edge case 10).
    - VoiceOver: "Charging, about 26 percent, estimated. 28 minutes left. Rs 152 so far. Double-tap to open the session." Custom action: "Stop charging".
    - Reduce Motion: no digit roll (values swap); the accessory fades in and out.
22. **Long-press a pin** [P21] → after 500 ms the pin lifts (scale 1.1, `snappy`) and a context menu with a preview appears: View Details · Book now · Directions · Save.
    - Haptic: medium (system, at menu open).
    - VoiceOver: the same four items are custom actions on the pin.
    - Reduce Motion: the menu fades in (system).
    - Optional. It is not in the logic.
23. **Paused station selected** (02.31 row 6) [P19] → the card shows Book now Disabled 978:442 and the reason line in text/warning. Tapping the disabled button does nothing (no press state, no haptic). View Details stays live.
    - VoiceOver: "Book now, dimmed. This station is currently paused and not accepting new bookings."
    - Offline and Maintenance keep Book now enabled (logic); booking is blocked later in 04 if the host has paused it.
24. **Selected station leaves the result set** (filter change or refetch) → the card stays until dismissed; then the pin fades out (`fade.quick`) (edge case 6). Haptic: none. VoiceOver: no announcement until the card closes.

### 4.3 Home · List (02.15–02.19)
1. **Arrive in list** → see 4.2-10.
2. **Scroll down** [P20] → the tab bar minimises to `Tab Bar / Minimized` and the accessory moves inline (iOS 26 system behaviour, ≈ 300 ms). Chips hide (fade + 8pt drop, `fade.quick`) and the search capsule remains. **Scroll up** by 24pt reverses it. The top Scroll Edge Fade sits under the status bar and the top buttons.
   - Haptic: none.
   - VoiceOver: while VoiceOver is running the chips never hide (they stay focusable); the tab bar still minimises (system).
   - Reduce Motion: chips fade without the drop.
3. **Pull to refresh** [P10] → system refresh control; it commits past a 64pt pull and runs the same fetch as the camera-idle refetch (centre = last fetch centre). Cards update in place, keyed by station id (`fade.quick`); the spinner retracts (`smooth`).
   - Haptic: light at the threshold (system).
   - VoiceOver: a "Refresh" custom action on the list; announces "Stations updated" or the error.
   - Reduce Motion: system behaviour (no extra motion).
4. **Tap a card** (logic: select station, switch to map, centre zoom 15, open the preview):
   - Press scale per §4.0.
   - Matched geometry: that card morphs into the floating preview card while the list cross-fades to the map (`smooth`, ≈ 450 ms).
   - The camera jumps to zoom 15 on the station before the fade completes; the pin appears already selected.
   - Haptic: selection.
   - VoiceOver: "{name}, {status}, {plug} · Lahore, rated 4.8, 1.2 kilometres, Rs 42 per kilowatt-hour. Double-tap to show on map." Focus lands on the preview card title.
   - Reduce Motion: cross-fade.
5. **Loading** (02.16) [P7] → skeleton cards appear only if the fetch takes > 300 ms (same threshold as the map pill), with a shimmer sweep (1.2 s linear loop, white 0 → 40% → 0 gradient, left → right). Real cards replace the skeletons with `fade.quick` and a 30 ms stagger.
   - Haptic: none.
   - VoiceOver: one "Loading stations" announcement; skeletons are hidden from accessibility.
   - Reduce Motion: static skeletons at 100%, no shimmer.
6. **Empty** (02.17) → the State View fades in (`fade.std`) with its icon scaling 0.9 → 1 (`snappy`). **Clear** [P6] clears filters (same as the sheet's Clear); skeletons show (rule 5), then results.
   - Haptic: selection on Clear.
   - VoiceOver: announces "No stations found"; "Clear, button. Clears all filters."
   - Reduce Motion: no icon scale.
7. **Error** (02.18) → State View Error fades in (`fade.std`). **Retry**: the button goes to its Loading variant (Medium Primary Loading 978:449) and the logic refetches at the camera, seed or default location.
   - Failure again: haptic error; the button returns to Default and the message stays. Success: the State View fades out (`fade.quick`) and cards stagger in (rule 5).
   - VoiceOver: the title has the heading trait; "Retry, button"; failure re-announces the title.
   - Reduce Motion: fades only.

### 4.4 Saved chargers (02.20–02.24)
1. **Push in** from the Home heart, Profile → Saved chargers (08) or the 03 search row → standard iOS push (system 350 ms).
   - `Nav Bar` Inline: the title "Saved chargers" is visible from the start; after 8pt of scroll the bar gains its scroll edge (Frost Strong + hairline, `fade.quick`), as in 08.02. "3 saved" scrolls with the content.
   - Cards insert with the logic's animated insert (`smooth`, 30 ms stagger) on first load only.
   - Haptic: none on arrival (the light haptic belonged to the originating tap).
   - VoiceOver: focus on "Saved chargers", heading; then "3 saved".
   - Reduce Motion: system cross-fade push; cards appear without stagger.
2. **Tap the heart (unsave):**
   - The heart pulses 1 → 0.8 → 1 (`bouncy`) and the fill cross-fades to the outline (`fade.quick`).
   - 150 ms later the row collapses (height → 0 and fades, `smooth`) and the rows below move up. The caption counts down "3 saved" → "2 saved" (numeric transition).
   - [P12] `Toast` Neutral "Removed from Saved chargers · Undo" (02.21) rises per §4.0 and stays **6 s** (it has an action). **Undo** re-inserts the row at its index (`smooth`), the heart refills with a 1 → 1.25 → 1 pop (`bouncy`) and the caption counts back up.
   - Haptic: light on unsave; **success** on Undo.
   - VoiceOver: heart = "Saved, toggle button, on". After the tap it announces "Removed from Saved chargers"; Undo is on the Actions rotor; focus moves to the next card (or the empty state).
   - Reduce Motion: the heart swaps without pulse, the row fades out and the others jump.
3. **Unsave fails** → the row re-inserts (`smooth`), the heart refills and `Toast` Error "Failed to update saved station. Please try again." (real, 02.24) replaces any Undo toast and stays 6 s (2 lines).
   - Haptic: **error**. VoiceOver: the toast text is announced. Reduce Motion: fade.
4. **Tap a card** → logic is "pop, then push `/station-details`". It is presented as **one** push transition to 04.12 from the Saved stack position [P13]; the logic is unchanged.
   - Press scale per §4.0. Haptic: light.
   - VoiceOver: "{name}, {status}, Rs 42 per kilowatt-hour. Double-tap to open details."
   - Reduce Motion: system cross-fade push.
5. **Last item removed** → after the row collapses the list cross-fades into the Empty State View (`fade.std`, icon 0.9 → 1 `snappy`). The Undo toast is still offered (edge case 18).
   - Haptic: none extra. VoiceOver: announces "No saved chargers yet". Reduce Motion: fade, no scale.
6. **Explore chargers** → sets the Home tab and pops (logic). Standard pop (system); Home shows the map as the user left it.
   - Haptic: light. VoiceOver: "Explore chargers, button. Goes to the map." Reduce Motion: system cross-fade.
7. **Swipe left on a card** [P12] → trailing destructive action "Remove" (`action/destructive` fill, trash 1025:496). A full swipe past 60% of the card width commits; same path as the heart (rule 2).
   - Haptic: light at the full-swipe threshold.
   - VoiceOver: custom action "Remove from Saved chargers" on each card.
   - Reduce Motion: the action reveals without the elastic stretch.
8. **Loading** (02.22) [P7] → skeletons as 4.3-5 (only when the list is empty and loading, logic). The logic shows a spinner; skeletons are the proposal.
   - VoiceOver: "Loading saved chargers". Reduce Motion: static skeletons.

### 4.5 Price Trends (02.25–02.29)
1. **Push in** → the Nav Bar and context row show immediately. If data takes > 300 ms, 02.27 (State View Loading) fades in (`fade.std`).
   - When data lands, the chart bars grow from the baseline (`smooth`, 40 ms stagger, Sun → Sat). The avg value fades up 6pt (`fade.std`).
   - Region cards rise 16pt with a 40 ms stagger (`smooth`). Each range-bar marker slides from the min end to its position (`smooth`).
   - Haptic: none (light belonged to the Map Controls tap).
   - VoiceOver: focus on "Price Trends", heading; announces "Price trends loaded" when content replaces the loader.
   - Reduce Motion: everything fades in place (`fade.std`), no growth or slide.
2. **Scrub the chart** [P14] → long press (300 ms), then drag, highlights a bar (others dim to 40%). The header line temporarily reads "Thu · Rs 47.8" (numeric transition); release restores "Avg Rs 47.3" (`fade.quick`).
   - Haptic: selection per bar crossed.
   - VoiceOver: an Audio Graph (`AXChartDescriptor`). Each bar reads "Thursday, Rs 47.8 per kilowatt-hour"; today reads "Saturday, today, Rs 47.3".
   - Reduce Motion: no numeric roll; the highlight moves instantly.
3. **Pull to refresh** (logic) → system refresh control; on success "Updated …" changes with `fade.quick` and changed numbers roll (numeric transition).
   - Haptic: light at the threshold (system). VoiceOver: "Refresh" custom action; announces "Updated 6:30 PM". Reduce Motion: values swap without roll.
4. **Region cards** → no tap action (logic). No press state, so they don't look tappable. [P22] would add one.
   - VoiceOver (one element per card): "Model Town. Cheapest right now. 6 stations. Rs 38.4 per kilowatt-hour. Below average. Down 4 percent this week. Price range Rs 34 to Rs 44, today's average marked. Peak demand at 7 PM; charge before 7 PM to avoid peak pricing."
5. **Error → Retry / Empty → Refresh** → the button goes to its Loading variant (Primary 978:449 / Secondary 978:479), then the State View cross-fades to content (`fade.std`).
   - Failure: haptic error; the button returns to Default; VoiceOver re-announces the title.
   - Success: VoiceOver announces "Price trends loaded".
   - Reduce Motion: fades only.
6. **Back** (Nav Bar leading chevron or edge swipe) → standard pop to Home; the map camera is unchanged.
   - Haptic: none (system). VoiceOver: "Back, button". Reduce Motion: system cross-fade.

---

## 5. Mobbin references (58 unique; all iOS)

Every major screen has at least 3 references (Map 7, Station selected 6, Map notices 6, Location 7, Session 3, List 8, Skeletons 3, Saved 7, Price Trends 5, Filter & sort 7). All were found with `mcp__Mobbin__search_screens` (platform ios). On the canvas each row's Refs · Mobbin card lists the references of that row in the brief's format (App — screen / What we take / hyperlink).

### 5.1 Home · Map (02.06, 02.07, 02.09, 02.13)
- **Chime — price pins on a map + floating offer card**: https://mobbin.com/screens/f2f4eb32-521b-49de-a5ca-cfe1c31e1287
  - What we take: price-labelled pins as the primary map information, a floating card docked above the bottom edge with the distance ("1.3 miles") in its meta line, and a slim countdown strip above the card ("3 hr 59 min left"). It supports price pins [P1], distance on the card [P2] and a time strip sitting with the card rather than over the map.
- **Apple Maps — Home (iOS 26)**: https://mobbin.com/screens/edf0fec0-9d0f-4ce8-b206-86becffb51f4
  - What we take: the search capsule in the thumb zone, a stacked glass control group at the right edge, and nothing else on the map. This confirms our bottom-search IA and the 44pt glass controls.
- **Apple Maps — Gas stations, clusters + selected pin + place card**: https://mobbin.com/screens/cc13099d-e1c2-43f0-a565-0e93c51c0c82
  - What we take:
    - Numbered clusters coexist with single pins.
    - The selected pin grows and gets a halo.
    - The place card replaces the search bar.
    - Primary + secondary action pair (Directions / Call).
    - A stat row (Hours · Ratings · Distance) for density.
- **Airbnb — Map with price pills**: https://mobbin.com/screens/c43b2728-2032-492b-9e41-4a99704214ce
  - What we take: price-only pills as the map's primary information. A white pill, dark text and a short tail, which validates our "Rs 42" pins. A collapsed bottom peek tells you list mode exists.
- **Agoda — Price pins with selected state + floating card**: https://mobbin.com/screens/8ac4d59b-5e65-4973-9beb-115e03aca6d4
  - What we take: the selected pin inverts colour (dark fill, white text) and the card floats above the bottom edge with peeks either side (our carousel proposal P16).
- **Shell (Recharge) — EV map with quick filter chips + floating station card**: https://mobbin.com/screens/262f81ef-b0c1-4955-9cd4-0badb52fd129
  - What we take: EV-domain proof that quick chips ("Available", "Rapid 50kW+") mirror filters. The card shows an "Available" status pill, a connector icon and an availability count.
- **Pangea Charging — EV map clusters and station sheet**: https://mobbin.com/screens/c1f5abb0-00fe-421d-824e-9366cf924512
  - What we take: a dense charger map with clusters, and the price as a big light number on the station sheet. It is also our counter-example: too many colours. We keep three status colours only.

### 5.2 Station selected (02.08, 02.14, 02.30, 02.31)
- **Apple Maps — place card** (same as above, cc13099d)
  - What we take: the card sits above the tab bar, the search hides, the close sits top-right and the actions are one emphasised + one quiet.
- **Wanderlog — Location detail (map) flow**: https://mobbin.com/flows/253f9e50-5ca8-44f1-b8bd-a8b5cec26e7c
  - What we take: the ✕ floats just above the card's top-right on the map (our glass close), and the card expands into a tabbed detail sheet on tap (our swipe-up → Station Detail).
- **Lyft — Bike dock station card**: https://mobbin.com/screens/97cfdcb8-09b7-42c8-8992-251acd1aa82b
  - What we take: a two equal-width buttons pattern (Scan / Reserve) is the template for "View Details" / "Book now". It also has a compact per-station stat row and the price line "Free + $0.44 per min" under the name.
- **Tripadvisor — Floating card + List pill**: https://mobbin.com/screens/47ef9950-448a-43fa-a469-1d4ff6330880
  - What we take: the floating card height (~110–170pt) keeps half the map visible; the heart on the card; rating dots next to the name.
- **Places — Searching Places flow**: https://mobbin.com/flows/64e98700-11fe-4926-b935-60de08c0e195
  - What we take: the dark-glass floating card with a status chip ("Open now"). The card swaps content in place when another pin is tapped (rule 4.2-4).
- **Apple Maps — Guide card with close**: https://mobbin.com/screens/ef125d25-1074-43b1-aa75-d643acc4ffc1
  - What we take: the card's frosted material over the map, the circular glass ✕ and equal-width tile actions.

### 5.3 Loading / notices on the map (02.05, 02.07, 02.10, 02.11)
- **Mindtrip — "•••" pill at top centre**: https://mobbin.com/screens/915b8b44-9102-408d-af2a-60266072067c
  - What we take: a tiny top-centre pill while the map refreshes. It is non-blocking and the controls stay live.
- **American Airlines — "Loading map…" pill**: https://mobbin.com/screens/2c106f8d-fa66-4859-9f12-e90abc9114ef
  - What we take: a short label + spinner in a capsule at the top. The copy is one word plus an ellipsis ("Loading…").
- **Tripadvisor — "Search this area"**: https://mobbin.com/screens/73a386de-c741-4c9c-b0a1-93fc1a859d76
  - What we take: map pills sit just above the bottom chips. We keep auto-refetch (logic), so this is used only as placement guidance.
- **Fresha — "0 results · Remove filters" + No internet**: https://mobbin.com/screens/b6f7d349-7d9f-466f-87ce-a2ed5c95b585
  - What we take: an empty-on-map pill with an inline action (P6) and the plain-language error with "Try again" (P15 tone).
- **Places — on-map empty card**: https://mobbin.com/screens/c9bf15ab-dcd8-416b-b610-4b41cbb12cb6
  - What we take: the alternative for empty results, a floating card with one action. We chose the lighter pill so the map stays usable.
- **Subway — "Location Services Off · Turn On" on map**: https://mobbin.com/screens/b1cbdbc6-6a58-4300-a5b4-7049cec4c660
  - What we take: the services-off notice coexists with a usable default-area map; it has one action (our "Settings", P5) and short title + body copy.

### 5.4 Location permission + finding your area (02.01–02.04, 02.32)
- **Urban Company — "Fetching your location…"**: https://mobbin.com/screens/04badc3c-2c76-4cad-b428-ec44d8d85425
  - What we take: before any map exists, a single centred glyph and one line of status on a plain canvas. This is 02.01: State View Loading + "Finding your area…" on Mesh Quiet, chrome already in place.
- **foodpanda — "Updating location…" over a dimmed map**: https://mobbin.com/screens/e8a41101-6c25-4d00-b5af-87e72e408482
  - What we take: the label sits centred on the map while location resolves and the rest of the UI is dimmed but present. Confirms our "no fly-in" rule: the map appears already centred once the fix arrives.
- **Tripadvisor — "See what's good nearby"**: https://mobbin.com/screens/9b1649df-9d4d-4b3b-80b4-17b3174b90fc
  - What we take: a map-dot illustration above the title + one-line value prop + one primary. Our sheet uses a tinted location.fill well instead of an illustration.
- **Cash App — Not now / Continue stacked**: https://mobbin.com/screens/a83fa99d-5202-4250-898a-8ccb1745143d
  - What we take: the stacked full-width buttons with the decline action visible and equal in size; tone is honest and short.
- **Sesame — explanation around the system prompt**: https://mobbin.com/screens/6b07c7e6-01ac-46d8-8855-2f8f3c7e56c6
  - What we take: shows the iOS prompt *in context* so reviewers see 02.03 is OS-owned, and how the purpose string reads.
- **Polarsteps — "Open phone settings" sheet**: https://mobbin.com/screens/3c51573f-81f3-4fc9-ab99-e1e80276596f
  - What we take: for denied-forever, a settings example is clearer than prose. Noted for a later version; we keep the native alert (logic).
- **Fresha — inline "no location access" notice**: https://mobbin.com/screens/04acf221-cfdc-424f-9fb2-0cbae0269d14
  - What we take: low-key, non-blocking wording when location is missing. It is the tone model for the 02.05 Toast.

### 5.5 Session active (02.13, 02.14, 02.19)
- **Apple Maps — glass bottom bar during navigation**: https://mobbin.com/screens/fa3e962f-5b20-4705-b9ee-853017b9c8b4
  - What we take: a persistent glass capsule pinned to the bottom with a title + one quiet metric ("19 min"). This is the density target for "Charging · ≈26%" / "28:00 left · Rs 152".
- **Chick-fil-A — persistent bar above the tab bar**: https://mobbin.com/screens/88fdccce-c4d2-4687-8b40-c7b758eba891
  - What we take: an ongoing-task bar docked directly above the tab bar with content pushed up rather than covered. This is our 60pt raise rule.
- **Glovo — live order header with ETA progress**: https://mobbin.com/screens/39ef8f73-3ddc-4517-858c-2a86ab9b1e85
  - What we take: the live-status hierarchy (time range big, progress bar, one status line), reused for the accessory's Ending state.

### 5.6 Home · List (02.15–02.19)
- **Apple Maps — results list with chips + sort**: https://mobbin.com/screens/e47f2f0c-d839-4fc4-b378-5613feb3f1fd
  - What we take: inset rows with name / address / meta line, filter chips above the list and native density. It is the model for the count + sort header.
- **Tripadvisor — "8 Results" + sort + floating Map pill**: https://mobbin.com/screens/62648541-051d-4790-b3b5-c4abce0aca86
  - What we take: the result count + sort label as a quiet header (P8) and the floating toggle back to the map.
- **Tesla — Nearby Chargers sheet**: https://mobbin.com/screens/9dd62c35-b70a-4fcb-b1b5-f63c9c417dd3
  - What we take: EV list rows with price per kWh and distance as the right-hand metric, and a sort dropdown. This confirms price + distance are the two decision numbers.
- **Too Good To Go — card list + floating Map pill**: https://mobbin.com/screens/dc3f8133-17b1-4f0a-a33e-e9c6e6cf32ca
  - What we take: generous card spacing, rating badge, distance in the meta line and heart on the card. The bottom gradient fade behind floating controls is our scroll-edge fade.
- **PayPal — Partnered gas stations list**: https://mobbin.com/screens/9aa7ac89-e5ad-4f3c-9523-f53449844a4c
  - What we take: one card per station with "2.1 mi · address" on a single meta line and the prices as light numbers below; a quiet disclaimer footer ("Prices provided by the store and subject to change"). Our list card keeps distance and price as the two decision numbers.
- **Shell — connector list with Available / Occupied tags**: https://mobbin.com/screens/03a69161-0568-4a8e-8bad-1c6a206ac275
  - What we take: EV-domain proof for the status pill on every row ("Available" green outline, "Occupied" red) and "CCS · 180 kW" as the connector line. Matches our status table (§2.0) and the "{plug} · {kW}" format.
- **Tesla — Nearby Chargers with sort + speed chips**: https://mobbin.com/screens/3351f028-dab2-46f9-b92b-e6c7ecd01634
  - What we take: a filter glyph, a "Sort By" control and speed chips sitting in one row above the list, and per-row distance in a trailing tile. Confirms our chips row above the list and the "Nearest first" header.
- **Starbucks — store list with status tags**: https://mobbin.com/screens/6137bdfc-9652-483d-b11e-15f10d0edcb2
  - What we take: the status tag ("Closed", "Online ordering not available") sits above the title in tinted pills. This is how Offline stations stay readable but de-emphasised.

### 5.7 Skeleton loading (02.16, 02.22)
- **Luma — skeleton rows with floating tab bar**: https://mobbin.com/screens/567ac178-b443-4ca7-84b5-8a9d2d946f0d
  - What we take: very light grey blocks at the exact card geometry under a floating glass tab bar. No spinner.
- **Shop — skeleton cards under the search field**: https://mobbin.com/screens/9b438485-4afa-4307-aaad-3b8cecd9a0c7
  - What we take: the skeleton keeps chips/search live above it, and a soft fade at the bottom.
- **Fly Delta — skeleton fare cards**: https://mobbin.com/screens/650052e4-fa2a-4562-b994-de2f60dfb427
  - What we take: the skeleton mirrors the price-heavy card layout (title bar + value bar); shimmer only, no text.

### 5.8 Saved chargers (02.20–02.24)
- **Fresha — Favourites**: https://mobbin.com/screens/f395936e-c610-4d55-9ea2-d1c70008ac9b
  - What we take: the large title + back button, the heart on each card and rating trailing the name. It is the exact template for our header.
- **Tripadvisor — "Removed from … · Undo"**: https://mobbin.com/screens/a3f0b27a-14d4-4602-aae4-e8e6c7414fca
  - What we take: the Toast shape, copy pattern and Undo placement for unsave (P12). It floats above the bottom, full width minus margins.
- **Places — saved places list**: https://mobbin.com/screens/52c3abfe-21ff-4a3d-ab3d-ff923d3aa5cf
  - What we take: a dense saved list with a trailing save glyph per row. It is the reference for row rhythm if the list grows past 10.
- **Shop — "You haven't saved any items yet"**: https://mobbin.com/screens/1251e265-4f81-429f-9577-62f99a5d691f
  - What we take: the empty state built around the heart glyph, one sentence on *how* to save and one primary action.
- **PayPal — Favorites empty**: https://mobbin.com/screens/ccb51eaa-14d1-4e58-941c-0638e89fd0d9
  - What we take: an outline heart icon, a two-line title and a pill CTA "Explore items". This mirrors our "Explore chargers" exactly.
- **Deliveroo — "No favourite places yet"**: https://mobbin.com/screens/25ed9478-a8ae-40a0-9027-7b50b7fddfe1
  - What we take: the copy structure "To save a place… tap the heart icon…", which matches our real copy.
- **Klarna — "Nothing saved"**: https://mobbin.com/screens/2ea34d6b-324c-49df-b09b-ccc61a3b2403
  - What we take: the compact empty state with a small CTA; vertical centring slightly above the middle.

### 5.9 Price Trends (02.25–02.29)
- **Brick — Weekly activity**: https://mobbin.com/screens/cf442781-3a85-4de9-8c0b-2a169eec4767
  - What we take: the "Avg" caption over a big light number, the delta line under it, 7 bars with day labels and a dashed AVG line with a tag. This is our Trend Chart Card anatomy.
- **Klarna — "Good time to buy" price range**: https://mobbin.com/screens/5fe6b0e4-34d5-406d-98ab-9de3a218308c
  - What we take: a horizontal min–max range bar with a "Today" marker and the verdict line ("lower than usual"). This maps 1:1 to "Price range · marker = today's avg" + BELOW AVERAGE.
- **Lloyds — Spending insights chart card**: https://mobbin.com/screens/f06acbc4-ffaa-4b40-8e2c-464e80f3e53c
  - What we take: the chart sits in its own white card with its title inside, and the legend values in Display beneath.
- **MoonPay — list with change arrows**: https://mobbin.com/screens/d87002c1-339d-45f4-a036-c2597a51f6f8
  - What we take: the "▼ 2.27%" coloured delta under the price, right-aligned. This is our "↓ 4% this week" treatment.
- **Klarna — "Best offer" badge on first card**: https://mobbin.com/screens/b46cb931-a989-418d-8d76-32f137e2c43e
  - What we take: one small tinted badge on the winning card only. This is "CHEAPEST RIGHT NOW" as `Status Pill` Success S.

### 5.10 Filter & sort (02.12)
- **Places — filter sheet over the map**: https://mobbin.com/screens/352e1016-ccda-482e-ae56-ef9989b4a7d1
  - What we take: a short sheet with segmented tiles, a quiet Cancel and a heavy Apply. The map stays visible above it (medium detent).
- **Tripadvisor — Price filter sheet**: https://mobbin.com/screens/68092d52-ee62-4709-82f0-37668de343db
  - What we take: Reset (text, left) vs Apply (filled, right); a grabber + ✕ header. It confirms "Clear" belongs in the header and "Show results" at the bottom.
- **Apple Maps — chips row above results** (e47f2f0c, above)
  - What we take: the quick-chip row mirrors the sheet's main filters and the sort chip lives in the same row.
- **Mindtrip — Filters sheet**: https://mobbin.com/screens/44b7b958-b5db-425d-839e-6d5651f0b0bf
  - What we take: sections of single-select pill options with a light section title, a text "Clear" on the left and one heavy "Show places" button. The anatomy of 02.12; our "Clear" moves to the header (logic) and "Show results" is full width.
- **Glovo — Sort by sheet + "Food type 4" count chip**: https://mobbin.com/screens/d08d2231-bb94-4732-9eda-522f652d003b
  - What we take: "Recommended / Near me / Ratings" as a radio list with "Show results" (our exact sort labels and CTA), and a filled chip with a count ("Food type 4") in the row behind. This is the "Filters" chip turning Fill/Yes with a count.
- **Cash App — filter sheet over a clustered map**: https://mobbin.com/screens/e5ab2de3-0096-4108-a9c1-64d3d871078c
  - What we take: a short sheet at a medium height over a live clustered map, one Apply. The map stays readable above the sheet, which is why 02.12 opens at the medium detent.
- **Fresha — chip sheet over map results with Clear / Apply**: https://mobbin.com/screens/71dd1fce-e8a5-4b0a-81b7-b1fcc0e80be2
  - What we take: quick chips ("Only verified", "Amenities") in the row behind the sheet, the same options as selected chips inside it. Proof that the quick chips and the sheet are two views of one state (03 §4.12).
- **Klarna — Filter sheet with Sort by + toggles + Show results**: https://mobbin.com/screens/012d0869-12a7-4319-ba48-6ebb49cc1a5a
  - What we take: sort (radio) and filters in one sheet under one "Show results", with a grabber and ✕. Matches "Filter & sort" as a single sheet.

---

## 6. New components needed (not in the inventory)

| Component | Purpose | Variants | Props / anatomy |
|---|---|---|---|
| **Map Status Pill · action + error** (add to set 975:257) | Empty / error on the map (02.10, 02.11); the plain Notice variant (no action) also shows "Showing Lahore" (02.32) | Notice + Action, Error + Action | Existing pill + trailing `Action` (TEXT, Footnote Emph text/brand) separated by a 1×14 separator; Error uses icon exclamationmark.triangle.fill icon/error. Height 36, Glass/Regular. |
| **Permission Sheet** → superseded: build it as `Sheet / Action` Kind=Permission (00-system C3, leading-aligned, 16pt margins); the row below is kept for its copy and props | Location pre-prompt on Home (02.02); the same instance is used by 01.45, which becomes a link card to 02.02. Onboarding's own Location and Notifications steps (01) are full screens and do not use it. | Kind = Location (one variant; add Notifications only if a later flow needs it) | 402 wide, height 372 (content-sized: a 3-line body clips at 352), Surface, radius/sheet 38 top, grabber 36×5, padding 24, gap 16. Nested `Icon Button` Tinted M 979:289 (location.fill 1024:472) rescaled to 56; `Title` (Title 2, text/primary); `Message` (Body, text/secondary); `Primary` = `Button / Large` Primary at (16,712); `Secondary` = `Button / Large` Tertiary at (16,772). Properties: Title#, Message#, Primary label#, Secondary label#. |
| **Trend Chart Card** | 7-day price chart (02.25) | State = Default / Loading | `Title` (Headline), nested `Hero Stat` M Leading (Caption "Avg", Value, Detail "/kWh"), 7 bars (each 28w, radius/xs top, bg/fillStrong; today = brand/primary), dashed 1pt stroke/separator avg line with "AVG" Caption 2 Emph tag on bg/fill, day labels Caption 2 text/secondary (today Caption 2 Emph text/primary), y-gridline labels Caption 2 text/tertiary. 370×236, `bg/surface`, radius/lg 22, padding 16, hairline stroke. Today's bar and label are the only emerald on the screen. Loading state = 7 static `bg/fill` bars (no shimmer under Reduce Motion). |
| **Region Price Card** | One region in "By Region" (02.25) | Rank = Cheapest / Default × Trend = Below / Average / Above | Optional `Status Pill` Success S "CHEAPEST RIGHT NOW"; `Region` (Headline), `Stations` (Footnote secondary), `Price` (Display/S) + "/kWh" (Footnote secondary), band `Status Pill` S (Below = Success, Average = Neutral, Above = Warning), `Change` (Footnote; ↓ text/available, → text/secondary, ↑ text/warning), nested **Price Range Bar**, tip row: clock 958:88 icon/secondary + `Peak` (Subheadline) + `Tip` (Footnote secondary), `Show tip` (BOOL). `bg/surface` (data card, §0 material rule), radius/lg 22, padding 16, gap 12, hairline stroke. |
| **Price Range Bar** | Min–max with today's average marker | none | 6pt track bg/fill radius pill, range segment bg/tint, marker 2×14 brand/primary + "Today" Caption 2 Emph above, `Min`/`Max` Caption 1 text/secondary under the ends, legend "Price range · marker = today's avg" Caption 2 text/tertiary. Marker position = a numeric 0–1 in notes (Figma: move the marker). |
| **Scroll Edge Fade** (utility, not a component set) | iOS 26 soft scroll edge behind floating chrome (list, saved) | Top / Bottom | A rectangle with a gradient from bg/canvas 0% to 92% (bottom) or bg/frost under the status bar (top). |

**Existing components that replace earlier drafts of this spec (do not build new ones):**
- `Toast` [1088:631] (Neutral 1088:611, Success 1088:616, Warning 1088:621, Error 1088:626; Message#1088:0, Action#1088:5, Action label#1088:10) replaces the "Snackbar" this spec first proposed. It has no icon slot; the tone carries the meaning. Used in 02.05, 02.21, 02.24 and the stop-failure rule (06.20).
- `Nav Bar` [1087:643] Inline 1087:607 at (0,54) is used on the pushed screens 02.20–02.29 (brief: Inline for pushed screens). No hand-built back button + large title.
- `iOS / Permission Alert` Kind=Location (system mock, defined in 01 §6) is used for 02.03. The "iOS / System Location Alert" this spec first proposed is dropped to avoid two mocks of the same OS surface.

**Reused as-is:** Map Pin, Map Cluster, User Location, Map Controls, Map Status Pill (Loading, Notice), Chip, Search Field, Station Card (Map preview, List, Saved + Loading variants), Status Pill (Success/Info/Warning/Neutral S), Button / Large + Medium (all states used incl. Disabled and Loading), Icon Button (Glass M/S, Tinted M), Sheet / Filter & sort, Alert Default, State View (Empty, Loading, Error), List Group Header, Hero Stat M Leading, Tab Bar Home, Tab Bar / Minimized, Tab Bar Accessory / Live Charging (Charging; other states in 06), iOS Status Bar Dark, iOS Home Indicator Dark, Mesh Quiet.

---

## 7. Proposals (not in the logic map), flagged

| # | Proposal | Why | Applied in frames? |
|---|---|---|---|
| P1 | Price pins + clustering (already flagged on 1076:5) | Price is the #1 decision number (Airbnb, Agoda, Tesla). Clusters stop the pin soup in DHA/Gulberg. | yes |
| P2 | Distance shown on the preview card ("1.2 km") | Logic computes and passes distance but doesn't render it (Appendix 4). Apple Maps and Shell show it. | yes |
| P3 | Hide search + chips while a station is selected; floating glass ✕ | Apple Maps pattern. Frees the thumb zone for the card's actions; ✕ is needed for VoiceOver and discoverability (logic only has scrim or handle tap). | yes |
| P4 | "Loading…" glass status pill (300 ms delay, 600 ms minimum) instead of the spinner chip | Same meaning, less flicker, consistent with the Map Status Pill component. Copy is reused from the search overlay. | yes |
| P5 | "Settings" action on the location-services-off snackbar | The logic snackbar tells the user to turn location on but gives no path. Subway does this. | yes |
| P6 | Map empty/error pills with "Clear" / "Retry" (last-known pins dimmed to 40% under the error pill); "Clear" action on list Empty | The logic defines empty/error only for list view, so map view shows silence. Fresha does this. | yes (02.10, 02.11, 02.17) |
| P7 | Skeleton cards instead of the full scrim + spinner (list, Saved) | Keeps layout stable; already a component variant (Loading). | yes |
| P8 | List header "4 stations · Nearest first" | Tells the user the sort and result size (Tripadvisor, Apple Maps). Derived data only. | yes |
| P9 | List location line uses the neighbourhood ("DHA Phase 5") + kW instead of the city | The logic's "last comma segment" always reads "Lahore", which is useless in one city. Frames keep the logic copy; this is shown in the flag only. | no |
| P10 | Pull to refresh on the list | Map users refetch by moving; list users have no refresh gesture. | no (interaction only) |
| P11 | Accessory subtitle "28:00 left" instead of "to full", and "≈" on battery %; Ending state from 5:00 that keeps counting, logic "Ending · Rs X" only at ≤ 0 (= 06-P3/P27) | Logic gap: "to full" is really booking time left, and battery % is estimated (the brief's charging limitation). Honest copy, same strings in 05, 06, 07. | yes (02.13) |
| P12 | Undo `Toast` after unsave + swipe-to-remove | Standard iOS. The logic removes instantly with no recovery. | yes (02.21) |
| P13 | Saved → Station Detail as one push instead of pop + push | Pop + push flashes Home for one frame. Presentation only. | interaction only |
| P14 | Scrub the 7-day chart to read each day | The per-day data is already in the chart; VoiceOver Audio Graph needs per-bar values anyway. | interaction only |
| P15 | Plain error copy "Couldn't load stations" / "Check your connection and try again." | The logic prints the raw error (progress flag #8). | yes |
| P16 | Swipeable card carousel between nearby stations | Airbnb, Agoda and Tripadvisor all do it; it saves pin hunting. It needs a selection-sync rule. | no |
| P17 | Full strings for the truncated copy: pre-prompt body "…show how far each charger is, and guide you there.", denied-forever "…system settings to see stations near you." (both identical to 01-P6), and "Check back after stations go live…" (paste from code). | The logic map truncates them; 01 and 02 must show the same sentence. Rayan verifies against the source. ("Finding your area…" is complete; its ellipsis is part of the string.) | yes (02.02, 02.04) |
| P18 | GPS timeout after 10 s → Lahore fallback | No timeout is defined; "Finding your area…" could spin forever. | interaction only |
| P19 | Paused station: Book now disabled on the floating card with the real reason line "This station is currently paused and not accepting new bookings"; Offline and Maintenance stay enabled (logic) | Aligns the Level-0 card with 04-P9 (sheet tile disabled for Paused). Logic only blocks at submit; telling the driver up front avoids a dead end. | yes (02.31 row 6) |
| P20 | Chips hide on scroll in the list + iOS 26 minimised tab bar | More list visible; native behaviour. | yes (02.19) |
| P21 | Long-press pin → context menu (View Details, Book now, Directions, Save) | Power-user shortcut; all actions exist elsewhere. | no |
| P22 | Tap a region card → map centred on that region | Natural next step from "cheapest". Not applied. | no |
| P23 | Filter sheet live count "Show 3 results" | Needs a count API. Not applied. | no |
| P24 | Motion tokens (`snappy`, `smooth`, `bouncy`, `fade.*`, `camera`) + haptic map as Foundations | Lets every flow's micro-interactions stay identical. | doc |
| P25 | Retro-label 1076:5's pins to the dummy station set and reset its chips to default | One consistent story across Discover. Labels and state only, layout unchanged. | yes |
| P26 | Quick filter chips on Home ("Available now", "Type 2 (AC)", "CCS (DC)", "GB/T") plus a "Filters" chip with a count, replacing the icon-only filter button | The logic has only a filter button and the sheet. One tap for the two most common filters; rules shared with 03 §4.12 (single-select connector, Count includes a non-default sort, Fill/Yes when Count > 0). "Filters" is new copy. | yes (all Home frames) |
| P27 | Logo mark + "Pak" "Plug" wordmark not drawn on Home; the brand is the mesh P in the search capsule | Maps-native chrome (concept A) keeps the map clear; the SF Pro wordmark stays on Splash, Story and Sign in. Hammad decides if Home should carry the wordmark (it would sit at (124,70) between the bell and Map Controls). | yes |
| P28 | Map \| List toggle and the two FABs ("My location", "Price Trends") merged into one Glass `Map Controls` group at the top right | Concept A; one control group, thumb-free map bottom. The logic's "FABs raised to 92 px during a session" becomes unnecessary. Labels kept as VoiceOver labels. | yes |
| P29 | `LocationPermissionDialog` shown as a bottom Permission Sheet; the denied-forever `AlertDialog` shown with Cupertino styling (`showAdaptiveDialog`) | Same copy and actions; native iOS presentation. Shared with 01.45/01.46. | yes (02.02, 02.04) |
| P30 | Hide distances (cards, preview, VoiceOver) while there is no GPS fix | Distance from the Lahore default centre would be misleading. Logic behaviour without GPS is unknown (?). | yes (02.05, 02.32 via edge case 4) |
| P31 | "Showing Lahore" notice pill (2.5 s) after a refusal or GPS timeout | Logic falls back silently; the user should know why the map is on Lahore. 01.45 rule 3 already expects a Home notice. | yes (02.32) |
| P32 | Render the computed-but-hidden `estimatedTime` ("1.2 km · 4 min") and `recommendedHighlight` ("Top match" pill on the top 3 when sort = Recommended) | Logic computes both (Appendix 4) but draws neither. Not applied; recorded for Hammad. | no |
| P33 | Price chart labels = rolling 7 days ending today (Sun → Sat) instead of Mon–Sun | Today is always the last, emerald bar; Mon–Sun would show tomorrow as an empty slot. | yes (02.25) |
| P34 | All VoiceOver labels, hints and announcements in §4, plus an accessibility overlay so map pins and clusters are focusable | Accessibility strings are new copy (not visible). Google Map markers are not accessible by default in Flutter. | interaction only |

---

## 8. Edge cases & defaults chosen (Hammad asleep: decided)

1. **Price N/A.**
   - The pin's Price#974:0 reads "N/A" (same pill, no new variant; logic uses N/A on the card).
   - The list card shows "N/A" (logic).
   - The preview connector shows "Pricing unavailable" (real copy from Book) in text/secondary (02.31 row 8).
2. **Hourly-priced station.** The pin reads "Rs 300/hr"; the list card shows "Rs 300/hr" (logic fallback); the preview shows "Rs 300" "/hr" (02.31 row 7).
3. **No reviews.** The rating shows "N/A" (logic). We do not invent "New".
4. **No GPS fix (services off, denied or Not now).**
   - Hide distances on cards and in the preview, rather than showing distance from the default centre (which would be misleading) [P30].
   - Hide the user location dot.
   - The my-location glyph shows its outline.
5. **Long names.** Truncate to 1 line on list cards and 2 lines on the preview card, with a tail ellipsis. VoiceOver reads the full name.
6. **Selected station disappears on refetch** (camera moved, filter changed). The selected pin is pinned, i.e. kept until deselected. If a filter excludes it, the card stays until dismissed, then the pin fades.
7. **Pin collision with the card.** The camera always offsets so the selected pin sits above the card's top edge + 24pt.
8. **Cluster thresholds.**
   - Cluster when two or more pins overlap by more than 50% at the current zoom.
   - Small for 2–9, Large for 10+.
   - Labels cap at "99+".
   - At max zoom, clusters never form; overlapping pins fan out by 8pt.
9. **Session active + station selected.** The card sits above the accessory (02.14). The accessory never hides on Home.
10. **Session ends while on Home.** The accessory slides down (`smooth`) and the stack lowers 60pt. Logic: if the route is current, `ChargingCompleteScreen` is pushed anyway.
11. **Ending state.** From 5:00 left the accessory uses State=Ending 967:135 and keeps counting ("5:00 left · Rs 262"); at ≤ 0 it reads "Ending · Rs X" (logic); null remaining → State=No window 967:146, "— · Rs X" (logic). Same rule as 06-P27; framed in 06.17/06.19.
12. **Filter sheet dismissed by scrim.** Nothing applies (logic). The chips behind never changed while the sheet was open (they only move on Show results), so nothing has to revert. Exception: a Clear tapped inside the sheet resets the provider at once (logic) and stays applied.
13. **GB/T filter.** It behaves like All (logic). The chip still shows selected, and the flag notes the missing backend key.
14. **Offline / Maintenance station tapped.** The card shows the status pill from the §2.0 table and Book now stays enabled (logic: no disabled state; blocked later in Book) (02.30, 02.31 row 5). **Paused**: Book now disabled with the real reason line [P19] (02.31 row 6), same as 04-P9.
15. **Bell unread dot.** Shown when `notificationsProvider.unreadCount > 0`; refreshed on mount and on return.
16. **Messages badge.** "2" in every Home frame (dummy). It caps at "9+" (logic).
17. **Dynamic Type (AX sizes).**
    - Pins cap at XL (they never grow past it); the preview card and VoiceOver carry the full information. Long-press stays the P21 context menu.
    - The chips row scrolls horizontally.
    - List cards grow in height (no truncation of price).
    - The accessory title wraps to 2 lines; time and cost move to a second line.
18. **Unsaving the last saved charger.** The row animates out, then the empty state cross-fades in, and Undo is still offered.
19. **Saved opened from Profile.** "Explore chargers" sets the Home tab, then pops; the user lands on Home · Map (logic).
20. **Price Trends edge data.**
    - With one region, the "CHEAPEST RIGHT NOW" badge still shows.
    - Equal prices are sorted by station count, then name.
    - A weekly change of 0 shows "→ 0% this week" in text/secondary.
21. **Chart flat line.** The y-axis auto-ranges to ±1 Rs around the average so bars never look identical; the avg line is always drawn.
22. **Toast collisions.** Only one Toast at a time; a new one replaces the old one with `fade.quick`. Toasts never cover the tab bar, the accessory, the chips or the search capsule: on Home the bottom edge sits 12pt above the chips (y 672, or y 612 with a session); with a station card open it sits 12pt above the card's top edge.
23. **Google attribution.** It must stay visible in every map frame; it moves with the bottom stack and the Toast (map padding animates). Hidden only while the search overlay is open (logic, 03).
24. **RTL / Urdu.** Out of scope for v1. All layouts are auto-layout so they can mirror later; pins and chips are direction-agnostic.
25. **Reduce Transparency.** Glass and Frost become Surface + hairline. The search field keeps the mesh P, which is not transparency.
26. **Android.** Same layouts; Frost without blur; Material haptics mapping (selection → `HapticFeedback.selectionClick`, light/medium → `lightImpact` / `mediumImpact`, error → `vibrate` pattern).
27. **Pin bitmaps fail to load.** Logic falls back to Google's default green marker (no price label). Selection still works; the card still opens. No error message.
28. **Saved list reload with rows present.** No loader (logic: spinner only when empty and loading); rows update in place with the animated insert/remove.
29. **Map view loading with no previous results** (first fetch after the GPS fix). Same "Loading…" pill (02.07) over an empty map; never the 02.01 State View again once the map exists.
30. **Wordmark.** If Hammad rejects P27 and wants the wordmark on Home, use `Brand / Wordmark` Ink 994:117 (SF Pro) at 96 wide, centred vertically on the heart/bell row (y 82), only in List view (Mesh Quiet). On the map it competes with the pins and the P mark already sits in the search capsule.

---

## 9. Logic-check summary (for the logic card)

Every logic item for this flow and where it is shown. "Real" = verbatim copy; [P] = proposal in the FLAG block.

| Logic item (driver-logic-map.md) | Covered in | Notes |
|---|---|---|
| §B Init · auto-switch activeRole to Driver | logic card text | invisible |
| §B Init 1 · services off → snackbar + default city | 02.05, 4.1-8 | real copy; Toast; "Settings" [P5] |
| §B Init 2 · denied forever → AlertDialog + fallback | 02.04, 4.1-7 | real copy; completion [P17]; Cupertino [P29] |
| §B Init 3 · denied → LocationPermissionDialog → system prompt → fallback | 02.02, 02.03, 02.32, 4.1-3…6 | real copy; sheet [P29]; "Showing Lahore" [P31] |
| §B Init 4 · granted → GPS fix → fetch | 4.1-2, 02.06 | timeout [P18] |
| §B Chrome · logo + "Pak" "Plug" wordmark | not drawn | [P27]; fallback placement in §8-30 |
| §B Chrome · Favorites button → FavoritesScreen | heart (16,60), 4.2-13 | |
| §B Chrome · bell + red unread dot, refresh on mount/return | bell (68,60), 4.2-14, §8-15 | |
| §B Search block · fake field "Search chargers" | search capsule, 4.2-18 | real; overlay is 03 |
| §B Search block · filter square button | "Filters" chip | [P26] |
| §B Search block · Map \| List toggle | Map Controls, 4.2-10 | [P28] |
| §B Map · placeholder "Finding your area…", no map | 02.01, 4.1-1 | real |
| §B Map · native my-location dot; zoom + compass off | User Location 974:264, §2.0 | |
| §B Map · pins default/selected 1.08×, SVG fallback | 02.06, 02.08, 4.2-3, §8-27 | price pins + clusters [P1] |
| §B Map · camera idle → debounced refetch | 4.2-2, 02.07 | pill [P4] |
| §B Map · FABs My location / Price Trends; raised 92 px in session | Map Controls, 4.2-11/12 | [P28]; raise not needed |
| §B Map · attribution (hidden while searching) | §2.0, §8-23 | |
| §B Map · loading spinner chip | 02.07 | [P4] |
| §B List · cards; tap → map, zoom 15, preview | 02.15, 4.3-4 | header [P8] |
| §B List · error + Retry | 02.18, 4.3-7 | plain copy [P15] |
| §B List · empty copy | 02.17, 4.3-6 | real; Clear [P6] |
| §B List · loading (scrim + spinner) | 02.16 | skeletons [P7] |
| §B Station list card · name, status, plug · area, rating/N/A, distance, price fallbacks | 02.15, 02.31, §8-1/2/3 | location line literal; [P9] not applied |
| §B List card · estimatedTime, recommendedHighlight (not rendered) | not drawn | [P32] |
| §B Preview · name, status (5 states), address, connector row, price unit | 02.08, 02.30, 02.31 | every status in 02.31; distance [P2] |
| §B Preview · scrim/handle tap closes | 4.2-5 | empty-map tap + ✕ [P3] |
| §B Preview · View Details / Book now; no disabled state | 4.2-7/8, 02.31 | Paused disabled [P19] |
| §B Filter sheet · title, Clear, 3 sections, defaults, Show results, scrim = no apply, sort refetch, GB/T = All | 02.12, 4.2-17, §8-12/13 | real copy |
| §B Filter state · price/distance/rating filters not surfaced | §3.1 | not drawn, on purpose |
| §B RegionalPriceTrends · every field, footer, 4 states, pull-to-refresh | 02.25–02.29, 4.5 | real copy; dummy values; rolling days [P33] |
| §B Favorites · title + "N saved", status mapping, per-kWh price, heart | 02.20 | real |
| §B Favorites · tap → pop + push details | 4.4-4 | one push [P13] |
| §B Favorites · unsave animated removal + error snackbar | 02.21, 02.24, 4.4-2/3 | Undo [P12] |
| §B Favorites · loading (empty only), empty + Explore chargers, animated insert | 02.22, 02.23, 4.4-1/5/6/8, §8-28 | skeletons [P7] |
| §A Charging pill · title, 3 subtitle cases, Stop, guard, error snackbar, tap → Live | 02.13, 4.2-21 (+06.17–06.20) | [P11] |
| App. 1 · Messages badge "9+" cap; bell dot | every Home frame | dummy "2" |
| App. 2 · App-resume re-runs location | 4.1-7 | |

Not in this flow:
- Search overlay → 03.
- Station Detail, Reviews, Directions, Book a slot → 04.
- Live session, End session modal, Charging complete → 06.
- Notifications screen → 08.

---

## Review notes (design review pass, 2026-10-04)

Checked against `BRIEF.md`, `NEW-COMPONENTS.md`, `driver-logic-map.md` §A/§B/Appendix 1–4 and the sibling specs 01, 03, 04, 06, 08 (which reference 02 frame numbers and rules). What changed:

**Missing logic states, errors and copy (added)**
1. Every preview-card status now has a card: In use, Offline, Maintenance, Paused, hourly price and price/power N/A. New frame **02.31 · Station cards · Every station & status** (P1 board) and **02.30 · Offline station selected** (P2). This also answers "cards of each and every station": the four dummy stations each have a map card and a list card.
2. Refusal fallback had no frame: added **02.32 · Showing Lahore** (P2, [P31]).
3. Added the logic items the draft skipped: top-bar logo + wordmark (now an explicit [P27] with a fallback placement in §8-30), auto-switch to Driver role, native my-location dot + zoom/compass off, pin SVG fallback (§8-27), attribution hidden while searching, FAB raise rule (made unnecessary by [P28]), Favorites "spinner only when empty and loading" (§8-28), price/distance/rating filters "not surfaced", `estimatedTime` / `recommendedHighlight` computed but not rendered ([P32]).
4. Charging accessory: aligned with 06 (Ending from 5:00 keeps counting "5:00 left · Rs 262", logic "Ending · Rs X" at ≤ 0, No window 967:146, Stopping, "Could not stop session: …" Toast, session-end slide-down). The draft showed "Ending · Rs X" at ≤ 5 min, which misread the logic.
5. Misquotes fixed: the camera-idle debounce was attributed to the logic as "400 ms" (the logic only says "debounced"); `LocationPermissionDialog` and the denied-forever `AlertDialog` were described as native iOS surfaces (they are Flutter dialogs, now [P29]); "Finding your area…" was wrongly listed as truncated.
6. Truncated-copy completions now match 01-P6 word for word ("…show how far each charger is, and guide you there." / "…system settings to see stations near you."); the draft used a different sentence.
7. Logic-check card rewritten as a coverage table (§9): every §B / §A item → frame and rule.

**Invented data / UI without a flag (now flagged)**
8. Quick filter chips row and the "Filters" label → [P26], with the 03 §4.12 rules (single-select connector chips, Count includes a non-default sort, Fill/Yes when Count > 0). 02.10, 02.17 and 03.20 now agree.
9. Map Controls replacing the Map | List toggle and both FABs → [P28]. Bottom-sheet pre-prompt and Cupertino alert → [P29]. Hidden distances without GPS → [P30]. Rolling 7-day chart labels → [P33]. All VoiceOver strings + a map-marker accessibility overlay → [P34]. Dimmed pins under the error pill folded into [P6].
10. [P19] changed from "not applied" to applied for **Paused only** on the floating card, matching 04-P9 (Offline and Maintenance stay enabled, per the logic). The draft's P19 disagreed with 04.

**Consistency with the brief and the new components**
11. "Snackbar" new component removed; all notices use the existing `Toast` [1088:631] (no icon slot; tone carries meaning), with one placement rule for Home (12pt above the chips) and the brief rule elsewhere (Saved: bottom edge y 828; the draft's y 786 overlapped the home indicator). Timings aligned with 04/08 (4 s one line, 6 s two lines or any action; Undo was 4 s).
12. Pushed screens (Saved chargers, Price Trends) now use `Nav Bar` Inline 1087:607 at (0,54), as the brief and 04/08 do; content starts at y 118 and all y positions were recomputed. The draft used a hand-built back button + Large Title "until Nav Bar ships"; it has shipped.
13. "iOS / System Location Alert" dropped in favour of 01's `iOS / Permission Alert` Kind=Location. Permission Sheet scoped to Kind=Location, uses the existing `Icon Button` Tinted M (56, as 01.45) instead of a custom well, height 372 (a 3-line body clips at 01's 352); 01.45/01.46 become link cards to 02.02/02.04 so the surface is built once.
14. Material rules made explicit (§0 header): no Hero mesh in this flow; station cards over map/Quiet = Frost Strong (draft used Frost 68% on list cards); Price Trends data cards = Surface (draft said "Surface/Frost"). Alert "bold role" removed (no Bold in UI); preferred action uses text/brand.
15. Status → pill/pin/text-colour table added (§2.0) so every frame and 04 use the same mapping (In use = Info, Maintenance/Paused = Warning, Offline = Neutral).
16. Exits fixed: Book now and View Details go to Flow **04** (04.24 / 04.02, swipe-up → 04.01), not "05 · Book"; Live/Complete exits point to 06, Notifications to 08.53.
17. Dynamic Type rule no longer gives pins a long-press Large Content Viewer (it collided with the [P21] context menu). Filter sheet scrim-close no longer "reverts chips" (chips only move on Show results; Clear applies immediately, per logic).
18. Frame list: 32 frames (21 P1, 10 P2, 1 done). 02.01–02.29 keep their numbers because 03–08 cite them.

**Micro-interactions made concrete**
19. Added §4.0 shared rules: spring settle times, press feedback for every control type (scale, `snappy`, Reduce Motion = 85% opacity), haptics on release, Toast behaviour (timing, tone haptics, VoiceOver rotor, timer pause), VoiceOver conventions.
20. Every rule in §4.1–4.5 now states trigger → response, timing/easing, haptic, VoiceOver and Reduce Motion. Rules that lacked one or more were filled in (e.g. 4.1-3/4/7, 4.2-6/11/13/14/16/18/20, 4.3-2/3/6, 4.4-1/5/6/7/8, 4.5-3/5/6). New rules: 4.1-10 (location granted later), 4.2-6 (partial card drag), 4.2-23 (Paused card), 4.2-24 (selected station leaves results), Stop failure and session-end inside 4.2-21.

**Mobbin**
21. Filter & sort had 2 unique references; now 7 (Mindtrip Filters, Glovo Sort by + count chip, Cash App filter over map, Fresha chip sheet, Klarna Filter). Added Urban Company "Fetching your location…" and foodpanda "Updating location…" for 02.01, PayPal station list, Shell connector status list and Tesla Nearby Chargers for the list, and Chime price pins + floating card for the map. 47 → 58 unique references; every major screen has ≥ 3. All new IDs were taken from `mcp__Mobbin__search_screens` results (ios, design_tool, Figma, jpg, standard) and their images were reviewed.
