defmodule Nerves.System.Linter.Linux.Rule.Squashfs do
  use Nerves.System.Linter.Rule
  ensure_bool("CONFIG_SQUASHFS")
  evaluate()
end
