defmodule Nerves.System.Defconfig do
  alias Nerves.System.Defconfig.Linter.Rule.Checks

  defstruct path: nil,
            config: %{},
            rules: [],
            errors: [],
            success: [],
            warnings: []


  def add_rules(%__MODULE__{} = config, rules) do
    Enum.reduce(rules, config, fn rule, acc ->
      add_rule(acc, rule)
    end)
  end

  def add_rule(config, rule) do
    %{config | rules: [rule | config.rules]}
  end

  def eval_rules(%__MODULE__{rules: []} = config) do
    config
  end

  def eval_rules(%__MODULE__{rules: [rule | remaining]} = config) do
    %{enumerate_checks(config, rule.__checks__) | rules: remaining} |> eval_rules()
  end

  def enumerate_checks(config, nil), do: config
  def enumerate_checks(config, []), do: config
  def enumerate_checks(config, [{fun, args} | rest]) do
    res = apply(Checks, fun, [config | args])
    enumerate_checks(res, rest)
  end
end
