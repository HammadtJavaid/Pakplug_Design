# SF Symbols → Figma icon components

The `Icon / …` components on the Figma Components page (Icons section) are **real SF Symbols**, not redraws. They were exported from macOS 26 with this tool. Use it to add more symbols the flows need, so every icon stays genuine and consistent.

## How it works

1. `sfexport.swift` renders each symbol with SwiftUI's `ImageRenderer` into a vector PDF.
2. It walks the PDF with `CGPDFScanner` and rebuilds the filled outlines as path data.
3. It resolves the soft-mask cut-outs Apple uses for symbols like `xmark.circle.fill`.
4. `sf_to_figma.py` places every symbol in a 24pt frame at one optical size (≈20.6pt) and writes Figma-ready paths.

## Run it (macOS 14+ with the Xcode command-line tools)

```bash
swiftc -O sfexport.swift -o sfexport
```

```bash
./sfexport medium "house.fill,ev.plug.dc.ccs2,wallet.pass" > medium.json
```

```bash
python3 sf_to_figma.py medium.json figma_medium.json sheet.svg
```

Check a name exists first: the names are in `/System/Library/CoreServices/CoreGlyphs.bundle/Contents/Resources/name_availability.plist`. For example, there is no `calendar.fill`.

## Into Figma

For each symbol, build a 24×24 component named `Icon / <sf name>` holding one vector:

- **Layers without `k`:** add each as a path, keeping its winding rule.
- **Layers with `k` (cut-outs):** first give the temporary vectors a fill and no stroke, otherwise flatten outlines the default stroke. Then run `figma.subtract([base, ...knockouts])` and `figma.flatten`. Add the result's paths, shifted by the flattened node's x/y.
- **Fill:** bind to `icon/primary` and set the constraints to Scale.
- **Description:** put the SF name plus the Material Symbols Rounded equivalent.

To change an existing icon, replace the **vector inside it** (`vectorPaths`) rather than the component. Instances then keep their colour overrides.

## Licence

SF Symbols may only be used in mock-ups and in apps for Apple platforms.

- **iOS:** the app uses `UIImage(systemName:)` natively, so no exported vectors ship.
- **Android:** use Material Symbols Rounded, mapped in each icon's description.
- **EV plug symbols** (Type 2, CCS2, GB/T) have no Material equivalent, so Android needs custom SVGs.
- **Never bundle these exported vectors into the Android build.**
