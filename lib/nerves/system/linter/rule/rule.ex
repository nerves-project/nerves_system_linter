defmodule Nerves.System.Linter.Rule do
  @moduledoc """
  A `rule` is a testable module against a buildroot defconfig.
  """
  alias Nerves.System.Linter.Rule.Callbacks

  defstruct [:check, :args]

  @typedoc @moduledoc
  @type rule :: %__MODULE__{
    check: Callbacks.check,
    args: Callbacks.args
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
      alias Nerves.System.Linter.Rule
      alias Nerves.System.Linter.Rule.Callbacks
      import Callbacks
      @before_compile Callbacks
      @behaviour Rule
    end
  end

  @doc "This function should be defined by `use Nerves.System.Linter.Rule`"
  @callback __checks__ :: [rule]
end
