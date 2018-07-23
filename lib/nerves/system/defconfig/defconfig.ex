defmodule Nerves.System.Defconfig do
  @moduledoc """
  Elixir representation of a defconfig.
  Currently only supports buildroot defconfigs and not Linux Kernel configs.
  """

  @typedoc "Name of a config."
  @type config_name :: binary

  @typedoc "Value inside a defconfig."
  @type package_value :: boolean | binary | [binary]

  defstruct path: nil,
            config: %{},
            rules: [],
            errors: [],
            success: [],
            warnings: []

  @typedoc "Path to the file this data represents."
  @type path :: Path.t()

  @typedoc "The actual config representation."
  @type config :: %{
          optional(config_name) => package_value
        }

  @typedoc "Elixir representation of a defconfig file."
  @type t :: %__MODULE__{
          path: path,
          config: config,
          rules: [Nerves.System.Linter.Rule.rule()],
          errors: [Nerves.System.Linter.Rule.Callbacks.message()],
          success: [Nerves.System.Linter.Rule.Callbacks.message()],
          warnings: [Nerves.System.Linter.Rule.Callbacks]
        }

  @doc "Add a list of rules to a Defconfig."
  @spec add_rules(Defconfig.t(), [Nerves.System.Linter.Rule.rule()]) :: Defconfig.t()
  def add_rules(%__MODULE__{} = config, rules) do
    Enum.reduce(rules, config, fn rule, acc ->
      add_rule(acc, rule)
    end)
  end

  @doc "Add a single rule to a defconfig."
  @spec add_rule(Defconfig.t(), Nerves.System.Linter.Rule.rule()) :: Defconfig.t()
  def add_rule(config, rule) do
    %{config | rules: [rule | config.rules]}
  end
end
