defmodule Aoc.Intcode do
  @moduledoc """
  An intcode computer.

  # Examples

  iex> import Aoc.Intcode
  iex> "1,0,0,0,99" |> new() |> run() |> read(0)
  2
  iex> "2,3,0,3,99" |> new() |> run() |> read(0)
  2
  iex> "2,4,4,5,99,0" |> new() |> run() |> read(0)
  2
  iex> "1,1,1,4,99,5,6,0,99" |> new() |> run() |> read(0)
  30
  iex> "1002,4,3,4,33" |> new() |> run() |> read(4)
  99
  iex> "1101,100,-1,4,0" |> new() |> run() |> read(4)
  99
  iex> "3,9,8,9,10,9,4,9,99,-1,8" |> new([8]) |> run() |> output()
  1
  iex> "3,9,8,9,10,9,4,9,99,-1,8" |> new([7]) |> run() |> output()
  0
  iex> "3,9,8,9,10,9,4,9,99,-1,8" |> new([9]) |> run() |> output()
  0
  iex> "3,3,1108,-1,8,3,4,3,99" |> new([8]) |> run() |> output()
  1
  iex> "3,3,1108,-1,8,3,4,3,99" |> new([7]) |> run() |> output()
  0
  iex> "3,3,1108,-1,8,3,4,3,99" |> new([9]) |> run() |> output()
  0
  iex> "3,9,7,9,10,9,4,9,99,-1,8" |> new([8]) |> run() |> output()
  0
  iex> "3,9,7,9,10,9,4,9,99,-1,8" |> new([7]) |> run() |> output()
  1
  iex> "3,9,7,9,10,9,4,9,99,-1,8" |> new([9]) |> run() |> output()
  0
  iex> "3,3,1107,-1,8,3,4,3,99" |> new([8]) |> run() |> output()
  0
  iex> "3,3,1107,-1,8,3,4,3,99" |> new([7]) |> run() |> output()
  1
  iex> "3,3,1107,-1,8,3,4,3,99" |> new([9]) |> run() |> output()
  0

  """
  defstruct tape: {}, position: 0, input: [], output: []

  @type datum :: integer()
  @type position :: non_neg_integer()
  @type command :: datum()
  @type modes :: Enum.t()

  @spec new(binary, any) :: Aoc.Intcode.t()
  def new(tape, input \\ []) when is_binary(tape) do
    %__MODULE__{tape: Aoc.Intcode.Tape.new(tape), position: 0, input: input, output: []}
  end

  def read(computer, index) do
    Aoc.Intcode.Tape.read(computer, {:position, index})
  end

  @spec configure(Aoc.Intcode.t(), [{position(), datum()}]) :: Aoc.Intcode.t()
  def configure(%__MODULE__{} = computer, values) do
    for {index, value} <- values, reduce: computer do
      acc -> put_in(acc, [Access.key(:tape), Access.elem(index)], value)
    end
  end

  @spec run(Aoc.Intcode.t()) :: Aoc.Intcode.t()
  def run(computer) do
    Aoc.Intcode.Commands.run(computer)
    # value = elem(tape, position)
    # code = rem(value, 100)

    # modes =
    #   value
    #   |> div(100)
    #   |> Integer.digits()
    #   |> Enum.reverse()
    #   |> Stream.concat(Stream.cycle([0]))

    # case Aoc.Intcode.Commands.command(code, modes, computer) do
    #   {:cont, computer} -> run(computer)
    #   {:stop, computer} -> computer
    # end
  end

  def diag(computer) do
    [code | zeroes] = computer.output

    if Enum.all?(zeroes, &(&1 === 0)) do
      code
    end
  end

  def output(computer), do: hd(computer.output)
end
