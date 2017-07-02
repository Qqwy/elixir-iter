defprotocol Iter.Iterator do
  @moduledoc """
  Protocol describing an iterator.
  """

  @type error_reason :: :empty | atom

  @doc """
  An iterator can do exactly one thing:

  return the next item inside its structure.
  The iterator internally keeps track of how far it is inside the structure

  _(Either by modifying the structure so it can quickly find the next item,
  or by keeping track of the current position in another way.)_

  Returns `{:ok, {item, iterator}}` when there still is an item inside the Iterator,
  and `{error, error_reason}` if a next item cannot be returned.

  The `:empty` error reason is standardized
  (and therefore functions that call Iterator.next/1 can handle it),
  but certain iterators might
  return different errors as well.
  """
  @spec next(t) :: {:ok, {item :: any, t}} | {:error, error_reason}
  def next(iterator)

  @doc """

  Can trivially be implemented as:

  ```
  case next(iterator) do
    {:ok, {item, _} -> {:ok, item}
    {:error, reason} -> {:error, reason}
  end
  ```

  But for some datatypes, there might be an alternative implementation
  that is faster because the iterator itself might not need to be modified.
  """
  @spec peek(t) :: {:ok, item :: any} | {:error, error_reason}
  def peek(iterator)
end
