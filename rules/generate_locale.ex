defmodule GenerateLocale do
  use Nerves.System.Linter.Rule
  ensure_value("BR2_GENERATE_LOCALE", "en_US.UTF-8")
  evaluate()
end
