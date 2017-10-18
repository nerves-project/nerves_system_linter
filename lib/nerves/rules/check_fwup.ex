defmodule CheckFWUP do
  use Nerves.System.Defconfig.Linter.Rule
  ensure_package "FWUP"
  evaluate()
end
