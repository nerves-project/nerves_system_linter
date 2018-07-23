defmodule Nerves.System.Linter.Rule.GlobalPatchDir do
  use Nerves.System.Linter.Rule
  ensure_value "BR2_GLOBAL_PATCH_DIR", "${BR2_EXTERNAL_NERVES_PATH}/patches"
  evaluate()
end
