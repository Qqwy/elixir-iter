defprotocol Iter.Iteratable do
  @moduledoc """
  This protocol can be implemented for any datatype
  that can be turned into an Iterator.

  If it is possible for a certain datatype
  to both be turned into a `Iter.PersistentIterator`
  and a normal, possibly destructive `Iter.Iterator` implementation, the more efficient one of the two should be specified
  for the Iter.Iterable.to_iterator/1 implementation.
  """

  @spec to_iterator(Iter.Iteratable.t) :: Iter.Iterator.t
  def to_iterator(iteratable)
end
