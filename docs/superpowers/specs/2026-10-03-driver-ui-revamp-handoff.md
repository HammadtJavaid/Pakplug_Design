# Driver UI Revamp — Handoff (updated 2026-10-04, cloud session)

Start here when you pick the work up in a new session, local or cloud.

## Latest (2026-10-04)

**Decided by Hammad:** type **A · SF Pro, lighter**; the **emerald mesh is approved**; the P is the signature P from the App Icon, with a **Mesh** variant (emerald mesh fill, transparent background) wherever the P sits on a light surface.

**Done this session** (details in the progress log, IDs in the ledger):
1. Type A applied: Display styles are SF Pro Light via `font/display` + `font/displayStyle`; titles and emphasis are Medium; docs and boards updated.
2. Mesh tokenised: 9 brand + 9 semantic `mesh/*` variables, bound to the Hero, Celebrate and Quiet shaders; alt modes derived.
3. Contrast on the Hero mesh measured and fixed: new `text/onMesh`; Frost Strong for cards and chrome; rule card on Materials · on Mesh Hero.
4. C10 Text Field (5 states) and C11 State View (Empty, Loading, Error), each with UX notes and real-copy examples.
5. List Row separator follows the text (58 with icon, 16 without).
6. Flow A · Home (map) on Driver Flows, built from components only, with a logic-check card.
7. `Brand / Mark / PakPlug P` is a set: Solid and Mesh. Mesh is in the Search Field, style frame, explorations and Emerald wordmark.

**Waiting on Hammad**
1. Wordmark: it still uses Sora letterforms. Keep it as brand art, or redraw it to sit with SF Pro?
2. Hero text colour: over the mint glow only black text passes (white is 2.2:1). For all-white text on the Hero, the glow has to move or dim, which changes the approved mesh.
3. Add the "iOS and iPadOS 27" library to the file (H4). The API can't do it.

**Next steps, in order**
1. Home states beside Home · Map: session active (charging pill, controls raised), list view, loading, empty, error, location off.
2. A2 Station place sheet → A3 Book in sheet → Bookings (passes) → Pass detail, each checked against `driver-logic-map.md`.
3. Later: Charge → Live session → Complete → Messages → Profile → Onboarding.

The sections below are the 2026-10-03 handoff, kept for history.

## Where everything lives

- **Figma** (all design work, saved in the cloud): [PakPlug Design System](https://www.figma.com/design/x2fPubLkytfeO9btWSoTu6/PakPlug-Design-System). The v4 pages come after the `——— v4 · Driver Revamp ———` divider:

  | Page | ID |
  |---|---|
  | Logic Map (empty) | `946:3` |
  | Brand | `946:4` |
  | Foundations | `946:5` |
  | Style Frame | `946:6` |
  | Components | `946:7` |
  | Driver Flows (Flow A · Home) | `946:8` |
  | Explorations | `995:2` |

- **Branch:** `claude/ui-redesign-components-0ab459`
- **Docs in this folder:**
  - [`2026-10-03-driver-ui-revamp-design.md`](2026-10-03-driver-ui-revamp-design.md): spec, decisions D1–D9
  - [`driver-logic-map.md`](driver-logic-map.md): every driver screen, state and piece of copy. The source of truth for flows.
  - [`2026-10-03-driver-ui-revamp-progress.md`](2026-10-03-driver-ui-revamp-progress.md): what's done, flags for Rayan
  - [`figma-ledger-v4.json`](figma-ledger-v4.json): **every Figma ID**: pages, variables, text and effect styles, components, the shader property keys and the current mesh values
  - [`../plans/2026-10-03-driver-ui-revamp.md`](../plans/2026-10-03-driver-ui-revamp.md): the original plan. Its palette table is outdated; emerald won.
  - [`../tools/sf-symbols/`](../tools/sf-symbols/README.md): exports real SF Symbols to Figma. Needs macOS, so it can't run in a Linux cloud session.

## State at the end of 2026-10-03

1. **Foundations are done.**
   - Variables: `v4 · Brand` (4 modes, Emerald is the default), `v4 · Primitives`, `v4 · Semantic`, `v4 · Scale`.
   - 20 text styles, 6 effect styles, and the "PakPlug Mesh" shader.
2. **Mesh retuned today**, after Hammad's feedback. He wanted deep emerald, one continuous flow, a calm lower half, and an accent in either yellow or teal-blue.
   - **Hero** `951:7416`: deep emerald diagonal with a mint glow top-left and a quiet teal-blue bottom-right.
   - **Quiet** `951:7417`: light, one soft emerald family over the canvas, for list screens.
   - **Celebrate** `951:7418`: the emerald family with an energy-green glow.
   - Exact values are in the ledger under `meshValues`.
   - **The colours are raw values, not tokens.** Hammad edited them directly. Tokenise them once he approves (next steps, item 2).
   - Yellow was tried and turns olive wherever it fades into deep green, so teal-blue is the accent.
3. **Icons:** 63 real SF Symbols (Medium) in the Icons section `958:2`.
   - Every inner vector is named `Symbol`, so colour overrides survive icon swaps.
   - Connector Row has a Plug swap: Type 2, CCS2 or GB/T.
4. **Components:** C1–C9 and C12 are built, each with UX notes and Mobbin refs. See the progress log for the list and the ledger for IDs.
   - C9 finished today: Choose vehicle sheet `1014:509`, Alert set `1014:577`.
5. **Explorations:** A–D are on `995:2`. Hammad chose **A · Maps-native discovery** and **B · Charging Pass bookings** for the flows.
6. **Type options board** `1044:2` on Foundations. **Waiting for Hammad's pick.** He hates the current fonts and wants lighter, better-looking ones.

   | Column | Fonts | Node |
   |---|---|---|
   | Now | Sora SemiBold numbers + SF Pro Semibold titles | `1044:6` |
   | A | SF Pro, lighter | `1044:32` |
   | B | Manrope | `1044:58` |
   | C | Plus Jakarta Sans (my recommendation) | `1044:84` |
   | D | Instrument Serif numbers + Instrument Sans | `1044:110` |

   Every option uses Light numbers, Medium titles and Regular body text, with no Bold or Semibold.

## Waiting on Hammad (2026-10-03; items 1 and 2 are done)

1. **Font pick:** A, B, C or D.
2. **Approve the new mesh**, or adjust it directly in Figma. He likes the look of the "Materials / on Mesh Hero" board (`954:3`).
3. **Add the "iOS and iPadOS 27" library to the file** (H4). The API can't do it.

## Next steps as of 2026-10-03 (items 1–5 and 8 are done)

1. **Apply the chosen font.**
   - Update the `font/display` and `font/displayStyle` variables in `v4 · Scale`. A UI-font variable exists as `font/ui`.
   - Update the 20 text styles to the lighter weights: titles Medium, numbers Light.
   - Run a visual QA pass on every component for text overflow: tab labels, pills, buttons, Station Card, Charging Pass.
   - Options B, C and D are OFL fonts that ship in the Flutter app on both platforms. Option A is native on iOS and needs a fallback on Android.
2. **Tokenise the mesh.**
   - Add Brand variables, for example `brand/meshDeep`, `meshGlow`, `meshMid`, `meshBridge`, `meshAccent`, with values for all 4 modes, plus semantic aliases.
   - Bind them to the Hero and Celebrate shader colours. Bind Quiet to its own light set.
   - Today's values are in the ledger.
3. **Fix card contrast on the deep emerald.**
   - Frost (white at 68%) over the deep areas drops secondary text below 4.5:1.
   - Use Frost Strong (white at 86%) or Surface for cards with small grey text on Hero. Update the Station Card and grouped-row usage when building flows.
4. **C10 inputs:** default, focused, filled, error, disabled.
5. **C11 states:** empty, loading, error.
6. **Flows A + B** on page `946:8`, one at a time, checking every state against `driver-logic-map.md`: Discover → Station → Book → Bookings (passes) → Pass detail.
7. **Later:** Charge → Live session → Complete (C's live surfaces, D's celebration) → Messages → Profile → Onboarding.
8. **Small known fix:** the List Row separator inset stays at 58 when the icon is hidden.

## Figma API gotchas learned here (save yourself the debugging)

- **One page per call:** switch to one page per `use_figma` call, never run `use_figma` calls in parallel, and return every created ID.
- **Text style IDs end with a comma** (`S:…,`). Use them exactly as stored in the ledger.
- **Descriptions:** write them with `descriptionMarkdown`. Setting `description` HTML-escapes quotes, and repeated read-and-write compounds the escaping into `&amp;quot;`.
- **Shader properties are keyed by hashed IDs**, not names. The map is in the ledger (`shader.propertyKeys`). `figma.listAvailableShaders()` returns the names.
  - Colours are `{r,g,b,a}`, points are `{x,y}` in %, and values can be variable aliases.
  - To change one, copy the SHADER paint, replace `properties`, and reassign `fills`.
- **Swap properties drop master colours:** setting an INSTANCE_SWAP property drops colour overrides that were set in the master on the nested icon. Re-apply the colour on the instance; once set there, it survives further swaps.
- **New vectors start with a 1px stroke and no fill.** Give them a fill and no stroke before boolean operations, or `flatten` outlines the stroke.
- **Changing an icon's shape:** set `vectorPaths` on the existing vector. Replacing the node loses instance overrides.
- **Image uploads:** use PNG via `upload_assets`. WebP renders blank.
- **Binding paints:** use `resolveForConsumer` and then `setBoundVariableForPaint`.
- **Bound paint opacity:** binding a variable resets paint opacity, so use layer opacity.

## Flags for Rayan

See the progress log, section "Flags for Rayan". Key items:
- the native iOS shell spike (glass tab bar + bottom accessory)
- SF Symbols inside Flutter content on iOS, with Material Symbols on Android
- custom SVGs for the three EV plugs on Android
- copy fixes and data quirks
- the iOS app still ships the Flutter placeholder icon

## Resume prompt for a new session

> Continue the PakPlug driver UI revamp. Read `docs/superpowers/specs/2026-10-03-driver-ui-revamp-handoff.md` first, then the progress log and `figma-ledger-v4.json`. Figma file `x2fPubLkytfeO9btWSoTu6`. Load the figma-use and figma-generate-library skills before any `use_figma` call. Hammad works on design and product only; route code changes to Rayan.
