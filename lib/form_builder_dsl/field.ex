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
    options: [],
    required: false,
    default: nil,
    validations: [],
    disabled: false
  ]
end
