class AddressTranslation
  attr_accessor :offset

  def initialize(memory)
    @memory = memory
    @offset = 0
  end

  def lookup(addr, mode = 0)
    return @memory.read(addr) if mode == 0
    return addr if mode == 1
    return @memory.read(addr+@offset) if mode == 2
  end

  def write(addr, mode = 0, value)
    @memory.write(addr, value) if mode == 0
    @memory.write(addr+@offset, value) if mode == 2
  end
end

