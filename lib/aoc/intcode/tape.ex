defmodule Aoc.Intcode.Tape do
  @type t :: tuple()
  @type mode :: :position | :immediate

  @spec read(Aoc.Intcode.t(), {mode(), Aoc.Intcode.position()}) :: Aoc.Intcode.datum()
  def read(%Aoc.Intcode{tape: data}, {:position, index}), do: elem(data, index)
  def read(_, {:immediate, index}), do: index

  @spec write(Aoc.Intcode.t(), {mode(), Aoc.Intcode.position()}, Aoc.Intcode.datum()) ::
          Aoc.Intcode.t()
  def write(%Aoc.Intcode{} = computer, {_, index}, value) do
    put_in(computer, [Access.key(:tape), Access.elem(index)], value)
  end

  @spec advance(Aoc.Intcode.t(), non_neg_integer()) :: Aoc.Intcode.t()
  def advance(%Aoc.Intcode{} = computer, nsteps) do
    %{computer | position: computer.position + nsteps}
  end

  @spec peek(Aoc.Intcode.t(), non_neg_integer(), Aoc.Intcode.modes()) :: [
          {mode(), Aoc.Intcode.datum()}
        ]
  def peek(computer, nparams, modes) do
    modes
    |> Enum.take(nparams)
    |> Enum.with_index(computer.position + 1)
    |> Enum.map(fn {mode, index} -> {mode, elem(computer.tape, index)} end)
  end

  def jump(computer, pos) do
    %{computer | position: pos}
  end

  @spec new(binary) :: t()
  def new(string) do
    string
    |> String.split(~r/[,\s]/, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
