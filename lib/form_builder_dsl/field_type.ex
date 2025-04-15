defmodule FormBuilderDSL.FieldType do
  @moduledoc """
  Field type metadata to describe rendering logic and behavior per type.
  """

  @type t :: atom()

  @field_types %{
    text: %{
      component: :input,
      type: "text",
      html_tag: "input",
      multiple: false
    },
    email: %{
      component: :input,
      type: "email",
      html_tag: "input"
    },
    password: %{
      component: :input,
      type: "password",
      html_tag: "input"
    },
    select: %{
      component: :select,
      html_tag: "select",
      multiple: false,
      supports_options: true
    },
    checkbox: %{
      component: :checkbox,
      html_tag: "input",
      type: "checkbox"
    },
    switch: %{
      component: :switch,
      html_tag: "input",
      toggle_style: true
    },
    file: %{
      component: :file_upload,
      html_tag: "input",
      type: "file"
    }
  }

  @doc "Returns all supported types"
  def all, do: Map.keys(@field_types)

  @doc "Returns true if the type is supported"
  def valid?(type), do: Map.has_key?(@field_types, type)

  @doc "Get metadata associated with a field type"
  def get_config(type), do: Map.get(@field_types, type)
end
