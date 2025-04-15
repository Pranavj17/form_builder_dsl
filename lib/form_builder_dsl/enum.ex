defmodule FormBuilderDSL.Enum do
  @moduledoc """
  Runtime-safe enum registry and utilities.
  """

  @type enum_name :: atom()
  @type enum_value :: atom()
  @type enum_list :: [enum_value]

  @table :form_builder_dsl_enum_registry
  def start_link(_) do
    if :ets.whereis(@table) == :undefined do
      :ets.new(@table, [:named_table, :public, read_concurrency: true])
    end

    {:ok, self()}
  end

  def register(name, values) when is_atom(name) and is_list(values) do
    :ets.insert(@table, {name, values})
  end

  def options(name) do
    name
  end

  def labeled_options(name) do
    name
    |> get_values()
    |> Enum.map(fn v -> {FormBuilderDSL.DSL.humanize(v), Atom.to_string(v)} end)
  end

  defp get_values(name) do
    case :ets.lookup(@table, name) do
      [{^name, vals}] -> vals
      _ -> []
    end
  end
end
