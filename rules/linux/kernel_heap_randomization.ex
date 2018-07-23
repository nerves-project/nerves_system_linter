defmodule Nerves.System.Linter.Linux.Rule.KernelHeapRandomization do
  use Nerves.System.Linter.Rule
  # NOTE: y means it turns off kernel heap randomization for backwards compatability (libc5)
  refute_trystate("CONFIG_COMPAT_BRK")
  evaluate()
end
