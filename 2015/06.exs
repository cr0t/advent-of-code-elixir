Code.require_file("../lib/load.exs", __DIR__)

defmodule AoC2015Day06 do
  use AoC

  @size 1000
  @regex ~r/^(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)$/

  def parse(input) do
    for line <- String.split(input, "\n", trim: true) do
      [_, action, x1, y1, x2, y2] = Regex.run(@regex, line)
      [x1, y1, x2, y2] = Enum.map([x1, y1, x2, y2], &String.to_integer/1)

      {parse_action(action), x1..x2, y1..y2}
    end
  end

  defp parse_action("turn on"), do: :on
  defp parse_action("turn off"), do: :off
  defp parse_action("toggle"), do: :toggle

  def part1(input),
    do: run(input, %{on: fn _ -> 1 end, off: fn _ -> 0 end, toggle: &(1 - &1)})

  def part2(input),
    do: run(input, %{on: &(&1 + 1), off: &max(&1 - 1, 0), toggle: &(&1 + 2)})

  defp run(instructions, rules) do
    instructions = Enum.map(instructions, fn {a, xs, ys} -> {Map.fetch!(rules, a), xs, ys} end)

    0..(@size - 1)
    |> Task.async_stream(&run_row(&1, instructions))
    |> Enum.sum_by(fn {:ok, n} -> n end)
  end

  defp run_row(y, instructions) do
    row = :atomics.new(@size, signed: true)

    for {f, xs, ys} <- instructions, y in ys do
      Enum.each(xs, fn x ->
        :atomics.put(row, x + 1, f.(:atomics.get(row, x + 1)))
      end)
    end

    Enum.reduce(1..@size, 0, &(&2 + :atomics.get(row, &1)))
  end

  # The (naive) solution below takes ~24s total on M4, in comparison to ~135ms using :atomics one.
  #
  # @regex ~r/^(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)$/
  #
  # def parse(input) do
  #   for line <- String.split(input, "\n", trim: true) do
  #     [_, action, x1, y1, x2, y2] = Regex.run(@regex, line)
  #     [x1, y1, x2, y2] = Enum.map([x1, y1, x2, y2], &String.to_integer/1)
  #
  #     {parse_action(action), x1..x2, y1..y2}
  #   end
  # end
  #
  # defp parse_action("turn on"), do: :on
  # defp parse_action("turn off"), do: :off
  # defp parse_action("toggle"), do: :toggle
  #
  # defp run(instructions, rules) do
  #   Enum.reduce(instructions, %{}, fn {action, xs, ys}, grid ->
  #     f = Map.fetch!(rules, action)
  #
  #     for x <- xs, y <- ys, reduce: grid do
  #       grid -> Map.update(grid, {x, y}, f.(0), f)
  #     end
  #   end)
  # end
  #
  # def part1(input) do
  #   input
  #   |> run(%{on: fn _ -> 1 end, off: fn _ -> 0 end, toggle: fn n -> 1 - n end})
  #   |> Enum.count(fn {_, v} -> v == 1 end)
  # end
  #
  # def part2(input) do
  #   input
  #   |> run(%{on: &(&1 + 1), off: &max(&1 - 1, 0), toggle: &(&1 + 2)})
  #   |> Map.values()
  #   |> Enum.sum()
  # end
end
