# FormBuilderDSL

A clean, minimal, and extensible DSL for defining structured, dynamic forms in Elixir.

FormBuilderDSL helps teams write intuitive, maintainable forms with metadata structures that can power:
- Web-based LiveView and HTML rendering
- JSON-serializable form schemas for APIs
- Dynamic admin and internal tool UIs

---

## Features

 Declarative definitions for form fields
 Reusable `defenum/2` macro for dropdown/select support
 Generates metadata as `FormBuilderDSL.Field` structs
 Support for text and select inputs (more coming!)
 Runtime-safe enum management using `ETS`
 Clean rendering logic that plays well with Phoenix Components

---

## Example

```elixir
defmodule MyForm do
  use FormBuilderDSL

  defenum :status, [:active, :inactive, :archived]

  form :user do
    text :name
    select :status, options: status_labeled_options()
  end
end