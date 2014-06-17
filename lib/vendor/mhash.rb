# Mhash
#
#   mhash is a hash with methods, accessors methods are defined for each hash key and return the corresponding value
#
#
#   why mhash?
#     to enhance syntactic sugar and to let the refactoring transition to a real object easier
#
#   example usage:
#
#     extend Mhash
#     h = { a: "b" }
#     to_mhash h
#     p h.a #=> "b"
#     h.a = "c"
#     p h.a
#
#   feel free to refactor as you need

module Mhash

  def to_mhash(object)
    if object.is_a? Array # probably an array of hashes
      object.map{ |obj| hash_to_mhash obj }
    else
      hash_to_mhash object
    end
  end

  alias :mhash :to_mhash

  private

  def hash_to_mhash(object)
    object.keys.each do |key|
      eval "
        def object.#{key}
          self[:#{key}]
        end"
      eval "
        def object.#{key}=(value)
          self[:#{key}] = value
        end"
    end
    object
  end
end

class Hash
  def to_mhash!
    Mhash.to_mhash self
  end
end