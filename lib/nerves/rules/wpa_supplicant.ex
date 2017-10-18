defmodule WpaSupplicant do
  use Nerves.System.Defconfig.Linter.Rule
  ensure_package("BR2_PACKAGE_WPA_SUPPLICANT", warn: true)
  evaluate()
end
