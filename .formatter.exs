# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [
    # Form definition
    form: 2,
    defenum: 2,

    # Text inputs
    text: 1,
    text: 2,
    email: 1,
    email: 2,
    password: 1,
    password: 2,
    number: 1,
    number: 2,
    tel: 1,
    tel: 2,
    url: 1,
    url: 2,
    search: 1,
    search: 2,

    # Date and time inputs
    date: 1,
    date: 2,
    time: 1,
    time: 2,
    date_time: 1,
    date_time: 2,
    month: 1,
    month: 2,
    week: 1,
    week: 2,

    # Selection inputs
    select: 1,
    select: 2,
    multi_select: 1,
    multi_select: 2,
    radio: 1,
    radio: 2,
    checkbox: 1,
    checkbox: 2,
    switch: 1,
    switch: 2,

    # File inputs
    file: 1,
    file: 2,
    image: 1,
    image: 2,

    # Special inputs
    color: 1,
    color: 2,
    range: 1,
    range: 2,
    hidden: 1,
    hidden: 2
  ]
]
