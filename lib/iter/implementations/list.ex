# Destructive Iterator
defmodule Iter.Iterator.Implementations.List do
  @required_fields [:rest]
  defstruct rest: []
end

defimpl Iter.Iterable, for: List do
  def to_iterator(list) do
    %Iter.Iterator.Implementations.List{rest: list}
  end
end

defimpl Iter.Iterator, for: Iter.Iterator.Implementations.List do
  def next(%Iter.Iterator.Implementations.List{rest: []}) do
    {:error, :empty}
  end
  def next(%Iter.Iterator.Implementations.List{rest: [head | tail]}) do
    iterator = %Iter.Iterator.Implementations.List{rest: tail}
    {:ok, {head, iterator}}
  end
end

# Persistent Iterator
defmodule Iter.PersistentIterator.Implementations.List do
  @required_fields [:passed, :rest]
  defstruct rest: [], passed: []
end

defimpl Iter.PersistentIterable, for: List do
  def to_iterator(list) do
    %Iter.PersistentIterator.Implementations.List{passed: [], rest: list}
  end
end

defimpl Iter.Iterator, for: Iter.PersistentIterator.Implementations.List do
  def next(%Iter.PersistentIterator.Implementations.List{rest: []}) do
    {:error, :empty}
  end
  def next(%Iter.PersistentIterator.Implementations.List{rest: [head | tail], passed: passed}) do
    iterator = %Iter.PersistentIterator.Implementations.List{rest: tail, passed: [passed | head]}
    {:ok, {head, iterator}}
  end
end

defimpl Iter.PersistentIterator, for: Iter.PersistentIterator.Implementations.List do
  def to_iteratable(%Iter.PersistentIterator.Implementations.List{passed: passed, rest: rest}) do
    reverse_snoc_list(passed, rest)
  end

  defp reverse_snoc_list([], acc), do: acc
  defp reverse_snoc_list([rest | elem], acc), do: reverse_improper_list(rest, [elem | acc])
end
