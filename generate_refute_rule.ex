#!/home/connor/.asdf/shims/elixir
rule_templ = """
defmodule Nerves.System.Linter.Linux.Rule.<%= mod %> do
  use Nerves.System.Linter.Rule
  refute_trystate "<%= config %>"
  evaluate()
end
"""
[_, config, mod] = :init.get_plain_arguments()
evald = EEx.eval_string(rule_templ, [mod: mod, config: config])
File.write!("rules/linux/#{Macro.underscore(to_string(mod))}.ex", evald)