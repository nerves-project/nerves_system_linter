#!/home/connor/.asdf/shims/elixir
rule_templ = """
defmodule Nerves.System.Linter.Linux.Rule.<%= mod %> do
  use Nerves.System.Linter.Rule
  ensure_bool "<%= config %>", true, message: "<%= config %> should be enabled"
  evaluate()
end
"""
[_, config, mod] = :init.get_plain_arguments()
evald = EEx.eval_string(rule_templ, [mod: mod, config: config])
File.write!("rules/linux/#{Macro.underscore(to_string(mod))}.ex", evald)
