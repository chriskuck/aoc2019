
class Memory

  attr_reader :contents

  def initialize(contents)
    @contents = contents
    @ancillary = Hash.new(0)
  end

  def clear
    @contents = []
  end

  def read(addr)
    if addr.kind_of?(Array)
      addr.map { |addr| _read(addr) }
    else
      _read(addr)
    end
  end

  def write(addr, value)
    if addr < @contents.length
      @contents[addr] = value
    else
      @ancillary[addr] = value
    end
  end

  private

  def _read(addr)
    return @contents[addr] if addr < @contents.length
    return @ancillary[addr]
  end
end
