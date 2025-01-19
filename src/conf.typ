#let conf(
  title: none,
  authors: (),
  abstract: [],
  doc,
) = {

  set align(center+horizon)
  text(17pt, title)

  let count = authors.len()
  let ncols = calc.min(count, 3)
  grid(
    columns: (1fr,) * ncols,
    row-gutter: 24pt,
    ..authors.map(author => [
      #author.name \
      #link("mailto:" + author.email)
    ]),
  )

  set align(left+top)
  doc
}
