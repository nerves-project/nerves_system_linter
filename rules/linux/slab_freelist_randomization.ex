defmodule Nerves.System.Linter.Linux.Rule.SlabFreelistRandomization do
  use Nerves.System.Linter.Rule

  ensure_bool "CONFIG_SLAB_FREELIST_RANDOM",
              true,
              message: "CONFIG_SLAB_FREELIST_RANDOM should be enabled"

  evaluate()
end
