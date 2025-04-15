defmodule FormBuilderDSL.Enum do
  @moduledoc """
  Runtime-safe enum registry and utilities using ETS.

  Ensures enums can be registered and retrieved safely at both compile-time and runtime.
  """

  @type enum_name :: atom()
  @type enum_value :: atom()
  @type enum_list :: [enum_value]
  @table :form_builder_dsl_enum_registry

  @doc """
  Starts the ETS table if not already started. Works in supervision trees.
  """
  def start_link(_) do
    ensure_table!()
    {:ok, self()}
  end

  @doc """
  Registers an enum under a given name (replaces previous if exists).
  """
  def register(name, values) when is_atom(name) and is_list(values) do
    ensure_table!()
    :ets.insert(@table, {name, values})
  end

  @doc """
  Returns the enum list as a list of strings.

  ## Example
      iex> Enum.register(:status, [:active, :inactive])
      :ok
      iex> Enum.options(:status)
      ["active", "inactive"]
  """
  def options(name) do
    name
    |> get_values()
    |> Enum.map(&Atom.to_string/1)
  end

  @doc """
  Returns enum values as `{label, value}` tuples — used for form select fields.
  """
  def labeled_options(name) do
    name
    |> get_values()
    |> Enum.map(fn value ->
      {FormBuilderDSL.DSL.humanize(value), Atom.to_string(value)}
    end)
  end

  defp get_values(name) do
    ensure_table!()

    case :ets.lookup(@table, name) do
      [{^name, values}] -> values
      _ -> []
    end
  end

  defp ensure_table! do
    if :ets.whereis(@table) == :undefined do
      :ets.new(@table, [:named_table, :public, :set, read_concurrency: true])
    end

    :ok
  end
end
