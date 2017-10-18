defmodule Mix.Tasks.Nerves.System.Lint do
  use Mix.Task
  alias Nerves.System.Defconfig
  alias Defconfig.Linter
  @rules [CheckFWUP, HasSkeleton, Erlinit, WpaSupplicant, GlobalPatchDir, GenerateLocale]

  def run(_) do
    case System.get_env("NERVES_SYSTEM") do
      nil ->
        Mix.raise("Could not detect buildroot output dir.")

      buildroot_dir ->
        res =
          [buildroot_dir, ".config"]
          |> Path.join()
          |> Linter.file_to_map()
          |> Defconfig.add_rules(@rules)
          |> Defconfig.eval_rules()

        case res do
          %Defconfig{errors: [], warnings: [], success: success} = _res ->
            Mix.shell().info([:green, "Successful checks:", "\n\n", Enum.join(success, "\n")])

          %Defconfig{errors: errors, warnings: warnings, success: success} ->
            Mix.shell().info([:green, "Successful checks:", "\n\n", Enum.join(success, "\n"), "\n"])
            Mix.shell().info("==========================\n")
            Mix.shell().info([:yellow, "Warn checks:", "\n\n", Enum.join(warnings, "\n"), "\n"])
            Mix.shell().info("==========================\n")
            Mix.shell().info([:red, "Failed checks:", "\n\n", Enum.join(errors, "\n")])
        end
    end
  end
end
