defmodule Nerves.System.Defconfig.Linter.Rule.Checks do
  alias Nerves.System.Defconfig

  def ensure_package(defconfig, package_name, opts \\ [])

  def ensure_package(
        %Defconfig{config: config} = defconfig,
        <<"BR2_PACKAGE_", _rest::binary>> = package_name,
        opts
      ) do
    res = config[package_name]
    message = Keyword.get(opts, :message, "ensure_package: #{package_name}: #{res || false}")
    update(defconfig, res, message, opts)
  end

  def ensure_package(%Defconfig{} = defconfig, package_name, opts) do
    ensure_package(defconfig, "BR2_PACKAGE_" <> package_name, opts)
  end

  def ensure_bool(%Defconfig{} = defconfig, config, bool, opts \\ []) do
    res = config in Map.keys(defconfig.config) and defconfig.config[config] == bool
    message = Keyword.get(opts, :message, "ensure_bool: #{config}: #{res || false}")
    update(defconfig, res, message, opts)
  end

  def ensure_value(%Defconfig{} = defconfig, config, value, opts \\ []) do
    res = defconfig.config[config] == value
    message = Keyword.get(opts, :message, "ensure_value: #{config}: #{res || false}")
    update(defconfig, res, message, opts)
  end

  defp update(defconfig, res, message, opts) do
    warn? = Keyword.get(opts, :warn, false)

    cond do
      res -> %{defconfig | success: [message | defconfig.success]}
      warn? and !res -> %{defconfig | warnings: [message | defconfig.warnings]}
      true -> %{defconfig | errors: [message | defconfig.errors]}
    end
  end
end
