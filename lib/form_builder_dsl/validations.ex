defmodule FormBuilderDSL.Validations do
  @moduledoc """
  Provides validation helpers for form fields.

  This module contains functions for validating form field values based on
  the validation rules defined in the form.
  """

  @doc """
  Validates a field value against its validation rules.

  ## Parameters

    - `value` - The value to validate
    - `validations` - List of validation rules

  ## Returns

    - `:ok` if validation passes
    - `{:error, reason}` if validation fails

  ## Validation Rules

    - `:required` - Value must be present
    - `:min_length` - String must be at least this long
    - `:max_length` - String must be at most this long
    - `:min` - Number must be at least this value
    - `:max` - Number must be at most this value
    - `:format` - Value must match the given format
    - `:in` - Value must be in the given list
  """
  def validate(value, validations) when is_list(validations) do
    Enum.reduce_while(validations, :ok, fn
      {:required, true}, :ok ->
        if present?(value), do: {:cont, :ok}, else: {:halt, {:error, "is required"}}

      {:min_length, min}, :ok ->
        if String.length(to_string(value)) >= min,
          do: {:cont, :ok},
          else: {:halt, {:error, "must be at least #{min} characters"}}

      {:max_length, max}, :ok ->
        if String.length(to_string(value)) <= max,
          do: {:cont, :ok},
          else: {:halt, {:error, "must be at most #{max} characters"}}

      {:min, min}, :ok ->
        if value >= min, do: {:cont, :ok}, else: {:halt, {:error, "must be at least #{min}"}}

      {:max, max}, :ok ->
        if value <= max, do: {:cont, :ok}, else: {:halt, {:error, "must be at most #{max}"}}

      {:format, :email}, :ok ->
        if email?(value), do: {:cont, :ok}, else: {:halt, {:error, "must be a valid email"}}

      {:in, list}, :ok ->
        if value in list,
          do: {:cont, :ok},
          else: {:halt, {:error, "must be one of #{inspect(list)}"}}

      _, :ok ->
        {:cont, :ok}
    end)
  end

  defp present?(nil), do: false
  defp present?(""), do: false
  defp present?(_), do: true

  defp email?(value) when is_binary(value) do
    ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
    |> Regex.match?(value)
  end

  defp email?(_), do: false
end
