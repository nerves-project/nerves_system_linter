defmodule Nerves.System.Linter.Linux.Rule.StackProtector do
  use Nerves.System.Linter.Rule

  ensure_bool "CONFIG_CC_STACKPROTECTOR",
              true,
              message: "CONFIG_CC_STACKPROTECTOR should be enabled"

  evaluate()
end
