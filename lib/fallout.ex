defmodule Fallout do
  def hack do
    IO.gets("Available words? ") |> String.rstrip |> String.upcase |> hack
  end
  def hack(words) when not is_list(words) do
    IO.puts("Remaining Possibilities: #{words}")
    words |> String.split(" ") |> hack
  end
  def hack([ word | [] ]) do
    vaultboy
    IO.puts "The Solution Is \"#{word}\""
  end
  def hack(word_list) do
    suggested_word = suggest_word(word_list)
    likeness = get_likeness(suggested_word)
    word_list
    |> Stream.filter(&(compare(&1, suggested_word) == likeness))
    |> Enum.join(" ")
    |> hack
  end

  @doc """
  Suggests the word with most commonly used characters among the word list.
  """
  def suggest_word(word_list) do
    suggested_word = word_list |> get_best_word
    IO.puts("Try This Word: #{suggested_word}")
    suggested_word
  end
  defp get_best_word(word_list) do
    word_list
    |> Stream.map(&(score_word(&1, count_chars(word_list))))
    |> Stream.zip(word_list)
    |> Enum.max
    |> Tuple.to_list
    |> Enum.at(1)
  end

  @doc """
  Asks user for the likeness result and returns as an integer.
  """
  def get_likeness(word) do
    IO.gets("Likeness for #{word}? ") |> String.rstrip |> String.to_integer
  end
  defp score_word(word, map),        do: word |> String.codepoints |> score_word(map, 0)
  defp score_word([h|t], map, acc),  do: score_word(t, map, acc + score_letter(h, map))
  defp score_word([], _map, acc),    do: acc
  defp score_letter(letter, map),    do: Map.fetch(map, String.to_atom(letter)) |> score_letter
  defp score_letter({:ok, value}),   do: value
  defp score_letter({:error}),       do: 0

  @doc """
  Find the amount of common letters at identical indexes between 2 strings

  ## Examples
      ...> Fallout.compare("WALL", "BALL")
      3
  """
  def  compare(a, b),                do: compare(String.codepoints(a), String.codepoints(b), 0)
  defp compare([], _, acc),          do: acc
  defp compare([a|t1], [a|t2], acc), do: compare(t1, t2, acc + 1)
  defp compare([_|t1], [_|t2], acc), do: compare(t1, t2, acc)

  @doc """
  Returns a map with the total character count (A-Z) of the list.

  ## Examples
      ...> Fallout.count_chars(["ABC", "BCD"])
      %{A: 1, B: 2, C: 2, D: 1, E: 0, F: 0, ...}
  """
  def  count_chars(list),            do: list |> Enum.join("") |> String.codepoints |> count_chars(alphabet_map)
  defp count_chars([], map),         do: map
  defp count_chars([h|t], map),      do: count_chars(t, Map.update!(map, String.to_atom(h), &(&1 +1)))
  defp alphabet_map(value \\ 0),     do: Enum.into ?A..?Z, %{}, &{String.to_atom(<<&1>>), value}

  def vaultboy do
    IO.puts """
    ░░░░░░░░░░░░░░░░░░▄▄░░░░░░░░░░░
    ░░░░░▄░░░░░░▄▄▄░░████▄▄░░░░░░░░
    ░░░░░██▄▄▄██████████████▄▄░░░░░
    ░░░░██████▀▒▀▀███▀████████▄░░░░
    ░░░▄▀▀▀▀▀▒████▄▄▄█▄▒▀███████░░░
    ░░░▀▒██▀▒████████████▄▄▄▄▒███░░
    ░░░░█████████████▄▀▀█████▀▄██░░
    ░░░▄██░░███████████▄████▒████░░
    ░░▄███▄███▒▄███▀░██████▄▀▄██▀░░
    ░░██████▀▒█████▄███████░▀░░▀░░░
    ░░██████▄█████████████▀░▒▄░░░░░
    ░░██▄▒▀▀██████▀▀███████▄█▀░░░░░
    ░░██▄▀▀▄▄▄▄▄▄▄▀░██████████░░░░░
    ░░░▀██▄░▄███▄▄▄█████████▀▀░░░░░
    ░░░░████▄▄███████████░░░░░░░░░░
    ░░░░░▀█████████████▀░░░░░░░░░░░
    ░░░░░░░▀▀▀███████▒░░░░░░░░░░░░░
    ░░░░░░░░░░░▀▀▀▀░░░░░░░░░░░░░░░░
    """
  end
end
