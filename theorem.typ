// Theorems support

#import "@preview/ctheorems:1.1.2": thmrules, thmenv, thmproof

#let thmstyle(
  identifier,
  head,
  supplement: auto,
  numbering: "1.1.",
  refnumbering: "1.1",
  titlefmt: strong,
  namefmt: x => [ (#x):],
  bodyfmt: x => x,
  separator: h(0.2em),
  base: "heading",
  base_level: none,
  ..blockargs
) = {
  if (head == auto) { head = upper([#identifier.first()]) + identifier.slice(1, identifier.len()) }
  if (supplement == auto) { supplement = head }

  let fmt(name, number, body, title: auto) = {
    if (name != none) { name = namefmt(name) } else { name = [] }
    if (title == auto) { title = head }
    if (number != none) { title += " " + number }

    title = titlefmt(title)
    body = bodyfmt(body)

    block(
      width: 100%,
      breakable: true,
      ..blockargs.named(),
      [#title#name#separator#body]
    )
  }

  return thmenv(
    identifier,
    base,
    base_level,
    fmt
  ).with(
    supplement: supplement,
    numbering: numbering,
    refnumbering: refnumbering
  )
}

#let plainstyle(identifier, head) = thmstyle(identifier, head)
#let statestyle(identifier, head) = thmstyle(identifier, head, bodyfmt: emph)
#let proofstyle(identifier, head) = thmproof(
  identifier,
  head,
  inset: (left: 10pt, bottom: 2pt),
  radius: 0pt,
  stroke: (left: black),
  separator: [_:_#h(0.2em)]
)

#let blockstyle(inset: 10pt, radius: 10pt, stroke: black, ..args) = thmstyle.with(
  inset: inset,
  radius: radius,
  stroke: stroke,
  ..args
)

#let def = plainstyle("definition", "Definition")
#let exam = plainstyle("example", "Example")
#let exer = plainstyle("exercise", "Exercise")

#let th = statestyle("theorem", "Theorem")
#let lm = statestyle("lemma", "Lemma")
#let prop = statestyle("proposition", "Proposition")
#let cor = statestyle("corollary", "Corollary")
#let prb = statestyle("problem", "Problem")

#let pf = proofstyle("proof", "Proof")

#let theorem = doc => {
  show: thmrules.with(qed-symbol: $square.filled.medium$)
  show link: underline
  doc
}
