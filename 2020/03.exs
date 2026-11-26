Code.require_file("../lib/load.exs", __DIR__)

defmodule AoC2020Day03 do
  use AoC

  defguard is_even(term) when is_integer(term) and rem(term, 2) == 0

  def parse(input), do: String.split(input, "\n", trim: true)

  def part1(lines) do
    pattern_width = lines |> List.first() |> String.length()

    lines
    |> Enum.with_index()
    |> Enum.count(fn
      {_line, 0} -> false
      {line, idx} -> char_at_infinite(line, idx * 3, pattern_width) == "#"
    end)
  end

  def part2(lines) do
    pattern_width = lines |> List.first() |> String.length()

    horizontal_shifts_trees =
      Enum.map([1, 3, 5, 7], fn shift ->
        lines
        |> Enum.with_index()
        |> Enum.count(&horizontal_shift(&1, shift, pattern_width))
      end)

    vertical_shifts_trees =
      lines
      |> Enum.with_index()
      |> Enum.count(&vertical_shift(&1, pattern_width))

    trees = horizontal_shifts_trees ++ [vertical_shifts_trees]

    Enum.reduce(trees, &(&1 * &2))
  end

  defp char_at_infinite(line, position, pattern_width) do
    position = rem(position, pattern_width)
    String.at(line, position)
  end

  defp horizontal_shift({_line, 0}, _shift, _pattern_width),
    do: false

  defp horizontal_shift({line, idx}, shift, pattern_width),
    do: char_at_infinite(line, idx * shift, pattern_width) == "#"

  defp vertical_shift({_line, 0}, _pattern_width),
    do: false

  defp vertical_shift({line, idx}, pattern_width) when is_even(idx) do
    char_at_infinite(line, div(idx, 2), pattern_width) == "#"
  end

  defp vertical_shift({_line, _idx}, _pattern_width),
    do: false
end
