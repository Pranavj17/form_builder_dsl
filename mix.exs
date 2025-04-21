defmodule FormBuilderDSL.MixProject do
  use Mix.Project

  def project do
    [
      app: :form_builder_dsl,
      version: "0.1.1",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex package metadata
      description: "A clean, minimal DSL for building dynamic forms in Elixir.",
      package: [
        licenses: ["MIT"],
        maintainers: ["Pranav J"],
        links: %{
          "GitHub" => "https://github.com/Pranavj17/form_builder_dsl",
          "Docs" => "https://hexdocs.pm/form_builder_dsl"
        }
      ],
      source_url: "https://github.com/Pranavj17/form_builder_dsl",
      homepage_url: "https://github.com/Pranavj17/form_builder_dsl"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end
end
