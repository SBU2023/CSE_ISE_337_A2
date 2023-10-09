class Array
  def map(range=(0..size))
    a = []
    range.each { |r|
      a.append(yield(self[r])) if self[r] != '\0'
    }
    return a
  end
end

class Array
  alias old []
  def [](index)
    if index >= 0  && index < size
      return old(index)
    elsif index >= -size && index < 0
      return old(index)
    else
      return '\0'
    end
    # if old(index).nil?
    #   return '\0'
    # else
    #   return old(index)
    # end
    # return self.fetch(index,'\0')
  end
end

# a = [1,2,3,4,5]
# puts a.map(10..100) { |i| i}
# puts a.map { |i| i.to_f}
#
b = ["cat","bat","mat","sat"]
print b.map(-10..10) { |x| x[0].upcase + x[1,x.length] }, "\n"

# print b.map(-1..-3) { |x| x[0].upcase }, "\n"
# print b.map(2..4) { |x| x[0].upcase + x[1,x.length] }, "\n"
# print b.map(-3..-1) { |x| x[0].upcase + x[1,x.length] }, "\n"
# print b.map(-1..-3) { |x| x[0].upcase + x[1,x.length] }, "\n"
# print b.map { |x| x[0].upcase + x[1,x.length] }, "\n"
#
# puts "Indexing..."
# a = [1,2,34,nil,5]
# puts a[0], a[2], a[3], a[-4], a[-1], a[4], a[20]
