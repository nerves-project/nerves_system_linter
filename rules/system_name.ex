defmodule Nerves.System.Linter.Rule.SystemName do
  use Nerves.System.Linter.Rule
  ensure_value_match "BR2_NERVES_SYSTEM_NAME", <<"nerves_system_", rest::binary>>
  evaluate()
end
