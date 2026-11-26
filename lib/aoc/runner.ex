defmodule AoC.Runner do
  @moduledoc false

  @parts [:part1, :part2]
  @part_parsers %{part1: :parse1, part2: :parse2}
  @shared_parser :parse

  def run(mod, file) do
    Code.ensure_loaded(mod)
    raw = AoC.Console.read_input()

    stats =
      mod
      |> parts_of()
      |> Enum.reduce({[], %{}}, fn part, acc -> run_part(mod, raw, part, acc) end)
      |> elem(0)
      |> Enum.reverse()

    AoC.Console.print_stats(%{module: mod, file: file}, stats)
  end

  defp parts_of(mod), do: Enum.filter(@parts, &function_exported?(mod, &1, 1))

  # Lookup order: parse1/parse2 (part specific) -> parse -> nil (raw input).
  defp parser_of(mod, part) do
    candidates = [Map.fetch!(@part_parsers, part), @shared_parser]
    Enum.find(candidates, &function_exported?(mod, &1, 1))
  end

  defp run_part(mod, raw, part, {stats, cache}) do
    parser = parser_of(mod, part)
    {parse_time, input, cache} = parsed(mod, parser, raw, cache)
    {run_time, answer} = measure(fn -> apply(mod, part, [input]) end)

    AoC.Console.print_answer(part, answer)

    {[%{part: part, parse: parse_time, run: run_time} | stats], cache}
  end

  # No parser: the part gets the raw string.
  defp parsed(_mod, nil, raw, cache), do: {0, raw, cache}

  # Both parts use the same parser: reuse its result instead of parsing twice.
  defp parsed(_mod, parser, _raw, cache) when is_map_key(cache, parser) do
    {:shared, Map.fetch!(cache, parser), cache}
  end

  defp parsed(mod, parser, raw, cache) do
    {time, input} = measure(fn -> apply(mod, parser, [raw]) end)

    {time, input, Map.put(cache, parser, input)}
  end

  # Returns {microseconds, result}.
  defp measure(fun), do: :timer.tc(fun)
end
