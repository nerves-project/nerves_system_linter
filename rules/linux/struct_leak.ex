defmodule Nerves.System.Linter.Linux.Rule.StructLeak do
  use Nerves.System.Linter.Rule

  ensure_bool "CONFIG_GCC_PLUGIN_STRUCTLEAK",
              true,
              message: "CONFIG_GCC_PLUGIN_STRUCTLEAK should be enabled"

  evaluate()
end
