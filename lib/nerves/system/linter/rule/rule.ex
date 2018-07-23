defmodule Nerves.System.Linter.Rule do
  @moduledoc """
  A `rule` is a testable module against a buildroot defconfig.
  """
  alias Nerves.System.Linter.Rule.Callbacks

  defstruct [:check, :args]

  @typedoc @moduledoc
  @type rule :: %__MODULE__{
          check: Callbacks.check(),
          args: Callbacks.args()
        }

  @typedoc @moduledoc
  @type t :: rule

  @doc false
  defmacro __using__(_) do
    quote do
      unless @moduledoc do
        @moduledoc """
        Linter Rule #{__MODULE__}
        """
      end

      Module.register_attribute(
        __MODULE__,
        :rules,
        accumulate: false,
        persist: false
      )

      Module.put_attribute(__MODULE__, :rules, nil)

      alias Nerves.System.Linter.Rule
      alias Nerves.System.Linter.Rule.Callbacks
      import Callbacks
      @before_compile Callbacks
      @after_compile __MODULE__
      @behaviour Rule

      defmacro __after_compile__(_env, _md5) do
        # IO.puts __MODULE__
        unless function_exported?(__MODULE__, :__checks__, 0) do
          raise CompileError,
            description: """
            Be sure to call `evaluate()` after your rule is defined.
            """,
            file: __ENV__.file
        end
      end
    end
  end

  @doc "This function should be defined by `use Nerves.System.Linter.Rule`"
  @callback __checks__ :: [rule]
end
