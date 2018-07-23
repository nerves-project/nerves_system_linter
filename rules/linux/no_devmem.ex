defmodule Nerves.System.Linter.Linux.Rule.NoDevmem do
  use Nerves.System.Linter.Rule
  refute_trystate("CONFIG_DEVMEM")
  evaluate()
end
