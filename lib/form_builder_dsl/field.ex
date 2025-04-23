defmodule FormBuilderDSL.Field do
  @moduledoc """
  Metadata struct representing one form input field.
  Used for rendering, validation, introspection, and serialization.
  """

  defstruct [
    :key,
    :label,
    :placeholder,
    :type,
    :min,
    :max,
    :step,
    :accept,
    options: [],
    required: false,
    default: nil,
    validations: [],
    disabled: false,
    multiple: false
  ]
end
