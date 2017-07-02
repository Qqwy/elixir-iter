# Destructive Iterator
defmodule Iter.Iterator.Implementations.Range do
  @enforce_keys [:current, :last]
  defstruct current: 0, last: 0

  defimpl Iter.Iterator do
    # When inclusive range is exhausted.
    def next(%@for{current: nil}) do
      {:error, :empty}
    end
    # When end of inclusive range is reached, change iterator to exhausted iterator.
    def next(%@for{current: last, last: last}) do
      {:ok, {last, %@for{current: nil, last: last}}}
    end
    def next(%@for{current: current, last: last}) when current < last do
      new_iterator = %@for{current: current + 1, last: last}
      {:ok, {current, new_iterator}}
    end
    def next(%@for{current: current, last: last}) when current > last do
      new_iterator = %@for{current: current - 1, last: last}
      {:ok, {current, new_iterator}}
    end

    def peek(%@for{current: nil}), do: {:error, :empty}
    def peek(%@for{current: current}), do: {:ok, current}
  end
end

defimpl Iter.Iteratable, for: Range do
  def to_iterator(first..last) do
    %Iter.Iterator.Implementations.Range{current: first, last: last}
  end
end

# Persistent Iterator
defmodule Iter.PersistentIterator.Implementations.Range do
  @enforce_keys [:current, :first, :last]
  defstruct current: nil, first: 0, last: 0

  defimpl Iter.Iterator do
    # When inclusive range is exhausted.
    def next(%@for{current: nil}) do
      {:error, :empty}
    end
    # When end of inclusive range is reached, change iterator to exhausted iterator.
    def next(iterator = %@for{current: last, last: last}) do
      {:ok, {last, %@for{iterator | current: nil}}}
    end
    def next(iterator = %@for{current: current, last: last}) when current < last do
      new_iterator = %@for{iterator | current: current + 1}
      {:ok, {current, new_iterator}}
    end
    def next(iterator = %@for{current: current, last: last}) when current > last do
      new_iterator = %@for{iterator | current: current - 1}
      {:ok, {current, new_iterator}}
    end

    def peek(%@for{current: nil}), do: {:error, :empty}
    def peek(%@for{current: current}), do: {:ok, current}
  end

  defimpl Iter.PersistentIterator do
    def to_iteratable(%@for{first: first, last: last}) do
      first..last
    end
  end
end

defimpl Iter.PersistentIteratable, for: Range do
  def to_iterator(first..last) do
    %Iter.PersistentIterator.Implementations.Range{current: first, first: first, last: last}
  end
end
