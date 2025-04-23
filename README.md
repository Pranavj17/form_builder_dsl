# FormBuilderDSL

A clean, minimal, and extensible DSL for defining structured, dynamic forms in Elixir.

FormBuilderDSL helps teams write intuitive, maintainable forms with metadata structures that can power:

- Web-based LiveView and HTML rendering
- JSON-serializable form schemas for APIs
- Dynamic admin and internal tool UIs

---

## ✨ Features

- Declarative definitions for form fields
- Support for all common form input types
- Reusable `defenum/2` macro for dropdown/select support
- Generates metadata as `FormBuilderDSL.Field` structs
- Runtime-safe enum management using `ETS`
- Clean rendering logic that plays well with Phoenix Components
- Comprehensive validation support
- Default values and field attributes
- Form context and state management

---

## 🧪 Examples

### Basic Form

```elixir
defmodule MyForm do
  use FormBuilderDSL

  defenum :status, [:approved, :rejected, :pending]

  form :user do
    text :name
    email(:email)
    password(:password)
    select :status, options: status_labeled_options()
  end
end
```

### Form with Validations

```elixir
defmodule UserForm do
  use FormBuilderDSL

  form :user do
    text :name, required: true, validations: [min_length: 3, max_length: 50]
    email(:email, required: true, validations: [format: :email])
    number(:age, required: true, validations: [min: 18, max: 100])
    select :role, required: true, options: role_labeled_options()
  end
end

# Using the form with validation
form = UserForm.fields()
context = FormBuilderDSL.Context.new(:user, form)

# Validate the form
context = FormBuilderDSL.Context.validate(context)

# Check for errors
if FormBuilderDSL.Context.valid?(context) do
  # Form is valid, process the data
  values = context.values
else
  # Form has errors
  errors = context.errors
end
```

### Advanced Form with All Input Types

```elixir
defmodule ProductForm do
  use FormBuilderDSL

  defenum :categories, [:tech, :science, :arts]

  form :product do
    # Text inputs
    text :name, required: true, placeholder: "Enter product name"
    email(:contact_email, required: true)
    password(:admin_password)
    number(:price, min: 0, max: 1000, step: 0.01)
    tel(:phone_number)
    url(:website)
    search(:keywords)

    # Date and time inputs
    date(:release_date)
    time(:available_time)
    date_time :last_updated
    month(:target_month)
    week(:target_week)

    # Selection inputs
    select :category, options: categories_labeled_options()
    multi_select(:tags, options: categories_labeled_options())
    radio(:status, options: status_labeled_options())
    checkbox(:featured)
    switch(:active)

    # File inputs
    file(:document, accept: ".pdf,.doc,.docx")
    image(:product_image)

    # Special inputs
    color(:theme_color)
    range(:rating, min: 1, max: 5, step: 1)
    hidden(:internal_id)
  end
end
```

### Form with Default Values

```elixir
defmodule SettingsForm do
  use FormBuilderDSL

  form :settings do
    text :name, default: "John Doe"
    email(:email, default: "john@example.com")
    select :role, default: "user", options: role_labeled_options()
  end
end
```

### Form with Disabled Fields

```elixir
defmodule ReadOnlyForm do
  use FormBuilderDSL

  form :user do
    text :name, disabled: true
    email(:email, disabled: true)
    select :role, disabled: true, options: role_labeled_options()
  end
end
```

### Validation Rules

The DSL supports various validation rules:

```elixir
form :user do
  # Required field
  text :name, required: true

  # String length validations
  text :description, validations: [min_length: 10, max_length: 1000]

  # Numeric range validations
  number :age, validations: [min: 18, max: 100]

  # Email format validation
  email :email, validations: [format: :email]

  # Value inclusion validation
  select :role, validations: [in: ["admin", "user", "guest"]]
end
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
    date_time: 2,
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
    date: 1,
    date: 2,
    time: 1,
    time: 2,
    month: 1,
    month: 2,
    week: 1,
    week: 2,
    multi_select: 1,
    multi_select: 2,
    radio: 1,
    radio: 2,
    checkbox: 1,
    checkbox: 2,
    switch: 1,
    switch: 2,
    file: 1,
    file: 2,
    image: 1,
    image: 2,
    color: 1,
    color: 2,
    range: 1,
    range: 2,
    hidden: 1,
    hidden: 2
  ]
]
```

> This tells the formatter not to wrap parentheses around common DSL macros.

---

## 📄 License

MIT © Pranav J