defmodule Day03 do
  @doc """
  iex> Day03.one()
  209

  """
  def one() do
    {_f, _s, common} = trails()

    common |> Enum.map(fn {x, y} -> abs(x) + abs(y) end) |> Enum.min()
  end

  @doc """
  iex> Day03.two()
  43258

  """
  def two() do
    {f, s, common} = trails()

    common |> Enum.map(fn x -> f[x] + s[x] end) |> Enum.min()
  end

  defp trails() do
    [f, s] =
      "priv/day_03_input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&trail/1)

    fk = f |> Map.keys() |> MapSet.new()
    sk = s |> Map.keys() |> MapSet.new()

    common = MapSet.intersection(fk, sk) |> MapSet.delete({0, 0})

    {f, s, common}
  end

  defp trail(string) do
    string
    |> String.split(",")
    |> Enum.map(fn <<dir::binary-size(1), n::binary>> -> {dir, String.to_integer(n)} end)
    |> Enum.reduce({{0, 0}, 0, %{{0, 0} => 0}}, fn step, path -> do_one_move(path, step) end)
    |> elem(2)
  end

  defp do_one_move({{x, y}, j, ms}, {dir, n}) do
    ms =
      for i <- 1..n, reduce: ms do
        m -> Map.put_new(m, up(dir, {x, y}, i), j + i)
      end

    {up(dir, {x, y}, n), j + n, ms}
  end

  defp up("R", {x, y}, st), do: {x + st, y}
  defp up("L", {x, y}, st), do: {x - st, y}
  defp up("U", {x, y}, st), do: {x, y + st}
  defp up("D", {x, y}, st), do: {x, y - st}
end
