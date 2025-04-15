defmodule FormBuilderDSL do
  @moduledoc """
  Use this module to enable the form DSL.
  """

  defmacro __using__(_opts) do
    quote do
      use FormBuilderDSL.DSL
    end
  end
end
