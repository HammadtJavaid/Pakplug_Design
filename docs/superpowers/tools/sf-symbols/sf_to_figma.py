"""Turn sfexport output into 24pt-frame path data for Figma icon components.

Usage: python3 sf_to_figma.py medium.json figma_medium.json [contact_sheet.svg]

Every symbol is drawn at one optical size (~20.6pt) and centred in a 24x24 frame.
Very wide symbols are scaled down to fit a 22.5pt box. Each layer is
{"d": path, "r": "NONZERO"|"EVENODD", "k": [knockouts]}; layers with knockouts
need a boolean subtract in Figma (base minus knockouts, then flatten).
"""
import json, re, sys

SCALE, MAX_DIM, FRAME = 0.206, 22.5, 24

def points(d):
    nums = [float(x) for x in re.findall(r'-?\d+\.?\d*', d)]
    return list(zip(nums[0::2], nums[1::2]))

def bbox(sym):
    pts = [p for layer in sym['layers'] for p in points(layer['d'])]
    xs, ys = [p[0] for p in pts], [p[1] for p in pts]
    return min(xs), min(ys), max(xs), max(ys)

def tight(s):
    s = re.sub(r'(\.\d*?)0+(?=[ ]|$)', r'\1', s)
    return re.sub(r'\.(?=[ ]|$)', '', s)

def to_frame(d, s, tx, ty):
    out, toks, i = [], re.findall(r'[MLCZ]|-?\d+\.?\d*', d), 0
    while i < len(toks):
        if toks[i] in 'MLCZ':
            out.append(toks[i]); i += 1
        else:
            out.append(f"{float(toks[i]) * s + tx:.2f} {float(toks[i + 1]) * s + ty:.2f}"); i += 2
    return tight(' '.join(out))

def convert(sym):
    x0, y0, x1, y1 = bbox(sym)
    w, h = x1 - x0, y1 - y0
    s = min(SCALE, MAX_DIM / max(w, h))
    tx, ty = (FRAME - w * s) / 2 - x0 * s, (FRAME - h * s) / 2 - y0 * s
    rule = lambda r: 'EVENODD' if r == 'evenodd' else 'NONZERO'
    return [{'d': to_frame(l['d'], s, tx, ty), 'r': rule(l['rule']),
             'k': [{'d': to_frame(k[0], s, tx, ty), 'r': rule(k[1])} for k in l['knockouts']]}
            for l in sym['layers']]

def contact_sheet(converted, path, cols=8, zoom=3):
    cell = FRAME * zoom
    body = []
    for i, (name, layers) in enumerate(converted.items()):
        gx, gy = 20 + (i % cols) * (cell + 90), 20 + (i // cols) * (cell + 34)
        g = []
        for j, l in enumerate(layers):
            mid = f"m{i}_{j}"
            if l['k']:
                g.append(f'<mask id="{mid}" maskUnits="userSpaceOnUse" x="0" y="0" width="24" height="24"><rect width="24" height="24" fill="#fff"/>'
                         + ''.join(f'<path d="{k["d"]}" fill-rule="{k["r"].lower()}"/>' for k in l['k']) + '</mask>')
                g.append(f'<path d="{l["d"]}" fill-rule="{l["r"].lower()}" mask="url(#{mid})"/>')
            else:
                g.append(f'<path d="{l["d"]}" fill-rule="{l["r"].lower()}"/>')
        body.append(f'<g transform="translate({gx} {gy}) scale({zoom})"><rect width="24" height="24" fill="#EEF6F1"/>{"".join(g)}</g>'
                    f'<text x="{gx}" y="{gy + cell + 14}" font-family="Helvetica" font-size="10" fill="#555">{name}</text>')
    rows = (len(converted) + cols - 1) // cols
    W, H = cols * (cell + 90) + 40, rows * (cell + 34) + 40
    open(path, 'w').write(f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}"><rect width="100%" height="100%" fill="#fff"/>{"".join(body)}</svg>')

if __name__ == '__main__':
    src, dst = sys.argv[1], sys.argv[2]
    converted = {sym['name']: convert(sym) for sym in json.load(open(src))}
    json.dump(converted, open(dst, 'w'), separators=(',', ':'))
    if len(sys.argv) > 3:
        contact_sheet(converted, sys.argv[3])
    print(f"{len(converted)} symbols -> {dst}")
