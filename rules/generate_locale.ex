defmodule Nerves.System.Linter.Rule.GenerateLocale do
  use Nerves.System.Linter.Rule

  ensure_value("BR2_GENERATE_LOCALE", "en_US.UTF-8", [
    message: "BR2_GENERATE_LOCALE should be en_US.UTF-8 if BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC is enabled.",
    if: [{"BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC", true}]
  ])

  ensure_value("BR2_GENERATE_LOCALE", false, [
    message: "BR2_GENERATE_LOCALE should be disabled if BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC is disabled",
    if: [{"BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC", false}]
  ])

  evaluate()
end
