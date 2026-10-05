# Open items collected from merge agents (for the coordinator + Hammad/Rayan)

## From D1 (6C docs, done ~02:5xZ)
- 6C cards: Refs LS 1348:37328, Refs DI 1348:37410, Micro LS 1348:37480, Micro DI 1348:37589. 6C now 4852×2650 at y 8420; 6D→11230, 6E→15964.
- Fixed values in 06.23, 06.25, 06.26, 06.24 push copy, 06.28c, 06.28d; notes; Logic 1302:4354 (P2 "No Stop on OS surfaces", P4 VoiceOver copy, items 3–4 for Rayan/Hammad).
- Gaps (spec states missing in base 6C): notifications-only frames when Live Activities are off (spec 06.27 LA off, 06.28 ≈80% DC, 06.28b plan done); Live Activity "Unknown battery".
- Base decisions differing from spec (kept, flagged): stale after 3 min (spec 5); activity kept 4 h (spec P32 30 min).
- Could not: 06.25 progress fill (instance resize) stays 53% vs true 55%.
- Handed to D2: island status-bar 9:41 clipped; 06.28b minimal island position; iOS / Lock Screen master shows status-bar time.

## From E1 (Flow 1 review, done ~02:5xZ)
- No frames added; 46 frames present. Fixes: eyebrows → v4/Caption 1 Emphasized; kWh suffix Inter → v4/Body (instances only); status bar above dim in 01.10/01.38/01.40; 01.12 return key "go"; non-breaking spaces; straight apostrophes in 01.09/01.41/01.42; Logic 1A styling; Review blocks 1348:37688/37691/37694/37697; sections refit (1A 0, 1B 4714, 1C 9710, 1D 13972).
- File-wide/system decisions (coordinator or Hammad):
  1. Text Field component 1070:590: suffix renders in Inter; Disabled state keeps suffix/helper at text/secondary while value dims. → fix the master at the end (safe once agents finish).
  2. Apostrophes: Flow 1 + logic map straight; Flow 5 curly almost everywhere. Pick one convention file-wide.
  3. Eyebrow letter spacing +6% (spec) needs a new caps text style (proposed in 1C card).
  4. Switch "on" uses status/available (system green), not emerald. System-level choice.

## From A1 (merge 4B, done)
- 4B 1301:4986 now 12 frames (04.12–04.21 + 04.17b 1348:36701, 04.17c 1324:7711; 04.20 1322:55207, 04.21 1323:7351 moved). 5452×2868 at y 4322 (600 wider than siblings: Refs overflow to x 3612, Micro at 4212/4812). 4C→7350, 4D→12964, 4E→14774.
- Cards: Refs 1326:8423/8459/8481 + 1348:37700 (Rs⇄$); Micro 1326:16473/16502/16525/16539 + 1348:37765 (Rs⇄$). Alt Logic 1326:16585 merged into base Logic 1301:6930 (~1770 tall); proposal tags renamed 04-Pn.
- Base fixes: Inter in List Group Header trailing labels (04.16–04.19); Directions sheet 1301:6478 Cancel/subtitle; 04.14 empty glyph → star; misnamed layers; notes hug; Logic COVERED title.
- Left on Alternates (equal to base or rebuilt): 1323:7416, 1324:7523, 1324:56564, 1324:57910, 1324:57997, 1324:58097, 1324:7617, Logic 1326:16585, alt labels/notes.
- For Hammad: (a) toggle placement — base puts Rs⇄$ under the place-sheet stats with no "Converted at Rs 280 = $1 (dummy rate)" line; first-session spec allowed the switch only on Estimate / Price Trends / Complete cards; kept base. (b) 04.19 note promises "Charged in Rs" on Confirm 04.41 but 04.41 is rupees-only: missing $ Confirm state. (c) spec proposals 04-P31 "More" truncation, 04-P32 glyph avatar for "Driver" reviews not drawn (base follows logic map).
- Possible tidy: Sheet / Directions master 1012:569 bottom padding + subtitle wrap (fixed on instances only).

## From B1 (merge 8E, done)
- 8E 1297:4495 now 12 frames: + 08.09b 1348:29762, 08.62 1348:36399 (alert 1348:36473 rewritten for the base model), 08.63 1348:36485 ("Finish charging to change your region."), 08.14b 1348:29845. 5452×3026 at y 19722; 8F → y 22908.
- Cards moved + renumbered (43 lines rewritten to the base design): Refs 1325:7831/7869/7915, Micro 1326:16323/16381/16433, Keyframes 1324:15204 (now documents 08.12). 6 refs added from spec lists. Alt Logic 1326:16562 merged into base Logic 1297:6128 (P8, P11 [spec wants native alert for Delete Account; base uses a sheet], P12–P14, P26, P28, P32, P35, US-P6, US-P15; Rayan items 4–7).
- Base fixes: Phone row hotline 0311 6677098 → driver 0301 2345678 in 08.09/08.12/08.13/08.14 + Logic DUMMY DATA; removed chevron on display-only Phone rows (agent's own call); 08.11 toast bottom 824 → 828.
- Alt frames equal to base: 1322:6600=08.09, 1323:55711=08.15, 1323:55893=08.16, 1323:55965=08.12, 1324:15221=08.10, 1324:56886=08.11, 1324:57364=08.13, 1324:57550=08.14 (left on Alternates).
- MOBBIN SEARCH UNAVAILABLE: workspace out of AI credits → refs come from spec lists. Tell Hammad.

## From C1 (canon US dataset, done ~03:00Z)
- specs/10-us-canon.md written; c1/canon_math.py; BRIEF pointer line appended.
- Canon: Emily Carter (no phone drawn; assigned (765) 555-0142); Bolt EUV J1772+CCS1 65 kWh IN 482 BKR (primary); Tesla Model 3 NACS 75 kWh IN 731 PUR (fits no station). Stations: Boilermaker · State St (J1772 7.4 kW $0.32 4.8 0.7 mi Available, host Jake), Wabash Landing Garage (CCS1 60 kW $0.52 4.6 2.1 mi In use), Chauncey Hill Home Charger (J1772 11 kW $0.29 4.9 3.2 mi, host Marcus Lee), Research Park DC Hub (CCS1 30 kW $0.42 4.4 4.8 mi Offline, host Olivia Brooks). Story Sat Oct 4 6–7 PM 6.8 kWh +10% ≈30% $2.18; live 6:32 28:00 left 3.6 kWh ≈26% $1.16.
- Base price level = PK price × 0.32/42 (a price level, not FX); display conversion Rs 280 = $1.
- Fixed in base: 10.03 query dha→state st + Levee leaks → State St places; 10.05 review text; dates TODAY · SAT, OCT 4; 10.10/10.11/10.12 ≈31%→≈30%, +11%→+10%; 10.11 overline GREENVOLT · Levee PHASE 5 → BOILERMAKER · STATE ST; 10.13/10.14 P-C Tesla CCS1 → Bolt, $14.30→$14.35; hidden Lahore address + CNIC → US; unused instance props; 76 layer names.
- Left for C4: "Chevrolet Bolt EUV" truncation (10.07/10.08 vehicle row, 10.13/10.14 pass footer); 10.10 plan bar + 10.11 gauge geometry still 31% (2–3pt); 10.05 anonymous reviewer initial "D" not glyph; 10.12 clock 9:41 at 7 PM finish (PK 06.30 same — fix both or neither).
- File-wide: Oct 4 2026 is actually a SUNDAY; every flow says Saturday (left as is) → ask Hammad.
- Flow 11 · Host · US (page 1346:2) was created by the OTHER session (session_01LLwa7…, ~01:xx–02:11Z, host UI 11 screens, PR #2 design log updated). Not in our plan; don't touch. C1 noticed: its "today" is Sun Oct 5 (vs Sat Oct 4 everywhere else) and it shows Marcus Lee as a Tesla driver while Flow 10 has him as a host.

## From E2 (Flow 3 review, done ~03:10Z)
- 24 frames present (03.01–03.24); no frames added. Fixes: RECENT "Clear" Inter → v4/Footnote Emphasized (instances); non-breaking spaces 03.10, 03.11; 3A notes → Footnote/text-secondary; 3B FLAG + S19/S20; 3B status range; Review blocks 1349:44906 / 1349:44909; refit 3A y0 (4410×6062), 3B y6222 (4410×3960). No Inter left on page (1,395 texts).
- Apostrophes: Flow 3 UI copy curly ’ (Flow 1 straight, Flow 5 curly) → file-wide decision.
- COMPONENT MASTER FIXES for coordinator (after all lanes):
  a. List Group Header / Trailing 1131:2783 → label renders Inter.
  b. Text Field 1070:590 → suffix renders Inter; Disabled state suffix/helper colour.
  c. Sheet / Filter & sort 1012:432 → fill bg/canvas vs §1.2 bg/surface (02.12, 03.17/03.18 inherit; decide + keep consistent); invented subtitle; bottom padding 34 → 50.
  d. Sheet / Directions 1012:569 → bottom padding 34 → 50, subtitle wrap (A1 fixed instances only).
  e. iOS / Lock Screen master → status-bar time next to big clock (D2 may have fixed it).
- Other: Flow 2 02.12 status bar sits under the scrim (outside lanes; fix in coordinator pass); scaled 0.96 motion stills have unstyled text (can't keep styles; accept); chip-row 24pt right-edge fade (spec 03 §2.0 A) not drawn anywhere (left out, matches Flow 2).

## From A2 (4D docs, done ~03:20Z)
- Cards: Refs 1351:34956 (04.35), 1351:35030 (04.36–04.40); Micro 1351:35104, 1351:35163. Logic 1301:8616 additions (P3–P5, Rayan items 2–4). 4D 5452×1986 at y 12964; 4E → 15110.
- Fixed: 18 Inter labels in 4D; 04.35 Sheet / Choose vehicle 1301:7131 bottom padding 34→50 (instance).
- Gaps (spec states base 4D lacks): picker Empty (spec 04.36), picker Couldn't load (04.37), picker Loading (04.52), Book a slot · Pricing unavailable (04.40).
- For Rayan (in Logic): logic table shows enabled "Add a vehicle" footer when no vehicle fits vs base keeps Confirm disabled; 04.39 keeps Confirm enabled while loading (spec disabled); when does "Choose your vehicle" show (04.38) given auto-pick?
- Handed to A3: 04.40 wrong component; 04.35 master defaults; 0.96 recede; status bar under scrim; Logic inaccuracies; stale cross-refs (4A note 1218:2021; Flow 5B link card 1169:19707, exception granted for that node).

## From B2 (merge 8F, done ~03:25Z)
- 8F 1297:6148 now 8 frames (+ 08.22c 1349:44932 cloned from 08.22, toast "Logout failed: Couldn't reach PakPlug." bottom 776 on root tab). 5452×2618 at y 22908.
- Cards moved + renumbered (29 texts) + 29 lines rewritten to base design: Refs 1338:9134 (+Opal/Oura/Noom), 1338:9164, 1338:9198 (+ElevenLabs/Alta/Fiverr); Micro 1339:14043, 1339:14107. Alt Logic 1339:14141 merged into base 1297:6798 (+DESIGN CALLS 1351:35222; P11 sheet vs native alert; P22, P7, P32).
- Base fixes: 08.20 alert now Cancel Logout | Retry; 08.19 accessory → Stopping state; 08.21 success well check mark + cleared placeholder props; 08.22b toast moved off the Log in button (bottom 700); status bar above dim in 08.17–08.22; 08.17 note → 08.22c.
- Alt frames equal to base: 1334:7831=08.17 (alt native alert), 1334:7911=08.18, 1335:8203=08.19, 1335:8311=08.20, 1335:8414=08.21, 1335:8514=08.22, 1335:13565=08.22b; 1335:13491 rebuilt as 08.22c. Alt labels/notes + Logic 1339:14141 remain on Alternates.
- DECISION FOR HAMMAD (P11): Sign out confirm (08.17) + Delete account (08.13) — sheet (logic map DestructiveConfirmSheet, base) vs native alert (spec 08 §2.1, design spec §4.1-5, 00-system §1.3).
- Icon gap: rectangle.portrait.and.arrow.right missing from icon set (08.17 uses info.circle).
- Toast rule refined: 828 on pushed screens with nothing pinned; 12 above tab bar (776) on root tabs; 12 above pinned buttons.

## From D2 (Flow 6 review, done ~03:35Z)
- 56 frames + 06.49 board checked; no frames added. Fixes: 48 Stat Tiles ghosted by leftover Frost/Card effects (6A/6B) cleared; 6D status-bar times → story times; 06.31 top scroll-edge fade (88pt + 12pt blur); 06.32 bottom fade opaque; 6E counters Inter → v4/Caption 1; 06.42 error stars on the visible sheet; 6C island status-bar times, compact island 210 wide at (96,11), 06.28b minimal detached right + other app's activity left (1351:63907/63908); 6C Logic renamed + item 5.
- iOS / Lock Screen master 1114:1657: status-bar Time hidden → inherited by 06.22–06.26, Components examples, 10.15 (1304:707) and 11.03 (1346:792, other session's Flow 11 page — harmless improvement, mention).
- Gaps 6C: LA-off notification stack (spec 06.27), ≈80% DC notification (spec 06.28), plan-done notification (spec 06.28b); Live Activity "Unknown battery"; spec wanted Map behind island frames (base uses neutral other-app placeholder).
- Open: compact island "28:00" at Display/S 22 too wide → propose ~17pt Light digits (C24, component); 06.24 push + LA together vs spec P17; input stars amber vs display stars emerald (C22); "Add your battery now" chip down chevron (component).

## From C2 (merge 10A, done ~03:26Z)
- 10A 1304:2 now 14 frames: 10.01–10.06 + 10.21 1351:63910 · 10.22 1351:64164 · 10.23 1351:64423 · 10.24 1351:64796 · 10.25 1351:65018 · 10.26 1351:65417 · 10.27 1351:66060 (all clones of base 10.01/10.03/10.04 with the alternate's state layers copied in) · 10.28 1336:4817 (alt board MOVED). Section 4852×5224 at (0,0); 10B → y 5384, 10C → y 7194.
- Cards in 10A: Logic 1304:195 (alt Logic 1339:4957 merged, left on Alternates) · Refs 1333:3642, 1335:13741, 1339:4885 (moved) + NEW 1351:67403 (Reviews) · Micro 1333:3666, 1335:13765, 1339:4905 (moved) + NEW 1351:67463 (Reviews).
- For the coordinator: alt frames equal to base frames 1331:2944 = 10.01, 1331:3221 = 10.02, 1331:3613 = 10.06, 1335:13128 = 10.03, 1336:4454 = 10.04; recreated in the base (alt left on Alternates) 1331:3080 → 10.21, 1331:3353 → 10.22, 1335:12662 → 10.23, 1335:12910 → 10.24, 1335:13346 → 10.25, 1336:4293 → 10.26, 1336:4654 → 10.27; the alt labels/notes/title/status (incl. 1336:5046/5047 of the moved board) stay on Alternates.
- Base defect fixed: 10.04 List Group Header trailing labels ("1", "See all") Inter Regular → Footnote / Footnote Emph.
- For Hammad / C4: (1) NACS gap: no canon station offers NACS, so the NACS chip, the "tesla"/"nacs" keywords and the Tesla Model 3 lead nowhere (flagged in the Logic check; a NACS host is a proposal). (2) 10.21 split-cluster pins are new [assigned] prices on the canon price level ($0.34/$0.46/$0.36/$0.30/$0.38/$0.31 from Rs 44/60/47/39/50/41). (3) 10.27 assigns S2's address (Brown St), host Ryan Miller and 21 reviews from the canon [assigned] values. (4) Still open from C1 (untouched): Bolt EUV truncations 10.07/10.08/10.13/10.14, 10.05 "Driver" initial, 10.12 clock 9:41.

## From E3 (Flow 7 review, done ~03:30Z)
- 40/40 spec frames present (07.01–07.40); no frames added. Sections refit: 7A y 0 4568×4906, 7B y 5066 4410×3568, 7C y 8794 3446×6136, 7D y 15090 4252×3640 (160 gaps). Review blocks: 1352:25837 (7A), 1352:25840 (7B), 1352:25843 (7C), 1352:25846 (7D).
- Fixed: 07.32 Alert Message lead Inter → v4/Footnote Emphasized (instance); in-app banner "PAKPLUG" unstyled → v4/Caption 1 Emphasized (07.05, 07.09); 38 pass-detail group headers (caps via textCase UPPER, style lost) → literal caps + v4/Footnote Emphasized; 94 hidden "See all" trailing labels Inter → Footnote Emph (no Inter left on page 1089:8871); 07.23 charger code → v4/Display/S (+6% tracking dropped); status bar above the last scrim in every sheet/alert frame (07.21–07.39); 07.20 scrolled list → Tab Bar / Minimized 1351:67447 (Bookings circle, accessory hidden) + toast bottom 788; NBSPs in 07.05, 07.26, 07.35, 07.36 and the estimate footnote ×14; status-line ranges.
- Apostrophes on Flow 7: curly ’ everywhere except the 07.32 alert's real-copy "can't" (straight, from the logic map).
- COMPONENT MASTER FIXES for coordinator: (a) Alert 1014:561 "Message lead" 1134:2826 renders Inter (also flagged by 8E); (b) Notification Preview In-app banner "App name" 1111:1779 has no text style (Medium 12, +4% tracking → v4/Caption 1 Emphasized); (c) List Group Header / Trailing 1131:2783 Inter (as E1/E2); (d) Sheet / Directions 1012:569 fill bg/canvas vs §1.2 bg/surface (07.31; also 04.16) — already in the 7C Logic "For Rayan" item 3; (e) Text Field Code master keeps an unstyled Display/S + 8% code; 07.23 now uses plain Display/S — a tracked "Display/S Code" text style would unify 05.13–05.17, 07.23 and the Wallet pass.
- Cross-flow: 00-system §1.4 minimizes the tab bar on scrolled root lists (02.19, now 07.20); 08.02 Profile · Scrolled (Flow 8A) still shows the full tab bar — B3 / coordinator to align.
- Kept on purpose: 07.39 toast at 828 (nothing pinned; keeps the new View in Wallet row visible) leaves an 8pt sliver of the scrolled Cancel booking button above it; 07.35 toast 760 sits above the just-tapped Cancel button (spec); scaled stills (07.09 motion strip, 07.29 keyframe, receded sheets 07.30/07.31/07.37/07.38) carry no text styles.

## From C2 (merge 10A, done ~03:40Z)
- 10A 1304:2 now 14 frames (10.01–10.06 + 10.21 1351:63910, 10.22 1351:64164, 10.23 1351:64423, 10.24 1351:64796, 10.25 1351:65018, 10.26 1351:65417, 10.27 1351:66060 (Wabash Landing Garage in use), 10.28 1336:4817 moved). 4852×5224 at (0,0); 10B → 5384; 10C → 7194.
- Cards: Logic 1304:195 merged (+NEW COPY (US, flagged) 1352:18397; FLAG US-P4/P5/P7/P8/P15 + NACS gap; Rayan items 4–9; price-level wording fixed). Refs moved 1333:3642, 1335:13741, 1339:4885 (+refs); new Refs Reviews US 1351:67403; Micro moved 1333:3666, 1335:13765, 1339:4905; new Micro Reviews US 1351:67463.
- Base fix: 10.04 List Group Header trailing labels Inter → Footnote/Footnote Emph.
- Alt equal to base: 1331:2944=10.01, 1331:3221=10.02, 1331:3613=10.06, 1335:13128=10.03, 1336:4454=10.04; rebuilt (originals left): 1331:3080, 1331:3353, 1335:12662, 1335:12910, 1335:13346, 1336:4293, 1336:4654. Alt Logic 1339:4957, labels/notes/title/status remain.
- FOR HAMMAD: NACS gap — no canon station offers NACS, so the NACS chip, "tesla" keyword and the Tesla Model 3 lead nowhere (add a NACS station, e.g. a Tesla Supercharger-style host, or accept).

## From E3 (Flow 7 review, done ~03:50Z)
- 40 frames present (07.01–07.40), none added. Fixes: 07.32 alert lead Inter → Footnote Emph; 07.05/07.09 banner app name styled; 38 group headers literal caps + Footnote Emph; 94 hidden "See all" Inter → Footnote Emph; 07.23 charger code → Display/S; status bar layer order (07.21–07.39); 07.20 → Tab Bar / Minimized 1351:67447 at (20,800) per §1.4; non-breaking spaces; status lines; Review blocks 1352:25837/40/43/46; refit 7A 0, 7B 5066, 7C 8794, 7D 15090.
- Apostrophes: Flow 7 curly ’ (one straight "can't" real copy in 07.32).
- Component masters for coordinator: Alert "Message lead" 1134:2826 Inter; banner master "App name" 1111:1779 no text style; List Group Header / Trailing 1131:2783 Inter; Sheet / Directions 1012:569 bg/canvas (shows on 07.31).
- Proposal: a tracked "Display/S Code" text style for the charger code (05 Text Field Code uses +8% tracking, 07.23 now Display/S).
- 08.02 full tab bar while scrolled → sent to B3 (minimized per §1.4).

## Alternates page DELETED ~03:50Z after verifying: only base-equal / rebuilt frames, merged Logic cards (1326:16585, 1326:16562, 1339:14141, 1339:4957), alt labels/notes and the header remained.

## From B3 (Flow 8 review, lean, done ~04:10Z)
- Fixed: 8E status bar above scrim (08.12/08.13/08.14/08.62); 08.02 → Tab Bar / Minimized 1353:11535 at (20,800) + note/micro.
- Open → F1-lite: status bar under scrim 08.06/08.07/08.08/08.32; kWh suffix Inter 08.41/43/44/46/48 (Text Field master fix covers).
- Open, minor (report only): 08.28 lacks Region & currency group vs 08.09; single-word last lines 08.06/08.37/08.53–08.55, "MG ZS EV" split 08.32; 08.38 hand-drawn spinner; 08.13 info.circle vs trash; 5 stale doc refs (build-log); 8E gaps: skeleton loading, no-user-data, charging-complete coming-soon copy, Delete Account native alert w/ email (P11/P14).

## From A3 (Flow 4 review, done ~04:15Z)
- Fixed: 04.40 → selected VEHICLE row (MG ZS EV · Type 2 (AC), Change); 04.35 sheet white, Neutral pill, car.fill, 60.5 kWh, Nissan Leaf, Book recede 0.96 (1352:63764), scrim token, status bar above scrims; 04.16/04.17c same recede/scrim/status-bar fix, Directions sheet white; 04.17/04.17b toasts 828; 04.15 Retry Primary; 100 Inter labels; 22 eyebrows; 04.03 reviewers; 4D Logic P1/REAL COPY; stale refs (4A note, 4 refs in 4A/4C, 5B link card 1169:19707); review blocks; refit.
- Gaps 4D: picker Empty / Couldn't load / Loading; Book a slot · Pricing unavailable. 4B: none.
- Open → F1-lite: Confirm (Sheet / Confirm booking), Directions, Choose vehicle masters still canvas fill (04.41/04.42 copies too). 05.22 rows group white on white (Flow 5).

## From D3 (9A–9D docs, done ~04:20Z)
- Cards: 9A Refs 1353:59884/59926, Micro 1353:59960/60004; 9B Refs 1354:1676, Micro 1354:1722; 9C Refs 1354:1777, Micro 1354:1815; 9D Refs 1354:1860, Micro 1354:1898. Logic checks: Spec→base + Gaps blocks.
- Fixed: status bar above scrim 09.14/09.17/09.18/09.19/09.20; "amber edge" text → green.
- Sections: 9A 0, 9B 2648, 9C 5326, 9D 7684.
- Gaps: 9A spec 09.03, 09.04, 09.09, 09.10; 9B 09.13b, 09.15b, 09.16, 09.18, 09.19b, 09.20, typing w/ keyboard; 9C 09.24 + unlock diagram; 9D 09.28 zero bookings, 09.29, 09.32.
- → F1-lite (cheap): 09.05 badge "2" on empty inbox; 09.19 info glyph → phone; Bilal's number differs from 04.17/07.30 (use one); status bar 7:05 (check story time); captions in 09.15/09.21 below y 824. Car glyphs on empty states (report only).
