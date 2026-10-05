# PakPlug driver app — overnight build brief (read fully before any work)

PakPlug is a peer-to-peer EV charging marketplace for Pakistan (Lahore first). Drivers find chargers on a map, book a slot, start/stop charging by QR or code, and pay per kWh or per hour. Hosts list chargers (host side is OUT of scope).

Owner: Hammad (design + product). Code: Rayan (Flutter, iOS-first, Android later). You are designing in Figma only. No code.

## Hammad's brief for tonight (verbatim intent)
- Make the WHOLE driver flow: onboarding → map/list + station cards → search → station → booking → start charging → live charging → finishing the session → bookings (upcoming, cancelled, every state) → profile (update profile, add/edit cars). Messages too (lower priority).
- Reference Mobbin for EVERY step and keep it consistent. One design language. Extremely beautiful.
- Search bar: decide what users can search, how they search, and every micro-interaction.
- Micro-interactions during charging and after charging ends, in detail.
- Charging limitation: the app can't read the car's real battery %. So at the start, ASK the driver their current battery % (and use their vehicle). Let them plan by TIME (e.g. 1 hour) and show a calculation: expected cost, expected units (kWh) and expected end battery %. Depends on the vehicle (battery size) and the charger (kW, price). Hammad will connect the backend maths later; use DUMMY numbers now, but show the interactions in full detail.
- Divide work into steps; think through every micro-interaction.

Decisions already made: type = SF Pro, lighter (numbers Light, titles Medium, body Regular; no Bold/Semibold in UI). Brand colour = deep emerald; mesh backgrounds approved. P mark: use `Brand / Mark / PakPlug P` Style=Mesh on light surfaces, Style=Solid (white) on emerald. Wordmark now SF Pro. Text on the Hero mesh: keep the measured rule (below).

## Sources of truth
- Logic: `/home/user/Pakplug_Design/docs/superpowers/specs/driver-logic-map.md` (every screen, state and real copy from the shipped code). Use REAL copy from it. Anything new = "proposal", flagged in a FLAG card. Never invent fake data fields silently.
- Spec + decisions: `/home/user/Pakplug_Design/docs/superpowers/specs/2026-10-03-driver-ui-revamp-design.md`
- Progress + flags for Rayan: `/home/user/Pakplug_Design/docs/superpowers/specs/2026-10-03-driver-ui-revamp-progress.md`
- Figma IDs: `/home/user/Pakplug_Design/docs/superpowers/specs/figma-ledger-v4.json`
- Concepts chosen: A · Maps-native discovery (search in the thumb zone, place sheets, glass controls) + B · Charging Pass bookings (Wallet-like passes). C's live surfaces (Live Activity, Dynamic Island, accessory) and D's celebration + time-first booking readout are also wanted.

## Figma
- File key `x2fPubLkytfeO9btWSoTu6`. Pages: Brand 946:4, Foundations 946:5, Style Frame 946:6, Components 946:7, **one page per flow (build screens there): Flow 1 · Onboarding 1089:8866, Flow 2 · Discover 946:8, Flow 3 · Search 1089:8867, Flow 4 · Station + Booking 1089:8868, Flow 5 · Charge + Planner 1089:8869, Flow 6 · Live + Complete 1089:8870, Flow 7 · Bookings 1089:8871, Flow 8 · Profile + Vehicles 1089:8872, Flow 9 · Messages 1089:8873**, Explorations 995:2 (old concepts, read-only reference).
- BEFORE any use_figma call: load skills with `mcp__Figma__get_figma_skill` → `skill://figma/figma-use/SKILL.md` (and `skill://figma/figma-generate-library/SKILL.md` for components, `skill://figma/figma-generate-design/SKILL.md` for screens). Pass skillNames "resource:figma-use,resource:figma-generate-design" (or generate-library).
- HARD RULES: one page per use_figma call (setCurrentPageAsync once); NEVER run use_figma calls in parallel; return every created/mutated ID; never guess IDs; load fonts before text edits (SF Pro styles: Light, Regular, Medium, Semibold; also load 'Inter Regular' before creating text); colors 0–1; fills arrays are immutable (clone + reassign).
- A failed script rolls back completely: re-read, fix, retry.
- Text styles have no `descriptionMarkdown` (use `description`, plain text, avoid quotes/&/<>). Components/sets: use `descriptionMarkdown`.
- Binding paints: `const r = v.resolveForConsumer(node).value; node.fills=[figma.variables.setBoundVariableForPaint({type:'SOLID',color:{r:r.r,g:r.g,b:r.b},opacity:r.a??1},'color',v)]`. Bind AFTER the node is appended.
- Icons: instance of `Icon / <sf name>` component; recolour the inner vector named `Symbol`. Resize icons/marks with `rescale()` (resize() crops brand marks). Setting an INSTANCE_SWAP property drops master colour overrides on the nested icon: re-apply colour on the instance.
- Use `figma.createAutoLayout()` for any container with related children. Set FILL/HUG only after appendChild. resize() before layoutSizing. Wrapping text: textAutoResize='HEIGHT' then layoutSizingHorizontal='FILL'.
- Images: the cloud proxy blocks downloading Mobbin images and uploading to Figma. Do NOT try to embed screenshots. Use text reference cards with hyperlinks (format below).
- Use `node.screenshot({scale})` inside use_figma to check your work visually (inline image). Fix clipped/overlapping/low-contrast things before moving on.

## Design language (tokens) — bind everything to variables
Semantic colours (v4 · Semantic, VariableID:<id>):
bg/canvas 948:40 (#F7F6F1) · bg/surface 948:41 (white) · bg/grouped 948:42 · bg/frost 948:43 (white 68%) · bg/frostStrong 948:44 (white 86%) · bg/tint 948:45 (#E5F3EB) · bg/fill 948:46 · bg/fillStrong 948:47 · bg/scrim 948:48 · bg/glass 953:4 (white 22%)
text/primary 948:49 · text/secondary 948:50 (76% grey) · text/tertiary 948:51 · text/onPrimary 948:52 · text/brand 948:53 · text/destructive 948:54 · text/available 948:55 · text/inUse 948:56 · text/booked 948:57 · text/offline 948:58 · text/warning 948:59 · text/error 948:60 · text/onMesh 1067:505 (white)
icon/primary 948:61 · icon/secondary 948:62 · icon/tertiary 948:63 · icon/brand 948:64 · icon/onPrimary 948:65 · icon/error 1070:506
action/primary 948:66 · action/primaryPressed 948:67 · action/secondary 948:68 · action/destructive 948:69 · action/disabled 948:70
status/available 948:71 · status/inUse 948:72 · status/booked 948:73 · status/offline 948:74 · status/warning 948:75 · status/error 948:76 · (Tint versions 948:77–948:82: availableTint, inUseTint, bookedTint, offlineTint, warningTint, errorTint)
energy 948:83 (#3DD68C) · stroke/separator 948:87 · stroke/hairline 948:88 · stroke/highlight 948:89 · stroke/focus 948:90 · stroke/error 1070:505 · effect/shadowSoft 948:91 · effect/shadow 948:92 · map/userLocation 974:222
mesh/deep 1062:3 · mesh/glow 1062:5 · mesh/mid 1062:7 · mesh/bridge 1062:9 · mesh/accent 1062:11 · mesh/celebrateGlow 1062:13 · mesh/quiet1–3 1062:15/17/19
Brand: brand/primary 947:3 (#0C7A4A).
Scale (v4 · Scale): space/0 948:95, /2 :96, /4 :97, /6 :98, /8 :99, /10 :100, /12 :101, /16 :102, /20 :103, /24 :104, /32 :105, /40 :106, /48 :107, /64 :108; layout/screenMargin 948:109 (16); radius/xs 948:114 (8), sm :115 (12), md :116 (16), lg :117 (22), xl :118 (28), sheet :119 (38), pill :120; size/touch 948:121 (44), buttonL :122 (52), buttonM :123 (44), buttonS :124 (34), iconS :125 (16), iconM :126 (20), iconL :127 (24).

Text styles (use setTextStyleIdAsync; IDs end with a comma):
Large Title 34 Medium S:96c02aa1ad50f00a25940487c8c4fef93ffef288, · Title 1 28 S:287babb6ad207b2db42d439f7735a18322d2b2fc, · Title 2 22 S:c7c61416e9136affe41256b5ecd6ccf54a697847, · Title 3 20 S:3cd5d7dab0a561fa5ee6046ceacc1bba49513ee1, · Headline 17 Medium S:a1bb39a0a592a2851692cd77dbf82bafbf84fd21, · Body 17 S:65b984824a1152616149c0c671280fa40ea03aa5, · Callout 16 S:29dd89a3308851eb2cfef13ae7beccc677064e42, · Callout Emph S:9bdd3dfb139939ed11c11d228c7029c6b9767c5f, · Subheadline 15 S:36ec37195e73343cc33b3ca2134619ee9d4d5b2d, · Subheadline Emph S:26407f21507c08c8e0d5e4b151d05dc0a8071e5b, · Footnote 13 S:e782c1e89500c982a06e3b5e56f0cf36eaeae64e, · Footnote Emph S:ea85a81524e0112d0f73ccfa8989d495c4cbde80, · Caption 1 12 S:cd08e5fe821ec03ece23eaa09eb8cc148c9e86c0, · Caption 1 Emph S:58faf0097f778363c81381a2d86c66a7578fa939, · Caption 2 11 S:36f31ae701320d694ac0de721f4b0bc8f0263f2e, · Caption 2 Emph S:91681ea185fe181b62dfc51aa44e12a85fd94036, · Display/XL 56 Light S:9e6f24bafc722abdcb88064084fcab5b663f95ae, · Display/L 40 S:b752a34226289292bbe958315187fc06c917cc1c, · Display/M 28 S:7eae7512406f85410daaacaedbd5ad5b8194af6b, · Display/S 22 S:271a0decbca7e7cba4080e44559dfc201ffb7509,
Use: screen titles = Large Title (Medium); section titles Title 3/Headline; body Body/Subheadline; meta Footnote/Caption; every number that matters (price, %, kWh, time, cost) = Display styles (SF Pro Light).

Effect styles: Frost/Card S:a34a91669bf56eb7e654485515c135944138e748, · Frost/Elevated S:eb9b262fcd164e380cbd6b1a2b0b56e72b88675a, · Glass/Regular S:c50cc753ab85b67f05f67a2d40f90e0c63e62701, · Glass/Clear S:9960d021f94622aba585bd2409f6fb81496c82d0, · Shadow/Button S:60fa2130ac1d13ae5bd466253615270c6ecffcaa, · Shadow/Pin S:4cfa4b37024c3ff56b2ec1b5f93ce9157574ac0d,

Backgrounds (components; instance and resize to 402×874): Mesh Hero 951:7416 (Charge tab, live charging, start-planner hero), Mesh Quiet 951:7417 (lists: Bookings, Profile, Messages, onboarding), Mesh Celebrate 951:7418 (charging complete, all-set). Map image: copy the fills of rectangle 996:430 (on page 995:2) onto a 402×874 rectangle named Map.

Contrast rule on the Hero mesh (measured): cards with grey secondary text must be Frost Strong (4.6:1) or Surface (5.3:1) — never Frost 68% (3.7:1). Text straight on the mesh: over the top glow (status bar, large title, top ~140pt) use text/primary (black); below that use text/onMesh (solid white); never text/secondary on the mesh. Floating chrome (tab bar, pills) on the mesh = Frost Strong. Celebrate mesh: same rule (deep base). Quiet mesh and canvas: normal text colours.

## Screen template (iPhone, 402×874 frame)
- iOS / Status Bar instance at (0,0): Content=Dark 996:398 on light screens; Content=Light 996:411 only where the top is dark.
- Content margin 16 (layout/screenMargin). Large title at y≈60–100 (or nav bar).
- Tab bar (only on the 5 root tabs): Tab Bar instance at (20,788), 362×64; Selected=Home 966:79 / Charge 966:107 / Bookings 966:135 / Messages 966:163 / Profile 966:191. Messages badge shows "2".
- Live charging pill above the tab bar while a session is active: Tab Bar Accessory / Live Charging 967:124 (State=Charging) at (20,728).
- iOS / Home Indicator at (0,840): Dark 996:425 / Light 996:427.
- Sheets: top radius 38 (radius/sheet), grabber 36×5 at top, Surface fill (or Frost Strong over mesh), scrim bg/scrim behind (alpha in the variable).
- Primary actions: Button / Large (370 wide → resize to 370 or FILL) pinned at the bottom with 16pt margin above the home indicator area.
- Navigation: use the Nav Bar component (Inline for pushed screens, Large for root tabs) at (0,54).

## Existing component inventory (instance these; never redraw what exists)
```
Tab Bar / Item [966:78] variants Tab=Home|Charge|Bookings|Messages|Profile × Selected; props Badge#966:0, Badge count#966:11
Tab Bar [966:219]: Selected=Home 966:79, Charge 966:107, Bookings 966:135, Messages 966:163, Profile 966:191 (362x64)
Tab Bar Accessory / Live Charging [967:168]: State=Charging 967:124, Ending 967:135, No window 967:146, Stopping 967:157 (362x52); prop Title#967:0
Tab Bar / Minimized [967:169]
Chip [970:186]: Glass/No 970:142, Glass/Yes 970:153, Fill/No 970:164, Fill/Yes 970:175; props Label#970:0, Leading icon#970:5, Icon#970:10, Chevron#970:15, Count#970:20, Count value#970:25
Segmented Control [970:218]: 2 segs sel1 970:187, sel2 970:192; 3 segs sel1 970:197, sel2 970:204, sel3 970:211 (labels are text inside; override text)
Search Field [971:262]: Idle/On map 971:202 (mesh P mark), Focused/On map 971:211, Filled/On map 971:222, Idle/In sheet 971:236, Focused/In sheet 971:243, Filled/In sheet 971:251
Search Result Row [971:284]: Station 971:263, Place 971:271, Loading 971:278, Empty 971:282
Map Pin [974:258]: Available 974:223, In use 974:228, Unavailable 974:233, Available selected 974:238, In use selected 974:244, Unavailable selected 974:251; prop Price#974:0
Map Cluster [974:263]: Small 974:259, Large 974:261 · User Location 974:264 · Map Button 975:225 (prop Icon#975:0) · Map Controls [975:248]: Mode=Map 975:228, Mode=List 975:244 · Map Status Pill [975:257]: Loading 975:249, Notice 975:253
Button / Large [978:427] (370x52): Primary Default 978:277 / Pressed 978:284 / Disabled 978:291 / Loading 978:298; Secondary 978:307/314/321/328; Tertiary 978:337/344/351/358; Destructive 978:367/374/381/388; Destructive Secondary 978:397/404/411/418; props Leading icon#978:0, Icon#978:21
Button / Medium [978:578] (44h): Primary 978:428/435/442/449; Secondary 978:458/465/472/479; Tertiary 978:488/495/502/509; Destructive 978:518/525/532/539; Destructive Secondary 978:548/555/562/569; props Leading icon#978:42, Icon#978:63
Icon Button [979:295]: Glass M 979:277, Glass S 979:280, Fill M 979:283, Fill S 979:286, Tinted M 979:289, Tinted S 979:292; prop Icon#979:0
Slide to Start [979:317]: Idle 979:296, Dragging 979:301, Starting 979:307, Disabled 979:312
Status Pill [980:347]: Tone=Success|Warning|Info|Neutral|Error|Live × Size=M|S (Success M 980:311, S 980:314; Warning M 980:317, S 980:320; Info M 980:323, S 980:326; Neutral M 980:329, S 980:332; Error M 980:335, S 980:338; Live M 980:341, S 980:344); prop Dot#980:0 (label is text inside)
Station Card [982:373]: Map preview 982:287 (370x170), List 982:314 (370x112), Saved 982:331, Map preview Loading 982:347, List Loading 982:359, Saved Loading 982:366
Switch [983:338]: On/Enabled 983:330, On/Disabled 983:332, Off/Enabled 983:334, Off/Disabled 983:336
List Row [983:388]: Navigation 983:339, Value 983:352, Toggle 983:364, Destructive 983:377 (370x64); props Icon#983:0, Icon glyph#983:5, Subtitle#983:10, Separator#983:15 (title text "Title", subtitle "Subtitle" nodes inside)
List Group Header [983:389] prop Label#983:20
Hero Stat [986:445]: XL Leading 986:421, XL Center 986:425, L Leading 986:429, L Center 986:433, M Leading 986:437, M Center 986:441; props Caption#986:0, Value#986:7, Detail#986:14, Show detail#986:21
Stat Tile [986:446] props Label#986:28, Value#986:29, Unit#986:30
Charging Gauge [987:414]: Charging 987:392, Complete 987:400, Unknown 987:409 (240x240)
Session Timeline Item [987:437]: Done 987:415, Current 987:422, Upcoming 987:430; prop Line#987:0
iOS / Status Bar [996:424]: Dark 996:398, Light 996:411 · iOS / Home Indicator [996:429]: Dark 996:425, Light 996:427
Sheet Header [1008:422]: Place 1008:401, Form 1008:413; props Title#1008:0, Subtitle#1008:3
Quick Action Tile [1008:431]: Primary 1008:423, Tinted 1008:427; prop Icon#1008:6
Stats Row [1008:432] props Label/Value 1–4 (#1008:9..16), Rating star#1008:17
Connector Row [1008:490]: Available 1008:454, In use 1008:466, Unavailable 1008:478; prop Plug#1026:0 (swap to ev.plug icons)
Floating Action Pill [1008:491] prop Show action 2#1008:18
Sheet / Filter & sort 1012:432 · Sheet / Directions 1012:569 · Sheet / Confirm booking 1012:594 · Sheet / Choose vehicle 1014:509 (402 wide, full sheets)
Alert [1014:577]: Destructive 1014:561, Default 1014:570
Charging Pass [1010:521]: Stacked Upcoming 1010:417, Stacked Completed 1010:425, Stacked Cancelled 1010:433, Front Upcoming 1010:441, Front Completed 1010:471, Front Cancelled 1010:496
Date Pill [1011:439]: Selected 1011:430, Default 1011:433, Disabled 1011:436
Time Window [1011:440] props Start#1011:0, End#1011:1, Duration#1011:2 · Availability Bar [1011:449] · Cost Footer [1011:479] props Amount#1011:3, Detail#1011:4, Show cost#1011:5
Text Field [1070:590]: Default 1070:510, Focused 1070:526, Filled 1070:542, Error 1070:558, Disabled 1070:574; props Label#1070:0, Placeholder#1070:6, Value#1070:12, Helper#1070:18, Error message#1070:24, Show label#1070:30, Show message#1070:36, Leading icon#1070:42, Icon#1070:48
State View [1072:599]: Empty 1072:573, Loading 1072:584, Error 1072:588; props Show action#1072:0, Icon#1072:4 (Title/Message text nodes inside)
Brand / Mark / PakPlug P [1082:126]: Style=Solid 991:69, Style=Mesh 1082:123 · Brand / Wordmark [994:132]: Ink 994:117, Emerald 994:122, White 994:127 · Brand / App Icon [992:94]: Default 992:82, Dark 992:86, Tinted 992:90
Backgrounds: Mesh Hero 951:7416, Mesh Quiet 951:7417, Mesh Celebrate 951:7418
Nav Bar [1087:643] (NEW, C13 section 1087:604): Style=Inline 1087:607 (402x52), Style=Large 1087:624 (402x103); props Title#1087:0, Leading#1087:3 (bool), Trailing 1#1087:6 (bool), Trailing 2#1087:9 (bool). Buttons are exposed Icon Button (Glass M) instances named "Leading button", "Trailing button 1", "Trailing button 2": change their icon with inst.findOne(n=>n.name==="Leading button").setProperties({"Icon#979:0": "<icon id>"}). Place at (0,54).
Toast [1088:631] (NEW, C14 section 1088:608): Tone=Neutral 1088:611, Success 1088:616, Warning 1088:621, Error 1088:626 (370 wide); props Message#1088:0, Action#1088:5 (bool), Action label#1088:10. Floats 12pt above the tab bar / bottom button.
Rating Stars [1088:728]: Value=0 1088:632, 1 1088:648, 2 1088:664, 3 1088:680, 4 1088:696, 5 1088:712 (5×44pt targets).
Connector Tile [1088:745]: Selected=No 1088:729, Selected=Yes 1088:737 (177x112); props Title#1088:15, Subtitle#1088:18, Plug#1088:21 (icon swap). Grid 2×2, gap 16.
```
ICONS (component ids): magnifyingglass 958:6, bell 958:10, line.3.horizontal.decrease 958:16, location 958:19, chart.bar 958:23, house 958:26, house.fill 958:29, bolt 958:32, bolt.fill 958:35, calendar 958:39, message 958:42, person 958:46, heart 958:49, star.fill 958:52, chevron.right 958:55, qrcode.viewfinder 958:61, stop.fill 958:64, car 958:69, xmark 958:72, plus 958:75, list.bullet 958:81, map 958:84, clock 958:88, checkmark 958:91, arrow.right 958:94, message.fill 966:7, person.fill 966:11, circle.grid.3x3 966:15, heart.fill 981:289, ev.plug.ac.type.2 981:294, phone 984:451, globe 984:455, xmark.circle.fill 1019:532, battery.75percent 1023:481, person.crop.circle 1023:483, bubble.left 1023:485, location.fill 1024:472, car.fill 1024:474, phone.fill 1024:476, ev.charger 1024:478, ev.charger.fill 1024:480, ev.plug.dc.ccs2 1024:482, ev.plug.dc.gb.t 1024:484, wallet.pass 1024:486, wallet.pass.fill 1024:488, arrow.triangle.turn.up.right.diamond.fill 1024:496, square.and.arrow.up 1024:503, ellipsis 1024:510, info.circle 1025:472, exclamationmark.triangle.fill 1025:474, chevron.left 1025:481, chevron.down 1025:483, mappin 1025:485, star 1025:492, creditcard 1025:494, trash 1025:496, gearshape 1025:498, bolt.car 1025:500, timer 1025:502, figure.walk 1025:504, checkmark.circle.fill 1025:506, slider.horizontal.3 1025:513.
Missing SF Symbols cannot be exported in this Linux session; if you need a symbol that isn't listed, pick the nearest listed one and note the wanted symbol name in the FLAG card.

## Documentation format on the flow pages — every flow section has the same anatomy
Each flow = one SECTION named `Flow <n> · <Name>` (copy the fills of section 1076:2). Inside, left → right / top → bottom:
1. Title (Title 1, text/primary) at (80,80); status line (Footnote, text/secondary) at (80,124).
2. **Refs · Mobbin card** (560 wide, Surface fill, hairline stroke, radius 28, padding 24, gap 12): header "REFS · MOBBIN" (Footnote Emph, text/primary), then one block per reference: "App — screen" (Subheadline Emph), "What we take: …" (Footnote, text/secondary) and the Mobbin URL as a hyperlink (Footnote, text/brand; `t.hyperlink = {type:'URL', value:url}`).
3. A row of phone frames (402×874, gap 80, labels above each frame in Footnote Emph secondary like `A1 · Home · Map`). States of the same screen sit next to each other.
4. **Micro-interactions card** per screen or step (560 wide, same card style): numbered rows "1  Trigger → response · 200 ms ease-out · light haptic". Cover: press states, transitions, loading, success/failure, haptics, VoiceOver, reduce-motion fallback.
5. **Logic check card**: logic-map items covered, real copy used, and a **FLAG — PROPOSALS** block (title in text/brand) for anything new.
Before placing a section, read the page to find the current bottom (max y + height of page children) and place the new section 160 below it at x=0. Name every node meaningfully.

## Consistent dummy data (use everywhere)
- Driver: Ayesha Khan, ayesha.khan@email.com, 0301 2345678, Lahore.
- Vehicle 1 (primary): BYD Atto 3 · 60.5 kWh · Type 2 (AC) + CCS2 (DC) · plate LEB-2481. Vehicle 2: MG ZS EV · 51 kWh · Type 2 + CCS2 · LEA-9034.
- Stations: GreenVolt · DHA Phase 5 (Street 12, Block CCA, DHA Phase 5, Lahore · Type 2 7.4 kW · Rs 42/kWh · 4.8★ · 1.2 km · Available) · Gulberg Galleria Charger (Main Boulevard, Gulberg III · CCS2 60 kW DC · Rs 68/kWh · 4.6★ · 3.4 km · In use) · Model Town Home Charger (Model Town · Type 2 11 kW · Rs 38/kWh · 4.9★ · 5.1 km · Available) · Johar Town Fast Hub (Johar Town · CCS2 30 kW · Rs 55/kWh · 4.4★ · 7.8 km · Offline).
- ONE story everywhere (AC): GreenVolt · DHA Phase 5, Type 2 7.4 kW, Rs 42/kWh. Booking: Today, Sat 4 Oct · 6:00 → 7:00 PM · 1 h · BYD Atto 3.
- Charge planner (dummy maths, label "Estimate"): efficiency 92%. Start 20% + 1 h on 7.4 kW → ~6.8 kWh → +11% → ends ≈31% · Rs 286. (Formula to show in notes: kWh = kW × hours × 0.92, capped by (target% − start%) × battery kWh; % added = kWh ÷ battery kWh; cost = kWh × Rs/kWh.)
- Planner by target on a DC example: Gulberg Galleria CCS2 60 kW, Rs 68/kWh: 20% → 80% = 36.3 kWh ≈ 40 min · Rs 2,468; or 30 min → 27.6 kWh → ≈66% · Rs 1,877.
- Copy for every estimate: "Estimate. The charger's meter decides the final amount."
- Live session (AC story) at 6:32 PM: 32 min in, 28 min left, +3.6 kWh, ≈26% (estimated, shown with "≈" and "est."), Rs 152 so far. Ending soon at 6:55 (5 min left).
- Complete: 1 h 00 min, 6.8 kWh, Rs 286, ≈31% (estimated), receipt no. PP-2410-0482.
- Messages: Host "Bilal (GreenVolt)".
