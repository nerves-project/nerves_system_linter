defmodule Nerves.System.Linter.Rule.GenerateLocale do
  use Nerves.System.Linter.Rule

  ensure_value("BR2_GENERATE_LOCALE", "en_US.UTF-8", [
    message: "BR2_GENERATE_LOCALE should be en_US.UTF-8 if BR2_TOOLCHAIN_USES_GLIBC is disabeld.",
    if: [{"BR2_TOOLCHAIN_USES_GLIBC", false}]
  ])

  ensure_value("BR2_GENERATE_LOCALE", false, [
    message: "BR2_GENERATE_LOCALE should be disabled if BR2_TOOLCHAIN_USES_GLIBC is enabled",
    if: [{"BR2_TOOLCHAIN_USES_GLIBC", true}]
  ])

  evaluate()
end
