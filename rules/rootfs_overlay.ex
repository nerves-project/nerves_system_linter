defmodule Nerves.System.Linter.Rule.RootfsOverlay do
  use Nerves.System.Linter.Rule
  #ensure_value_match("BR2_ROOTFS_OVERLAY", <<"$\{BR2_EXTERNAL_NERVES_PATH}/board/nerves-common/rootfs_overlay", rest :: binary>>)
  ensure_value_match("BR2_ROOTFS_OVERLAY", <<rest :: binary>>)

  # Always include the generic rootfs_overlay and then override it with your
  # own overlay if necessary.
  evaluate()
end
