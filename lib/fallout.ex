defmodule Fallout do
  def hack, do: hack IO.gets "Available words? "
  def hack(word_list) when is_list(word_list) do
    scored_words = score_words(word_list)
    word_to_try = scored_words |> best_word |> suggested_word |> String.upcase
    IO.puts "Optimal word to try next: #{word_to_try}"
    likeness = IO.gets "Likeness for #{word_to_try}? "
    likeness = likeness |> String.rstrip |> String.to_integer
    word_list |> Stream.filter(&(compare(&1, word_to_try) == likeness)) |> Enum.join(" ") |> hack
  end
  def hack(words) do
    words = words |> String.rstrip |> String.upcase
    IO.puts "Possible words remaining: #{words}"
    words |> String.split(" ") |> hack
  end

  def best_word(scored_words),      do: scored_words |> Enum.max_by fn({_, v}) -> v end
  def suggested_word({word, _val}), do: word

  @doc """
  Find the amount of common letters at identical indexes between 2 strings
  """
  def compare(a, b),                do: compare(to_charlist(a), to_charlist(b), 0)
  def compare([], _, acc),          do: acc
  def compare([a|t1], [a|t2], acc), do: compare(t1, t2, acc + 1)
  def compare([_|t1], [_|t2], acc), do: compare(t1, t2, acc)

  def score_words(""),              do: :error
  def score_words(word_list),       do: Enum.zip(word_list, word_score_values(word_list)) |> to_map

  def word_score_values(word_list), do: word_list |> Enum.map &(score_word(&1, count_chars(word_list)))

  def score_word(word, map),        do: word |> String.codepoints |> score_word(map, 0)
  def score_word([h|t], map, acc),  do: score_word(t, map, acc + score_letter(h, map))
  def score_word([], _map, acc),    do: acc

  def score_letter(letter, map),    do: Map.fetch(map, String.to_atom(letter)) |> score_letter
  def score_letter({:ok, value}),   do: value
  def score_letter({:error}),       do: 0

  def to_list(string),              do: String.split(string, [" ", ","], trim: true)
  def to_charlist(string),          do: String.split(string, "", trim: true)
  def to_map(kw_list),              do: Enum.into(kw_list, %{})
  def list_to_string(list),         do: Enum.map(list, &("#{&1} ")) |> List.to_string |> String.rstrip
  def alphabet_map(value \\ 0),     do: Enum.into ?A..?Z, %{}, &{String.to_atom(<<&1>>), value}

  def count_chars(list),            do: list |> Enum.join("") |> String.codepoints |> count_chars(alphabet_map)
  def count_chars([], map),         do: map
  def count_chars([h|t], map),      do: count_chars(t, Map.update!(map, String.to_atom(h), &(&1 +1)))
end
