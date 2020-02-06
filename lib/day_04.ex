defmodule Day04 do
  def one() do
    # ~w"134792 675810"
    [low, high] =
      ~w"134792 675810"
      |> Enum.map(&String.to_charlist(&1))
      |> Enum.map(&Enum.map(&1, fn i -> i - 48 end))

    count(low, high, false)
  end

  def two() do
    [low, high] =
      ~w"134792 675810"
      |> Enum.map(&String.to_charlist(&1))
      |> Enum.map(&Enum.map(&1, fn i -> i - 48 end))

    all(low, high, false)
    |> Enum.filter(fn ls ->
      ls
      |> Enum.group_by(& &1)
      |> Enum.map(&(&1 |> elem(1) |> length()))
      |> Enum.any?(fn x -> x == 2 end)
    end)
    |> length()
  end

  @spec count(low :: list(integer()), high :: list(integer()), dup_found? :: boolean()) ::
          non_neg_integer()

  # def count([_, _, _, _], _, _), do: 0

  def count([n | _], _, _) when n > 9, do: 0

  def count([m], [m], true), do: 1
  def count([m], [n], true) when n > m, do: n - m + 1
  def count([_], [_], _), do: 0

  # skip all cases where the low limit is more than high limit
  def count([a | _], [b | _], _) when b < a, do: 0

  # bump up the low limit when it is decreasing
  def count([a1, a2 | _] = as, bs, f) when a2 < a1,
    do: count(List.duplicate(a1, length(as)), bs, f)

  # count from [x, x, ...] to [x, x, ...] (set found to true and drop 1)
  def count([a1 | [a1 | _] = ass], [a1 | [a1 | _] = bss], _) do
    count(ass, bss, true)
  end

  # count from [x, x, ...] to [x, ...] (split at a->[x, x, 9...] and [x, x+1...]->b)
  def count([a1 | [a1 | _] = ass], [a1 | [b1 | bsss] = bss], found?) when b1 >= a1 do
    count(ass, [a1 | List.duplicate(9, length(bsss))], true) +
      count(List.duplicate(a1 + 1, length(bss)), bss, found?)
  end

  def count([a1 | [a1 | _] = _] = _, [a1 | [_ | _] = _] = _, _), do: 0

  # count from [x, y, ...] to [x, ...] (y > x)
  def count([a1 | ass], [a1 | bss], found?), do: count(ass, bss, found?)

  # split count [x, ...] -> [y, ...] at a->[x, 9, ...] and [x+1...]->b
  def count([a1 | ass] = as, bs, found?) do
    n = length(ass)

    count(as, [a1 | List.duplicate(9, n)], found?) +
      count(List.duplicate(a1 + 1, n + 1), bs, found?)
  end

  @spec all(low :: list(integer()), high :: list(integer()), dup_found? :: boolean()) ::
          list(list(integer()))

  def all([n | _], _, _) when n > 9, do: []

  def all([m], [m], true), do: [[m]]
  def all([m], [n], true) when n > m, do: Enum.map(m..n, &[&1])
  def all([_], [_], _), do: []

  # skip all cases where the low limit is more than high limit
  def all([a | _], [b | _], _) when b < a, do: []

  # bump up the low limit when it is decreasing
  def all([a1, a2 | _] = as, bs, f) when a2 < a1,
    do: all(List.duplicate(a1, length(as)), bs, f)

  # all from [x, x, ...] to [x, x, ...] (set found to true and drop 1)
  def all([a1 | [a1 | _] = ass], [a1 | [a1 | _] = bss], _) do
    all(ass, bss, true) |> prepend(a1)
  end

  # all from [x, x, ...] to [x, ...] (split at a->[x, x, 9...] and [x, x+1...]->b)
  def all([a1 | [a1 | _] = ass], [a1 | [b1 | bsss] = bss], found?) when b1 >= a1 do
    (all(ass, [a1 | List.duplicate(9, length(bsss))], true) ++
       all(List.duplicate(a1 + 1, length(bss)), bss, found?))
    |> prepend(a1)
  end

  def all([a1 | [a1 | _] = _] = _, [a1 | [_ | _] = _] = _, _), do: []

  # all from [x, y, ...] to [x, ...] (y > x)
  def all([a1 | ass], [a1 | bss], found?) do
    all(ass, bss, found?) |> prepend(a1)
  end

  # split all [x, ...] -> [y, ...] at a->[x, 9, ...] and [x+1...]->b
  def all([a1 | ass] = as, bs, found?) do
    n = length(ass)

    all(as, [a1 | List.duplicate(9, n)], found?) ++
      all(List.duplicate(a1 + 1, n + 1), bs, found?)
  end

  defp prepend(items, head), do: Enum.map(items, &[head | &1])
end
