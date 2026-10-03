# Driver UI Revamp — Figma Build Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. All work happens in Figma through the Figma MCP (`use_figma`), so load `figma:figma-use` before the first `use_figma` call, `figma:figma-generate-library` before building variables and components, and `figma:figma-shaders` before creating shaders. Steps use checkbox (`- [ ]`) syntax for tracking. Tasks run sequentially in one session, because parallel writes to one Figma file conflict.

**Goal:** Build the new PakPlug driver design system in Figma: logic map → brand → foundations → style frame → components → flows. It is reviewed step by step by Hammad.

**Architecture:**
- **Variables:** palette directions are **modes of one `Brand` variable collection**, so previewing or choosing a palette is a mode switch, not a rebuild. Semantic tokens alias Brand and kit neutrals, and every component binds only to semantic tokens.
- **Native chrome:** instances from the iOS and iPadOS 27 community library.
- **Custom content:** our own component sets on the Frost material.

**Tech stack:**
- Figma (file `x2fPubLkytfeO9btWSoTu6`)
- Figma MCP: `use_figma`, `get_screenshot`, `search_design_system`, `create_shader`, `upload_assets`
- Mobbin MCP: `search_screens`

**Spec:** `docs/superpowers/specs/2026-10-03-driver-ui-revamp-design.md` (logic inventory: `docs/superpowers/specs/driver-logic-map.md`)

## Global Constraints

- Driver side only. Logic unchanged: same screens, states, data and navigation (spec D5).
- Old Figma flows and components are not a design input (spec D7).
- Base kit: **iOS and iPadOS 27** library key `lk-3167e7e1386e96621fc3b20782e2ec1b199754eeceff2ef04bf90d28a124be6414b67982dc8fb71ea1896b0310c316f54d7b9f0ac598cb3111748728c039a567`.
- Frame size: iPhone 17 Pro, **402 × 874** pt.
- Light mode only; token structure must allow a Dark mode later.
- Glass = controls layer only. Frost = content cards. Text never sits directly on mesh; contrast ≥ 4.5:1 body, ≥ 3:1 large/bold.
- Every custom fill, stroke, radius and gap is bound to a variable. No raw hex in components.
- Touch targets ≥ 44 × 44 pt. Side margin 16 pt. 4 pt grid. Concentric corners (inner = outer − padding).
- Anything awaiting Hammad's choice is labelled `PROVISIONAL`. Every component starts as `Draft`.
- Leave the existing `📐 Cover` page untouched.

## Palette directions (Brand collection modes)

| Token | A · Volt Indigo (recommended) | B · Jade Monsoon | C · Sunset Ember |
|---|---|---|---|
| `brand/primary` | `#4A4DF0` | `#0B7A5E` | `#C9401C` |
| `brand/primaryPressed` | `#3A3CD6` | `#08664E` | `#AD3515` |
| `brand/onPrimary` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` |
| `brand/energy` (gauges, live) | `#2FDB9B` | `#1FD18A` | `#FFB020` |
| `brand/mesh1` | `#8EF0D0` | `#A8EED3` | `#FFC7A8` |
| `brand/mesh2` | `#A9B4FF` | `#FFE08A` | `#FFE3A3` |
| `brand/mesh3` | `#7FD4FF` | `#9BD6EE` | `#F7B5D0` |
| `brand/canvas` (page base) | `#F5F6FA` | `#F6F8F4` | `#FBF7F3` |
| `brand/tint` (selected fills) | `#ECEDFE` | `#E3F3EC` | `#FBE7E0` |

Contrast of white on primary: A 5.8:1 · B 5.3:1 · C 5.1:1 (all pass for body text).

Trade-offs:
- A doesn't clash with any status colour.
- B's primary sits close to the "Available" green.
- C's primary sits close to the "In use" orange.

---

### Task 1: Page scaffold + Logic Map

**Produces:** pages `🧭 Logic Map`, `🌱 Brand`, `🎨 Foundations`, `🖼 Style Frame`, `🧩 Components`, `📱 Driver Flows`.

- [ ] Create the six pages after `📐 Cover`, in that order.
- [ ] On `🧭 Logic Map`:
  - one section per flow (Shell, Discover, Book, Charge, Live session, Complete, Bookings, Messages, Profile, Onboarding)
  - per screen: a 240×160 grey card with screen name, Flutter class, data shown, actions → destination, and states as small tags
  - source: `driver-logic-map.md`
- [ ] **Verify:** `get_screenshot` of each section; every screen in `driver-logic-map.md` has a card (count them).

### Task 2: Brand — mark directions, wordmark, app icon

**Produces:** components `Brand/Mark`, `Brand/Wordmark`, `Brand/AppIcon` (layers: Background, Foreground).

- [ ] Draw 3 mark directions as vectors on a 24-pt grid, each shown at 128, 48 and 24 pt on light and on primary:
  - **(a) Plug-Bolt:** monoline plug glyph whose prongs form a bolt
  - **(b) P-Cable:** a "P" whose bowl is a cable loop ending in a plug
  - **(c) Spark:** a four-point energy spark with a rounded core
- [ ] Mark (a) as `PROVISIONAL — recommended`. Build the wordmark (mark + "PakPlug" in the display face) and the layered app icon (1024 frame: mesh background layer + white glyph foreground layer).
- [ ] **Verify:** screenshot. At 24 pt the mark still reads; the app icon foreground sits inside the 824-pt safe zone.

### Task 3: Foundations — variables, type, spacing

**Produces:** variable collections:
- `Brand`: modes A/B/C, tokens per the table above
- `Semantic` (Light mode): `bg/canvas`, `bg/surface`, `bg/frost`, `text/primary`, `text/secondary`, `text/tertiary`, `text/onPrimary`, `action/primary`, `action/primaryPressed`, `status/available`, `status/inUse`, `status/booked`, `status/offline`, `status/error`, `stroke/hairline`, `stroke/frostHighlight`, `energy`
- `Scale`: `space/1..12` (4-pt steps), `radius/xs 8 · sm 12 · md 16 · lg 22 · xl 28 · sheet 38 · pill 999`

Plus text styles and effect styles `Frost/Card` and `Frost/Elevated`.

- [ ] Load `figma-generate-library`. Create the collections; alias Semantic → Brand / kit-equivalent neutrals:
  - text primary `#000000`, secondary `#3C3C43` at 60%, tertiary `#3C3C43` at 30%
  - status: green `#34C759`, orange `#FF9500`, blue `#0088FF`, grey `#8E8E93`, red `#FF3B30`
- [ ] Check font availability (`figma.listAvailableFontsAsync`):
  - UI face: SF Pro, falling back to Inter if absent
  - display candidates: Geist, Sora, Bricolage Grotesque
- [ ] Create text styles mirroring iOS sizes: Large Title 34/41, Title1 28/34, Title2 22/28, Title3 20/25, Headline 17/22 semibold, Body 17/22, Callout 16/21, Subheadline 15/20, Footnote 13/18, Caption1 12/16, Caption2 11/13. Plus display styles `Display/XL 56/60`, `Display/L 40/44`, `Display/M 28/32` in the chosen display face (Geist PROVISIONAL).
- [ ] Build a Foundations board:
  - palette swatches for A/B/C side by side
  - type specimen
  - spacing and radius tokens
  - display-face candidates rendered as "Rs 1,250" and "68%"
- [ ] **Verify:** screenshot; a variable audit script reports 0 unbound fills on the Foundations board's tokenised swatches.

### Task 4: Mesh shaders + materials

**Produces:** shaders `Mesh/Hero`, `Mesh/Quiet`, `Mesh/Celebrate` (colours from `brand/mesh1..3` + `brand/canvas`); a materials board.

- [ ] Load `figma-shaders`; create the three mesh shaders:
  - Hero: three soft blobs, high saturation, top-weighted
  - Quiet: two blobs, low opacity
  - Celebrate: four blobs with energy accent
- [ ] Materials board: sample cards on each mesh, showing Surface, Frost (white 62% + background blur 30 + 1-px inner highlight + `Frost/Card` shadow) and Glass (kit material sample).
- [ ] **Verify:** screenshot. Compute contrast of `text/primary` and `text/secondary` on Frost over the brightest mesh pixel (≥ 4.5:1).

### Task 5: Style frame (disposable)

- [ ] On `🖼 Style Frame`: one 402×874 Driver Home mood test. It contains:
  - light map placeholder
  - kit search capsule and map buttons
  - filter chip row
  - one floating Frost station card
  - kit tab bar with bottom accessory showing a live charge
  - alongside it, a Charge-tab frame using Mesh/Hero + hero stat + grouped rows (the Nessie hierarchy)
- [ ] Label it `PROVISIONAL — mood test, not a deliverable`.
- [ ] **Verify:** screenshot; send it to Hammad.

### Tasks 6–16: Components (one task each, in spec §5.2 order)

Each component task follows spec §5.3:
1. Mobbin `search_screens` (2–3 queries), with a `Refs` frame of 3–6 images and links.
2. A UX notes frame covering:
   - purpose
   - anatomy
   - states
   - interaction and motion
   - accessibility
   - SF → Material icon mapping
   - native API for Rayan
3. A component set with every state variant, bound to Semantic/Scale variables.
4. **Verify:** screenshot + variable audit (0 raw fills) + target-size check; label it `Draft`; send it to Hammad.

| Task | Component | States / variants |
|------|-----------|-------------------|
| 6 | Tab bar + bottom accessory | 5 tabs × selected; Messages badge; accessory: none / charging (kWh, %, time) / connecting |
| 7 | Search capsule + filter chips | idle / focused / with query; chip default / selected / with count |
| 8 | Map pins + clusters + map buttons | available / in use / offline / selected / favourite; cluster 2–99+; locate, layers |
| 9 | Station card | default / selected / loading; with/without photo |
| 10 | Buttons + slide-to-start | primary / secondary / tertiary / destructive × default / pressed / disabled / loading; slide idle / dragging / done |
| 11 | Grouped list rows | title / subtitle / value / chevron / toggle / destructive; first / middle / last |
| 12 | Status pills | Available / In use / Booked / Offline / Completed / Cancelled / Expired |
| 13 | Hero stat + charging gauge | stat with caption / delta; gauge 0–100 / charging / complete |
| 14 | Sheets + dialogs | content shell medium / large; confirm; destructive |
| 15 | Inputs | default / focused / filled / error / disabled |
| 16 | Empty / loading / error | per-screen illustration slot + copy + action |

### Tasks 17–26: Flows (spec §6), one per flow, only from approved components

Discover · Station · Book · Charge · Live session · Complete · Bookings · Messages · Profile · Onboarding.
Each flow's states are checked against `driver-logic-map.md` line by line.

---

## Tonight's scope (overnight run, 2026-10-03)

Tasks 1–5, then components in order for as long as quality holds. Stop and leave a summary rather than rushing.
