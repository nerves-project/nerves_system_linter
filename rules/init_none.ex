defmodule Nerves.System.Linter.Rule.InitNone do
  use Nerves.System.Linter.Rule
  ensure_bool "BR2_INIT_NONE", true
  # Using systemd or busybox init isn't supported. Nerves expects to use
  # erlinit.
  evaluate()
end
