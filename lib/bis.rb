require 'bis/version'

class Bis
  extend Forwardable

  def_delegators :@bitset, :[], :each, :to_s

  def initialize(lenght)
    @bitset = [].tap { |bs| bs[0...length] = 0 }
  end
end
