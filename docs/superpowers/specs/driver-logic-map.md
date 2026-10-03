# PakPlug Driver Logic Map

> Source of truth for the v4 driver redesign (see `2026-10-03-driver-ui-revamp-design.md`).
> Extracted from the Flutter code on 2026-10-03. Logic is unchanged by the redesign; every v4 flow is checked against this file state by state.

## Inventory

`$SRC` = `Code/pakplug_app/lib/src`

Everything below comes from reading the code. Anything I couldn't confirm is marked **(?)**. Navigation notes: "push" means `Navigator.push`, "root" means the root navigator (it covers the bottom nav), and "slideUp" means `ChargingFlowPageRoutes.slideFromBottom`.

## 0. Reachability: what's live and what's dead

Several files you listed exist but no live driver path reaches them. I traced every call site.

| File / class | Status |
|---|---|
| `$SRC/features/driver/presentation/screens/driver_booking_schedule_screen.dart` (`DriverBookingScheduleScreen`) | **Legacy, unreachable.** The `AppRoutes.bookingSchedule` route is registered but nothing pushes it. The live booking screen is `BookingCreateScreen`. |
| `$SRC/features/driver/presentation/widgets/driver_confirm_booking_modal.dart` | Deprecated wrapper around `ConfirmBookingDialog`. Only the legacy schedule screen uses it. |
| `$SRC/features/station/presentation/screens/my_bookings_screen.dart` (`MyBookingsScreen`) | **Dead.** Replaced by `DriverMyBookingsScreen` (comment in app.dart). |
| `$SRC/features/station/presentation/screens/booking_detail_screen.dart` | Route `/booking-details` is registered, but only the dead `MyBookingsScreen` pushes it. **Not reachable for drivers.** |
| `$SRC/features/session/presentation/screens/scan_entry_screen.dart` | Only the dead `MyBookingsScreen` pushes it. **Not reachable.** |
| `$SRC/features/session/presentation/widgets/session_confirmation_modal.dart` | `SessionConfirmationModal.show` is never called. **Dead.** |
| `$SRC/features/station/presentation/screens/map_screen.dart` | Not referenced anywhere. **Dead.** |
| `$SRC/features/station/presentation/screens/station_picker_list_screen.dart` | Route registered, never pushed. **Dead.** |
| Unused driver widgets: `driver_station_chip`, `driver_charger_result_item`, `driver_host_detail_chip`, `driver_vehicle_card`, `driver_status_tabs`, `start_charging_action_card`, `driver_filter_button`, `driver_charger_type_button`, `pin_charger_default_marker`, `driver_booking_status_pill` | No usages outside their own files. `driver_booking_summary_card` is used only by the legacy schedule screen. |
| `$SRC/features/auth/presentation/widgets/notification_settings_sheet.dart`, `role_selector.dart`, `coming_soon_modal.dart`'s `ComingSoonFeature.identity` | Unused. |
| Wrappers that are live but deprecated: `DriverStationBottomSheet` (wraps `StationPreviewSheet`), `ChargingSessionNoticeModal` (wraps `SessionAlertDialog`), `DriverBookingsTabs` (wraps `TabFilter3Up`), `ChargeQrScanPromptCard` (wraps `DriverScanCard`) | Live call sites, thin wrappers. |

---

## A. Driver shell

### `DriverMainScreen`: `$SRC/features/driver/presentation/screens/driver_main_screen.dart`
- **Purpose:** root of the driver role. Route `/driver-home`; an `int` argument sets the initial tab.
- **Structure:** `IndexedStack` keeps all 5 tabs alive. Index 0 Home (`DriverHomeScreen`), 1 Charge (`ChargeScreen`), 2 Bookings (`DriverMyBookingsScreen`), 3 Messages (`MessagesInboxScreen`), 4 Profile (`ProfileScreen`).
- **Bottom slot:** a Column holding the persistent charging pill (only while a session is active) above `BottomNav`.
- **Logic on mount:**
  - Hydrates any active driver session and starts polling it.
  - Then checks for a "pending charging complete" session id. This is persisted when the app was killed after a stop, for example from the home widget.
  - If that session is closed, belongs to this user, and nothing is live, it pushes `ChargingCompleteScreen` (slideUp). Otherwise it clears the pending id.
- **Listeners:**
  - `driverMainTabIntentProvider` (int) switches tabs programmatically. Favorites and the empty Bookings state set it to 0.
  - `sessionProvider`: when the same session goes active → closed and this route is current, it pushes `ChargingCompleteScreen`.
- **Tab destinations from elsewhere:**
  - Booking success → tab 2.
  - Charging Complete "X" → tab 1 (Charge).
  - Widget intent `active_session` → tab 1, then `ActiveSessionScreen`.

### `BottomNav`: `$SRC/common_widgets/bottom_nav.dart`
- **Tabs:** `['Home','Charge','Bookings','Messages','Profile']`. Each has a linear icon when idle and a bold icon when selected: home2, bolt, calendar, chatRoundDots, user.
- **Badge:** Messages tab only. Value is `totalUnreadCountProvider` (sum of `unreadCount` across chat threads). Rendered as a red count circle, capped at `"9+"`, hidden at 0.
- **States:** selected and unselected colour only. No disabled state.

### `DriverHomePersistentChargingPanel`: `$SRC/features/driver/presentation/widgets/driver_home_persistent_charging_panel.dart`
- **Purpose:** a mini "charging" pill shown above the bottom nav on every tab while a session is active.
- **Data:**
  - Title: `"Charging · {battery}%"`.
  - Subtitle depends on remaining booking seconds:
    - Null: `"— · Rs X"`.
    - ≤0: `"Ending · Rs X"`.
    - Otherwise: `"{mm:ss | h:mm:ss} to full · Rs X"`.
  - The cost is `liveTimeBasedRunningCostPkr`.
  - "to full" is really the **booking window remaining**, not time to a full battery.
  - A bolt icon well. Ticks every 1 s.
- **Actions:**
  - Tap the text area: slideUp `ActiveSessionScreen`.
  - **Stop:** opens `EndChargingSessionModal` (root). On confirm it calls `stopSession`, then pushes `ChargingCompleteScreen`. On error: snackbar `"Could not stop session: $e"`.
- **States:**
  - Hidden: no session, or session not active.
  - A stop-in-flight guard ignores repeat taps.
  - Preview override exists (gallery only).

---

## B. Discover

### `DriverHomeScreen`: `$SRC/features/driver/presentation/screens/driver_home_screen.dart`
**Purpose:** a map or list of nearby stations, with a search overlay, a filter sheet and a station preview sheet. These are all stack overlays, not routes.

**Init:**
- Auto-switches `activeRole` to Driver if the user has the Driver role and isn't mid role-switch.
- Location sequence:
  1. **Location services off:** snackbar "Location services are off. Showing the default area; turn on location for stations near you." Then falls back to the default city (Lahore, from `AppConfig`).
  2. **Permission denied forever:** AlertDialog "Location access" / "Location permission is turned off for PakPlug. Enable it in system settings…" with **Not now** and **Open settings**. Then falls back.
  3. **Permission denied:** `LocationPermissionDialog` ("Allow location access?", "PakPlug uses your location to center the map on you, show how far…", **Allow location** / **Not now**). Then the system prompt. Refusal falls back.
  4. **Granted:** GPS fix, then fetch nearby stations.

**Chrome (always on top):**
- **`DriverHomeScreenTopBar`** (`$SRC/features/driver/presentation/widgets/driver_home_screen_top_bar.dart`):
  - Logo mark plus "Pak" "Plug" wordmark.
  - Favorites circle button → `FavoritesScreen`.
  - Notifications bell → `NotificationsScreen`. Shows a **red unread dot** when `notificationsProvider.unreadCount > 0`; the count refreshes on mount and on return.
- **`DriverHomeSearchBlock`** (`$SRC/common_widgets/driver_home_search_block.dart`):
  - Fake search field "Search chargers"; tap opens the search overlay.
  - Filter square button (tuning icon) opens the filter sheet.
  - **Map | List** segmented toggle with icons.

**Map view:**
- Before a centre is known: placeholder `LoadingIndicator("Finding your area…")`. No map is shown.
- Google Map with the native my-location dot. Zoom and compass controls are off.
- **Pins:** one per station from `filteredStationsProvider` that has coordinates. Two SVG bitmaps: default and selected (selected is 1.08× larger). If the SVGs fail to load, it falls back to the green default marker. Tap a pin → select the station.
- When the camera goes idle, `onMapMoved` triggers a debounced refetch.
- **FABs** (map view only, bottom-right, raised to 92 px while a session is active):
  - "My location" (map-point icon): clears selection, closes search, switches to map, recentres on GPS (falls back to the default city).
  - "Price Trends" (chart icon) → `RegionalPriceTrendsScreen`.
- Google Maps attribution overlay (hidden while search is active).

**List view:**
- `ListView` of `DriverStationListCard`. Tapping a card selects the station, **switches to map view**, centres at zoom 15 and opens the preview sheet.
- **Error:** `ErrorState(message)` with Retry (refetch at the camera, seed or default location).
- **Empty:** `EmptyState` "No stations found" / "No charging stations found in this area. Try moving the map or adjusting filters."
- **Loading:** full scrim plus spinner in list view. In map view, a small centred spinner chip.

**Station list card:** `DriverStationListCard` → `DriverStationCard` (`$SRC/features/driver/presentation/widgets/driver_station_list_card.dart`, `$SRC/common_widgets/driver_station_card.dart`, helpers in `$SRC/common_widgets/driver_station_card_helpers.dart`)
- **Data:**
  - Station name.
  - Status pill: Available / In use / Maintenance / Paused / Offline.
  - Location line: `"{firstPlugType} · {last comma-segment of address}"`.
  - ★ rating, or `N/A` when there are no reviews.
  - Distance, with "away" stripped (e.g. "9.3 km").
  - Price: `"Rs 1,234/kWh"`, falling back to `"/hr"`, falling back to `N/A`.
- **Computed but not rendered:** `estimatedTime` (travel time) and `recommendedHighlight` (top 3 when sort = Recommended and `matchScore` exists).

**Station preview sheet:** `DriverStationBottomSheet` → `StationPreviewSheet` (`$SRC/common_widgets/station_preview_sheet.dart`)
- Appears in map view when a station is selected. Scrim tap or handle tap closes it.
- **Data:**
  - Name.
  - Status pill: Available / In use / Maintenance / Paused / Offline.
  - Address (2 lines).
  - **Connector row:** plug label (e.g. "Type 2 (AC)"), subtitle `"{maxPowerKw} kW · {status}"` (or `N/A`), price "Rs X" with unit "/kWh" or "/hr".
  - Distance is passed in but **not displayed**.
- **Actions:**
  - **View Details** (secondary) → `/station-details`.
  - **Book now** (primary) → `/booking-create`.
- **Note:** no disabled state for paused or offline stations; booking is only blocked later (see C).

**Search overlay** (`_DriverSearchOverlay`, same file):
- **Visuals:** scrim fade-in. The header repeats the top bar plus a live search card: text field with hint "Station name, address, or place", filter button, Map/List toggle.
- **Station data:** on open it loads all nearby stations (max radius) around the last fetch centre, falling back to GPS, then the camera, then the default.
- **Query behaviour (300 ms debounce):**
  - Local station matches (max 10). Row: title = name, subtitle = address, trailing distance label.
  - Then Google Places (max 5). Row: title and subtitle are split from the place name.
- **Result-panel states:**
  - Initial loading: "Loading…".
  - Places still loading: trailing "Loading…" row.
  - Empty: "No stations or places found."
  - Places failure: snackbar "Could not load place suggestions. Check your connection."
  - Google attribution footer.
- **Actions:**
  - Tap a station → close the overlay and select it on the map.
  - Tap a place → resolve its details, switch to map, animate to zoom 14, fetch nearby stations.
- **Dismissal:** tap the empty area below, swipe up on the results list, or system back. All animate out.

**Filter sheet:** `DriverFilterBottomSheet` (`$SRC/features/driver/presentation/widgets/driver_filter_bottom_sheet.dart`)
- Stack overlay above the nav. Title "Filter & sort" with a trailing **Clear** (resets the provider).
- **Sections:**
  - **Connector type:** All, Type 2 (AC), CCS (DC), GB/T. GB/T has no backend key, so it behaves like All.
  - **Availability:** Any, Available now.
  - **Sort by:** Recommended, Nearest, Price, Rating. Default is Nearest.
- **Show results** applies the filters and closes. Scrim tap closes without applying.
- Changing sort refetches nearby stations; Recommended uses the scored API.
- Price, distance and rating filters exist in state but aren't surfaced.

### `RegionalPriceTrendsScreen`: `$SRC/features/station/presentation/screens/regional_price_trends_screen.dart`
- **Purpose:** Lahore price trends. Opened from the Home FAB.
- **Data:**
  - Context row: "LAHORE · LAST 7 DAYS" plus "Updated …".
  - `TrendChartCardWidget`: "7-day price trend", "Avg Rs X.X", Mon–Sun chart.
  - "By Region" header with "Cheapest first".
  - **`RegionCardWidget` per region:**
    - The first card is badged "CHEAPEST RIGHT NOW".
    - Region name and "N stations".
    - "Rs X.X" "/kWh".
    - Trend band: BELOW AVERAGE / AVERAGE / ABOVE AVERAGE.
    - Weekly change: "↓/↑/→ N% this week".
    - Min–max price range bar ("Price range · marker = today's avg").
    - Peak tip: "Peak demand at H" / "Charge before H to avoid peak pricing".
  - Footer: "{updated} · Based on N active stations across Lahore".
- **States:**
  - Loading: "Loading price trends…".
  - Error: "Unable to load regional price trends" / "We couldn't load price trends. Please try again." with Retry.
  - Empty: "No pricing data available yet" / "Check back after stations go live…" with **Refresh**.
  - Populated: pull-to-refresh.

### `StationDetailScreen`: `$SRC/features/station/presentation/screens/station_detail_screen.dart`
- **Route:** `/station-details` with `stationId`.
- **App bar:** back button. Trailing heart toggles a favourite (filled when saved). Toggle error snackbar: "Could not update saved state: …".
- **Data:**
  - Status pill and name.
  - Address with pin icon.
  - **3 stat cards:**
    - Rating: ★ value or N/A, with label "No reviews yet" / "1 review" / "N reviews". **Tappable** (value underlined) → `StationReviewsScreen`.
    - Distance: from GPS only, else N/A.
    - Connectors: count.
  - "Connectors": one `ConnectorRow` per plug type, with dividers.
  - "Host": initials avatar plus host name (no verified badge or response time, removed on purpose).
- **Bottom CTA bar:**
  - **Directions** (secondary) opens `GetDirectionsModal`. If the station has no coordinates: error snackbar "Station location is not available".
  - **Book now** (2× width) → `/booking-create`.
- **States:**
  - Loading: blank app bar plus spinner.
  - Error: "Failed to load station details", error text, Retry, Go Back.
  - Populated.
- **Note:** there's no "Message host" entry point anywhere pre-booking (see H).

**`GetDirectionsModal`:** `$SRC/features/station/presentation/widgets/get_directions_modal.dart`, built on `SheetGoogleMapsDirections`
- Bottom sheet: "Open in Google Maps" / "Get turn-by-turn directions to {station}" / optional "{km} · ~{min} min drive" (estimated at 35 km/h).
- **Open Google Maps** launches an external URL and falls back to a `geo:` URI. Failure snackbars: "Could not open Maps…" or "Error opening maps…".
- **Cancel** closes.

### `FavoritesScreen` ("Saved chargers"): `$SRC/features/station/presentation/screens/favorites_screen.dart`
- **Opened from:** the home top-bar heart and Profile → Saved chargers.
- **Header:** title plus caption "N saved".
- **Rows:** `DriverStationFavouriteCard` (`$SRC/common_widgets/driver_station_favourite_card.dart`). Same as the station card, but status maps available → Available, busy → In use, anything else → Offline. Price is per kWh. Has a heart.
- **Actions:**
  - Tap a card: pop, then push `/station-details`.
  - Heart: un-save, with an animated row removal. Error snackbar "Failed to update saved station. Please try again."
- **States:**
  - Loading (empty and loading): spinner.
  - Empty: "No saved chargers yet" / "Tap the heart on a charger to save it here for quick access." with **Explore chargers** (sets Home tab, pops).
  - Populated: animated insert and remove.

### `StationReviewsScreen`: `$SRC/features/review/presentation/screens/station_reviews_screen.dart`
- **Title:** "Reviews" (driver; `asHost` = false).
- **Summary card:** ★ average (N/A when no reviews) and "Based on N review(s)".
- **List:** `CardReviewWidget` (`$SRC/common_widgets/card_review_widget.dart`). Each row has initials avatar, reviewer name ("First L." or "Driver"), date "MMMM d, yyyy", 5 stars (whole stars only), optional body.
- **States:**
  - Loading: "Loading reviews…".
  - Error: "Failed to load reviews. Please try again." with Retry.
  - Empty: "No reviews yet" / "No reviews yet for this station."
  - Pull-to-refresh.

---

## C. Book

### `BookingCreateScreen` ("Book a slot"): `$SRC/features/station/presentation/screens/booking_create_screen.dart`
**Route:** `/booking-create` with `stationId`. Reached from the preview sheet's Book now and Station Detail's Book now.

**Sections (scroll):**
1. **Station card** (`BookASlotStationCardWidget`). Name plus meta line `"{address} · {connector} · {kW} kW · Rs X/kWh|/hr"`. An encrypted-looking address is hidden.
2. **DATE:** `DateChipStrip` (`$SRC/common_widgets/date_chip_strip.dart`). 7 days starting today. Labels: "Today", then "EEE" plus the day number. Defaults to today. Changing the date clears the window and start time.
3. **WHEN** header:
   - Optional peak note: amber dot plus "Peak 5 PM–9 PM" (first contiguous run of peak hours).
   - Body comes from `dayAvailabilityProvider`:
     - Loading: compact spinner.
     - Error: "Error loading available times: …".
     - Closed: "Station is closed on this day".
     - Otherwise:
       - **Duration chips** (shown only if free windows exist): 15 min, 30 min, 45 min, 1 h, 1.5 h. Chips that don't fit from the chosen start are dimmed and disabled. Hint: "Longest here: {Xh Ym}".
       - "Day availability": `BookingDayTimelineBar`, non-interactive. Segments are free, booked or past. Peak tint. Legend: Free / Unavailable / Peak. Highlights the selected window.
       - Either "No free windows on this day", or "Available windows": `BookingFreeWindowPills`. Each pill reads "9 AM – 12 PM · 3h". A pill is dimmed and disabled when shorter than the chosen duration. Selecting one scrolls to the grid.
       - "Start time": `BookASlotTimeGridWidget`. 15-min `TimeChip`s inside the window. Chip states: normal, selected, booked (doesn't fit). Placeholder before a window is picked: "Pick a window above to see start times". Fallback copy: "No available times". Tapping a selected chip deselects it.
4. **VEHICLE:** `BookASlotVehicleRowWidget`.
   - Loading: spinner.
   - Error, or no vehicles: "No vehicle added" with **Add** → `/add-vehicle`, then refresh.
   - Vehicles but none selected: "Choose your vehicle" with **Change**.
   - Selected: `"{name} · {matching plug label}"` with **Change**.
   - Red outline plus error line when blocked:
     - **No vehicles:** "Add a vehicle to book this charger".
     - **Vehicle mismatch:** "None of your vehicles match this charger".
   - Auto-picks the primary compatible vehicle, else the first compatible one.

**`BookASlotVehiclePickerSheet`** ("Choose vehicle"): `$SRC/features/station/presentation/widgets/book_a_slot_vehicle_picker_sheet.dart`
- Rows show car icon, name, "Primary" pill, and subtitle (plugs · battery).
- **Incompatible rows are disabled** and the subtitle becomes a warning: "Doesn't fit this charger ({station plugs})".
- Footer **Add vehicle** pushes `/add-vehicle`. If a newly added vehicle fits, it's auto-selected and the sheet closes.
- **States:** loading; error "Couldn't load vehicles. Try again, or add one."; empty "No vehicles added yet."

**Pinned footer:** `BookingCostFooter` (`$SRC/features/station/presentation/widgets/booking_cost_footer.dart`)
- **Cost block** (shown only when there's something to quote):
  - Start and duration chosen: `"Rs {cost} · Ends {h:mm AM}"`.
  - Window and duration only: `"Rs min–max · {duration}"` (or a single value).
  - When there's no cost, the CTA goes full width.
- **CTA state table** (first matching row wins):

| Condition | CTA label | Enabled | Action |
|---|---|---|---|
| No vehicles, or no compatible vehicle | "Add a vehicle" | yes | → `/add-vehicle` |
| No duration and no start | "Select a time" | no | |
| Duration set, no start | "Pick a start time" | no | |
| Start set, no duration | "Pick a duration" | no | |
| All set | "Confirm booking" | yes (not while submitting) | opens the confirm dialog |
| Override: every hourly rate ≤ 0 | "Pricing unavailable" | no | |

**Confirm dialog:** `ConfirmBookingDialog` (`$SRC/common_widgets/confirm_booking_dialog.dart`)
- "Confirm booking" / "Review your charging slot before you book."
- Rows: Date "MMM d, yyyy", Time "HH:mm – HH:mm", Duration ("1 hour" / "N hours" / "N min"), Total "Rs X".
- **Confirm booking** / **Back**.
- If the cost can't be computed: snackbar "Unable to calculate cost. Please check station pricing."

**Submit:**
- **Station paused:** snackbar "This station is currently paused and not accepting new bookings". No API call.
- Creates the booking with the vehicle and connector, invalidates availability and bookings, then **replaces the whole stack with the driver shell on the Bookings tab**. There is **no dedicated success screen**; the new booking simply appears under Upcoming.
- **Errors:** snackbar (6 s) with **Retry**. Messages:
  - Server message, if any.
  - "Connection was interrupted. Your booking may still have been created—open Bookings and pull to refresh before booking again."
  - "This time slot is already booked…"
  - "Invalid booking details…"
  - "Station not found."
  - "Network error…"
  - "Failed to create booking".
- Offline and maintenance stations are not blocked client-side **(?)**.

**Screen-level states:**
- Station loading: "Loading station…".
- Station error: "Failed to load station" with **Go back**.

### Legacy (unreachable): `DriverBookingScheduleScreen`
- Old "Select Charging Schedule" flow.
- Fields: "Select Date", "Charging Duration" (with "Custom Duration", max 4 hours), "Start Time" slots ("Show all times" / "Hide all times").
- Vehicle dropdown, "Booking Summary" card, "Confirm Booking — Rs X" CTA.
- Optimistic `_optimistic_` booking: the card shows "Confirming...".
- Keep it only as reference. `pendingBookingProvider` / `bookingErrorProvider` are still read by the Bookings tab.

---

## D. Charge

### `ChargeScreen` (Charge tab): `$SRC/features/driver/presentation/screens/charge_screen.dart`
- **Header:** `PakPlugTabScreenShell` titled "Charge" (no bell).

**State 1: no active session**
- "Start charging" / "Scan a charger's QR code to begin a session."
- **`DriverScanCard`** (`$SRC/features/driver/presentation/widgets/driver_scan_card.dart`): dashed QR frame with bolt, "Scan to charge" / "Point your camera at the QR on the charger.", CTA **Scan QR code** → `QRScannerScreen`.
- **`ChargeShortcutRow` "Enter charger ID"** / "Type the code shown on the charger" → `ManualChargerIdEntryScreen`.
- **`ChargeShortcutRow` "Find a charger"** / "Browse chargers on the map" → switches to the Home tab.

**State 2: session active**
- "Charging in progress" / "You're already charging — finish or stop that session before starting another."
- Card with station name (or "Charging session") and "Charging · X%".
- **View session** → slideUp `ActiveSessionScreen`.

### `QRScannerScreen`: `$SRC/features/session/presentation/screens/qr_scanner_screen.dart`
- **Top bar:** back plus "Scan charger QR". Live camera with a dashed frame. "Align the QR code within the frame".
- **Enter code manually** pill → manual entry.
- **Permission denied state:** "Camera Permission Required" / "Allow camera access to scan QR codes" with **Open Settings** and **Go back**.

**Detection logic** (`_isProcessing` blocks re-entry):
1. Bad payload → snackbar "Invalid charging station QR code".
2. Station lookup fails → snackbar "This QR code does not match any registered charging station."
3. Find the earliest **confirmed** booking at this station whose end is after now.
4. Check the time window:
   - **Too early (more than 15 min):** "Your booking starts at HH:mm. You can only start charging within 15 minutes of your scheduled time."
   - **Expired:** "Your booking ended at HH:mm. Please create a new booking."
5. Outcome:
   - **No booking:** "You don't have an upcoming booking at this station. Please create a booking before starting a session."
   - Any error from steps 4–5 → `SessionAlertDialog` (see below).
   - Booking OK → `StartSessionDialog` (see below).

**`StartSessionDialog`** (`$SRC/common_widgets/start_session_dialog.dart`)
- Bolt icon well. "Start charging session?"
- Rows:
  - Station.
  - Connector: the booking's connector, else the first plug, formatted "X (AC)", default "Type 2 (AC)".
  - Rate: "Rs N / kWh", or "Rs — / kWh".
- **Start charging** / **Cancel**.
- Start calls `startSession(qrPayload, bookingId)`, then clears the stack back to the shell and slides up `ConnectingToChargerScreen`.
- On failure: `SessionAlertDialog` with a mapped error.

**`SessionAlertDialog`** (`$SRC/common_widgets/session_alert_dialog.dart`)
- Info icon, title "Cannot start session", message, station-name strip, **OK**.

### `ManualChargerIdEntryScreen`: `$SRC/features/session/presentation/screens/manual_charger_id_entry_screen.dart`
- **Header:** back plus "Enter charger ID".
- **Copy:**
  - "Type the code printed on the charging unit to start your session."
  - Label "Charger code".
  - Helper: "Find this 6-character code on the charger or its QR sticker."
- **Field:** autofocus, uppercase, auto-formatted as `ABC-123`, alphanumeric only.
- **Start charging** is disabled until there are 6 valid characters, and while loading or showing an error. Shows a spinner while loading.
- **Errors:**
  - "Code must be 6 characters"
  - "Code must contain only letters and numbers"
  - **Invalid code:** "We don't recognize this code. Double-check the sticker on the charger, or rescan the QR." plus a link **"Scan the QR instead →"** (replaces this screen with the scanner).
  - Lookup failure: "Failed to lookup charger. Please try again."
  - Editing the field clears the error.
- **On station found:** pops itself, then runs the same booking and time-window checks as QR via `ManualChargerIdStationConfirmationDialog` (`$SRC/features/session/presentation/widgets/manual_charger_id_station_confirmation_dialog.dart`).
  - Same `StartSessionDialog` / `SessionAlertDialog` outcomes.
  - Starts with `startSessionByShortCode`. A missing code gives "Short code is missing. Please try scanning the QR code instead."

### `ConnectingToChargerScreen` / `ConnectingToChargerView`: `$SRC/features/session/presentation/screens/connecting_to_charger_screen.dart`, `…/connecting_to_charger_view.dart`
- **Data:**
  - Bolt circle.
  - "Connecting to charger" / "Please wait while we establish a secure connection…"
  - Card "Connecting to" plus the station name (hidden until the name is known from polling).
  - Animated 3 dots. Staggered fade-in.
- **Behaviour:** starts polling and **automatically replaces itself with `ActiveSessionScreen` after 2 s**. No buttons.

### Not reachable
- `ScanEntryScreen` ("Scan QR Code": Scan with Camera / Upload QR Image / Enter Charger ID, plus the note "Make sure you have an active booking before scanning").
- `SessionConfirmationModal` ("Finding your booking...", auto-matches the booking).

---

## E. Live session

### `ActiveSessionScreen` → `ActiveChargingView`: `$SRC/features/session/presentation/screens/active_session_screen.dart`, `$SRC/features/session/presentation/widgets/active_charging_view.dart`
- **Entered from:** Connecting (auto), the shell pill, Charge tab "View session", or the widget intent. Slides up from the bottom.
- **Telemetry:**
  - **Overline:** `"CHARGING · {STATION NAME}"` (fallback "Charging Station").
  - **Battery ring** (`ActiveChargingBatteryRingWidget`): `{battery}%` plus "CHARGING". If battery is null it **defaults to 40** **(?)**.
  - **ETA row:** `{mm:ss | h:mm:ss}` "to full". This is the **booking-window remaining** (`effectiveRemainingBookingSeconds`); it shows "—" when there's no booking.
  - **3 stat cells:**
    - **KM ADDED:** **hard-coded placeholder "+92"**.
    - **KWH:** `energyKwh` with 1 decimal, or "—".
    - **SO FAR:** `"Rs {liveTimeBasedRunningCostPkr}"` (elapsed time × per-hour rate, falling back to the running estimate).
  - `currentPowerKw` (kW) **exists on the model but isn't shown**.
  - **Timeline:**
    - "Plugged in": start time.
    - "Charging started": the same start time.
    - "Now · X%": current clock (active dot).
  - **Tip:** "Stopping under 80% helps your battery last longer."
- **Actions:**
  - Minimize chevron (top right) pops back to the driver shell; the session keeps running and the pill shows.
  - **Stop charging** opens `EndChargingSessionModal`. On confirm: `stopSession` → replace with `ChargingCompleteScreen`.
- **States:**
  - Session null: "Loading session...".
  - Stop loading: button spinner, disabled.
  - Stop error: snackbar "Error stopping session: $e" with **Retry**.
  - **Booking window ended (remaining ≤ 0):** auto-stop with snackbar "Session time reached. Stopping charging automatically...", then Complete.
  - Session closed remotely: auto-navigates to Complete.
  - UI re-renders every 1 s.

### `EndChargingSessionModal`: `$SRC/features/session/presentation/widgets/end_charging_session_modal.dart`, wraps `DestructiveConfirmSheet`
- Bottom sheet: "End charging session?" / "Your car is at {X}% — ending now bills this session at Rs {Y}."
- **End session** / **Keep charging**. Returns a bool.

---

## F. Complete

### `ChargingCompleteScreen` → `ChargingCompleteView`: `$SRC/features/session/presentation/screens/charging_complete_screen.dart`, `…/charging_complete_view.dart`
- **Entered from:** active screen stop, auto-stop or remote close; pill Stop; shell listener; app-relaunch resume; home-widget stop intent. Clears the pending id.
- **Data:**
  - Close **X** (top right).
  - Check icon. "Charging complete" / "Your vehicle is ready to go".
  - **Stat cards:**
    - Battery `{X}%` (defaults to 40 if null).
    - kWh (1 decimal or N/A).
    - Total `"Rs {billedAmount ?? runningCostEstimate}"`.
  - **Session summary card:** station name and address; Date "MMM d, yyyy"; Time "HH:mm – HH:mm"; Duration ("1 hour 5 minutes"); Transaction ID "#{first 8 characters of the session id}".
- **Actions:**
  - **X** → `pushNamedAndRemoveUntil(driverHome, tab 1 = Charge)`.
  - **Leave a review** → `showLeaveReviewModal(bookingId, stationName, "MMM d, yyyy, HH:mm")`. If there's no booking id: snackbar "Booking not found — cannot open review".
  - **Download receipt** (secondary, shows loading):
    1. Asks for gallery permission. Denied: "Permission required to save receipt".
    2. Renders `ChargingReceiptWidget` off-screen to PNG and saves it as `PakPlug_Receipt_{id}`.
    3. Snackbars: "Receipt saved to your gallery", "Could not save receipt", "Could not generate receipt. Please try again.", "Could not save receipt. Please try again."
- **States:** a staggered entrance animation with a safety timer.

### Receipt: `$SRC/features/session/presentation/screens/charging_receipt_generator.dart` (`ChargingReceiptWidget`)
- Brand header (bolt plus "PakPlug"), then the same hero, stats and summary card.
- Dashed divider. Footer "Thank you for charging with PakPlug" / "pakplug.com". No buttons.

### Review prompt: `LeaveReviewModal` (`$SRC/features/review/presentation/widgets/leave_review_modal.dart`)
- Bottom sheet on the root navigator. **Not auto-shown.** It opens from Complete, from the Bookings card links, and from the `/write-review` route.
- **States:**
  - Loading: spinner.
  - Error: "Failed to load review" plus error text with Retry.
  - **Read-only, no review:** "Your review" / "The review period has ended." / "You did not submit a review for this booking." with **Done**.
  - **New:** "How was your session?"
  - **Edit:** "Edit your review" (prefilled).
  - **Read-only:** "Your review" with **Done** and "Submitted reviews are visible to the station host."
- **Data and inputs:**
  - Subtitle `"{station} · {date, time}"`.
  - 5 tappable stars; tapping the current star clears it. Required hint: "Please select a star rating".
  - Text field with hint "Anything the next driver should know? (optional)".
  - Counter "N/500 characters", red at or over the limit. Submit is disabled at ≥500, with snackbar "Shorten your review before submitting."
- **CTA:** **Submit Review** or **Update Review**. Footnote: "You have 7 days to edit your review after submitting."
- **Results:**
  - Success snackbars: "Review submitted successfully" / "Review updated successfully".
  - Errors: server message, or "Failed to submit review (HTTP n)".

---

## G. Bookings tab

### `DriverMyBookingsScreen`: `$SRC/features/driver/presentation/screens/driver_my_bookings_screen.dart`
- **Also opened** as a pushed route via `/my-bookings` (notification tap). The `bookingId` argument is **ignored**; there's no deep link to a specific booking.
- **Header:** "Bookings" with `TabFilter3Up` tabs **Upcoming · Completed · Cancelled** (`$SRC/common_widgets/tab_filter_3up.dart`). Tabs are synced with a swipeable `PageView`.
- **Buckets** (`$SRC/features/station/data/booking_tab_buckets.dart`):

| Tab | Contents | Sort |
|---|---|---|
| Upcoming | status `confirmed` and end > now, plus the optimistic pending booking | newest start first |
| Completed | status `completed` | by end time, descending |
| Cancelled | cancelled, expired, or confirmed but past its window (shown as "Expired") | newest start first |

  `paused` bookings fall into **no tab** **(?)**.
- **Live updates:** a socket `booking_updated` event refreshes the list. Pull-to-refresh.
- **States:**
  - Not logged in: "Please log in to view your bookings".
  - Loading: spinner. Reloads keep the old data on screen.
  - Error with no cache: `ErrorState` "Failed to load bookings" with Retry.
  - **Offline cache banner:** "Showing cached bookings (offline)".
  - A tab with any station still loading shows a centre loader.
  - Card-level station error: "Error loading station: …".
  - Legacy optimistic-booking error snackbar with **Dismiss**.
- **Empty states:**

| Tab | Title | Message | Action |
|---|---|---|---|
| Upcoming | "No bookings yet" | "Find a charger nearby and book your first slot." | **Explore chargers** → Home tab |
| Completed | "No completed bookings" | "Finished sessions will appear here." | none |
| Cancelled | "No cancelled bookings" | "Cancelled or expired bookings will appear here." | none |

### `DriverBookingCard` → `BookingListCard`: `$SRC/features/driver/presentation/widgets/driver_booking_card.dart`, `$SRC/common_widgets/booking_list_card.dart`
- **Data:**
  - Station name.
  - **Status pill:** confirmed or paused → "Upcoming"; Completed; Cancelled; Expired. An optimistic booking shows "Confirming..." and is **not tappable**.
  - Schedule `"{Today|Tomorrow|EEE, MMM d}, h:mm a · {duration}"`. Duration is the actual session duration when completed.
  - Connector.
  - Amount: completed uses the billed amount; cancelled or expired shows "—" when the amount is 0; otherwise "Rs X".
  - Chevron.
- **Inline review link** (completed bookings only):
  - Within 7 days, not reviewed: **Leave a Review**.
  - Within 7 days, reviewed: **Edit Review**.
  - Past 7 days, reviewed or unknown: **View Review** (read-only).
  - Past 7 days, not reviewed: **Review period ended** (dimmed). Tap shows snackbar "Reviews can only be submitted within 7 days of the session."
- **Tap** → booking details sheet.

### `DriverBookingDetailsBottomSheet`: `$SRC/features/driver/presentation/widgets/driver_booking_details_bottom_sheet.dart`
- Custom slide-up route over a scrim; scrim tap closes it.
- **Title:** "Booking details" plus a status pill:
  - Upcoming.
  - Completed.
  - Cancelled, or "Cancelled by you" / "Cancelled by host" when known.
  - Expired.
  - Paused.
  - The pill uses the **raw** status, so a confirmed booking past its window still reads "Upcoming" here **(?)**.
- **Charger card:** bolt avatar, station name, address, connector row (`chargerType` or connector; "{maxPower} · {Available|Completed|Cancelled|Expired}"; no price).
- **"Booking information":**
  - Scheduled date "MMM dd, yyyy".
  - Scheduled time "HH:mm – HH:mm".
  - Duration.
  - Total cost.
- **"Access notes":** shown only when present.
- **Host card:** initials, host name, "Charger host".
  - **Call** circle, shown only if a socket URL is configured. Resolves the thread by booking, then opens `ManualCallSheet`. Error snackbar "Unable to load contact info. Please try again."
  - **Message** circle, with a **red unread dot** (`chatUnreadCountForBookingProvider`). Opens `ChatThreadScreen(bookingId)` on root.
- **Buttons:**
  - **View charger** → `/station-details`.
  - **Cancel booking** (outlined red). Shown only when the booking is confirmed or paused **and** not past its window.

### `DriverCancelBookingModal`: `$SRC/features/driver/presentation/widgets/driver_cancel_booking_modal.dart`
- Centred dialog: warning icon, "Cancel booking?", "Are you sure you want to cancel this booking? This action can't be undone."
- **Cancel booking** (red) / **Keep booking**.
- **After confirm:** blocking spinner, then the cancel API.
  - **Success:** marks the booking cancelled locally, switches to the Cancelled tab, snackbar "Booking cancelled successfully", refetch.
  - **Error:** snackbar with the server message. If the message says "cannot be cancelled" or "expired", it also jumps to Cancelled and refetches.
  - Debug test bookings: "Test bookings cannot be cancelled via API".

### `BookingDetailScreen`
- Unreachable (see §0). It had sections Vehicle / Charging Station / Charger / Booking Details / Amount Estimation / Selected Payment Method, and a "Cancel Booking?" dialog with **No** / **Yes, Cancel**.

---

## H. Messages

### `MessagesInboxScreen`: `$SRC/features/chat/presentation/screens/messages_inbox_screen.dart`
- **Header:** "Messages" with a **bell** action that opens Notifications (unread dot).
- **Filter pills with counts:** All · Unread · Inquiries · Upcoming.
  - Upcoming = linked booking status `confirmed` or `paused`.
  - Inquiries = relationship state `inquiry_pending` or `inquiry_waiting`.
- **Thread row:**
  - Initials avatar and other participant's name.
  - Last-message preview, or "No messages yet".
  - Optional chips: upcoming booking ("Today 6:00 PM" / "Tomorrow …" / "Mon …"), and "New inquiry" (`isInquiryPendingHostReply`).
  - Relative time: now / Nm / Nh / Yesterday / weekday / d/m/y.
  - Unread dot.
  - **Amber left border** when the thread has an active session.
- **Tap** → `ChatThreadScreen.fromThread` on root (bottom nav hidden).
- **States:**
  - Loading: spinner.
  - Error: "Unable to load conversations" with Retry.
  - Empty (driver): "No messages yet" / "Book a charger or ask a host — conversations show up here." with **Find a charger**. That button calls `maybePop`, which is effectively a no-op inside the tab **(?)**.
  - Filtered empty: "No conversations in this filter".
  - Pull-to-refresh.

### `ChatThreadScreen`: `$SRC/features/chat/presentation/screens/chat_thread_screen.dart`
- **Entry points:**
  - Inbox row (thread object).
  - Booking sheet (`bookingId`; resolved through `GET /thread/by-booking`).
  - Push tap (`chatRoomId`).
  - Loading and error states for the last two: "Messages" app bar plus spinner; "Unable to open conversation" with Retry.
- **App bar:**
  - Title is the other participant's name. **Tapping the title** opens `ChatModerationSheet`.
  - Trailing **phone** → `ManualCallSheet`. Hidden when the thread is blocked.
- **Presence strip:** "typing…" or a dot plus "Online".
- **Booking banner:** shown only when the linked booking is `confirmed` ("Upcoming booking", calendar icon) or `paused` ("Charging now", live style). Tap → read-only `DriverBookingDetailsBottomSheet` with **no cancel and no chat**; call goes through `ManualCallSheet`. Fetch error: "Unable to load booking details."
- **Message list:**
  - Date separators: Today / Yesterday / d/m/y.
  - Bubbles: mine vs theirs (theirs get an avatar), with time "h:mm AM".
  - **System event cards:**
    - "Booking confirmed".
    - "Booking cancelled" (muted, tappable).
    - "Booking expired" (muted, tappable).
    - "Charging session completed" (tappable).
    - Subtitle: `"{station} · d/m h:mm AM–h:mm PM"`.
  - Messages loading: spinner. Messages error: "Unable to load messages".
  - **Empty thread hero:**
    - Upcoming booking: "Booking at {station}" (or "You're booked with {name}") / "Ask about parking, access, or anything else before you arrive."
    - Driver not yet unlocked: "Ask {first} a question" / "Pick an inquiry below to start. Once they reply, you can message freely."
    - Neutral: "Message {first}" / "No messages yet — say hello or ask a question to get started."
- **Composer modes** (`_deriveComposerMode`):

| Mode | When | UI |
|---|---|---|
| freeText | relationship `unlocked` | "Message" field plus send button (spinner while sending); typing events emitted |
| needsTemplate | cold inquiry | button "Send an inquiry to get started" |
| nudgeAvailable | `inquiry_waiting` and ≥48 h since last nudge | button "Send a follow-up" |
| waitingForHost | `inquiry_waiting` and <48 h | text "Waiting for the host to reply. You can send a follow-up soon." |
| blocked | thread blocked | text "You can't send messages in this conversation." |

- **Inquiry template sheet** ("Send an inquiry" or "Send a follow-up"):
  - "The host will need to reply before you can send a free-text message."
  - 4 templates: "Is the charger available this evening?" · "Can I book a recurring slot?" · "Asking about access / parking before I book." · "Asking about your charger before booking."
  - Or a custom message ("Or write your own message…", max 140) with **Send**.
- **Send errors:**
  - Free text: inline red strip, "Message failed to send. Please try again." or the server message.
  - Inquiry: snackbar "Inquiry failed to send. Please try again."
- **Note:** there's **no UI anywhere for a driver to start a brand-new thread** (pre-booking inquiry) with a host. Threads only appear once the server has created them **(?)**.

### `ChatModerationSheet`: `$SRC/features/chat/presentation/widgets/block_report_sheet.dart`
- "Conversation options".
- Trust chip: "No completed bookings together yet" / "1 completed booking together" / "N completed bookings together".
- Rows **"Block {name}"** and **"Report conversation"** are both disabled with a "Coming soon" label.
- **Close**.

### `ManualCallSheet`: `$SRC/common_widgets/manual_call_sheet.dart`
- "Call {name}".
- Body:
  - With a number: "You'll leave PakPlug and call {name} at {number} using your phone's dialer."
  - Without: "{name} hasn't added a phone number yet. Send them a message instead."
- **Call** opens the `tel:` dialer; it's disabled when there's no number. Failure snackbar "Couldn't open your phone's dialer."
- **Cancel**.

---

## I. Profile

### `ProfileScreen`: `$SRC/features/auth/presentation/screens/profile_screen.dart`
- **Header:** user name as title, email as subtitle, initials avatar.
- **Stats:**
  - Sessions: count of completed bookings, or "—".
  - Charged: **always "—"** (no API).
  - Saved: number of favourites.
- **`ProfileModeSwitcher`** ("Driver mode" | "Host mode", `$SRC/common_widgets/profile_mode_switcher.dart`):
  - Host tap, user already has the Host role: spinner dialog → `switchRole(host)` → host dashboard. Error snackbar on failure.
  - Host tap, no Host role: push `HostRegistrationScreen` (host flow, out of scope).
  - Driver tap on the driver profile: no-op (already selected).
  - The thumb animates, then snaps back to its resting position after the action.
- **Menu:**
  - **Wallet & earnings:** Coming Soon modal ("Wallet is coming soon" / "In-app payments arrive with v2. Until then, settle with your host directly — every session still gets a receipt." / **Got it**).
  - **Saved chargers** → Favorites.
  - **My vehicles** (only if the user has the Driver role) → `/vehicles`.
  - **Identity & verification** → `DriverIdentityVerificationScreen`.
  - **Notifications** → `NotificationsScreen`.
  - **Settings** → `/driver-account-settings`.
  - **Help & support:** `HostHelpSupportSheet` ("Help & support", "Need assistance? We're here to help.", "Support hotline" 03116677098, "Available 24/7 for assistance", **Call support** / **Cancel**).
- **Sign out:** `DestructiveConfirmSheet` "Logout" / "Are you sure you want to logout?" with **Logout** / **Cancel**, then `logoutWithActiveSessionGuard` (`$SRC/features/auth/presentation/utils/logout_with_active_session_guard.dart`):
  1. If a session is active: dialog "Active Charging Session" / "You are currently charging. Logging out will end your session now…" with **Stay Logged In** / **End Session & Logout**.
  2. Loader "Ending charging session...".
  3. On failure: "Could Not End Session" with **Cancel Logout** / **Retry**.
  4. "Charging Summary" (Station / Duration / Final Amount Rs X.XX) with **Continue Logout**.
  5. Snackbar "You logged out during an active charging session. Session was ended and billed for actual usage."
  6. "Logging out..." → login. Logout failure: snackbar "Logout failed: …".
- **States:** loading spinner; error "Failed to load profile"; "No user data".

### `DriverAccountSettingsScreen` ("Account & settings"): `$SRC/features/auth/presentation/screens/driver_account_settings_screen.dart`
- **Avatar row:** initials, name, email, **Edit** → `/driver-edit-profile`.
- **ACCOUNT:**
  - Phone: shows a "Verified" pill when a phone is present, else "—".
  - Number plate: from the primary vehicle, else "—".
  - Language: "English" (static).
- **PREFERENCES:**
  - Push notifications: real toggle; disabled until loaded.
  - SMS booking reminders: switch shows off; tap → Coming Soon.
  - Charging-complete alerts: switch shows off; tap → Coming Soon.
- **Delete account:** `DestructiveConfirmSheet` "Delete Account" / "Are you sure you want to delete your account? This action cannot be undone." → spinner → login. Error snackbar on failure.
- **States:** loading; "Failed to load account"; "No user data".

### `DriverEditProfileScreen` ("Edit profile"): `$SRC/features/auth/presentation/screens/driver_edit_profile_screen.dart`
- **Fields:**
  - Full name: required, hint "Your name".
  - Email: validated, hint "you@email.com". **Disabled for Apple private-relay addresses**, with the note "Hidden by Apple. This private address forwards to your real inbox. To change it, open Settings on your iPhone → your name → Sign in with Apple → PakPlug."
  - Phone number: validated, hint "03XXXXXXXXX".
- Errors show inline under each field.
- **Save changes** (loading) → pop. Error snackbar on failure.

### `NotificationsScreen`: `$SRC/features/auth/presentation/screens/notifications_screen.dart`
- **Header:** "Notifications" with a trailing **Mark all read** (only when populated and there are unread items). Failure snackbar "Couldn't mark notifications as read. Try again."
- **Sections:** TODAY / YESTERDAY / EARLIER.
- **`NotificationRow`:** icon tile (varies by type and status), title, body, relative time, unread state.
- **Tap a row:** marks it read, then navigates by type:
  - `BOOKING_STATUS_CHANGED` / `BOOKING_EXPIRING` → `/my-bookings`.
  - `chat_message` → chat thread.
  - `incoming_call` → `CallScreen`.
  - Host types → host screens.
- **States:**
  - Loading: "Loading…".
  - Empty: "No notifications yet" / "When you get updates about bookings and charging, they'll show up here." (pull-to-refresh).
  - Error: "We couldn't load your notifications. Please try again." with Retry.

### `VehiclesScreen` ("My vehicles"): `$SRC/features/vehicle/presentation/screens/vehicles_screen.dart`
- **List:** `VehicleListItem` (`$SRC/features/vehicle/presentation/widgets/vehicle_list_item.dart`). Car icon, display name, "Primary" pill, subtitle "{plugs} · {battery}", edit icon.
  - **Tap** → `/edit-vehicle`.
  - **Long-press** → delete sheet: "Delete Vehicle" / "Are you sure you want to delete {name}? This action cannot be undone." with **Delete Vehicle** / **Keep Vehicle**. Snackbars "Vehicle deleted" or the error.
- **Footnote:** "Your primary vehicle powers connector matching and Recommended stations."
- **FAB:** **Add vehicle** → `/add-vehicle`.
- **States:**
  - Loading.
  - Error: "Error loading vehicles" plus error text with Retry.
  - Empty: "No vehicles added" / "Add a vehicle so we can match connectors and recommend stations." with **Add vehicle**.
  - Pull-to-refresh.

### `AddEditVehicleScreen`: `$SRC/features/vehicle/presentation/screens/add_edit_vehicle_screen.dart`
- **Title:** "Add vehicle" or "Edit vehicle". Edit mode shows a loading state first; a load failure shows a snackbar and pops.
- **Fields:**
  - Brand: required, "e.g., Tesla", error "Car brand is required".
  - Model: required, "e.g., Atto 3, Model 3", error "Car model is required".
  - **CONNECTOR TYPE:** a 2×2 multi-select of `ConnectorTile`s: Type 2 "AC · common", CCS 2 "DC · fast", Type 1 "AC", CHAdeMO "DC". At least one is required; otherwise snackbar "Select at least one connector type".
  - Battery (optional): "e.g., 60 kWh", must be 1–1000. Error "Enter a battery size between 1 and 1000 kWh".
  - Plate (optional): "e.g., LES-1234", uppercased.
  - "Set as primary vehicle" switch.
- **Save vehicle** (loading). Success snackbar "Vehicle added successfully!" / "Vehicle updated successfully!", then `pop(true)`. Adding a vehicle also marks the driver as verified. Error snackbar "Error: …".
- **Draft:** onboarding passes a `VehicleFormDraft`, so backing out keeps the typed values.

### `DriverIdentityVerificationScreen` ("Identity & verification"): `$SRC/features/auth/presentation/screens/driver_identity_verification_screen.dart`
- **Status banner:**
  - Verified: "You're a Verified Driver" (green check).
  - Not verified: "Not a Verified Driver yet".
- Line: "Add a vehicle to get verified as a driver."
- **Condition card "Vehicle added":**
  - Done: "You've added at least one vehicle."
  - Not done: "Add your car to meet this condition." with **Add a vehicle** → `AddEditVehicleScreen`, then refresh the user.
- **Auto-latch:** if the user has a vehicle but isn't marked verified, it marks them verified.

---

## J. Onboarding and auth (driver path, in order)

Flow controller: `$SRC/features/onboarding/onboarding_flow/onboarding_flow.dart`. Internal pushes go on the root navigator and slide in from the right. Only `/onboarding` and `/login` are named routes.

1. **`SplashScreen`** (`$SRC/features/splash/screens/splash_screen.dart`)
   - Logo, "Pak""Plug" wordmark, "Charge Your Journey", spinner.
   - After 1.5 s:
     - Onboarding not seen → `/onboarding`.
     - Otherwise checks auth (10 s timeout) → `/driver-home`, host or admin home, or `/login`.
   - A 12 s safety timer forces `/login`.
2. **`OnboardingScreen`** (`$SRC/features/onboarding/screens/onboarding_screen.dart`, slides use `$SRC/features/onboarding/widgets/onboarding_slide.dart`)
   - Pages:
     - Splash page: "PakPlug" / "Community charging for Pakistan's EVs".
     - "Charge anywhere" / "Private chargers all around you — clear Rs/kWh pricing, rated by drivers like you." (chip "Rs 42/kWh").
     - "Plug in. Watch it live." / "Scan the station QR to start — then track battery, speed and cost in real time." (68%, "Charging · 22 kW", "Rs 385 so far", "80% by 6:40 PM").
     - "Earn from your charger" / "Share it while you're parked elsewhere. You set the price and the hours." ("+ Rs 1,240 this week").
   - **Skip** appears on the middle slides only and jumps to the last slide.
   - **Next** / **Get started** (last slide). Get started marks onboarding seen → `/login`.
3. **`OnboardingSignInScreen`** (`/login`; `$SRC/features/onboarding/screens/onboarding_sign_in_screen.dart`)
   - "Let's get you charging" / "Sign in or create your account — it takes a minute."
   - Buttons:
     - **Continue with email** → step 4.
     - **Continue with Apple** (iOS and macOS only).
     - **Continue with Google**.
   - Links and footnotes:
     - **"Already have an account? Log in"** → step 4b.
     - "New here? Your account is created automatically."
     - Footer "By continuing you agree to our **Terms & Privacy Policy**" → `PrivacyPolicyScreen`.
   - Social result: a new user goes to Choose role (step 6); a returning user goes straight to role home.
   - States: shared loading (button spinners), inline error text.
4. **`OnboardingCreateAccountScreen`** (`…/onboarding_create_account_screen.dart`)
   - "Create your account" / "Book and charge at any PakPlug station."
   - Fields: Full name, Email, Phone number (optional), Password. A check icon turns active when the password meets "At least 6 characters".
   - Errors appear only after the first submit attempt. Inline error message for API failures.
   - **Create account** (loading) → step 5.
   - "Already have an account? **Log in**" replaces this screen with 4b.
   - **4b. `OnboardingLoginScreen`** (`…/onboarding_login_screen.dart`)
     - "Welcome back" / "Log in to your PakPlug account."
     - Email and Password, inline error, **Forgot password?** → `/forgot-password` (prefilled with the email).
     - **Log in** → role home directly (no email-verify gate).
     - "Don't have an account? **Sign up**" → step 4.
   - **`ForgotPasswordScreen`** (`$SRC/features/auth/presentation/screens/forgot_password_screen.dart`)
     - "Reset password" / "Enter the email for your account. If it is registered, we will send reset instructions."
     - Email field, **Send reset link** (spinner). On success: snackbar "If an account exists for that email, you will receive password reset instructions shortly." then pop.
     - **Back to login** replaces the route with `/login` (the Sign-in screen, not 4b). Inline error and snackbar on failure.
5. **`OnboardingVerifyEmailScreen`** (`…/onboarding_verify_email_screen.dart`)
   - Link-based, not a code.
   - "Check your inbox" / "We sent a verification link to\n{email}".
   - **"Didn't get it? Resend"** (shows "Resending…"). Message "Verification email resent." or "Couldn't resend — try again in a moment."
   - **I've verified — Continue** (loading) reloads the user:
     - Verified → step 6.
     - Not verified: "Not verified yet — tap the link in the email we sent you."
6. **`OnboardingChooseRoleScreen`** (`…/onboarding_choose_role_screen.dart`)
   - Progress step 1. "STEP 1 OF 3". "How will you use PakPlug?" / "Pick one to start — you can add the other anytime."
   - Cards (Driver selected by default):
     - "Drive & charge" / "Find, book and start charging sessions near you".
     - "Host & earn" / "List your charger, set your price and hours".
   - CTA **Continue as driver** → step 7. (Host goes to the host flow.) Inline error.
7. **`OnboardingAddVehicleScreen`** (`…/onboarding_add_vehicle_screen.dart`)
   - Progress step 2 and "STEP 2 OF 3", both hidden in role-switch mode.
   - "Add your vehicle?" / "Saving your car makes booking faster — you can always add it later from your profile."
   - Select-only cards:
     - "Add it now" (pill "1 min") / "Brand, model, connector type — under a minute." Default.
     - "Set up later" / "Add your car from Profile whenever you're ready."
   - Info: "We'll only show you chargers that fit your car's connector type."
   - CTA:
     - **Add my vehicle** → `AddEditVehicleScreen(draft)`. Advances only after a real save.
     - **Continue** (when "later" is selected) → next.
   - Next = Location, or All set in role-switch mode.
8. **`OnboardingLocationScreen`** (`…/onboarding_location_screen.dart`)
   - Dark green screen. 3-segment progress bar. "STEP 3 OF 3". Route illustration.
   - "Find chargers near you" / "Your location helps us show stations nearby and guide you there. Prefer not to? Browse any area in Limited Mode."
   - **Allow location** (OS prompt) → Notifications. **Not now** → Notifications. Back arrow.
9. **`OnboardingNotificationsScreen`** (`…/onboarding_notifications_screen.dart`)
   - Progress step 3, "STEP 3 OF 3".
   - "Never miss a charge" / "Booking confirmations, session updates, and a ping when your car hits 80%. The stuff that matters — nothing else."
   - 2 static preview cards:
     - "Booking confirmed 🎉" "GreenVolt Charger · DHA Phase 5, tomorrow 6:00 PM".
     - "Charged to 80% ⚡" "Rs 385 · 14.2 kWh — you're good to go".
   - **Turn on notifications** (OS prompt) → All set. **Maybe later** → All set.
10. **`OnboardingAllSetScreen`** (`…/onboarding_all_set_screen.dart`)
    - Confetti and check.
    - "You're all set, {first name}!"
    - Body: "Let's find your first charger." or "Your {vehicle} is ready. Let's find its first charger."
    - Recap pills: "Driver", plus vehicle name and connectors when a vehicle exists.
    - **Find my first charger** and **Explore the app first** do the **same thing**: `finishToRoleHome` marks onboarding complete and goes to `/driver-home` (Home tab).

**Role-switch variant (existing host adds Driver):**
- Profile Driver mode, not yet driver-onboarded → `DriverRegistrationScreen` (`$SRC/features/auth/presentation/screens/driver_registration_screen.dart`).
- "Become a driver" / "This is your first time switching to Driver — add your vehicle first to get verified. Same quick step every driver goes through." **Continue** → step 7 → All set (skips Location and Notifications). Back cancels the role switch.

Host-only screens (`onboarding_verify_identity`, `upload_cnic`, `add_station_now`, `under_review`) were skipped as you asked.

---

## Appendix 1: Notifications and badges

| Where | Signal | Source |
|---|---|---|
| Bottom nav, Messages tab | Red count badge, "9+" cap | `totalUnreadCountProvider` |
| Home top-bar bell; Messages tab header bell | Red dot | `notificationsProvider.unreadCount > 0` |
| Notifications list rows | Unread state; "Mark all read" | same |
| Booking details sheet, Message circle | Red unread dot | `chatUnreadCountForBookingProvider(bookingId)` (`$SRC/common_widgets/booking_modal_chat_unread_badge.dart`) |
| Inbox rows | Unread dot; "New inquiry" chip; upcoming-time chip; amber left border for an active session | `ChatRoomModel` |
| Inbox filter pills | Counts per filter | computed |
| Shell | Persistent charging pill (battery %, time left, Rs) | `sessionProvider` |
| Bookings | Offline cache banner; "Confirming..." pill (legacy optimistic booking) | `myBookingsProvider` tuple / `pendingBookingProvider` |
| Push types handled | `BOOKING_STATUS_CHANGED` ("Booking update"), `BOOKING_EXPIRING` ("Booking expiring soon" / "Start charging before your window ends."), `chat_message`, `incoming_call`, plus host types | `$SRC/core/services/notification_service.dart` |

## Appendix 2: Global overlays and OS surfaces
- **Foreground push banner:** `AnimatedNotificationBanner` (`$SRC/common_widgets/in_app_notification_banner.dart`), inserted into the root Overlay on iOS.
  - Shows title, body, relative time ("now", "Ns ago", "N mins ago", …).
  - Auto-dismisses after 6 s. Tap navigates as above.
  - Suppressed for `chat_message` when that thread is open (`ChatForegroundTracker`).
  - Android shows a system tray notification instead (channels "Chat messages" / "Bookings & alerts").
- **`IncomingCallListener`** wraps the whole `MaterialApp`. On a socket `incoming_call` it pushes `CallScreen` (`/call`), or auto-rejects as "busy". In-app WebRTC calling is otherwise dormant in v1; manual `tel:` calling is the live path.
- **Auth-loss redirect:** if the user becomes null on a non-public route → `/login`.
- **Android charging surfaces:** `DriverChargingSurfaceService` (overlay pill when foregrounded with overlay permission, plus a foreground-service notification). `DriverHomeWidgetSurfaceService` drives the home-screen widget. A widget "stop_session" action stops the session, then pushes Charging Complete.
- **App-resume:** refreshes auth and the notification inbox, and consumes widget launch intents.

## Appendix 3: Key product copy (CTAs and labels)
- **Tabs:** Home · Charge · Bookings · Messages · Profile
- **Home:** "Search chargers" · "Map" / "List" · "Filter & sort" · "Clear" · "Show results" · "View Details" · "Book now" · "My location" · "Price Trends" · "No stations found"
- **Station:** "Directions" · "Book now" · "Open in Google Maps" / "Open Google Maps" · "Connectors" · "Host" · "Saved chargers" · "Explore chargers"
- **Book:** "Book a slot" · DATE / WHEN / VEHICLE · "Day availability" · "Available windows" · "Start time" · "Longest here: …" · "Peak …" · "Select a time" · "Pick a start time" · "Pick a duration" · "Confirm booking" · "Add a vehicle" · "Pricing unavailable" · "Choose vehicle" · "Doesn't fit this charger (…)" · "Confirm booking" / "Review your charging slot before you book." / "Back"
- **Charge:** "Start charging" · "Scan to charge" · "Scan QR code" · "Enter charger ID" · "Find a charger" · "Scan charger QR" · "Enter code manually" · "Charger code" · "Scan the QR instead →" · "Start charging session?" · "Start charging" · "Cannot start session" · "Charging in progress" · "View session"
- **Live:** "Connecting to charger" · "CHARGING · {STATION}" · "to full" · KM ADDED / KWH / SO FAR · "Plugged in" / "Charging started" / "Now · X%" · "Stop charging" · "End charging session?" · "End session" / "Keep charging" · mini-pill "Charging · X%" / "Stop"
- **Complete:** "Charging complete" · "Your vehicle is ready to go" · Battery / kWh / Total · "Session summary" · "Leave a review" · "Download receipt" · "How was your session?" · "Submit Review" / "Update Review"
- **Bookings:** Upcoming / Completed / Cancelled · Expired · "Booking details" · "Booking information" · "Access notes" · "Charger host" · "View charger" · "Cancel booking" · "Keep booking" · "Leave a Review" / "Edit Review" / "View Review" / "Review period ended"
- **Messages:** All / Unread / Inquiries / Upcoming · "New inquiry" · "Upcoming booking" / "Charging now" · "Send an inquiry to get started" · "Send a follow-up" · "Message" · "Conversation options" · "Call {name}" / "Call"
- **Profile:** "Driver mode" / "Host mode" · Sessions / Charged / Saved · "Wallet & earnings" · "My vehicles" · "Identity & verification" · "Settings" · "Help & support" · "Sign out" · "Account & settings" · "Delete account" · "Edit profile" / "Save changes" · "Add vehicle" / "Save vehicle" · "Set as primary vehicle" · "Primary" · "You're a Verified Driver"
- **Onboarding:** "Charge Your Journey" · "Community charging for Pakistan's EVs" · "Get started" · "Let's get you charging" · "Continue with email / Apple / Google" · "Create your account" · "Check your inbox" · "I've verified — Continue" · "How will you use PakPlug?" · "Drive & charge" / "Host & earn" · "Continue as driver" · "Add your vehicle?" · "Add my vehicle" · "Find chargers near you" · "Allow location" / "Not now" · "Never miss a charge" · "Turn on notifications" / "Maybe later" · "You're all set, {name}!" · "Find my first charger" / "Explore the app first"

## Appendix 4: Logic gaps that affect the redesign
- KM ADDED is hard-coded to "+92". kW is never shown. "Charged" on Profile is always "—".
- "to full" means booking time remaining, not battery-to-full time.
- If battery % is missing, it defaults to 40% on the Live and Complete screens.
- There's no vehicle-mismatch check at charge start. The only check is booking plus a ±15-minute time window.
- There's no booking success screen; confirming redirects to the Bookings tab.
- Paused bookings don't appear in any Bookings tab, and the details sheet doesn't show the derived "Expired" status. Both **(?)**.
- Drivers have no UI to start a new chat thread with a host. The empty-inbox "Find a charger" button is likely a no-op **(?)**.
- Station preview sheet: distance and ETA are computed but not displayed. The list card's "recommended" highlight isn't rendered.
- Charging Complete's X lands on the **Charge** tab (index 1), not Home.
