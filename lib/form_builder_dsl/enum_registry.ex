defmodule FormBuilderDSL.EnumRegistry do
  @moduledoc """
  Runtime-safe enum registry and utilities using ETS.

  This module provides a way to register and manage enums in your application, ensuring they can be
  safely accessed at both compile-time and runtime. It uses ETS (Erlang Term Storage) for efficient
  storage and retrieval of enum values.

  ## Usage

  First, ensure the enum registry is started in your application's supervision tree:

  ```elixir
  # In your application.ex
  children = [
    FormBuilderDSL.EnumRegistry
  ]
  ```

  Then you can register and use enums in your forms:

  ```elixir
  defmodule MyForm do
    use FormBuilderDSL

    # Register an enum
    defenum :status, [:active, :inactive, :pending]

    form :user do
      # Use the enum in a select field
      select :status, options: status_labeled_options()
    end
  end
  ```

  ## Features

  - Runtime-safe enum registration and retrieval
  - Support for both simple string options and labeled options (for form selects)
  - ETS-based storage for efficient access
  - Automatic table creation and management
  """

  @type enum_name :: atom()
  @type enum_value :: atom()
  @type enum_list :: [enum_value]
  @table :form_builder_dsl_enum_registry

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [[]]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  @doc """
  Starts the ETS table if not already started. Works in supervision trees.

  ## Examples

      iex> FormBuilderDSL.EnumRegistry.start_link([])
      {:ok, #PID<0.123.0>}
  """
  def start_link(_) do
    ensure_table!()
    {:ok, self()}
  end

  @doc """
  Registers an enum under a given name (replaces previous if exists).

  ## Parameters

    - `name` - The atom name for the enum (e.g., `:status`)
    - `values` - List of atom values for the enum (e.g., `[:active, :inactive]`)

  ## Examples

      iex> FormBuilderDSL.EnumRegistry.register(:status, [:active, :inactive])
      :ok
      iex> FormBuilderDSL.EnumRegistry.options(:status)
      ["active", "inactive"]
  """
  def register(name, values) when is_atom(name) and is_list(values) do
    ensure_table!()
    :ets.insert(@table, {name, values})
  end

  @doc """
  Returns the enum list as a list of strings.

  ## Parameters

    - `name` - The atom name of the registered enum

  ## Returns

    - List of strings representing the enum values

  ## Examples

      iex> FormBuilderDSL.EnumRegistry.register(:status, [:active, :inactive])
      :ok
      iex> FormBuilderDSL.EnumRegistry.options(:status)
      ["active", "inactive"]
  """
  def options(name) do
    name
    |> get_values()
    |> Enum.map(&Atom.to_string/1)
  end

  @doc """
  Returns enum values as `{label, value}` tuples — used for form select fields.

  ## Parameters

    - `name` - The atom name of the registered enum

  ## Returns

    - List of `{label, value}` tuples where:
      - `label` is a humanized version of the value (e.g., "Active" for `:active`)
      - `value` is the string representation of the enum value

  ## Examples

      iex> FormBuilderDSL.EnumRegistry.register(:status, [:active, :inactive])
      :ok
      iex> FormBuilderDSL.EnumRegistry.labeled_options(:status)
      [{"Active", "active"}, {"Inactive", "inactive"}]
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
