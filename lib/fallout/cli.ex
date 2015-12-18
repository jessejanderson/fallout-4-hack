defmodule Fallout.CLI do
  import Fallout

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                               aliases:  [ h:    :help    ])
    case parse do
      {[help: true], _, _} -> :help
      {_, list, _}         -> list
      _                    -> :help
    end
  end

  def process(:help) do
    IO.puts "Help Goes Here!"
  end

  def process(list) when is_list(list) do
    list
    |> Enum.join(" ")
    |> String.upcase
    |> Fallout.hack
  end
  def process(a) do
    IO.puts "what is it?"
  end
end
