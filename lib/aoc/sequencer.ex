defmodule Aoc.Sequencer do
  def new(data, inputs) do
    inputs
    |> Enum.reduce([], fn settings, prev_output ->
      Aoc.Intcode.new(data, settings ++ prev_output)
      |> IO.inspect()
      |> Aoc.Intcode.run()
      |> Map.get(:output)
      |> Enum.reverse()
    end)
  end
end
