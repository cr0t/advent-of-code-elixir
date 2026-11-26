Code.require_file("../lib/load.exs", __DIR__)

defmodule AoC2020Day02 do
  use AoC

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": ", trim: true))
  end

  def part1(input), do: Enum.count(input, &satisfy1?/1)

  defp satisfy1?([rule, password]) do
    [limits, character] = String.split(rule)
    [limit_s, limit_f] = String.split(limits, "-") |> Enum.map(&String.to_integer/1)

    characters_number = Regex.scan(~r/#{character}/, password) |> Enum.count()
    Enum.member?(limit_s..limit_f, characters_number)
  end

  def part2(input), do: Enum.count(input, &satisfy2?/1)

  defp satisfy2?([rule, password]) do
    [positions, character] = String.split(rule)
    [pos_first, pos_last] = String.split(positions, "-") |> Enum.map(&String.to_integer/1)

    first = String.at(password, pos_first - 1) == character
    second = String.at(password, pos_last - 1) == character

    #  only in one of the positions character exists, not in the both
    # /                    / but it exists at least in one of them
    # |                    |
    first != second && (first || second)
  end
end
