defmodule Aoc.Intcode.Runner do
  use GenServer

  def start_link(opts) do
    {init_arg, options} = Keyword.split(opts, ~w[tape input]a)
    GenServer.start_link(__MODULE__, init_arg, options)
  end

  def init(init_arg) do
    computer = Aoc.Intcode.new(Keyword.fetch!(init_arg, :tape), Keyword.get(init_arg, :input, []))
    {:ok, computer, {:continue, :run}}
  end

  def handle_continue(:run, computer) do
    {cmd, args} = get_command_and_args(computer)

    case apply(Aoc.Intcode.Language, cmd, [computer | args]) do
      {:ok, computer} ->
        {:noreply, computer, {:continue, :run}}

      {:wait, computer} ->
        {:noreply, computer}

      {:halt, computer} ->
        {:stop, computer}
    end
  end

  def handle_info({:input, n}, computer) do
    computer = %{computer | input: computer.input ++ [n]}
    {:noreply, computer, {:continue, :run}}
  end

  @spec get_command_and_args(Aoc.Intcode.t()) :: {atom(), [{:immediate | :position, integer}]}
  def get_command_and_args(%Aoc.Intcode{position: position, tape: tape}) do
    cur = elem(tape, position)

    {cmd, arity} =
      cur
      |> rem(100)
      |> case do
        1 -> {:add, 3}
        2 -> {:multiply, 3}
        3 -> {:input, 1}
        4 -> {:output, 1}
        5 -> {:jump_if_true, 2}
        6 -> {:jump_if_false, 2}
        7 -> {:less_than, 3}
        8 -> {:equals, 3}
        99 -> {:halt, 0}
      end

    args =
      cur
      |> div(100)
      |> Integer.digits()
      |> Enum.reverse()
      |> Stream.concat(Stream.cycle([0]))
      |> Enum.take(arity)
      |> Enum.map(fn
        1 -> :immediate
        _ -> :position
      end)
      |> Enum.with_index(position + 1)
      |> Enum.map(fn {mode, pos} -> {mode, elem(tape, pos)} end)

    {cmd, args}
  end
end
