defmodule FormBuilderDSLTest do
  use ExUnit.Case
  doctest FormBuilderDSL

  setup_all do
    FormBuilderDSL.Enum.start_link([])
    :ok
  end

  defmodule Enums do
    use FormBuilderDSL

    defenum(:status, [:approved, :rejected, :pending])
  end

  defmodule TestForm do
    use FormBuilderDSL
    alias Enums

    form :test_form do
      text(:id)
      select(:status, options: Enums.status_labeled_options())
    end
  end

  test "my form works with enums" do
    assert TestForm.fields() |> Enum.any?(fn f -> f.key == :status end)

    assert Enums.status_labeled_options() == [
             {"Approved", "approved"},
             {"Rejected", "rejected"},
             {"Pending", "pending"}
           ]
  end
end
