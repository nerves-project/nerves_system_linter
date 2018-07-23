defmodule Nerves.System.Linter.Rule.Checks do
  @moduledoc "Actual check implementation for the Callbacks module."
  alias Nerves.System.Defconfig
  alias Nerves.System.Linter.Rule.Callbacks

  @doc "Ensures a package is enabled."
  @spec ensure_package(Defconfig.t(), Defconfig.config_name(), Callbacks.args()) :: Defconfig.t()
  def ensure_package(defconfig, package_name, opts \\ [])

  def ensure_package(
        %Defconfig{config: config} = defconfig,
        <<"BR2_PACKAGE_", _rest::binary>> = package_name,
        opts
      ) do
    if eval_conditionals(defconfig, opts) do
      res = config[package_name] || false
      message = Keyword.get(opts, :message, "ensure_package: #{package_name}: #{res || false}")
      update(defconfig, res, message, opts)
    else
      defconfig
    end
  end

  def ensure_package(%Defconfig{} = defconfig, package_name, opts) do
    if eval_conditionals(defconfig, opts) do
      ensure_package(defconfig, "BR2_PACKAGE_" <> package_name, opts)
    else
      defconfig
    end
  end

  @doc "Ensures a boolean value."
  @spec ensure_bool(Defconfig.t(), Defconfig.config_name(), boolean, Callbacks.args()) ::
          Defconfig.t()
  def ensure_bool(%Defconfig{} = defconfig, config, bool, opts \\ []) do
    if eval_conditionals(defconfig, opts) do
      res = config in Map.keys(defconfig.config) and defconfig.config[config] == bool
      message = Keyword.get(opts, :message, "ensure_bool: #{config}: #{res || false}")
      update(defconfig, res, message, opts)
    else
      defconfig
    end
  end

  @doc "Ensures a value."
  @spec ensure_value(
          Defconfig.t(),
          Defconfig.config_name(),
          Defconfig.package_value(),
          Callbacks.args()
        ) :: Defconfig.t()
  def ensure_value(%Defconfig{} = defconfig, config, value, opts \\ []) do
    if eval_conditionals(defconfig, opts) do
      res = defconfig.config[config] == value
      message = Keyword.get(opts, :message, "ensure_value: #{config}: #{res || false}")
      update(defconfig, res, message, opts)
    else
      # IO.puts "conditional failed for not evaluating #{config} == #{value}"
      defconfig
    end
  end

  def eval_conditionals(defconfig, opts) do
    case Keyword.fetch(opts, :if) do
      {:ok, l} when is_list(l) ->
        Enum.any?(l, fn {check, val} ->
          r = defconfig.config[check] == (val || false)
          # IO.puts "Conditional: #{check}(#{defconfig.config[check]}) => #{val} (#{r})"
          r
        end)

      :error ->
        true
    end
  end

  def ensure_value_match(defconfig, package_name, pattern, opts \\ []) do
    pattern = Code.eval_string(pattern)
    expr = defconfig.config[package_name]

    quoted =
      quote do
        case {unquote(expr), []} do
          unquote(pattern) ->
            true

          _ ->
            false
        end
      end

    {res, _env} = Code.eval_quoted(quoted)
    update(defconfig, res, "ensure_value_match: #{package_name}: #{res || false}", opts)
  end

  @spec update(Defconfig.t(), boolean, Callbacks.message(), Callbacks.args()) :: Defconfig.t()
  defp update(defconfig, res, message, opts) do
    warn? = Keyword.get(opts, :warn, false)

    cond do
      res -> %{defconfig | success: [message | defconfig.success]}
      warn? and !res -> %{defconfig | warnings: [message | defconfig.warnings]}
      true -> %{defconfig | errors: [message | defconfig.errors]}
    end
  end
end
