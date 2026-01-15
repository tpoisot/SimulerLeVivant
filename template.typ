#set page(
  paper: "us-letter",
  margin: (left: 5cm, right: 5cm, y: 3.5cm),
)
#set par(
  justify: true,
  leading: 0.52em,
)

#set text(font: "Libertinus Serif", size: 12pt)
#show heading: set text(font: "Libertinus Sans")
#show math.equation: set text(font: "Libertinus Math")
#show raw: set text(font: "Iosevka Custom", size: 10.5pt) 
#show raw.where(block: true): it => block(
  fill: luma(95%),
  inset: 10pt,
  width: 100%,
  radius: 3pt,
  stroke: 1pt + luma(80%),
  text(fill: luma(20%), size: 8pt, it)
)

#text(fill: luma(70), font: "Libertinus Sans", size: 15pt)[BIO2045 -- $title$]
#linebreak()
#text(fill: luma(20), font: "Libertinus Sans", size: 20pt)[$topic$]

#v(2em)

#outline(
  title: "Contenu",
  depth: 2
);

#v(2em)

$body$