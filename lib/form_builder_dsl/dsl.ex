defmodule FormBuilderDSL.DSL do
  @moduledoc """
  The core DSL module that provides form building capabilities.

  This module provides macros for defining form fields, enums, and form structure.
  It handles the compilation of form definitions into metadata structures that can
  be used for rendering, validation, and serialization.
  """

  alias FormBuilderDSL.Field

  @type field_key :: atom()
  @type field_type :: atom()
  @type field_opts :: keyword()
  @type enum_name :: atom()
  @type enum_values :: [atom()]

  defmacro __using__(_opts) do
    quote do
      import FormBuilderDSL.DSL
      Module.register_attribute(__MODULE__, :fields, accumulate: true)
      Module.register_attribute(__MODULE__, :enums, accumulate: true)
      @before_compile FormBuilderDSL.DSL
    end
  end

  @doc """
  Defines a form with the given name and block of field definitions.

  ## Parameters

    - `name` - The atom name for the form
    - `block` - A block containing field definitions

  ## Example

      form :user do
        text :name
        email(:email)
      end
  """
  defmacro form(name, do: block) do
    quote do
      @form_name unquote(name)
      unquote(block)
    end
  end

  # Text-based inputs
  @doc """
  Defines a text input field.

  ## Parameters

    - `key` - The atom key for the field
    - `opts` - Optional field attributes

  ## Options

    - `:label` - Custom label for the field
    - `:required` - Whether the field is required
    - `:placeholder` - Placeholder text
    - `:default` - Default value
    - `:validations` - List of validation rules
    - `:disabled` - Whether the field is disabled
  """
  defmacro text(key, opts \\ []) do
    define(:text, key, opts)
  end

  defmacro email(key, opts \\ []) do
    define(:email, key, opts)
  end

  defmacro password(key, opts \\ []) do
    define(:password, key, opts)
  end

  defmacro number(key, opts \\ []) do
    define(:number, key, opts)
  end

  defmacro tel(key, opts \\ []) do
    define(:tel, key, opts)
  end

  defmacro url(key, opts \\ []) do
    define(:url, key, opts)
  end

  defmacro search(key, opts \\ []) do
    define(:search, key, opts)
  end

  # Date and time inputs
  defmacro date(key, opts \\ []) do
    define(:date, key, opts)
  end

  defmacro time(key, opts \\ []) do
    define(:time, key, opts)
  end

  defmacro date_time(key, opts \\ []) do
    define(:date_time, key, opts)
  end

  defmacro month(key, opts \\ []) do
    define(:month, key, opts)
  end

  defmacro week(key, opts \\ []) do
    define(:week, key, opts)
  end

  # Selection inputs
  defmacro select(key, opts \\ []) do
    define(:select, key, opts)
  end

  defmacro multi_select(key, opts \\ []) do
    define(:multi_select, key, opts)
  end

  defmacro radio(key, opts \\ []) do
    define(:radio, key, opts)
  end

  defmacro checkbox(key, opts \\ []) do
    define(:checkbox, key, opts)
  end

  defmacro switch(key, opts \\ []) do
    define(:switch, key, opts)
  end

  # File inputs
  defmacro file(key, opts \\ []) do
    define(:file, key, opts)
  end

  defmacro image(key, opts \\ []) do
    define(:image, key, opts)
  end

  # Special inputs
  defmacro color(key, opts \\ []) do
    define(:color, key, opts)
  end

  defmacro range(key, opts \\ []) do
    define(:range, key, opts)
  end

  defmacro hidden(key, opts \\ []) do
    define(:hidden, key, opts)
  end

  @doc """
  Defines an enum with the given name and values.

  ## Parameters

    - `name` - The atom name for the enum
    - `values` - List of atom values for the enum

  ## Example

      defenum :status, [:active, :inactive]

  This will generate:
    - `status_options/0` - Returns list of string values
    - `status_labeled_options/0` - Returns list of {label, value} tuples
  """
  defmacro defenum(name, values) do
    quote bind_quoted: [name: name, values: values] do
      @enums {name, values}

      FormBuilderDSL.EnumRegistry.register(name, values)

      def unquote(:"#{name}_options")() do
        Enum.map(unquote(values), &Atom.to_string/1)
      end

      def unquote(:"#{name}_labeled_options")() do
        Enum.map(unquote(values), fn v ->
          {FormBuilderDSL.DSL.humanize(v), Atom.to_string(v)}
        end)
      end
    end
  end

  @doc """
  Returns the list of fields defined in the form.
  """
  defmacro __before_compile__(_) do
    quote do
      def fields, do: @fields
      def enums, do: @enums
    end
  end

  @doc """
  Converts an atom to a human-readable string.

  ## Parameters

    - `atom` - The atom to convert

  ## Returns

    - A capitalized string with underscores replaced by spaces

  ## Example

      iex> FormBuilderDSL.DSL.humanize(:first_name)
      "First name"
  """
  def humanize(atom) do
    atom
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end

  # Private helper functions
  defp define(type, key, opts) do
    label = Keyword.get(opts, :label, humanize(key))
    options = Keyword.get(opts, :options, [])
    required = Keyword.get(opts, :required, false)
    placeholder = Keyword.get(opts, :placeholder, false)
    default = Keyword.get(opts, :default, false)
    validations = Keyword.get(opts, :validations, false)
    disabled = Keyword.get(opts, :disabled, false)
    min = Keyword.get(opts, :min, false)
    max = Keyword.get(opts, :max, false)
    step = Keyword.get(opts, :step, false)
    accept = Keyword.get(opts, :accept, false)
    multiple = Keyword.get(opts, :multiple, false)

    quote do
      @fields %Field{
        key: unquote(key),
        label: unquote(label),
        type: unquote(type),
        options: unquote(options),
        required: unquote(required),
        placeholder: unquote(placeholder),
        default: unquote(default),
        validations: unquote(validations),
        disabled: unquote(disabled),
        min: unquote(min),
        max: unquote(max),
        step: unquote(step),
        accept: unquote(accept),
        multiple: unquote(multiple)
      }
    end
  end
end
