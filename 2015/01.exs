Code.require_file("../lib/load.exs", __DIR__)

defmodule AoC2015Day01 do
  use AoC

  def parse(input), do: String.codepoints(input)

  def part1(input) do
    Enum.reduce(input, 0, fn
      "(", floor -> floor + 1
      ")", floor -> floor - 1
    end)
  end

  def part2(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce_while(0, fn
      {"(", _}, floor when floor >= 0 -> {:cont, floor + 1}
      {")", _}, floor when floor >= 0 -> {:cont, floor - 1}
      {_, idx}, _ -> {:halt, idx}
    end)
  end
end
