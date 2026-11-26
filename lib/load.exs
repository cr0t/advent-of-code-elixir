# Plain `elixir` does not compile lib/ like Mix does, so load it by hand.
# aoc.ex goes last: it needs nothing at compile time, but the helpers it
# imports and the modules its hook calls must be defined before `use AoC`.
lib = __DIR__

modules = Path.wildcard(Path.join(lib, "aoc/**/*.ex")) |> Enum.sort()

Enum.each(modules ++ [Path.join(lib, "aoc.ex")], &Code.require_file/1)
