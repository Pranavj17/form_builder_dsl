defmodule FormBuilderDSL.DSL do
  alias FormBuilderDSL.Field

  defmacro __using__(_opts) do
    quote do
      import FormBuilderDSL.DSL
      Module.register_attribute(__MODULE__, :fields, accumulate: true)
      Module.register_attribute(__MODULE__, :enums, accumulate: true)
      @before_compile FormBuilderDSL.DSL
    end
  end

  defmacro form(name, do: block) do
    quote do
      @form_name unquote(name)
      unquote(block)
    end
  end

  defmacro text(key, opts \\ []) do
    define(:text, key, opts)
  end

  defmacro date_time(key, opts \\ []) do
    define(:date_time, key, opts)
  end

  defmacro select(key, opts \\ []) do
    define(:select, key, opts)
  end

  defp define(type, key, opts) do
    label = Keyword.get(opts, :label, humanize(key))
    options = Keyword.get(opts, :options, [])
    required = Keyword.get(opts, :required, false)
    placeholder = Keyword.get(opts, :placeholder, false)
    default = Keyword.get(opts, :default, false)
    validations = Keyword.get(opts, :validations, false)
    disabled = Keyword.get(opts, :disabled, false)

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
        disabled: unquote(disabled)
      }
    end
  end

  defmacro defenum(name, values) do
    quote bind_quoted: [name: name, values: values] do
      @enums {name, values}

      FormBuilderDSL.Enum.register(name, values)

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

  defmacro __before_compile__(_) do
    quote do
      def fields, do: @fields
      def enums, do: @enums
    end
  end

  def humanize(atom) do
    atom
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end
end
