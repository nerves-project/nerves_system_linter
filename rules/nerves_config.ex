defmodule Nerves.System.Linter.Rule.NervesConfig do
  use Nerves.System.Linter.Rule
  ensure_package "NERVES_CONFIG"

  # NERVES_CONFIG pulls in Erlang, fwup, erlint and a few other manditory
  # packages.
  evaluate()
end
