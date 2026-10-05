# PakPlug · Merge to standard (2026-10-05)

Hammad's decision (verbatim option he picked): "Keep the flow-page sections and their screen numbers. Add the extra states from my copies, add Mobbin-refs and micro-interaction cards where missing, run the screen-by-screen reviews, then delete the Alternates page."

Background: on 4 Oct a second Claude session built 4B, 4D, 6C, 8E, 8F, 9A–9D and Flow 10 on the flow pages (the BASE sections). The first session later built fuller versions of 4B, 8E, 8F and US 10A; those are parked on page "v4 · 🗂 Alternates · second build (2026-10-05)" (id 1342:9134) as the ALTERNATE sections. None of the base sections has Refs · Mobbin or Micro-interactions cards.

Figma file key: x2fPubLkytfeO9btWSoTu6. Scratchpad (SP): /tmp/claude-0/-home-user-Pakplug-Design/2ac01624-1917-5f7f-8c6e-0acefbdecad4/scratchpad
Shared references: SP/brief/BRIEF.md (tokens, text styles, components, screen template, dummy data), SP/brief/NEW-COMPONENTS.md (component registry), SP/specs/00-system.md (system rules; §4 section plan), the flow specs SP/specs/01…10-*.md (each lists Mobbin refs with URLs and micro-interactions per screen), SP/build-log.md.

## Ground rules (every agent)
1. BASE = the section on the flow page. Never renumber, rename or delete a base frame. Change base copy/layers only to fix a defect, and list every such fix in your result.
2. Data + copy source of truth = the base frames. For US data: SP/specs/10-us-canon.md (written by step C1 from the base Flow 10 frames). Where SP/specs/10-us-locale.md or the BRIEF's "US edition dataset" block disagree with the base frames or 10-us-canon.md, the base wins.
3. EXTRA states get the new numbers in the tables below (letter suffixes follow the file's convention, e.g. 08.05b, 06.14b). For each extra:
   - if the base has the screen it is a state of (a sibling), CLONE the base sibling and recreate the state change shown in the alternate frame (copy layers across where it helps) so it looks identical to its siblings;
   - if the base has no such screen, MOVE the alternate frame into the base section and restyle/re-text it to match the base siblings (background, nav bar, type, components, dummy data).
   Name each added frame "NN.NN · Screen · State" with its new number, and give it a Label (30 above) and Note (16 below) by cloning a base sibling's Label/Note and editing the text.
4. DOC CARDS: move the alternate's Refs · Mobbin, Micro-interactions and Logic check cards into the base section. Rewrite every frame number inside them with ONE simultaneous mapping (a single regex alternation, longest keys first, with a replacer callback; never chained replaces, because old and new numbers overlap). Fix any line that describes the alternate's design where the base looks different. Merge the alternate's FLAG items into the base Logic check (append them under "FLAG — PROPOSALS", drop duplicates) or keep the alternate's card retitled "Logic check · additions". Then add whatever is still missing so every major screen in the section has ≥3 hyperlinked Mobbin refs (Refs card) and its interactions are covered by a Micro-interactions card (numbered: trigger → response · duration + easing · haptic · VoiceOver · reduce motion). Sources: the flow spec in SP/specs (already has Mobbin refs + micro-interactions per screen); search Mobbin (mcp__Mobbin__search_screens: platform ios, output_destination design_tool, output_tool Figma, task_intent "Design a complete iOS EV-charging driver app flow in Figma, referencing real apps for each screen", image_format jpg, mode standard) only when a screen has no refs. Copy the card style from an existing card (e.g. "Refs · Mobbin · Place sheet & details (04.01–04.06)" 1219:3757 and "Micro-interactions · Place sheet · detents (04.01–04.03, 04.06)" 1219:3844 on page 1089:8868): 560 wide, auto-layout, bg/surface fill, hairline stroke, radius 28, padding 24.
5. LAYOUT inside a section: title (80,80), status line (80,124), Logic check at (80,250); phone frames 402×874 from x=720 every 482, 6 per row; rows 1350 apart (Label 30 above, Note 16 below). Refs cards stack in the left column under the Logic check (x=80, 40 gaps; if the left column runs too long, start a second card column at x=3612). Micro-interactions cards go right of the frames from x=3612 (and x=4212), 40 gaps. Extra frames continue the row grid. Fit the section (80 right/bottom padding), update the status line (frame count + range), then move every section BELOW it on the same page so a 160 gap holds and nothing overlaps.
6. Cross-page MOVE (current page = your flow page): const alt = await figma.getNodeByIdAsync('1342:9134'); await alt.loadAsync(); const n = await figma.getNodeByIdAsync(ID); section.appendChild(n); then set n.x/n.y. CLONE: const c = base.clone(); section.appendChild(c).
7. Never edit other pages except taking nodes out of YOUR alternate section; never delete the Alternates page (the coordinator does that last). Other agents are working on other flow pages at the same time.
8. Progress (for crash recovery): after each finished sub-step append one line to SP/merge/progress.log with Bash: cat >> SP/merge/progress.log <<'EOF' … EOF  (format: "<UTC time> <STEP> <what> <node ids>"). Append build notes to SP/build-log.md the same way. Never use Edit/Write on shared files.

## Figma rules
Tools: load with ToolSearch "select:mcp__Figma__use_figma,mcp__Figma__get_figma_skill,mcp__Figma__get_metadata" (add mcp__Mobbin__search_screens if you need Mobbin). Before your first use_figma call read skill://figma/figma-use/SKILL.md and skill://figma/figma-use/references/gotchas.md with mcp__Figma__get_figma_skill; for visible design changes also read skill://figma/figma-generate-design/SKILL.md. skillNames for use_figma: "resource:figma-use,resource:figma-generate-design".
One use_figma call at a time; switch page once per call (await figma.setCurrentPageAsync); return every created/mutated node id; load fonts before any text edit (load each node's current fonts via getStyledTextSegments(['fontName']); the file uses SF Pro Light/Regular/Medium/Semibold and Inter Regular); bind fills/strokes to the semantic variables and text to the text styles the brief lists; instance existing components instead of drawing; a failed script rolls back, so read, fix, retry; keep scripts under ~40,000 characters. Gotchas: binding a colour variable resets that paint's opacity (set it again); resizing layers inside an instance does not stick; a text property default is shared by all variants; TextStyle has description (not descriptionMarkdown).
Check your work: screenshot each new or changed frame inside use_figma (await node.screenshot({scale:0.5})) and fix anything clipped, overlapping, truncated, misaligned, low-contrast or off-data before moving on.

## Review checklist (review steps)
Screenshot each section at scale 0.2 for an overview, then every frame at 0.5 (one or two per call). Check and FIX directly:
- consistency with the reviewed flows (Flow 5 on page 1089:8869, Flow 2 on 946:8): status bar at (0,0), Nav Bar at (0,54) or map chrome, 16pt margins, tab bar at (20,788) only on root tabs, live-charging accessory placement, home indicator, text styles (no stray Inter), Display styles for numbers, token-bound colours, the same dummy data and the same components for the same jobs;
- quality: nothing clipped, truncated, overlapping, misaligned or off-rhythm; clear hierarchy; Hero-mesh contrast rule (no grey text on mesh; Frost Strong cards); calm and beautiful;
- docs: every section has Refs · Mobbin (≥3 hyperlinked refs per major screen), Micro-interactions cards and a Logic check with FLAG — PROPOSALS; sections fitted, 160 apart, no overlaps; frame numbers unique on the page;
- states: for sections the FIRST session built (named in your step), build any frame the spec lists that is missing, using the spec's number. For BASE sections (second session), do NOT add new frames; list the states the spec has that the base lacks under "Gaps" in your result (Hammad decides later).
Append one review line to SP/build-log.md.

## Steps

### Lane A · Flow 4 page 1089:8868 (sections in page order: 4A 1213:1595 · 4B 1301:4986 · 4C 1232:1775 · 4D 1301:6950 · 4E 1241:7573)
**A1 · Merge 4B.** Base 1301:4986 "Flow 4B · Station · Reviews, directions & currency" (04.12–04.19). Alternate 1322:55204. Spec SP/specs/04-station-book.md (+ SP/specs/10-us-locale.md for the currency-toggle refs).
| Alternate frame | Result |
|---|---|
| 1322:55207 04.12 Station details · Pushed (from Saved) | NEW 04.20 · Station details · Pushed (from Saved) |
| 1323:7351 04.13 Station details · Pushed · Loading | NEW 04.21 · Station details · Pushed · Loading |
| 1323:7416 04.14 Directions | = base 04.16 (do not add) |
| 1324:7523 04.15 Directions · No coordinates | = base 04.17 (do not add) |
| 1324:7617 04.16 Directions · Couldn't open Maps | NEW 04.17b · Directions · Couldn't open Maps (clone base 04.16 + the failure toast) |
| 1324:7711 04.17 Call host · proposal | NEW 04.17c · Call host · proposal |
| 1324:56564 04.18 Reviews | = base 04.12 |
| 1324:57910 04.19 Reviews · Loading | = base 04.13 |
| 1324:57997 04.20 Reviews · Empty (state demo) | = base 04.14 |
| 1324:58097 04.21 Reviews · Couldn't load | = base 04.15 |
Doc-card map (alternate → base, simultaneous): 04.12→04.20, 04.13→04.21, 04.14→04.16, 04.15→04.17, 04.16→04.17b, 04.17→04.17c, 04.18→04.12, 04.19→04.13, 04.20→04.14, 04.21→04.15 (rewrite ranges by hand, e.g. "04.18–04.21" → "04.12–04.15", "04.14–04.16" → "04.16, 04.17, 04.17b"). Alternate cards: 1326:8423, 1326:8459, 1326:8481 (Refs), 1326:16473, 1326:16502, 1326:16525, 1326:16539 (Micro), 1326:16585 (Logic). Also add Refs + Micro cards for the quick Rs ⇄ $ toggle frames 04.18 and 04.19. Numbers already used on this page: 04.01–04.19, 04.22–04.50, 04.53 (don't reuse; 04.51/04.52 are reserved for 4D).
**A2 · Docs for 4D.** Base 1301:6950 "Flow 4D · Book · Vehicle" (04.35–04.40), no alternate. Add Refs · Mobbin + Micro-interactions cards (spec SP/specs/04-station-book.md, vehicle step; plan row 13 in 00-system §4).
**A3 · Review Flow 4** (all five sections). First-session sections: 4A, 4C, 4E. Base sections: 4B, 4D.

### Lane B · Flow 8 page 1089:8872 (8A 1201:2 · 8B 1205:29868 · 8C 1222:4347 · 8D 1229:3574 · 8E 1297:4495 · 8F 1297:6148)
**B1 · Merge 8E.** Base 1297:4495 "Flow 8E · Profile · Settings, region & currency" (08.09–08.16). Alternate 1322:6597. Spec SP/specs/08-profile-vehicles.md (+ 10-us-locale.md §6 for Region & currency).
| Alternate frame | Result |
|---|---|
| 1322:6600 08.16 Account & settings · Default | = base 08.09 |
| 1323:55521 08.16b … · No phone, no vehicle | NEW 08.09b · Settings · No phone, no vehicle (clone base 08.09) |
| 1323:55711 08.17 … · Loading | = base 08.15 |
| 1323:55893 08.18 … · Couldn’t load | = base 08.16 |
| 1323:55965 08.19 … · Coming soon | = base 08.12 (the alternate's "Keyframes · Switch nudge (08.19)" card 1324:15204 may document base 08.12 if it shows the same moment; otherwise drop it) |
| 1324:15221 08.62 Region & currency · Pakistan | = base 08.10 |
| 1324:56886 08.63 … · US dollars shown | = base 08.11 |
| 1324:57018 08.64 … · Switch to United States | NEW 08.62 · Region & currency · Switch to United States (clone base 08.10; the alert over it, copy matching the base's region/currency model) |
| 1324:57136 08.65 … · While charging | NEW 08.63 · Region & currency · While charging (clone base 08.10/08.11) |
| 1324:57364 08.20 Delete account · Confirm | = base 08.13 |
| 1324:57550 08.21 … · Deleting | = base 08.14 |
| 1324:57614 08.22 … · Couldn’t delete | NEW 08.14b · Delete account · Couldn't delete (clone base 08.13/08.14 + error toast) |
Doc-card map (simultaneous, longest first): 08.16b→08.09b, 08.16→08.09, 08.17→08.15, 08.18→08.16, 08.19→08.12, 08.62→08.10, 08.63→08.11, 08.64→08.62, 08.65→08.63, 08.20→08.13, 08.21→08.14, 08.22→08.14b. Alternate cards: 1325:7831, 1325:7869, 1325:7915 (Refs), 1326:16323, 1326:16381, 1326:16433 (Micro), 1326:16562 (Logic), 1324:15204 (Keyframes).
Known base defect to fix: the Phone row in base 08.09 shows the support hotline number instead of the driver's own phone (use the Profile 08.01 dummy data).
**B2 · Merge 8F.** Base 1297:6148 "Flow 8F · Sign out" (08.17–08.22b). Alternate 1342:9135.
| Alternate frame | Result |
|---|---|
| 1334:7831 08.09 Sign out · Confirm (native alert) | = base 08.17 (base uses a sheet; keep it; say in the Logic check which presentation the logic map / spec supports) |
| 1334:7911 08.10 Active session | = base 08.18 |
| 1335:8203 08.11 Ending session | = base 08.19 |
| 1335:8311 08.12 Couldn’t end session | = base 08.20 |
| 1335:8414 08.13 Charging summary | = base 08.21 |
| 1335:8514 08.14 Logging out | = base 08.22 |
| 1335:13491 08.14b Logout failed | NEW 08.22c · Sign out · Logout failed (match base 08.22's background + an error toast) |
| 1335:13565 08.15 Signed out notice | = base 08.22b |
Doc-card map (simultaneous, longest first): 08.14b→08.22c, 08.09→08.17, 08.10→08.18, 08.11→08.19, 08.12→08.20, 08.13→08.21, 08.14→08.22, 08.15→08.22b. Alternate cards: 1338:9134, 1338:9164, 1338:9198 (Refs), 1339:14043, 1339:14107 (Micro), 1339:14141 (Logic).
**B3 · Review Flow 8.** First-session sections: 8A–8D. Base sections: 8E, 8F.

### Lane C · Flow 10 page 1294:2 (10A 1304:2 · 10B 1304:215 · 10C 1304:617)
**C1 · Canon US dataset + data fixes.** Read every text layer of the base frames 10.01–10.20 and write SP/specs/10-us-canon.md: the US dataset as built (driver, email, phone, vehicles with battery/plugs/plate, every station with address, plug, kW, price, distance, rating, status, host; reviewers; inbox names; booking times; planner maths; live and complete numbers; region & currency copy; formats). Check the arithmetic. Find and FIX inconsistencies in the base frames, e.g. Pakistani place names left over from a find-and-replace ("Levee Phase 6", "Levee Raya", "Levee Phase 3", "GREENVOLT · Levee PHASE 5" came from "DHA") → West Lafayette places from the dataset; "Tesla Model 3 · CCS1 (DC)" vs "Tesla Model 3 · NACS · 75 kWh"; any "Rs", "km", Lahore/Karachi, +92 or Pakistani plate left on US screens except the deliberate Rs view in 10.20. Then append a pointer line to SP/brief/BRIEF.md: "US dataset: see SP/specs/10-us-canon.md (supersedes the US edition dataset block above)".
**C2 · Merge 10A.** Base 1304:2 "Flow 10A · US · Discover & station" (10.01–10.06). Alternate 1331:2941 — built with a DIFFERENT US dataset: re-text every person, station, price, distance, rating and car to 10-us-canon.md.
| Alternate frame | Result |
|---|---|
| 1331:2944 10.01 Home · Map | = base 10.01 |
| 1331:3080 10.02 Map · Cluster opened | NEW 10.21 · Home · Map · Cluster opened (clone base 10.01) |
| 1331:3221 10.03 Map · Station selected | = base 10.02 |
| 1331:3353 10.04 Filter & sort | NEW 10.22 · Home · Filter & sort |
| 1331:3613 10.05 List | = base 10.06 |
| 1335:12662 10.06 Search · Focused · Recents | NEW 10.23 · Search · Focused · Recents |
| 1335:12910 10.07 Results for purdue / 1335:13128 10.08 Results for state st | base 10.03 shows one query; add the OTHER query as NEW 10.24 · Search · Typing · Results for "<query>" |
| 1335:13346 10.09 Search → Place · Purdue University | NEW 10.25 · Search → Place · Purdue University |
| 1336:4293 10.10 Station · Sheet · Medium | NEW 10.26 · Station · Sheet · Medium (clone base 10.04, medium detent) |
| 1336:4454 10.11 Sheet · Large | = base 10.04 |
| 1336:4654 10.12 Sheet · In use (DC) | NEW 10.27 · Station · Sheet · In use (DC) (the canon DC station) |
| 1336:4817 10.13 Station cards · Every US station | NEW 10.28 · Station cards · Every US station |
Doc-card map (simultaneous): 10.02→10.21, 10.03→10.02, 10.04→10.22, 10.05→10.06, 10.06→10.23, 10.07/10.08→(10.03 or 10.24 as decided), 10.09→10.25, 10.10→10.26, 10.11→10.04, 10.12→10.27, 10.13→10.28 (10.01 stays). Alternate cards: 1333:3642, 1335:13741, 1339:4885 (Refs), 1333:3666, 1335:13765, 1339:4905 (Micro), 1339:4957 (Logic → merge into base "Logic check · Flow 10 · US edition" 1304:195). Re-text station names/prices in the cards to the canon. 10A grows: move 10B and 10C down.
**C3 · Docs for 10B and 10C.** Base 1304:215 and 1304:617 have no Refs, Micro-interactions or (10B/10C) Logic check cards. Add Refs · Mobbin (US-market refs from SP/specs/10-us-locale.md + the matching PK specs 04/05/06/07/08/09), Micro-interactions per major screen, and a Logic check per section (US copy/format rules, FLAGs). Data per 10-us-canon.md.
**C4 · Review Flow 10.** All three are base sections (10A now includes the merged extras). Extra US checks: every price in $ with US formats, miles, US places/names/cars/plugs per 10-us-canon.md, nothing Pakistani except the deliberate Rs view in 10.20.

### Lane D · Flow 6 page 1089:8870 and Flow 9 page 1089:8873
**D1 · Docs for 6C.** Base 1302:3888 "Flow 6C · Live · Lock Screen & Dynamic Island" (06.22–06.28d), between 6B 1203:4583 and 6D 1216:1595. Refs + Micro from SP/specs/06-live-complete.md (plan row 20). Shift 6D/6E down if 6C grows.
**D2 · Review Flow 6.** First-session sections: 6A 1194:26020, 6B 1203:4583, 6D 1216:1595, 6E 1237:2506. Base: 6C.
**D3 · Docs for 9A–9D.** Base 1300:2 (9A Inbox, 09.01–09.06), 1300:2010 (9B Thread, 09.07–09.12), 1300:3154 (9C Inquiry, 09.13–09.17), 1300:4196 (9D Options & call, 09.18–09.21). Refs + Micro per section from SP/specs/09-messages.md (its frame numbers differ from the base — map by screen meaning, write the base numbers). Shift sections down as they grow.
**D4 · Review Flow 9.** All base sections.

### Lane E · reviews of first-session flows
**E1 · Review Flow 1** page 1089:8866: 1A 1158:2, 1B 1169:2575, 1C 1182:4522, 1D 1184:12519 (spec 01-onboarding.md). All first-session sections.
**E2 · Review Flow 3** page 1089:8867: 3A 1186:23663, 3B 1201:27993 (spec 03-search.md). All first-session sections.
**E3 · Review Flow 7** page 1089:8871: 7A 1249:2, 7B 1259:1513, 7C 1270:2555, 7D 1284:4955 (spec 07-bookings.md). All first-session sections.

### Coordinator (last)
Check every alternate frame/card is accounted for (moved, or equal to a base frame), then delete page 1342:9134; update docs; commit; push.
