defmodule Aoc.Intcode.IO do
  @spec input(Aoc.Intcode.t()) :: {Aoc.Intcode.datum() | nil, Aoc.Intcode.t()}
  def input(%Aoc.Intcode{input: []} = computer) do
    {nil, computer}
  end

  def input(%Aoc.Intcode{input: [head | rest]} = computer) do
    {head, %{computer | input: rest}}
  end

  @spec output(Aoc.Intcode.t(), any) :: Aoc.Intcode.t()
  def output(computer, value) do
    send(computer.output, value)
    computer
  end
end
