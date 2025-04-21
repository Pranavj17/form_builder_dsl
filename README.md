# FormBuilderDSL

A clean, minimal, and extensible DSL for defining structured, dynamic forms in Elixir.

FormBuilderDSL helps teams write intuitive, maintainable forms with metadata structures that can power:

- Web-based LiveView and HTML rendering
- JSON-serializable form schemas for APIs
- Dynamic admin and internal tool UIs

---

## ✨ Features

- Declarative definitions for form fields
- Reusable `defenum/2` macro for dropdown/select support
- Generates metadata as `FormBuilderDSL.Field` structs
- Support for text and select inputs (more coming!)
- Runtime-safe enum management using `ETS`
- Clean rendering logic that plays well with Phoenix Components

---

## 🧪 Example

```elixir
defmodule MyForm do
  use FormBuilderDSL

  defenum :status, [:approved, :rejected, :pending]

  form :user do
    text :name
    select :status, options: status_labeled_options()
  end
end
```

```Output
  [
    %FormBuilderDSL.Field{
      key: :status,
      label: "Status",
      placeholder: false,
      type: :select,
      options: [
        {"Approved", "approved"},
        {"Rejected", "rejected"},
        {"Pending", "pending"}
      ],
      required: false,
      default: false,
      validations: false,
      disabled: false
    },
    %FormBuilderDSL.Field{
      key: :id,
      label: "Id",
      placeholder: false,
      type: :text,
      options: [],
      required: false,
      default: false,
      validations: false,
      disabled: false
    }
  ]
```

---

## 📦 Installation

Add the dependency to your `mix.exs`:

```elixir
def deps do
  [
    {:form_builder_dsl, "~> 0.1.0"}
  ]
end
```

Then run:

```bash
mix deps.get
```

---

### 🛠 Optional: Add Formatter Settings

To keep the DSL syntax clean and bracket-free, add the following to your `.formatter.exs`:

```elixir
[
  import_deps: [:form_builder_dsl],
  locals_without_parens: [
    form: 2,
    defenum: 2,
    text: 1,
    text: 2,
    select: 1,
    select: 2,
    date_time: 1,
    date_time: 2
  ]
]
```

> This tells the formatter not to wrap parentheses around common DSL macros.

---

## 📄 License

MIT © Pranav J