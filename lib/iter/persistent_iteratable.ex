defprotocol Iter.PersistentIteratable do
  @moduledoc """
  This protocol should be implemented for any datatype
  that can be turned into an `Iter.PersistentIterator`.
  """

  @spec to_iterator(Iter.PersistentIteratable.t) :: Iter.PersistentIterator.t
  def to_iterator(iteratable)
end
