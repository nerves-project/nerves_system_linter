defmodule Nerves.System.Defconfig.Linter do
  @moduledoc """
  Documentation for NervesSystemLinter.
  """
  alias Nerves.System.Defconfig

  @doc "reads a defconfig, and turns it into a map."
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
              [key, ugly_val] = String.split(line, "=")
              {String.trim(key), parse_val(ugly_val)}
            end)
       )
  end

  def parse_val(ugly_val) do
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

  def maybe_parse_bool("y"), do: true
  def maybe_parse_bool("n"), do: false
  def maybe_parse_bool(val), do: val

  def maybe_parse_val_as_list(val) when is_boolean(val) do
    val
  end

  def maybe_parse_val_as_list(val) do
    case String.split(val, " ") do
      [val] -> val
      [_ | _] = val -> val
    end
  end

  def strip_comments(data, acc \\ [])

  def strip_comments([], acc), do: Enum.reverse(acc)

  def strip_comments([line | rest], acc) do
    case strip_comment_from_line(line) do
      nil -> strip_comments(rest, acc)
      "" -> strip_comments(rest, acc)
      stripped -> strip_comments(rest, [stripped | acc])
    end
  end

  def strip_comment_from_line(line, acc \\ <<>>)
  def strip_comment_from_line(<<>>, acc), do: acc
  def strip_comment_from_line(<<"#", _rest::binary>>, _acc), do: nil

  def strip_comment_from_line(<<char, rest::binary>>, acc) do
    strip_comment_from_line(rest, acc <> <<char>>)
  end
end
