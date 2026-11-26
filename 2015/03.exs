Code.require_file("../lib/load.exs", __DIR__)

defmodule AoC2015Day03 do
  use AoC

  def parse(input), do: String.codepoints(input)

  def part1(input) do
    input
    |> Enum.reduce({MapSet.new([{0, 0}]), {0, 0}}, fn move, {houses, {last_x, last_y}} ->
      new_pos =
        case move do
          "^" -> {last_x, last_y + 1}
          ">" -> {last_x + 1, last_y}
          "v" -> {last_x, last_y - 1}
          "<" -> {last_x - 1, last_y}
        end

      {MapSet.put(houses, new_pos), new_pos}
    end)
    |> elem(0)
    |> MapSet.size()
  end

  # The walk-variant works ×2 faster (~500 µs) than MapSet-variant (~1.1 ms, incl. parsing) for 8192
  # moves in the input.
  #
  # ...just do not parse the binary input!
  #
  # def part1(input) do
  #   input
  #   |> walk(0, 0, [0])
  #   |> :lists.usort()
  #   |> length()
  # end
  #
  # defp walk(<<?^, r::binary>>, x, y, acc), do: step(r, x, y + 1, acc)
  # defp walk(<<?>, r::binary>>, x, y, acc), do: step(r, x + 1, y, acc)
  # defp walk(<<?v, r::binary>>, x, y, acc), do: step(r, x, y - 1, acc)
  # defp walk(<<?<, r::binary>>, x, y, acc), do: step(r, x - 1, y, acc)
  # defp walk(_, _x, _y, acc), do: acc
  #
  # defp step(r, x, y, acc), do: walk(r, x, y, [x * 100_000 + y | acc])

  def part2(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce({MapSet.new([{0, 0}]), {0, 0}, {0, 0}}, fn {move, idx},
                                                              {houses, santa, robot} ->
      {last_x, last_y} = if rem(idx, 2) == 0, do: robot, else: santa

      new_pos =
        case move do
          "^" -> {last_x, last_y + 1}
          ">" -> {last_x + 1, last_y}
          "v" -> {last_x, last_y - 1}
          "<" -> {last_x - 1, last_y}
        end

      if rem(idx, 2) == 0 do
        {MapSet.put(houses, new_pos), santa, new_pos}
      else
        {MapSet.put(houses, new_pos), new_pos, robot}
      end
    end)
    |> elem(0)
    |> MapSet.size()
  end
end
