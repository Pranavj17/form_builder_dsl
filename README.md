# FormBuilderDSL

A clean, minimal DSL for defining complex, dynamic forms in Elixir.

This library allows developers to:

- Declaratively define text, select, checkbox fields, and more
- Register and reuse enums
- Automatically generate form metadata using structs
- Extend input behavior with validations, options, conditions, and dynamic rendering
- Use in LiveView, traditional views, APIs, or internal admin tools

## Example

```elixir
defmodule MyForm do
  use FormBuilderDSL

  defenum :status, [:active, :inactive, :archived]

  form :user do
    text_field :name
    select_field :status, options: status_labeled_options()
  end
end