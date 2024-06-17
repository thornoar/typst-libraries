// Positioning
#let centering(shallow: true) = content => {
  if shallow { stack(dir: ltr, spacing: 1fr, [], content, []) } else { align(center)[ #content ] }
}
#let mfrac(a, b) = move(a, dy: -0.2em) + "/" + move(b, dy: 0.2em, dx: -0.1em)
#let vphantom(size) = box(height: size, width: 0pt, [])
#let hphantom(size) = box(height: 0pt, width: size, [])

// Colors
#let palered = rgb("#ffc0c0")
#let palegreen = rgb("#c0ffc0")
#let paleblue = rgb("#c0c0ff")
#let paleyellow = rgb("#ffffc0")
#let palemagenta = rgb("#ffc0ff")
#let palecyan = rgb("#c0ffff")
#let palegray = rgb("#f3f3f3")

// Math
#let circ = math.circle.stroked.tiny
#let hs = h(5pt)
#let lle = math.lt.eq.slant
#let gge = math.gt.eq.slant

// Templates
#let attention(
  body,
  title: [*ATTENTION*],
  font: auto,
  color: red,
  stroke: 0.5pt,
  centering: false
) = context {
  let blockinset = text.size + 2pt
  let blockfont = font
  if (font == auto) {
    blockfont = "Noto Sans"
  } else if (font == none) {
    blockfont = text.font
  }
  let titleshift = text.size / 2
  let titlemargin = text.size / 6
  let res = block(
    above: 2em,
    stroke: stroke + color,
    inset: blockinset,
    {
      set text(font: blockfont, fill: color)
      place(
        top + left,
        dy: -titleshift - blockinset,
        dx: titleshift - blockinset,
        block(fill: white, inset: titlemargin, strong(upper(title)))
      )
      body
    }
  )
  if centering {
    stack(dir: ltr, spacing: 1fr, [], res, [])
  } else {
    res
  }
}

#let skew(angle, body, vscale: 1) = {
  let (a,b,c,d)= (1,vscale*calc.tan(angle),0,vscale)
  let E = (a + d)/2
  let F = (a - d)/2
  let G = (b + c)/2
  let H = (c - b)/2
  let Q = calc.sqrt(E*E + H*H)
  let R = calc.sqrt(F*F + G*G)
  let sx = Q + R
  let sy = Q - R
  let a1 = calc.atan2(F,G)
  let a2 = calc.atan2(E,H)
  let theta = (a2 - a1) /2
  let phi = (a2 + a1)/2

  set rotate(origin: bottom+center)
  set scale(origin: bottom+center)

  rotate(phi,scale(x: sx*100%, y: sy*100%,rotate(theta,body)))
}

#let namedgaps(
  names,
  length: 10em,
  stroke: 0.5pt,
  row-gutter: 1em,
  column-gutter: .5em,
  shift: auto
) = {
  if shift == auto { shift = row-gutter / 5 }
  let gap = align(bottom, move(dy: shift, line(length: length, stroke: stroke)))
  grid(
    columns: 2,
    rows: names.len(),
    row-gutter: row-gutter,
    column-gutter: column-gutter,
    align: (right, left),
    ..names.map(name => (name+[:], gap)).flatten()
  )
}
