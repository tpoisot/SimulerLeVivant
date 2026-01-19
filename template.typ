#set page(
  paper: "us-letter",
  margin: (left: 3cm, right: 7cm, y: 3.5cm),
  header: align(
    right + horizon,
    text(font: "Libertinus Sans", fill: luma(40%), size: 8pt)[BIO2045 - $topic$],
  ),
  numbering: "1 de 1"
)
#set par(
  justify: false,
  leading: 0.52em,
)

#set text(font: "Libertinus Serif", size: 12pt)
#show heading: set text(font: "Libertinus Sans")
#show math.equation: set text(font: "Libertinus Math")
#show raw: set text(font: "JuliaMono", size: 9.8pt)
#show raw.where(block: false): set text(fill: maroon)
#show raw.where(block: true, lang: "julia"): it => block(
  fill: luma(97%),
  inset: 9pt,
  width: 100%,
  radius: 1pt,
  stroke: 0.2pt + luma(40%),
  text(fill: luma(20%), size: 8pt, it)
)
#show raw.where(block: true, lang: none): it => block(
  fill: luma(99%),
  inset: 9pt,
  width: 100%,
  radius: 1pt,
  stroke: 0.2pt + luma(80%),
  text(fill: luma(20%), size: 8pt, it)
)
#show raw.where(block: true, lang: "raw"): it => block(
  fill: luma(97%),
  inset: 9pt,
  width: 100%,
  radius: 1pt,
  stroke: (paint: maroon, thickness: 0.2pt, dash: "dashed"),
  text(fill: maroon, size: 8pt, it)
)

#show link: set text(font: "Libertinus Sans", fill: blue)

#show heading.where(level: 2): set text(weight: 400)

#text(fill: luma(70), font: "Libertinus Sans", size: 15pt)[BIO2045 -- $title$]
#linebreak()
#text(fill: luma(20), font: "Libertinus Sans", size: 20pt)[$topic$]
#line(length: 100%, stroke: 0.2pt + black)

#v(3em)


#outline(
  title: "Contenu",
  depth: 2
);

#v(3em)

$body$