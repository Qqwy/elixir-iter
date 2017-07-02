defmodule Iter do
  @doc """
  Turns an iteratable  datatype into an iterator.

  ## Examples

      iex> Iter.to_iterator([1,2,3,4])
      %Iter.Iterator.Implementations.List{rest: [1,2,3,4]}
  """
  defdelegate to_iterator(iteratable), to: Iter.Iteratable

  @doc """
  Turns an iteratable datatype into a persistent iterator.

  This is an iterator which can at some point in the future be
  turned back into the iteratable datatype.

  ## Examples

      iex> Iter.to_iterator([1,2,3,4])
      %Iter.PersistentIterator.Implementations.List{passed: [], rest: [1,2,3,4]}

  """
  defdelegate to_persistent_iterator(iteratable), to: Iter.PersistentIteratable, as: :to_iterator

  @doc """
  Attempts to look up the next element in the given `iterator`.

  Returns `{:ok, {item, iterator}}` on success, or `{:error, reason}` on failure.

  The `:empty` reason is standardized, but certain iterators might also return their own.

  ## Examples

      iex> iterator = Iter.to_iterator([1,2])
      iex> {:ok, {item, iterator}} = Iter.next(iterator)
      iex> item
      1
      iex> {:ok, {item, iterator}} = Iter.next(iterator)
      iex> item
      2
      iex> Iter.next(iterator)
      {:error, :empty}

  """
  defdelegate next(iterator), to: Iter.Iterator

  @doc """
  A variant of `next/1` that assumes that `iterator` is not empty (and will raise otherwise).
  """
  def next!(iterator) do
    {:ok, {item, iterator}} = next(iterator)
    {item, iterator}
  end

  @doc """
  Returns the next item in the iterator. (but not the iterator itself).

  For some iterators, this can be implemented in a more efficient way than by wrapping `next/1`.


  ## Example

      iex> iterator = Iter.to_iterator([1, 2])
      iex> Iter.peek(iterator)
      {:ok, 1}
      iex> iterator = Iter.to_iterator([])
      iex> Iter.peek(iterator)
      {:error, :empty}


  """
  def peek(iterator) do
    case next(iterator) do
      {:ok, {item, _}} -> {:ok, item}
      {:error, reason} -> {:error, reason}
    end
  end


  @doc """
  A variant of `peek/1` that assumes that `iterator` is not empty (and will raise otherwise).
  """
  def peek!(iterator) do
    {:ok, {item, _}} = next(iterator)
    item
  end

  @doc """
  Skips a single item that would be returned by `next/1`.
  If the iterator is already at its end (and `next/1` returns `{:error, :empty}`),
  does nothing (it returns the same iterator that was passed in in this case).

  ## Examples
      iex> iterator = Iter.to_iterator(%{a: 1, b: 2, c: 3})
      %Iter.Iterator.Implementations.Map{rest: [a: 1, b: 2, c: 3]}
      iex> iterator |> skip_next() |> skip_next() |> peek()
      {:ok, {:c, 3}}
  """
  def skip_next(iterator) do
    case next(iterator) do
      {:ok, {_, new_iterator}} -> new_iterator
      {:error, :empty} -> iterator
    end
  end

  @doc """
  Turns a `Iter.PersistentIterator` back into its iterable data type.

  ## Examples

      iex> iterator = Iter.to_iterator([1, 2, 3, 4])
      iex> {:ok, {item, iterator}} = Iter.next(iterator)
      iex> {:ok, {item, iterator}} = Iter.next(iterator)
      iex> item
      2
      iex> Iter.from_persistent_iterator(iterator)
      [1, 2, 3, 4]

  """
  defdelegate from_persistent_iterator(iterator), to: Iter.PersistentIterator, as: :to_iteratable
end
