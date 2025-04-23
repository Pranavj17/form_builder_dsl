defmodule FormBuilderDSL.FieldType do
  @moduledoc """
  Field type metadata to describe rendering logic and behavior per type.
  """

  @type t :: atom()

  @field_types %{
    # Text-based inputs
    text: %{
      component: :input,
      type: "text",
      html_tag: "input",
      multiple: false
    },
    email: %{
      component: :input,
      type: "email",
      html_tag: "input",
      multiple: false
    },
    password: %{
      component: :input,
      type: "password",
      html_tag: "input",
      multiple: false
    },
    number: %{
      component: :input,
      type: "number",
      html_tag: "input",
      multiple: false,
      supports_min_max: true,
      supports_step: true
    },
    tel: %{
      component: :input,
      type: "tel",
      html_tag: "input",
      multiple: false
    },
    url: %{
      component: :input,
      type: "url",
      html_tag: "input",
      multiple: false
    },
    search: %{
      component: :input,
      type: "search",
      html_tag: "input",
      multiple: false
    },

    # Date and time inputs
    date: %{
      component: :input,
      type: "date",
      html_tag: "input",
      multiple: false
    },
    time: %{
      component: :input,
      type: "time",
      html_tag: "input",
      multiple: false
    },
    date_time: %{
      component: :input,
      type: "datetime-local",
      html_tag: "input",
      multiple: false
    },
    month: %{
      component: :input,
      type: "month",
      html_tag: "input",
      multiple: false
    },
    week: %{
      component: :input,
      type: "week",
      html_tag: "input",
      multiple: false
    },

    # Selection inputs
    select: %{
      component: :select,
      html_tag: "select",
      multiple: false,
      supports_options: true
    },
    multi_select: %{
      component: :select,
      html_tag: "select",
      multiple: true,
      supports_options: true
    },
    radio: %{
      component: :radio,
      html_tag: "input",
      type: "radio",
      supports_options: true
    },
    checkbox: %{
      component: :checkbox,
      html_tag: "input",
      type: "checkbox",
      multiple: false
    },
    switch: %{
      component: :switch,
      html_tag: "input",
      type: "checkbox",
      toggle_style: true
    },

    # File inputs
    file: %{
      component: :file_upload,
      html_tag: "input",
      type: "file",
      supports_accept: true,
      supports_multiple: true
    },
    image: %{
      component: :file_upload,
      html_tag: "input",
      type: "file",
      accept: "image/*",
      supports_multiple: true
    },

    # Special inputs
    color: %{
      component: :input,
      type: "color",
      html_tag: "input",
      multiple: false
    },
    range: %{
      component: :input,
      type: "range",
      html_tag: "input",
      multiple: false,
      supports_min_max: true,
      supports_step: true
    },
    hidden: %{
      component: :input,
      type: "hidden",
      html_tag: "input",
      multiple: false
    }
  }

  @doc "Returns all supported types"
  def all, do: Map.keys(@field_types)

  @doc "Returns true if the type is supported"
  def valid?(type), do: Map.has_key?(@field_types, type)

  @doc "Get metadata associated with a field type"
  def get_config(type), do: Map.get(@field_types, type)
end
