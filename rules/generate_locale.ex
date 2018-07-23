defmodule Nerves.System.Linter.Rule.GenerateLocale do
  use Nerves.System.Linter.Rule

  ensure_value "BR2_GENERATE_LOCALE", "en_US.UTF-8",
    message: "When using glibc, make sure that BR2_GENERATE_LOCALE=en_US.UTF-8.",
    if: [{"BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC", true}]

  evaluate()
end
