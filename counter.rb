class Counter
  attr_accessor :count

  def initialize(count)
    @operation = :plus
    @count = count
  end

  def plus(number)
    @count += number
  end

  def minus(number)
    @count -= number
  end

  def plus_minus_alternate(number)
    if @operation == :plus
      @count += number
      @operation = :minus
    else
      @count -= number
      @operation = :plus
    end
  end
end

c = Counter.new(1)
for i in (1..10)
  plus_minus_alternate(Random.randit)
end

p c.count