
# Destructive Iterator
defmodule Iter.Iterator.Implementations.Map do
  @enforce_keys [:rest]
  defstruct rest: []

  defimpl Iter.Iterator do
    def next(%@for{rest: []}) do
      {:error, :empty}
    end
    def next(%@for{rest: [head | tail]}) do
      iterator = %@for{rest: tail}
      {:ok, {head, iterator}}
    end

    def peek(%@for{rest: []}) do
      {:error, :empty}
    end
    def peek(%@for{rest: [head | _]}) do
      {:ok, head}
    end
  end
end

defimpl Iter.Iteratable, for: Map do
  def to_iterator(map) do
    list = :maps.to_list(map)
    %Iter.Iterator.Implementations.Map{rest: list}
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

  defimpl Iter.Iterator do
    def next(%@for{rest: []}) do
      {:error, :empty}
    end
    def next(%@for{rest: [head | tail], passed: passed}) do
      iterator = %@for{rest: tail, passed: [passed | head]}
      {:ok, {head, iterator}}
    end

    def peek(%@for{rest: []}) do
      {:error, :empty}
    end
    def peek(%@for{rest: [head | _]}) do
      {:ok, head}
    end
  end

  defimpl Iter.PersistentIterator do
    def to_iteratable(%@for{passed: passed, rest: rest}) do
      :maps.from_list(reverse_snoc_list(passed, rest))
    end

    defp reverse_snoc_list([], acc), do: acc
    defp reverse_snoc_list([rest | elem], acc), do: reverse_snoc_list(rest, [elem | acc])
  end
end

defimpl Iter.PersistentIteratable, for: Map do
  def to_iterator(map) do
    list = :maps.to_list(map)
    %Iter.PersistentIterator.Implementations.Map{passed: [], rest: list}
  end
end
