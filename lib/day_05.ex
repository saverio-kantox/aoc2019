defmodule Day05 do
  @doc """
  iex> Day05.one()
  10987514
  """
  def one() do
    "priv/day_05_input.txt"
    |> File.read!()
    |> Aoc.Intcode.new([1])
    |> Aoc.Intcode.run()
    |> Aoc.Intcode.diag()
  end

  @doc """
  iex> Day05.two()
  14195011
  """
  def two() do
    "priv/day_05_input.txt"
    |> File.read!()
    |> Aoc.Intcode.new([5])
    |> Aoc.Intcode.run()
    |> Aoc.Intcode.diag()
  end
end
