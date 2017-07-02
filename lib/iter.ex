defmodule Iter do
  @doc """
  Turns an iteratable  datatype into an iterator.

  ## Examples

      iex> Iter.iterator([1,2,3,4])
      %Iter.Iterator.Implementations.List{rest: [1,2,3,4]}
  """
  defdelegate iterator(iteratable), to: Iter.Iteratable, as: :to_iterator

  @doc """
  Turns an iteratable datatype into a persistent iterator.

  This is an iterator which can at some point in the future be
  turned back into the iteratable datatype.

  ## Examples

      iex> Iter.persistent_iterator([1,2,3,4])
      %Iter.PersistentIterator.Implementations.List{passed: [], rest: [1,2,3,4]}

  """
  defdelegate persistent_iterator(iteratable), to: Iter.PersistentIteratable, as: :to_iterator

  @doc """
  Attempts to look up the next element in the given `iterator`.

  Returns `{:ok, {item, iterator}}` on success, or `{:error, reason}` on failure.

  The `:empty` reason is standardized, but certain iterators might also return their own.

  ## Examples

      iex> iterator = Iter.iterator([1,2])
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

      iex> iterator = Iter.iterator([1, 2])
      iex> Iter.peek(iterator)
      {:ok, 1}
      iex> iterator = Iter.iterator([])
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
      iex> iterator = Iter.iterator(%{a: 1, b: 2, c: 3})
      %Iter.Iterator.Implementations.Map{rest: [a: 1, b: 2, c: 3]}
      iex> iterator |> Iter.skip_next() |> Iter.skip_next() |> Iter.peek()
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

      iex> iterator = Iter.persistent_iterator(1..10)
      iex> {:ok, {item, iterator}} = Iter.next(iterator)
      iex> {:ok, {item, iterator}} = Iter.next(iterator)
      iex> item
      2
      iex> Iter.from_persistent_iterator(iterator)
      (1..10)

  """
  defdelegate from_persistent_iterator(iterator), to: Iter.PersistentIterator, as: :to_iteratable

  # @doc """
  # Skips a number of elements from the beginning of the iterator.
  # """
  # def skip(iterator, 0), do: iterator
  # def skip(iterator, n_elems) when n_elems > 0 do
  #   skip_next(iterator)
  #   |> skip(n_elems - 1)
  # end

  # def take(iterator, n_elems), do: take(iterator, n_elems, into: [])

  # def take(_iterator, 0, into: insertable), do: insertable
  # def take(iterator, n_elems, into: insertable) when n_elems > 0 do
  #   case next(iterator) do
  #     {:error, :empty} -> insertable
  #     {:ok, {item, new_iterator}} ->
  #       case Insertable.insert(insertable, item) do
  #         {:ok, new_insertable} ->
  #           take(new_iterator, n_elems - 1, into: new_insertable)
  #         {:error, :full} -> insertable
  #       end
  #   end
  # end

  # def take_while(iterator, fun, into: insertable) do
  #   case next(iterator) do
  #     {:error, :empty} -> insertable
  #     {:ok, {item, new_iterator}} ->
  #       if fun.(item) do
  #         case Insertable.insert(insertable, item) do
  #           {:ok, new_insertable} ->
  #             take_while(new_iterator, fun, into: new_insertable)
  #           {:error, :full} -> insertable
  #         end
  #       else
  #         insertable
  #       end
  #   end
  # end
end
