defmodule Day16 do
  @doc """
  iex> Day16.one()
  "94960436"

  """
  def one() do
    "priv/day_16_input.txt"
    |> File.read!()
    |> String.trim()
    |> String.to_charlist()
    |> Enum.map(&(&1 - 48))
    |> Day16.transform(100)
    |> Enum.join()
  end

  def transform(input, nsteps) do
    1..nsteps |> Enum.reduce(input, fn _, input -> transform_step(input) end) |> Enum.take(8)
  end

  def transform_full(input, nsteps) do
    to_skip = input |> Enum.take(7) |> Enum.join() |> String.to_integer()
    input = input |> List.duplicate(10) |> List.flatten()

    1..nsteps
    |> Enum.reduce(input, fn _, input -> transform_step(input) end)
    |> Enum.drop(to_skip)
    |> Enum.take(8)
  end

  def transform_step(input) do
    for i <- 1..length(input) do
      input
      |> Enum.with_index(1)
      |> Enum.reduce(0, fn {x, j}, acc ->
        case rem(div(j, i), 4) do
          1 -> acc + x
          3 -> acc - x
          _ -> acc
        end
      end)
      |> case do
        0 -> 0
        n when n < 0 -> rem(-n, 10)
        n -> rem(n, 10)
      end
    end
  end
end
