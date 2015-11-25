defmodule Fallout do
  def hack,        do: hack IO.gets "Available words? "
  def hack(words)  do
    words = words |> String.rstrip |> String.upcase
    scored_words = words |> score_words
    word_to_try = scored_words |> best_word |> suggested_word |> String.upcase
    word_list = words |> to_list
    IO.puts "Possible words remaining: #{words}"
    IO.puts "Optimal word to try next: #{word_to_try}"
    likeness = IO.gets "Likeness for #{word_to_try}? "
    if "exit\n" == likeness do
      :ok
    else
      likeness = likeness |> String.rstrip |> String.to_integer
      words
      |> to_list
      |> Enum.filter(&(compare(&1, word_to_try) == likeness))
      |> Enum.join(" ")
      |> hack
    end
  end

  def suggested_word({word, _val}), do: word

  @doc """
  See if a given `string` matches all other options in a given map
  """
  def matches_all?(map, string), do: Enum.all? map, &F4.match?(&1, string)

  @doc """
  Call the `compare` function on a key and a string
  """
  def match?({a, value}, b), do: value === compare(Atom.to_string(a), b)

  @doc """
  Find the amount of common letters at identical indexes between 2 strings
  """
  def  compare(a, b),               do: compare(to_charlist(a), to_charlist(b), 0)
  defp compare([], _, acc),         do: acc
  defp compare([a|at], [b|bt], acc) do
    if (a === b), do: acc = acc + 1
    compare(at, bt, acc)
  end


  def score_words(""),    do: :error
  def score_words(words), do: Enum.zip(word_score_keys(words), word_score_values(words)) |> to_map

  def word_score_keys(words),       do: words |> to_list
  def word_score_values(words),     do: words |> to_list |> Enum.map &(score_word(&1, count_chars(words)))

  def score_word(word, map),        do: word |> String.codepoints |> score_word(map, 0)
  def score_word([h|t], map, acc),  do: score_word(t, map, acc + score_letter(h, map))
  def score_word([], _map, acc),    do: acc

  def score_letter(letter, map),    do: Map.fetch(map, String.to_atom(letter)) |> score_letter
  def score_letter({:ok, value}),   do: value
  def score_letter({:error}),       do: 0

  def best_word(scored_words), do: scored_words |> Enum.max_by fn({_, v}) -> v end

  def to_list(string),              do: String.split(string, [" ", ","], trim: true)
  def to_charlist(string),          do: String.split(string, "", trim: true)
  def to_map(kw_list),              do: Enum.into(kw_list, %{})
  def list_to_string(list),         do: Enum.map(list, &("#{&1} ")) |> List.to_string |> String.rstrip
  def alphabet_map(value \\ 0),     do: Enum.into ?A..?Z, %{}, &{String.to_atom(<<&1>>), value}

  def count_chars(s),         do: s |> String.replace(" ", "") |> String.codepoints |> count_chars(alphabet_map)
  def count_chars([], map),   do: map
  def count_chars([h|t], map) do
    map = Map.update!(map, String.to_atom(h), &(&1 +1))
    count_chars(t, map)
  end
end
