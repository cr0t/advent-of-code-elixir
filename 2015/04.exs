Code.require_file("../lib/load.exs", __DIR__)

defmodule AoC2015Day04 do
  use AoC

  def part1(input), do: brute(input, 1, 5)
  def part2(input), do: brute(input, 1, 6)

  defp brute(key, n, zeros) do
    digest = :crypto.hash(:md5, [key, Integer.to_string(n)])

    if zeros?(zeros, digest), do: n, else: brute(key, n + 1, zeros)
  end

  # Each hex zero is 4 bits, so:
  #
  # 5 hex zeros = 20 bits = 2 full bytes (0, 0) + 4 bits (0::4)
  # 6 hex zeros = 24 bits = 3 full bytes (0, 0, 0)
  #
  # The digest is a binary of bytes, and each byte shows up as two hex digits.
  # Five zeros ends in the middle of the third byte, so we match only its high
  # nibble (the first 4 bits) with 0::4 and ignore the rest. Six zeros lines up
  # exactly on a byte boundary, so we can match whole bytes.

  defp zeros?(5, <<0, 0, 0::4, _::bitstring>>), do: true
  defp zeros?(6, <<0, 0, 0, _::bitstring>>), do: true
  defp zeros?(_, _), do: false
end
