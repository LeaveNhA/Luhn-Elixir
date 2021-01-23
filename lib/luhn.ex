defmodule Luhn do
  import Integer

  @acceptableSpecialCharacters [" "]
  @acceptableCharacters for n <- ?0..?9, do: << n :: utf8 >>

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    validate(number)
    &&
    number
    |> String.split("")
    |> Enum.filter(fn i -> Integer.parse(i) != :error end)
    |> Enum.reverse
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&(elem(&1, 0)))
    |> Enum.with_index(1)
    |> Enum.map(fn {v, i} -> Integer.is_even(i) && v * 2 || v end)
    |> Enum.map(fn n -> n > 9 && n - 9 || n end)
    |> Enum.sum
    |> (&(rem(&1, 10))).()
    |> (&(Kernel.==(&1, 0))).()
  end

  defp validate(input) do
    input
    |> String.trim
    |> String.split("")
    |> Enum.filter(fn s -> s != "" end)
    |> Enum.group_by(fn s -> !(Kernel.in(s, @acceptableSpecialCharacters ++ @acceptableCharacters)) end)
    |> validation_helper
  end

  defp validation_helper(%{true => _}), do: false
  defp validation_helper(%{true => invalids, false => valids}),
    do: Enum.count(invalids) == 0 and Enum.count(valids) > 1
  defp validation_helper(%{false => valids}), do: Enum.count(valids) > 1
end
