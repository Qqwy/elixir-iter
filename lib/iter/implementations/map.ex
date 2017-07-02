
# Destructive Iterator
defmodule Iter.Iterator.Implementations.Map do
  @enforce_keys [:rest]
  defstruct rest: []
end

defimpl Iter.Iteratable, for: Map do
  def to_iterator(map) do
    list = :maps.to_list(map)
    %Iter.Iterator.Implementations.Map{rest: list}
  end
end

defimpl Iter.Iterator, for: Iter.Iterator.Implementations.Map do
  def next(%Iter.Iterator.Implementations.Map{rest: []}) do
    {:error, :empty}
  end
  def next(%Iter.Iterator.Implementations.Map{rest: [head | tail]}) do
    iterator = %Iter.Iterator.Implementations.Map{rest: tail}
    {:ok, {head, iterator}}
  end

  def peek(%Iter.Iterator.Implementations.Map{rest: []}) do
    {:error, :empty}
  end
  def peek(%Iter.Iterator.Implementations.Map{rest: [head | _]}) do
    {:ok, head}
  end
end

# Persistent Iterator
defmodule Iter.PersistentIterator.Implementations.Map do
  @moduledoc """
  Based on the 'Zipper' principle.

  Clevery uses improper lists to construct a 'snoc' list that
  can be appended-and-reversed tail-recursively in linear time.

  """

  @enforce_keys [:passed, :rest]
  defstruct rest: [], passed: []
end

defimpl Iter.PersistentIteratable, for: Map do
  def to_iterator(map) do
    list = :maps.to_list(map)
    %Iter.PersistentIterator.Implementations.Map{passed: [], rest: list}
  end
end

defimpl Iter.Iterator, for: Iter.PersistentIterator.Implementations.Map do
  def next(%Iter.PersistentIterator.Implementations.Map{rest: []}) do
    {:error, :empty}
  end
  def next(%Iter.PersistentIterator.Implementations.Map{rest: [head | tail], passed: passed}) do
    iterator = %Iter.PersistentIterator.Implementations.Map{rest: tail, passed: [passed | head]}
    {:ok, {head, iterator}}
  end

  def peek(%Iter.PersistentIterator.Implementations.Map{rest: []}) do
    {:error, :empty}
  end
  def peek(%Iter.PersistentIterator.Implementations.Map{rest: [head | _]}) do
    {:ok, head}
  end
end

defimpl Iter.PersistentIterator, for: Iter.PersistentIterator.Implementations.Map do
  def to_iteratable(%Iter.PersistentIterator.Implementations.Map{passed: passed, rest: rest}) do
    :maps.from_list(reverse_snoc_list(passed, rest))
  end

  defp reverse_snoc_list([], acc), do: acc
  defp reverse_snoc_list([rest | elem], acc), do: reverse_snoc_list(rest, [elem | acc])
end
