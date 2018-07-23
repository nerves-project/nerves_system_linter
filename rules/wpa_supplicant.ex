defmodule Nerves.System.Linter.Rule.WpaSupplicant do
  use Nerves.System.Linter.Rule
  ensure_package "BR2_PACKAGE_WPA_SUPPLICANT", warn: true
  evaluate()
end
