defmodule HasSkeleton do
  use Nerves.System.Defconfig.Linter.Rule
  ensure_bool("BR2_ROOTFS_SKELETON_CUSTOM")
  ensure_value("BR2_ROOTFS_SKELETON_CUSTOM_PATH", "${BR2_EXTERNAL_NERVES_PATH}/board/nerves-common/skeleton")
  evaluate()
end
