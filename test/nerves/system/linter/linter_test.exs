defmodule Nerves.System.LinterTest do
  use ExUnit.Case
  alias Nerves.System.Linter
  alias Nerves.System.Defconfig

  defmodule SuccessRule do
    use Nerves.System.Linter.Rule
    ensure_package("BR2_PACKAGE_NERVES_CONFIG")
    # ensure_value_match("PACKAGE_NAME", <<"nerves_system_", rest :: binary>>)
    evaluate()
  end

  defmodule WarnRule do
    use Nerves.System.Linter.Rule
    ensure_package("NOT_REAL_PACKAGE_A", warn: true)
    evaluate()
  end

  defmodule ErrorRule do
    use Nerves.System.Linter.Rule
    ensure_package("NOT_REAL_PACKAGE_B")
    evaluate()
  end

  @success_rule SuccessRule
  @warn_rule WarnRule
  @error_rule ErrorRule

  defp find_file(filename) do
    file = Path.join(["fixture", "buildroot", filename])

    if File.exists?(file) do
      file
    else
      flunk("Coudl not find file: #{filename}")
    end
  end

  test "lints rpi0 build config" do
    file = find_file("rpi0.build.config")

    res =
      Linter.file_to_map(file)
      |> Defconfig.add_rules([@success_rule, @warn_rule, @error_rule])
      |> Linter.eval_rules()

    # make sure all the rules were evaluated.
    assert res.rules == []

    assert res.errors == ["ensure_package: BR2_PACKAGE_NOT_REAL_PACKAGE_B: false"]
    assert res.warnings == ["ensure_package: BR2_PACKAGE_NOT_REAL_PACKAGE_A: false"]
    assert res.success == ["ensure_package: BR2_PACKAGE_NERVES_CONFIG: true"]
  end

  test "lints rpi0 defconfig" do
    file = find_file("rpi0_defconfig")

    res =
      Linter.file_to_map(file)
      |> Defconfig.add_rules([@success_rule, @warn_rule, @error_rule])
      |> Linter.eval_rules()

    # make sure all the rules were evaluated.
    assert res.rules == []

    assert res.errors == ["ensure_package: BR2_PACKAGE_NOT_REAL_PACKAGE_B: false"]
    assert res.warnings == ["ensure_package: BR2_PACKAGE_NOT_REAL_PACKAGE_A: false"]
    assert res.success == ["ensure_package: BR2_PACKAGE_NERVES_CONFIG: true"]
  end

  test "lints osd32mp1 defconfig" do
    file = find_file("osd32mp1_defconfig")

    res =
      Linter.file_to_map(file)
      |> Defconfig.add_rules([@success_rule, @warn_rule, @error_rule])
      |> Linter.eval_rules()

    # make sure all the rules were evaluated.
    assert res.rules == []

    assert res.errors == ["ensure_package: BR2_PACKAGE_NOT_REAL_PACKAGE_B: false"]
    assert res.warnings == ["ensure_package: BR2_PACKAGE_NOT_REAL_PACKAGE_A: false"]
    assert res.success == ["ensure_package: BR2_PACKAGE_NERVES_CONFIG: true"]
  end
end
