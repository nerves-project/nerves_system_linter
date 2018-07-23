defmodule Nerves.System.Linter.Linux.Rule.VirtuallyMappedKernel do
  use Nerves.System.Linter.Rule
  ensure_bool("CONFIG_VMAP_STACK", true, message: "CONFIG_VMAP_STACK should be enabled")
  evaluate()
end
