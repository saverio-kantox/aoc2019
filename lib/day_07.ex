defmodule Day07 do
  @doc """
  iex> Day07.one()
  :foo
  """
  def one() do
    data = File.read!("priv/day_07_input.txt")

    [0, 1, 2, 3, 4]
    |> perm()
    |> Enum.map(fn i -> Enum.map(i, &[&1]) end)
    |> IO.inspect()
    |> Enum.each(fn settings -> Aoc.Sequencer.new(data, settings) end)
    |> Enum.max()
  end

  defp perm([]), do: [[]]

  defp perm(list) do
    for h <- list, t <- perm(list -- [h]), do: [h | t]
  end
end
