import SwiftUI
import AppKit
import CoreGraphics

// SF Symbol -> vector layers. Each filled path may carry knockout shapes (from SMask soft masks),
// which Figma subtracts with a boolean op.
final class Walker {
  var ctm = CGAffineTransform.identity
  var stack: [(CGAffineTransform, [[String]])] = []
  var cur = ""; var cp = CGPoint.zero
  var lum: CGFloat = 0
  var mask: [[String]] = []           // knockout paths active for subsequent fills
  var out: [[String: Any]] = []       // main: {d, rule, knockouts}; mask walker: {d, rule, lum}
  var warnings = Set<String>()
  let isMask: Bool
  init(isMask: Bool) { self.isMask = isMask }
  func t(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x, y: y).applying(ctm) }
  func f(_ p: CGPoint) -> String { String(format: "%.3f %.3f", p.x, p.y) }
  func emit(_ evenOdd: Bool) {
    if !cur.isEmpty {
      if isMask { out.append(["d": cur, "rule": evenOdd ? "evenodd" : "nonzero", "lum": Double(lum)]) }
      else { out.append(["d": cur, "rule": evenOdd ? "evenodd" : "nonzero", "knockouts": mask]) }
    }
    cur = ""
  }
}
func pop(_ s: CGPDFScannerRef, _ n: Int) -> [CGFloat] {
  var v = [CGFloat](repeating: 0, count: n)
  for i in stride(from: n - 1, through: 0, by: -1) { var x: CGPDFReal = 0; CGPDFScannerPopNumber(s, &x); v[i] = x }
  return v
}
func W(_ info: UnsafeMutableRawPointer?) -> Walker { Unmanaged<Walker>.fromOpaque(info!).takeUnretainedValue() }
func matrix(_ d: CGPDFDictionaryRef) -> CGAffineTransform {
  var arr: CGPDFArrayRef? = nil
  guard CGPDFDictionaryGetArray(d, "Matrix", &arr), let a = arr else { return .identity }
  var v = [CGFloat](repeating: 0, count: 6)
  for i in 0..<6 { var x: CGPDFReal = 0; CGPDFArrayGetNumber(a, i, &x); v[i] = x }
  return CGAffineTransform(a: v[0], b: v[1], c: v[2], d: v[3], tx: v[4], ty: v[5])
}
var table: CGPDFOperatorTableRef! = nil
func scanForm(_ stream: CGPDFStreamRef, parent: CGPDFContentStreamRef, walker: Walker) {
  let sd = CGPDFStreamGetDictionary(stream)!
  var res: CGPDFDictionaryRef? = nil
  CGPDFDictionaryGetDictionary(sd, "Resources", &res)
  let saved = walker.ctm
  walker.ctm = matrix(sd).concatenating(walker.ctm)
  let cs = CGPDFContentStreamCreateWithStream(stream, res ?? sd, parent)
  let sc = CGPDFScannerCreate(cs, table, Unmanaged.passUnretained(walker).toOpaque())
  CGPDFScannerScan(sc)
  walker.ctm = saved
}
table = CGPDFOperatorTableCreate()!
CGPDFOperatorTableSetCallback(table, "q") { _, i in let w = W(i); w.stack.append((w.ctm, w.mask)) }
CGPDFOperatorTableSetCallback(table, "Q") { _, i in let w = W(i); if let c = w.stack.popLast() { w.ctm = c.0; w.mask = c.1 } }
CGPDFOperatorTableSetCallback(table, "cm") { s, i in let w = W(i); let v = pop(s, 6); w.ctm = CGAffineTransform(a: v[0], b: v[1], c: v[2], d: v[3], tx: v[4], ty: v[5]).concatenating(w.ctm) }
CGPDFOperatorTableSetCallback(table, "m") { s, i in let w = W(i); let v = pop(s, 2); w.cp = CGPoint(x: v[0], y: v[1]); w.cur += "M" + w.f(w.t(v[0], v[1])) + " " }
CGPDFOperatorTableSetCallback(table, "l") { s, i in let w = W(i); let v = pop(s, 2); w.cp = CGPoint(x: v[0], y: v[1]); w.cur += "L" + w.f(w.t(v[0], v[1])) + " " }
CGPDFOperatorTableSetCallback(table, "c") { s, i in let w = W(i); let v = pop(s, 6); w.cur += "C" + w.f(w.t(v[0], v[1])) + " " + w.f(w.t(v[2], v[3])) + " " + w.f(w.t(v[4], v[5])) + " "; w.cp = CGPoint(x: v[4], y: v[5]) }
CGPDFOperatorTableSetCallback(table, "v") { s, i in let w = W(i); let v = pop(s, 4); w.cur += "C" + w.f(w.t(w.cp.x, w.cp.y)) + " " + w.f(w.t(v[0], v[1])) + " " + w.f(w.t(v[2], v[3])) + " "; w.cp = CGPoint(x: v[2], y: v[3]) }
CGPDFOperatorTableSetCallback(table, "y") { s, i in let w = W(i); let v = pop(s, 4); w.cur += "C" + w.f(w.t(v[0], v[1])) + " " + w.f(w.t(v[2], v[3])) + " " + w.f(w.t(v[2], v[3])) + " "; w.cp = CGPoint(x: v[2], y: v[3]) }
CGPDFOperatorTableSetCallback(table, "h") { _, i in W(i).cur += "Z " }
CGPDFOperatorTableSetCallback(table, "re") { s, i in let w = W(i); let v = pop(s, 4); let (x, y, ww, hh) = (v[0], v[1], v[2], v[3]); w.cur += "M" + w.f(w.t(x, y)) + " L" + w.f(w.t(x + ww, y)) + " L" + w.f(w.t(x + ww, y + hh)) + " L" + w.f(w.t(x, y + hh)) + " Z " }
for op in ["f", "F", "b", "B"] { CGPDFOperatorTableSetCallback(table, op) { _, i in W(i).emit(false) } }
for op in ["f*", "b*", "B*"] { CGPDFOperatorTableSetCallback(table, op) { _, i in W(i).emit(true) } }
CGPDFOperatorTableSetCallback(table, "n") { _, i in W(i).cur = "" }
CGPDFOperatorTableSetCallback(table, "W") { _, i in W(i).warnings.insert("clip") }
CGPDFOperatorTableSetCallback(table, "W*") { _, i in W(i).warnings.insert("clip") }
for op in ["S", "s"] { CGPDFOperatorTableSetCallback(table, op) { _, i in W(i).warnings.insert("stroke"); W(i).cur = "" } }
for op in ["sc", "scn", "g", "rg"] { CGPDFOperatorTableSetCallback(table, op) { s, i in
  var comps: [CGFloat] = []; var x: CGPDFReal = 0
  while CGPDFScannerPopNumber(s, &x) { comps.append(x) }
  if !comps.isEmpty { W(i).lum = comps.reduce(0, +) / CGFloat(comps.count) } } }
CGPDFOperatorTableSetCallback(table, "Do") { s, i in
  let w = W(i); var name: UnsafePointer<CChar>? = nil
  guard CGPDFScannerPopName(s, &name), let n = name else { return }
  let cs = CGPDFScannerGetContentStream(s)
  guard let obj = CGPDFContentStreamGetResource(cs, "XObject", n) else { w.warnings.insert("xobject?"); return }
  var st: CGPDFStreamRef? = nil
  guard CGPDFObjectGetValue(obj, .stream, &st), let stream = st else { return }
  var sub: UnsafePointer<CChar>? = nil
  CGPDFDictionaryGetName(CGPDFStreamGetDictionary(stream)!, "Subtype", &sub)
  if let sub, String(cString: sub) == "Form" { scanForm(stream, parent: cs, walker: w) } else { w.warnings.insert("image") }
}
CGPDFOperatorTableSetCallback(table, "gs") { s, i in
  let w = W(i); var name: UnsafePointer<CChar>? = nil
  guard CGPDFScannerPopName(s, &name), let n = name else { return }
  let cs = CGPDFScannerGetContentStream(s)
  guard let obj = CGPDFContentStreamGetResource(cs, "ExtGState", n) else { return }
  var gd: CGPDFDictionaryRef? = nil
  guard CGPDFObjectGetValue(obj, .dictionary, &gd), let g = gd else { return }
  var smObj: CGPDFObjectRef? = nil
  guard CGPDFDictionaryGetObject(g, "SMask", &smObj), let sm = smObj else { return }
  var smd: CGPDFDictionaryRef? = nil
  if CGPDFObjectGetValue(sm, .dictionary, &smd), let smDict = smd {
    var gst: CGPDFStreamRef? = nil
    guard CGPDFDictionaryGetStream(smDict, "G", &gst), let groupStream = gst else { w.warnings.insert("smask-noG"); return }
    let mw = Walker(isMask: true); mw.ctm = w.ctm
    scanForm(groupStream, parent: cs, walker: mw)
    w.mask = mw.out.filter { ($0["lum"] as! Double) < 0.5 }.map { [$0["d"] as! String, $0["rule"] as! String] }
    if mw.out.contains(where: { ($0["lum"] as! Double) >= 0.5 }) { w.warnings.insert("mask-white-shapes") }
  } else { w.mask = [] }   // /SMask /None
}

@MainActor func export(_ name: String, _ weight: Font.Weight) -> [String: Any]? {
  guard NSImage(systemSymbolName: name, accessibilityDescription: nil) != nil else { return nil }
  let r = ImageRenderer(content: Image(systemName: name).font(.system(size: 100, weight: weight)).foregroundStyle(.black))
  let data = NSMutableData(); var H: CGFloat = 0; var Wd: CGFloat = 0
  r.render { size, draw in
    var box = CGRect(origin: .zero, size: size); H = size.height; Wd = size.width
    let ctx = CGContext(consumer: CGDataConsumer(data: data as CFMutableData)!, mediaBox: &box, nil)!
    ctx.beginPDFPage(nil); draw(ctx); ctx.endPDFPage(); ctx.closePDF()
  }
  let page = CGPDFDocument(CGDataProvider(data: data as CFData)!)!.page(at: 1)!
  let w = Walker(isMask: false)
  let sc = CGPDFScannerCreate(CGPDFContentStreamCreateWithPage(page), table, Unmanaged.passUnretained(w).toOpaque())
  CGPDFScannerScan(sc)
  let flip = { (d: String) -> String in
    var res = ""; var nums: [Double] = []
    for tok in d.split(separator: " ") {
      if let c = tok.first, c.isLetter { res += String(c); let rest = tok.dropFirst(); if !rest.isEmpty { nums.append(Double(rest)!) } } else { nums.append(Double(tok)!) }
      if nums.count == 2 { res += String(format: "%.3f %.3f ", nums[0], Double(H) - nums[1]); nums = [] }
    }
    return res.trimmingCharacters(in: .whitespaces)
  }
  let layers: [[String: Any]] = w.out.map { l in
    ["d": flip(l["d"] as! String), "rule": l["rule"]!, "knockouts": (l["knockouts"] as! [[String]]).map { [flip($0[0]), $0[1]] }]
  }
  return ["name": name, "w": Double(Wd), "h": Double(H), "layers": layers, "warnings": Array(w.warnings)]
}

let names = CommandLine.arguments[2].split(separator: ",").map(String.init)
let weight: Font.Weight = ["medium": .medium, "semibold": .semibold][CommandLine.arguments[1]] ?? .regular
MainActor.assumeIsolated {
  var res: [[String: Any]] = []
  for n in names { if let s = export(n, weight) { res.append(s) } else { FileHandle.standardError.write("missing \(n)\n".data(using: .utf8)!) } }
  FileHandle.standardOutput.write(try! JSONSerialization.data(withJSONObject: res, options: [.sortedKeys]))
}
