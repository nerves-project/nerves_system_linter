defmodule Nerves.System.Linter.Rule.E2fsprogs do
  use Nerves.System.Linter.Rule
  ensure_package "BR2_PACKAGE_E2FSPROGS", warn: true
  # e2fsprogs is used to format the application partition since most Nerves
  # systems use ext4. If you're not using an application partition or not using
  # ext4, then feel free to not enable this.
  evaluate()
end
