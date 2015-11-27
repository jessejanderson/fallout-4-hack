defmodule Fallout do
  def hack do
    IO.gets("Available words? ") |> String.rstrip |> String.upcase |> hack
  end
  def hack(words) when not is_list(words) do
    words |> pipe_puts("Words remaining: ") |> String.split(" ") |> hack
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
  Suggests the best word to try.
  """
  def suggest_word(word_list) do
    word_list
    |> best_word
    |> pipe_puts("Try This Word: ")
  end

  @doc """
  Finds the word with the most characters in common with the entire word list.
  """
  def best_word(word_list) do
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

  def word_score_values(word_list), do: word_list |> Enum.map &(score_word(&1, count_chars(word_list)))

  def score_word(word, map),        do: word |> String.codepoints |> score_word(map, 0)
  def score_word([h|t], map, acc),  do: score_word(t, map, acc + score_letter(h, map))
  def score_word([], _map, acc),    do: acc

  def score_letter(letter, map),    do: Map.fetch(map, String.to_atom(letter)) |> score_letter
  def score_letter({:ok, value}),   do: value
  def score_letter({:error}),       do: 0

  def pipe_puts(string, pre_text, post_text \\ "") do
    IO.puts(pre_text <> string <> post_text)
    string
  end


  @doc """
  Find the amount of common letters at identical indexes between 2 strings
  """
  def compare(a, b),                do: compare(to_charlist(a), to_charlist(b), 0)
  def compare([], _, acc),          do: acc
  def compare([a|t1], [a|t2], acc), do: compare(t1, t2, acc + 1)
  def compare([_|t1], [_|t2], acc), do: compare(t1, t2, acc)

  def to_list(string),              do: String.split(string, [" ", ","], trim: true)
  def to_charlist(string),          do: String.split(string, "", trim: true)
  def to_map(kw_list),              do: Enum.into(kw_list, %{})
  def list_to_string(list),         do: Enum.map(list, &("#{&1} ")) |> List.to_string |> String.rstrip
  def alphabet_map(value \\ 0),     do: Enum.into ?A..?Z, %{}, &{String.to_atom(<<&1>>), value}

  def count_chars(list),            do: list |> Enum.join("") |> String.codepoints |> count_chars(alphabet_map)
  def count_chars([], map),         do: map
  def count_chars([h|t], map),      do: count_chars(t, Map.update!(map, String.to_atom(h), &(&1 +1)))

  # def suggested_word({word, _val}), do: word
end
