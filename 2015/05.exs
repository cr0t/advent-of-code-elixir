Code.require_file("../lib/load.exs", __DIR__)

defmodule AoC2015Day05 do
  use AoC

  def parse(input), do: String.split(input, "\n", trim: true)

  def part1(input), do: Enum.count(input, &nice1?/1)

  defp nice1?(string) do
    has_three_vowels = Regex.scan(~r/[aeiou]/, string) |> length() |> Kernel.>=(3)
    has_duplicates = Regex.scan(~r/(.)\1+/, string) |> length() |> Kernel.>(0)
    has_naughties = Regex.scan(~r/ab|cd|pq|xy/, string) |> length() |> Kernel.>(0)

    has_three_vowels && has_duplicates && not has_naughties
  end

  def part2(input), do: Enum.count(input, &nice2?/1)

  defp nice2?(string) do
    # let's use back-references
    has_pairs = Regex.match?(~r/([a-z][a-z]).*\1/, string)
    has_litms = Regex.match?(~r/([a-z])[a-z]\1/, string)

    has_pairs && has_litms
  end
end
