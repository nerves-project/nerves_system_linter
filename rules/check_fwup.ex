defmodule Nerves.System.Linter.Rule.CheckFwup do
  use Nerves.System.Linter.Rule
  ensure_package "FWUP"
  evaluate()
end
