defmodule GlobalPatchDir do
  use Nerves.System.Defconfig.Linter.Rule
  ensure_value("BR2_GLOBAL_PATCH_DIR", "${BR2_EXTERNAL_NERVES_PATH}/patches")
  evaluate()
end
