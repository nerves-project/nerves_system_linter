defmodule GenerateLocale do
  use Nerves.System.Defconfig.Linter.Rule
  ensure_value("BR2_GENERATE_LOCALE", "en_US.UTF-8")
  evaluate()
end
