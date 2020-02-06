defmodule Aoc.Intcode.Commands do
  alias Aoc.Intcode.{Language, Tape}

  @spec ast(non_neg_integer()) :: {atom(), non_neg_integer()}
  def ast(1), do: {:add, 3}
  def ast(2), do: {:multiply, 3}
  def ast(3), do: {:input, 1}
  def ast(4), do: {:output, 1}
  def ast(5), do: {:jump_if_true, 2}
  def ast(6), do: {:jump_if_false, 2}
  def ast(7), do: {:less_than, 3}
  def ast(8), do: {:equals, 3}
  def ast(99), do: {:halt, 0}

  @spec run(Aoc.Intcode.t()) :: Aoc.Intcode.t()
  def run(%Aoc.Intcode{tape: tape, position: position} = computer) do
    value = elem(tape, position)
    code = rem(value, 100)
    {name, arity} = ast(code)

    modes =
      value
      |> div(100)
      |> Integer.digits()
      |> Enum.reverse()
      |> Stream.concat(Stream.cycle([0]))
      |> Stream.map(fn
        0 -> :position
        1 -> :immediate
      end)

    args = Tape.peek(computer, arity, modes)

    case apply(Language, name, [computer | args]) do
      {:ok, computer} -> computer |> Tape.advance(arity + 1) |> run()
      {{:jump, n}, computer} -> computer |> Tape.jump(n) |> run()
      {:halt, computer} -> computer
    end
  rescue
    e ->
      IO.inspect(e)
      IO.inspect(computer)
      raise e
  end
end
