defmodule Mix.Tasks.Nerves.System.Lint do
  @usage """
  Usage:
  mix nerves.system.lint nerves_defconfig path_to_rules
  """
  @shortdoc "Lint a defconfig."

  @moduledoc ~s"""
  Lint a defconfig.

  #{@usage}
  """

  use Mix.Task
  alias Nerves.System.Defconfig
  alias Nerves.System.Linter

  @default_rules File.ls!("rules")
                 |> Enum.map(fn filename ->
                   mod = Path.rootname(filename) |> Macro.camelize()
                   Module.concat(["Nerves", "System", "Linter", "Rule", mod])
                 end)

  def run(opts) do
    case opts do
      [] ->
        auto_detect_defconfig()

      [defconfig_file] ->
        defconfig_file
        |> Linter.file_to_map()
        |> Defconfig.add_rules(@default_rules)
        |> Linter.eval_rules()
        |> print()

      [path_a, path_b] ->
        {defconfig_file, rules_dir} = detect_opts(path_a, path_b)

        defconfig_file
        |> Linter.file_to_map()
        |> Defconfig.add_rules(@default_rules)
        |> Defconfig.add_rules(find_rules(rules_dir))
        |> Linter.eval_rules()
        |> print()
        |> quit()
    end
  end

  def auto_detect_defconfig do
    case System.get_env("NERVES_SYSTEM") do
      nil ->
        Mix.raise("Could not detect buildroot output dir.")

      buildroot_dir ->
        [buildroot_dir, ".config"]
        |> Path.join()
        |> Linter.file_to_map()
        |> Defconfig.add_rules(@default_rules)
        |> Linter.eval_rules()
        |> print()
        |> quit()
    end
  end

  defp detect_opts(path_a, path_b) do
    cond do
      File.dir?(path_a) and !File.dir?(path_b) -> {path_b, path_a}
      File.dir?(path_b) and !File.dir?(path_a) -> {path_a, path_b}
      true -> Mix.raise(@usage)
    end
  end

  defp find_rules(path) do
    path = Path.expand(path)

    File.ls!(path)
    |> Enum.map(fn filename ->
      Code.eval_file(Path.join(path, filename)) |> elem(0) |> elem(1)
    end)
  end

  defp print(res) do
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

    res
  end

  defp quit(_res = %Defconfig{errors: []}), do: System.halt(0)
  defp quit(_res), do: System.halt(1)
end
