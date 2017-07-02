defprotocol Iter.PersistentIterator do
  @moduledoc """
  A PersistentIterator can be turned back into its Iteratable,
  as this is what its 'Persistence' means.

  Data types that implement this protocol should also implement the `Iter.Iterator` protocol,
  as `Iter.PersistentIterator`s are a stronger variant of `Iter.Iterator`s.
  """
  @spec to_iteratable(t) :: Iter.Iteratable.t
  def to_iteratable(iterator)
end
