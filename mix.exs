defmodule Nerves.System.Linter.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nerves_system_linter,
      version: "0.4.0",
      elixir: "~> 1.5",
      package: package(),
      description: description(),
      start_permanent: Mix.env() == :prod,
      elixirc_paths: ["lib", "rules"],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:dialyxir, "~> 1.0.0", only: :dev}
    ]
  end

  defp description do
    """
    Nerves System Linter - Lint Nerves System Defconfigs.
    """
  end

  defp package do
    [
      maintainers: ["Connor Rigby"],
      licenses: ["Apache 2.0"],
      files: [
        "config",
        "fixture",
        "lib",
        "rules",
        "test",
        "mix.exs",
        "LICENSE",
        "README.md",
        "CHANGELOG.md"
      ],
      links: %{"Github" => "https://github.com/nerves-project/nerves_system_linter"}
    ]
  end
end
