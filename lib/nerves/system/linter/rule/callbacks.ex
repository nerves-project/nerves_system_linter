defmodule Nerves.System.Linter.Rule.Callbacks do
  @moduledoc "The language for defining a `rule`."
  alias Nerves.System.Linter.Rule
  alias Nerves.System.Defconfig

  @typedoc "The name of the check to aply."
  @type check :: :ensure_package | :ensure_bool | :ensure_value

  @typedoc "List or arguments."
  @type args :: [arg]

  @typedoc "Argument to a check."
  @type arg :: message_arg | warning_arg

  @typedoc "Replace the message for a check."
  @type message_arg :: {:message, message}

  @typedoc "Human readable message for a check."
  @type message :: String.t()

  @typedoc "If a check evaluates false, it should be a warning instead of error."
  @type warning_arg :: {:warn, boolean}

  defmacro ensure_value_match(config_name, pattern, opts \\ []) do
    pattern = inspect(pattern)

    quote do
      @rules [
        %Rule{
          check: :ensure_value_match,
          args: [unquote(config_name), unquote(pattern), unquote(opts)]
        }
        | @rules
      ]
    end
  end

  @doc "Ensures a package is enabled."
  @spec ensure_package(Defconfig.config_name(), args) :: Macro.t()
  defmacro ensure_package(package_name, opts \\ []) do
    quote do
      @rules [
        %Rule{check: :ensure_package, args: [unquote(package_name), unquote(opts)]} | @rules
      ]
    end
  end

  @doc "Ensures a boolean value."
  @spec ensure_bool(Defconfig.config_name(), args) :: Macro.t()
  defmacro ensure_bool(config_name, bool \\ true, opts \\ []) do
    quote do
      @rules [
        %Rule{check: :ensure_bool, args: [unquote(config_name), unquote(bool), unquote(opts)]}
        | @rules
      ]
    end
  end

  @doc "Ensures a value."
  @spec ensure_value(Defconfig.config_name(), args) :: Macro.t()
  defmacro ensure_value(config_name, value, opts \\ []) do
    quote do
      @rules [
        %Rule{check: :ensure_value, args: [unquote(config_name), unquote(value), unquote(opts)]}
        | @rules
      ]
    end
  end

  @doc false
  defmacro __before_compile__(_) do
    quote do
      Module.register_attribute(__MODULE__, :rules, accumulate: true)
      Module.put_attribute(__MODULE__, :rules, [])
    end
  end

  @doc "Registers this rule to be evaluated."
  defmacro evaluate do
    quote do
      @doc false
      @spec __checks__ :: [Rule.rule()]
      def __checks__, do: @rules
    end
  end
end
