Code.require_file("../lib/load.exs", __DIR__)

defmodule AoC2015Day02 do
  use AoC

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("x", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1(input) do
    Enum.reduce(input, 0, fn [l, w, h], total_paper ->
      surface_area = 2 * l * w + 2 * w * h + 2 * h * l

      smallest_side =
        Enum.min([
          l * w,
          w * h,
          h * l
        ])

      total_paper + surface_area + smallest_side
    end)
  end

  def part2(input) do
    Enum.reduce(input, 0, fn [l, w, h], total_ribbon ->
      volume = l * w * h

      smallest_perimeter =
        Enum.min([
          2 * l + 2 * w,
          2 * w + 2 * h,
          2 * h + 2 * l
        ])

      total_ribbon + volume + smallest_perimeter
    end)
  end
end
