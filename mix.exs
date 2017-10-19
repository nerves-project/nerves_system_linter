defmodule NervesSystemLinter.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nerves_system_linter,
      version: "0.1.0",
      elixir: "~> 1.5",
      package: package(),
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: []
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Nerves System Linter - Lint Nervees Defconfigs.
    """
  end

  defp package do
    [
      maintainers: ["Connor Rigby"],
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/nerves-project/nerves_system_linter"}
    ]
  end
end
