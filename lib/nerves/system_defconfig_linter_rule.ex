defmodule Nerves.System.Defconfig.Linter.Rule do
  defmodule Callbacks do
    defmacro ensure_package(package_name, opts \\ []) do
      quote do
        @rules [{:ensure_package, [unquote(package_name), unquote(opts)]} | @rules]
      end
    end

    defmacro ensure_bool(config_name, bool \\ true, opts \\ []) do
      quote do
        @rules [{:ensure_bool, [unquote(config_name), unquote(bool), unquote(opts)]} | @rules]
      end
    end

    defmacro ensure_value(config_name, value, opts \\ []) do
      quote do
        @rules [{:ensure_bool, [unquote(config_name), unquote(value), unquote(opts)]} | @rules]
      end
    end

    defmacro __before_compile__(_) do
      quote do
        Module.register_attribute(__MODULE__, :rules, accumulate: true)
        Module.put_attribute(__MODULE__, :rules, [])
      end
    end

    defmacro evaluate do
      quote do
        def __checks__ do
          @rules
        end
      end
    end
  end

  defmacro __using__(_) do
    quote do
      alias Nerves.System.Defconfig.Linter.Rule.Callbacks
      import Callbacks
      @before_compile Callbacks
      @behaviour Nerves.System.Defconfig.Linter.Rule
    end
  end

  @type rule :: {atom, [term]}
  @callback __checks__ :: [rule]
end
