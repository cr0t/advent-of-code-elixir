defmodule AoC.Console do
  @moduledoc false

  @us_per_ms 1_000
  @us_per_s 1_000_000
  @decimals 2

  @stats_divider "--"
  @part_color :blue
  @dim_style :faint

  # Colors are always on: output is only read in a terminal or under watchexec.
  @emit_ansi true

  # "/repo/elixir/2015/01.exs" -> last 2 segments -> "2015/01"
  @day_segments 2

  def read_input do
    case IO.read(:stdio, :eof) do
      :eof -> ""
      data -> String.trim_trailing(data)
    end
  end

  def print_answer(part, answer) do
    IO.puts("#{paint(@part_color, part)}: #{answer}")
  end

  # stderr carries timings, dimmed as a single block, e.g.:
  # -- AoC2015Day01 (2015/01)
  # part1: parse 212 µs + run 180 µs
  # part2: parse shared + run 205 µs
  # total: 597 µs
  def print_stats(_source, []), do: :ok

  def print_stats(source, stats) do
    total = Enum.sum(for s <- stats, do: us(s.parse) + s.run)

    lines =
      [header(source)] ++
        Enum.map(stats, &part_line/1) ++
        ["total: #{fmt(total)}"]

    IO.puts(:stderr, paint(@dim_style, Enum.join(lines, "\n")))
  end

  defp header(%{module: mod, file: file}) do
    "#{@stats_divider} #{inspect(mod)} (#{day_of(file)})"
  end

  defp day_of(file) do
    file
    |> Path.rootname()
    |> Path.split()
    |> Enum.take(-@day_segments)
    |> Path.join()
  end

  defp part_line(%{part: part, parse: parse, run: run}) do
    "#{part}: parse #{fmt(parse)} + run #{fmt(run)}"
  end

  defp us(:shared), do: 0
  defp us(time), do: time

  defp fmt(:shared), do: "shared"
  defp fmt(us) when us < @us_per_ms, do: "#{us} µs"
  defp fmt(us) when us < @us_per_s, do: "#{Float.round(us / @us_per_ms, @decimals)} ms"
  defp fmt(us), do: "#{Float.round(us / @us_per_s, @decimals)} s"

  # to_string/1: parts are atoms, which IO.ANSI.format/2 would read as style names.
  defp paint(style, text) do
    [style, to_string(text)]
    |> IO.ANSI.format(@emit_ansi)
    |> IO.iodata_to_binary()
  end
end
