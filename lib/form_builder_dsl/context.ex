defmodule FormBuilderDSL.Context do
  @moduledoc """
  Provides form context and state management.

  This module helps manage form state, including:
  - Field values
  - Validation errors
  - Form submission state
  - Field dependencies
  """

  defstruct [
    :form_name,
    :fields,
    :values,
    :errors,
    :submitted,
    :dependencies
  ]

  @type t :: %__MODULE__{
          form_name: atom(),
          fields: [FormBuilderDSL.Field.t()],
          values: map(),
          errors: map(),
          submitted: boolean(),
          dependencies: map()
        }

  @doc """
  Creates a new form context.

  ## Parameters

    - `form_name` - The name of the form
    - `fields` - List of field definitions
    - `opts` - Additional options

  ## Options

    - `:values` - Initial field values
    - `:dependencies` - Field dependencies
  """
  def new(form_name, fields, opts \\ []) do
    %__MODULE__{
      form_name: form_name,
      fields: fields,
      values: Keyword.get(opts, :values, %{}),
      errors: %{},
      submitted: false,
      dependencies: Keyword.get(opts, :dependencies, %{})
    }
  end

  @doc """
  Updates a field value in the form context.

  ## Parameters

    - `context` - The form context
    - `field` - The field key
    - `value` - The new value
  """
  def update_value(context, field, value) do
    %{context | values: Map.put(context.values, field, value)}
  end

  @doc """
  Validates all fields in the form context.

  ## Parameters

    - `context` - The form context

  ## Returns

    - Updated context with validation errors
  """
  def validate(context) do
    errors =
      context.fields
      |> Enum.map(fn field ->
        case FormBuilderDSL.Validations.validate(
               Map.get(context.values, field.key),
               field.validations
             ) do
          :ok -> nil
          {:error, reason} -> {field.key, reason}
        end
      end)
      |> Enum.reject(&is_nil/1)
      |> Map.new()

    %{context | errors: errors, submitted: true}
  end

  @doc """
  Checks if the form is valid.

  ## Parameters

    - `context` - The form context

  ## Returns

    - `true` if the form has no errors
    - `false` otherwise
  """
  def valid?(context) do
    map_size(context.errors) == 0
  end

  @doc """
  Gets the error message for a field.

  ## Parameters

    - `context` - The form context
    - `field` - The field key

  ## Returns

    - Error message if the field has an error
    - `nil` if the field has no error
  """
  def error_for(context, field) do
    Map.get(context.errors, field)
  end

  @doc """
  Checks if a field has an error.

  ## Parameters

    - `context` - The form context
    - `field` - The field key

  ## Returns

    - `true` if the field has an error
    - `false` otherwise
  """
  def has_error?(context, field) do
    Map.has_key?(context.errors, field)
  end
end
