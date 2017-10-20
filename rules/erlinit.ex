defmodule Erlinit do
  use Nerves.System.Linter.Rule
  ensure_bool("BR2_INIT_NONE")
  ensure_package("ERLINIT", warn: true)
  evaluate()
end
