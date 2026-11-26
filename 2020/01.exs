Code.require_file("../lib/load.exs", __DIR__)

defmodule AoC2020Day01 do
  use AoC

  @sum 2020

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1(input) do
    [a, b] =
      Enum.flat_map(input, fn op_a ->
        Enum.filter(input, &(op_a + &1 == @sum))
      end)

    a * b
  end

  def part2(input) do
    [a, b, c] =
      Enum.map(input, fn op_a ->
        Enum.map(input, fn op_b ->
          Enum.filter(input, &(op_a + op_b + &1 == @sum))
        end)
      end)
      |> List.flatten()
      |> Enum.uniq()

    a * b * c
  end
end
