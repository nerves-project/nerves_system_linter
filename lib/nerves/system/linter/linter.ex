defmodule Nerves.System.Linter do
  @moduledoc """
  Lint defconfig files.
  """

  alias Nerves.System.Defconfig
  alias Nerves.System.Linter.Rule
  alias Nerves.System.Linter.Rule.Checks

  @doc "Evaluates the rules that have been built."
  @spec eval_rules(Defconfig.t()) :: Defconfig.t()
  def eval_rules(defconfig)

  def eval_rules(%Defconfig{rules: []} = config) do
    config
  end

  def eval_rules(%Defconfig{rules: [rule | remaining]} = config) do
    %{enumerate_checks(config, rule.__checks__) | rules: remaining} |> eval_rules()
  end

  @doc "Actually aplies a list of rules on the config."
  @spec enumerate_checks(Defconfig.t(), [Rule.rule()]) :: Defconfig.t()
  def enumerate_checks(defconfig, rules)

  def enumerate_checks(%Defconfig{} = config, nil), do: config
  def enumerate_checks(%Defconfig{} = config, []), do: config

  def enumerate_checks(%Defconfig{} = config, [%Rule{check: fun, args: args} | rest]) do
    res = apply(Checks, fun, [config | args])
    enumerate_checks(res, rest)
  end

  @doc "reads a defconfig, and turns it into a map."
  @spec file_to_map(Path.t()) :: Defconfig.t()
  def file_to_map(file) do
    Defconfig
    |> struct()
    |> Map.put(:path, file)
    |> Map.put(
      :config,
      File.read!(file)
      |> String.trim()
      |> String.split("\n")
      |> strip_comments()
      |> Map.new(fn line ->
        [key, ugly_val] = String.split(line, "=", parts: 2)
        {String.trim(key), parse_val(ugly_val)}
      end)
    )
  end

  @spec parse_val(binary) :: Defconfig.package_value()
  defp parse_val(ugly_val) do
    ugly_val
    |> String.trim()
    |> String.split("\"")
    |> case do
      ["", val, ""] -> val
      [val] -> val
    end
    |> maybe_parse_bool()
    |> maybe_parse_val_as_list
  end

  @spec maybe_parse_bool(binary) :: boolean | binary
  defp maybe_parse_bool("y"), do: true
  defp maybe_parse_bool("n"), do: false
  defp maybe_parse_bool(val), do: val

  @spec maybe_parse_val_as_list(binary | boolean) :: [binary] | boolean | binary
  defp maybe_parse_val_as_list(val) when is_boolean(val) do
    val
  end

  defp maybe_parse_val_as_list(val) do
    case String.split(val, " ") do
      [val] -> val
      [_ | _] = val -> val
    end
  end

  @spec strip_comments([binary], [binary]) :: [binary]
  defp strip_comments(data, acc \\ [])

  defp strip_comments([], acc), do: Enum.reverse(acc)

  defp strip_comments([line | rest], acc) do
    case strip_comment_from_line(line) do
      nil -> strip_comments(rest, acc)
      "" -> strip_comments(rest, acc)
      stripped -> strip_comments(rest, [stripped | acc])
    end
  end

  @spec strip_comment_from_line(binary, binary) :: nil | binary
  defp strip_comment_from_line(line, acc \\ <<>>)
  defp strip_comment_from_line(<<>>, acc), do: acc
  defp strip_comment_from_line(<<"#", _rest::binary>>, _acc), do: nil

  defp strip_comment_from_line(<<char, rest::binary>>, acc) do
    strip_comment_from_line(rest, acc <> <<char>>)
  end
end
