Code.require_file("../lib/load.exs", __DIR__)

defmodule AoC2020Day04 do
  use AoC

  def parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.replace(&1, "\n", " "))
    |> Enum.map(fn passport_record ->
      passport_record
      |> String.split()
      |> Enum.sort()
      |> Enum.map(fn passport_details ->
        [field, value] = String.split(passport_details, ":")

        {String.to_existing_atom(field), value}
      end)
    end)
  end

  def part1(passports) do
    Enum.count(passports, &all_required_fields?/1)
  end

  def part2(passports) do
    passports
    |> Enum.filter(&all_required_fields?/1)
    |> Enum.count(fn passport ->
      Enum.all?(passport, &valid?/1)
    end)
  end

  defp all_required_fields?([
         {:byr, _},
         {:cid, _},
         {:ecl, _},
         {:eyr, _},
         {:hcl, _},
         {:hgt, _},
         {:iyr, _},
         {:pid, _}
       ]),
       do: true

  defp all_required_fields?([
         {:byr, _},
         {:ecl, _},
         {:eyr, _},
         {:hcl, _},
         {:hgt, _},
         {:iyr, _},
         {:pid, _}
       ]),
       do: true

  defp all_required_fields?(_), do: false

  # byr (Birth Year) - four digits; at least 1920 and at most 2002.
  defp valid?({:byr, year}) when is_binary(year), do: valid?({:byr, String.to_integer(year)})
  defp valid?({:byr, year}) when year >= 1920 and year <= 2002, do: true
  defp valid?({:byr, _year}), do: false

  # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  defp valid?({:iyr, year}) when is_binary(year), do: valid?({:iyr, String.to_integer(year)})
  defp valid?({:iyr, year}) when year >= 2010 and year <= 2020, do: true
  defp valid?({:iyr, _year}), do: false

  # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  defp valid?({:eyr, year}) when is_binary(year), do: valid?({:eyr, String.to_integer(year)})
  defp valid?({:eyr, year}) when year >= 2020 and year <= 2030, do: true
  defp valid?({:eyr, _year}), do: false

  # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  defp valid?({:hcl, color}), do: Regex.match?(~r/^#[0-9a-f]{6}$/, color)

  # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  defp valid?({:ecl, color}) when color in ~W(amb blu brn gry grn hzl oth), do: true
  defp valid?({:ecl, _color}), do: false

  # pid (Passport ID) - a nine-digit number, including leading zeroes.
  defp valid?({:pid, passport_id}), do: String.length(passport_id) == 9

  # cid (Country ID) - ignored, missing or not.
  defp valid?({:cid, _country_id}), do: true

  # hgt (Height) - a number followed by either cm or in:
  # - if cm, the number must be at least 150 and at most 193.
  # - if in, the number must be at least 59 and at most 76.
  defp valid?({:hgt, height_value}) do
    case Regex.scan(~r/^([0-9]+)(cm|in)$/, height_value) do
      [[_, height, "cm"]] ->
        height = String.to_integer(height)
        height >= 150 && height <= 193

      [[_, height, "in"]] ->
        height = String.to_integer(height)
        height >= 59 && height <= 76

      [] ->
        false
    end
  end
end
