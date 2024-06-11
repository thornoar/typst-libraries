#import "@preview/wrap-it:0.1.0": *
#import "@preview/wordometer:0.1.2": total-words, word-count
#import "@preview/equate:0.1.0": equate
#import "@preview/quick-maths:0.1.0": shorthands

// Layout

#let font = "TeX Gyre Schola"
#let pagecount(format) = doc => {
  set page(numbering: format)
  counter(page).update(1)
  doc
}
#let mtxt(str) = [ #set text(font: font); #text(str) ]

#let preamble(wordometerargs: ()) = doc => {
  set page("a4", margin: (x: 0.7in, y: 1in))
  set text(12pt, font: font)
  set par(justify: true, leading: 0.5em)

  set math.equation(numbering: "(1.1)", supplement: "Equation")
  show: equate.with(sub-numbering: false, number-mode: "label")
  show: shorthands.with(
    ($>=$, math.gt.eq.slant),
    ($<=$, math.lt.eq.slant)
  )

  show ref: underline
  show link: it => {
    if (type(it.dest) == str) {
      set text(blue)
      it
    } else { it }
  }

  set heading(numbering: "1.1.")
  set outline(indent: auto, fill: repeat([.#h(3pt)]))
  set figure(gap: 1.5em)

  show: word-count.with(..wordometerargs)

  doc
}

// Templates

#let title(
  downstep: 0pt,
  title,
  author: "Roman Maksimovich",
  titlefunction : none,
  keywords: (),
  keywordsfunction: none,
  keywordlength: auto,
  abstract: none,
  abstractfunction: none,
  logo: none,
  date: datetime.today(),
  format: "[month repr:long] [day], [year]",
  index: true,
  indextitle: "Contents",
  index-of-figures: false,
  figurestitle: "Index of Figures",
  index-of-tables: false,
  tablestitle: "Index of Tables",
  index-of-listings: false,
  listingstitle: "Index of Listings",
  pagenumbering: "1"
) = doc => {
  context {
    let fontsize = text.size
    v(downstep)
    set par(first-line-indent: 0pt)
    
    if (titlefunction != none) {
      titlefunction(title, author)
    } else {
      set par(justify: false)
      text(size: 2*fontsize+1pt, strong(title))
      linebreak(); linebreak()
      text(size: fontsize+5pt, author)
    }

    v(1fr)

    if (keywords.len() > 0) {
      if (keywordsfunction != none) {
        keywordsfunction(keywords)
      }
      else {
        let rownum = calc.ceil(calc.sqrt(keywords.len()))
        let colnum = calc.ceil(keywords.len() / rownum)
        let len = keywordlength
        if (len == auto) { len = calc.min(100%, colnum*25%) }

        text(size: fontsize+2pt, strong([ Keywords ])); linebreak()
        line(start: (-2.5%, 0pt), length: len + 5%)
        block(width: len, columns(colnum, gutter: 1em, {
          let count = 0
          for keyword in keywords {
            if (count >= rownum) { colbreak(); count = 0 }
            text(keyword); linebreak(); //linebreak()// text(", ")
            count += 1
          }
        }))
      }
    }

    v(1fr)

    if (abstract != none) {
      if (abstractfunction != none) {
        abstractfunction(abstract)
      }
      else {
        set par(first-line-indent: 0pt)

        text(size: fontsize+2pt, strong([ Abstract ])); linebreak()
        align(center, line(length: 105%))
        abstract
        align(center, line(length: 105%))
        v(1em)
      }
    }

    if (logo != none) {
      align(center)[
        #logo
        #date.display(format)
      ]
    }
  }

  pagebreak()

  set page(numbering: pagenumbering)

  context {
    let hascontents = false
    if index and (query(heading).len() > 0) {
      show outline.entry.where(level: 1): it => {
        v(1em, weak: true)
        strong(it)
      }
      outline(title: indextitle, target: heading)
      hascontents = true
    }
    v(1fr)
    if index-of-figures and (query(figure.where(kind: image)).len() > 0) {
      outline(title: figurestitle, target: figure.where(kind: image))
      hascontents = true
    }
    v(1fr)
    if index-of-tables and (query(selector(figure.where(kind: table))).len() > 0) {
      outline(title: tablestitle, target: figure.where(kind: table))
      hascontents = true
    }
    v(1fr)
    if index-of-listings and (query(selector(figure.where(kind: raw))).len() > 0) {
      outline(title: listingstitle, target: figure.where(kind: raw))
      hascontents = true
    }
    if hascontents { pagebreak() }
  }

  doc
}

#let clean-numbering(..schemes) = {
  (..nums) => {
    let (section, ..subsections) = nums.pos()
    let (section_scheme, ..subschemes) = schemes.pos()

    if subsections.len() == 0 {
      numbering(section_scheme, section)
    } else if subschemes.len() == 0 {
      numbering(section_scheme, ..nums.pos())
    }
    else {
      clean-numbering(..subschemes)(..subsections)
    }
  }
}
