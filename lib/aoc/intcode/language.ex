defmodule Aoc.Intcode.Language do
  alias Aoc.Intcode.{IO, Tape}

  @type address :: {:position | :immediate, non_neg_integer()}

  @spec add(Aoc.Intcode.t(), address(), address(), address()) :: {:ok, Aoc.Intcode.t()}
  def add(computer, a, b, c) do
    value = Tape.read(computer, a) + Tape.read(computer, b)

    {:ok, computer |> Tape.write(c, value) |> Tape.advance(4)}
  end

  @spec multiply(Aoc.Intcode.t(), address(), address(), address()) :: {:ok, Aoc.Intcode.t()}
  def multiply(computer, a, b, c) do
    value = Tape.read(computer, a) * Tape.read(computer, b)

    {:ok, computer |> Tape.write(c, value) |> Tape.advance(4)}
  end

  @spec input(Aoc.Intcode.t(), address()) :: {:ok | :wait, Aoc.Intcode.t()}
  def input(computer, a) do
    with {val, computer} when is_integer(val) <- IO.input(computer) do
      {:ok, computer |> Tape.write(a, val) |> Tape.advance(2)}
    else
      _ -> {:wait, computer}
    end
  end

  @spec output(Aoc.Intcode.t(), address()) :: {:ok, Aoc.Intcode.t()}
  def output(computer, a) do
    value = Tape.read(computer, a)

    {:ok, computer |> IO.output(value) |> Tape.advance(2)}
  end

  @spec jump_if_true(Aoc.Intcode.t(), address(), address()) :: {:ok, Aoc.Intcode.t()}
  def jump_if_true(computer, a, b) do
    case Tape.read(computer, a) do
      0 -> {:ok, computer}
      _ -> {:ok, Tape.jump(computer, Tape.read(computer, b))}
    end
  end

  @spec jump_if_false(Aoc.Intcode.t(), address(), address()) :: {:ok, Aoc.Intcode.t()}
  def jump_if_false(computer, a, b) do
    case Tape.read(computer, a) do
      0 -> {:ok, Tape.jump(computer, Tape.read(computer, b))}
      _ -> {:ok, computer}
    end
  end

  @spec less_than(Aoc.Intcode.t(), address(), address(), address()) :: {:ok, Aoc.Intcode.t()}
  def less_than(computer, a, b, c) do
    value = if Tape.read(computer, a) < Tape.read(computer, b), do: 1, else: 0
    {:ok, computer |> Tape.write(c, value) |> Tape.advance(4)}
  end

  @spec equals(Aoc.Intcode.t(), address(), address(), address()) :: {:ok, Aoc.Intcode.t()}
  def equals(computer, a, b, c) do
    value = if Tape.read(computer, a) == Tape.read(computer, b), do: 1, else: 0
    {:ok, computer |> Tape.write(c, value) |> Tape.advance(4)}
  end

  @spec halt(Aoc.Intcode.t()) :: {:halt, Aoc.Intcode.t()}
  def halt(computer) do
    {:halt, computer}
  end
end
